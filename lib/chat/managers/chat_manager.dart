import 'dart:async';

import 'package:bitirmes/UserLogin-Register/sign_in_page.dart';
import 'package:bitirmes/chat/chat_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat_message_model.dart';
import '../models/message_model.dart';
import '../utils/command_consts.dart';
import 'client_manager.dart';

abstract class ChatManager {
  // static final chatMessagesProv =
  //     StateProvider<List<ChatMessageModel>>((_) => []);
  static final chatsProv = StateProvider.autoDispose<List<Chat>>((_) => []);
  static List<ChatMessageModel> chatMessages = [];
  static StreamSubscription<MessageModel>? _msgsLis;
  static Future initChatMessagesList(WidgetRef ref) async {
    _msgsLis?.cancel();
    _msgsLis = ClientManager.chatMessagesController.stream.listen(
      (_) async {
        // final params = msg.params;
        // if (params == null) {
        //   return;
        // }
        // final chatMsg = ChatMessageModel.fromJson(params);

        // addMessage(chatMsg, ref);

        final chjts = await LoginFormPage.currentCustomer.getChats() ?? [];

        ref.read(chatsProv.notifier).state = chjts;
      },
    );
  }

  // static void addMessage(ChatMessageModel chatMsg, WidgetRef ref) {
  //   final myid = LoginFormPage.currentCustomer.id;

  //   // if (chatMsg.senderId == myid?.toString()) {
  //   //   return;
  //   // }

  //   chatMessages.add(chatMsg);

  //   ref.read(chatMessagesProv.notifier).state = List.from(chatMessages);
  // }

  static void sendMessage(ChatMessageModel chatMsg, WidgetRef ref) {
    final msg = MessageModel(
      title: sendMessageCommand,
      params: chatMsg.toJson(),
    );

    ClientManager.sendMessage(msg);

    // addMessage(chatMsg, ref);
  }
}
