import 'package:bitirmes/chat/managers/chat_manager.dart';
import 'package:bitirmes/chat/models/chat_message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:bitirmes/ObjectClasses/customer.dart';
import 'package:bitirmes/UserLogin-Register/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

enum SenderType {
  customer,
  guider;

  factory SenderType.fromString({required String type}) {
    switch (type) {
      case 'customer':
        return SenderType.customer;
      case 'guider':
        return SenderType.guider;
      default:
        throw Exception('Unknown sender type!');
    }
  }
}

class ChatMessage {
  final int id;
  final int chatId;
  final DateTime date;
  final String body;
  final SenderType sender;

  String get sentTimeAgo {
    return timeago.format(date, locale: 'en_short');
  }

  const ChatMessage({
    required this.id,
    required this.chatId,
    required this.date,
    required this.body,
    required this.sender,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      chatId: json['chat_id'],
      date: DateTime.parse(json['date']),
      body: json['body'],
      sender: SenderType.fromString(
        type: json['sender'],
      ),
    );
  }
}

class Chat {
  final int customerId;
  final int guiderId;
  final int id;
  final Guider? guider;
  final Customer? customer;
  List<ChatMessage> messages;

  Chat({
    required this.customerId,
    required this.guiderId,
    required this.id,
    required this.guider,
    required this.customer,
    required this.messages,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      customerId: json['customer_id'],
      guiderId: json['guider_id'],
      id: json['id'],
      guider: json['guider'] == null
          ? null
          : Guider.fromJson(
              json['guider'],
            ),
      customer: json['customer'] == null
          ? null
          : Customer.fromJson(
              json['customer'],
            ),
      messages: json['messages']
          .map<ChatMessage>((message) => ChatMessage.fromJson(message))
          .toList(),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final int? userId;
  final Chat? chat;
  const ChatScreen({
    super.key,
    this.userId,
    this.chat,
  }) : assert(
          (userId != null && chat == null) || (userId == null && chat != null),
        );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LoginFormPage.currentCustomer.startChat(
        userId: userId!,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(snapshot.error.toString()),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final data = snapshot.data as Chat?;

        if (data == null) {
          return Scaffold(
            body: Center(
              child: Text('Error occured!'),
            ),
          );
        }

        final chat = data;

        // final chatMsgs = chat.messages;

        return Consumer(
          builder: (context, ref, child) {
            // final iamacustomer = LoginFormPage.currentCustomer.isCustomer;
            // final myid = LoginFormPage.currentCustomer.id;

            // final allMsgs = ref.watch(ChatManager.chatMessagesProv);
            // final msgs = allMsgs.where(
            //   (msg) {
            //     final f1 = (iamacustomer
            //         ? msg.receiverGuiderId == chat.guiderId
            //         : msg.receiverCustomerId == chat.customerId);
            //     ;
            //     return f1;
            //   },
            // ).toList();

            // final msgsToApiMsgs = msgs.map(
            //   (e) {
            //     return ChatMessage(
            //       id: 0,
            //       chatId: chat.id,
            //       date: e.date,
            //       body: e.message,
            //       sender: () {
            //         if (e.senderId == e.receiverCustomerId?.toString()) {
            //           return SenderType.customer;
            //         }

            //         if (e.senderId == e.receiverGuiderId?.toString()) {
            //           return SenderType.guider;
            //         }

            //         return SenderType.customer;
            //       }(),
            //     );
            //   },
            // ).toList();

            // chat.messages = [
            //   ...chatMsgs,
            //   ...msgsToApiMsgs,
            // ];

            final chjts = ref.watch(ChatManager.chatsProv);

            final chjt = chjts.any((e) => e.id == chat.id)
                ? chjts.firstWhere((e) => e.id == chat.id)
                : chat;

            return _ChatScreen(chat: chjt);
          },
        );
      },
    );
  }
}

class _ChatScreen extends StatelessWidget {
  final Chat chat;
  const _ChatScreen({
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LoginFormPage.currentCustomer.isCustomer
              ? (chat.guider?.fullName ?? '')
              : chat.customer?.fullName ?? '',
        ),
      ),
      body: _MessagesList(
        messages: chat.messages,
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: MessageInp(
          chatId: chat.id,
          receiverCustomerId: chat.customerId,
          receiverGuiderId: chat.guiderId,
        ),
      ),
    );
  }
}

class MessageInp extends ConsumerStatefulWidget {
  final int chatId;
  final int? receiverGuiderId, receiverCustomerId;
  const MessageInp({
    super.key,
    required this.chatId,
    this.receiverGuiderId,
    this.receiverCustomerId,
  });

  @override
  ConsumerState<MessageInp> createState() => _MessageInpState();
}

class _MessageInpState extends ConsumerState<MessageInp> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller.addListener(() {
      onValueUpdated(controller.value.text);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isSendButtonEnabled = false;

  void onValueUpdated(String newVal) {
    isSendButtonEnabled = newVal.isNotEmpty;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
    );
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(20),
          hintText: 'Type a message',
          border: border,
          focusedBorder: border,
          enabledBorder: border,
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            onPressed: isSendButtonEnabled
                ? () async {
                    await EasyLoading.show(status: 'Sending...');
                    final isSent =
                        await LoginFormPage.currentCustomer.sendMessage(
                      chatId: widget.chatId,
                      date: DateTime.now(),
                      body: controller.value.text,
                    );

                    // final iamcustomer =
                    //     LoginFormPage.currentCustomer.isCustomer;

                    final myid = LoginFormPage.currentCustomer.id;

                    final msg = ChatMessageModel(
                      message: controller.value.text,
                      date: DateTime.now(),
                      senderId: myid?.toString(),
                      receiverCustomerId: widget.receiverCustomerId,
                      receiverGuiderId: widget.receiverGuiderId,
                    );

                    ChatManager.sendMessage(
                      msg,
                      ref,
                    );

                    EasyLoading.dismiss();

                    if (isSent) {
                      controller.clear();
                      onValueUpdated('');
                    } else {
                      EasyLoading.showError('Error occured while sending!');
                    }
                  }
                : null,
          ),
        ),
      ),
    );
  }
}

class _MessagesList extends StatelessWidget {
  final List<ChatMessage> messages;
  const _MessagesList({
    required this.messages,
  });

  bool isMessageFromMe(ChatMessage message) {
    final iamcustomer = LoginFormPage.currentCustomer.isCustomer;
    return iamcustomer
        ? message.sender == SenderType.customer
        : message.sender == SenderType.guider;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[messages.length - index - 1];
        return Container(
          margin: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: isMessageFromMe(message)
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isMessageFromMe(message)
                      ? Colors.blue
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  message.body,
                  style: TextStyle(
                    color:
                        isMessageFromMe(message) ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
