import 'dart:async';
import 'dart:convert';

import 'package:bitirmes/UserLogin-Register/sign_in_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/message_model.dart';
import '../utils/command_consts.dart';
import '../utils/consts.dart';
import 'package:web_socket_channel/io.dart';

import '../models/user_model.dart';
import 'chat_manager.dart';

abstract class ClientManager {
  static IOWebSocketChannel? _ch;

  static final userProv = StateProvider<UserModel?>((ref) => null);

  static Uri get _wsUri {
    if (socketEnv == SocketEnv.dev) {
      return Uri(
        scheme: 'ws',
        host: '192.168.1.130',
        port: 8080,
      );
    }

    if (socketEnv == SocketEnv.heroku) {
      return Uri(
        scheme: 'wss',
        host: 'still-scrubland-14831.herokuapp.com',
      );
    }
    // ec2
    return Uri(
      scheme: 'ws',
      host: '13.50.109.56',
      port: 8080,
    );
  }

  static StreamSubscription? _subscription;

  static StreamController<MessageModel> chatMessagesController =
      StreamController.broadcast();

  static void setListener(WidgetRef ref) {
    _subscription ??= channel.stream.listen(
      (event) {
        final msg = MessageModel.fromJson(json.decode(event));

        if (msg.title == sendMessageCommand) {
          chatMessagesController.sink.add(msg);
          return;
        }

        if (msg.title == authCommand) {
          final prms = msg.params;
          if (prms == null || prms.isEmpty) {
            return;
          }
          final user = UserModel.fromJson(prms);

          ref.read(userProv.notifier).state = user;
        }
      },
      onError: (e) {
        print('error started: $e');
        channel.sink.close();
        _subscription?.cancel();
        _subscription = null;
        _ch = null;
        final _ = channel;

        setListener(ref);
        print('error ended');
      },
      onDone: () {
        print('done started');
        channel.sink.close();
        _subscription?.cancel();
        _subscription = null;
        _ch = null;
        final _ = channel;

        setListener(ref);
        print('done ended');
      },
    );

    ChatManager.initChatMessagesList(ref);
  }

  static void dispose() {
    _subscription?.cancel();
    _ch?.sink.close();
  }

  static IOWebSocketChannel get _channel {
    final _u = _wsUri;
    _ch ??= IOWebSocketChannel.connect(_u);

    return _ch!;
  }

  static IOWebSocketChannel get channel => _channel;

  static Future<void> auth(WidgetRef ref) async {
    final iamcustomer = LoginFormPage.currentCustomer.isCustomer;
    final myid = LoginFormPage.currentCustomer.id;
    final user = ref.watch(userProv) ??
        UserModel(
          guiderId: iamcustomer ? null : myid,
          customerId: iamcustomer ? myid : null,
        );

    final msg = MessageModel(
      title: authCommand,
      params: user.toJson(),
    );

    await sendMessage(msg);
  }

  static Future<void> sendMessage(MessageModel msg) async {
    try {
      channel.sink.add(msg.toJsonStr());
    } catch (e) {
      print(e);
    }
  }
}
