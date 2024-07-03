import 'package:bitirmes/CustomClass/CardList.dart';
import 'package:bitirmes/CustomClass/TextWidget.dart';
import 'package:bitirmes/Features/FeatureSelection.dart';
import 'package:bitirmes/GuiderClasses/guider-selection.dart';
import 'package:bitirmes/chat/managers/chat_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../UserLogin-Register/sign_in_page.dart';
import '../chat/chat_screen.dart';

class ChatPage extends StatelessWidget {
  //const NewsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chats',
        ),
      ),
      body: _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LoginFormPage.currentCustomer.getChats(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final data = snapshot.data as List<Chat>?;

        if (data == null) {
          return Center(
            child: Text('Error occured!'),
          );
        }

        return Consumer(
          builder: (context, ref, _) {
            // final iamacustomer = LoginFormPage.currentCustomer.isCustomer;
            // final myid = LoginFormPage.currentCustomer.id;

            // final allMsgs = ref.watch(ChatManager.chatMessagesProv);

            // final chats = data.map(
            //   (chat) {
            //     final msgsToApiMsgs = allMsgs.where(
            //       (e) {
            //         final f1 = (iamacustomer
            //             ? e.receiverGuiderId == chat.guiderId
            //             : e.receiverCustomerId == chat.customerId);
            //         ;
            //         return f1;
            //       },
            //     ).map(
            //       (e) {
            //         return ChatMessage(
            //           id: 0,
            //           chatId: chat.id,
            //           date: e.date,
            //           body: e.message,
            //           sender: () {
            //             if (e.senderId == e.receiverCustomerId?.toString()) {
            //               return SenderType.customer;
            //             }

            //             if (e.senderId == e.receiverGuiderId?.toString()) {
            //               return SenderType.guider;
            //             }

            //             return SenderType.customer;
            //           }(),
            //         );
            //       },
            //     ).toList();

            //     chat.messages = [
            //       ...chat.messages,
            //       ...msgsToApiMsgs,
            //     ];

            //     return chat;
            //   },
            // ).toList();

            final chtPro = ref.watch(ChatManager.chatsProv);
            final chats = chtPro.isEmpty ? data : chtPro;

            return ListView(
              children: chats
                  .map(
                    (e) => _ChatItem(
                      chat: e,
                    ),
                  )
                  .toList(),
            );
          },
        );
      },
    );
  }
}

class _ChatItem extends StatelessWidget {
  final Chat chat;
  const _ChatItem({
    required this.chat,
  });

  bool get iamcustomer => LoginFormPage.currentCustomer.isCustomer;

  @override
  Widget build(BuildContext context) {
    final guider = chat.guider;
    final customer = chat.customer;
    final lastMsg = chat.messages.isEmpty ? null : chat.messages.last;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              userId: iamcustomer ? guider?.id : customer?.id,
            ),
          ),
        );
      },
      child: CardWidget(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Builder(
                builder: (context) {
                  if (guider == null || !iamcustomer) {
                    return SizedBox();
                  } else {
                    return SizedBox(
                      height: 50,
                      width: 50,
                      child: ClipRRect(
                        // to give an image radius value
                        borderRadius: BorderRadius.circular(50),
                        child: GuiderImage(
                          guider: guider,
                        ),
                      ),
                    );
                  }
                },
              ), // suppose the image width is 200
              const SizedBox(width: 10),
              Expanded(
                // then, Expanded will tell the Column that its max width would be screensize-200
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.height / 5,
                            child: Text(
                              iamcustomer
                                  ? guider?.fullName ?? ''
                                  : customer?.fullName ?? '',
                              style: ThemeClass.headline2,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        if (lastMsg != null)
                          Text(
                            lastMsg.sentTimeAgo,
                            style: ThemeClass.headline4,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (lastMsg != null)
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lastMsg.body,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: ThemeClass.headline4,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    Key? key,
    required this.name,
    required this.imagePath,
    required this.message,
    required this.online,
  }) : super(key: key);
  final String name;
  final String imagePath;
  final String message;
  final Color online;

  @override
  Widget build(BuildContext context) {
    double cardWidht = 380;
    double cardHeight = 100;
    // double heightSize = MediaQuery.of(context).size.height;
    return Padding(
      padding: ProjectPadding.FavoritePadding,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Card(
          elevation: 5,
          color: ColorItems.newsWidgetBackGroundColor,
          shadowColor: ColorItems.newsCardShadowColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            width: cardWidht,
            height: cardHeight,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.transparent,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 5,
                    width: MediaQuery.of(context).size.width / 4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(width: 1, color: Colors.transparent),
                      ),
                      child: ClipRRect(
                        // to give an image radius value
                        //  borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          imagePath,
                          //'assets/test.png',
                        ),
                      ),
                    ),
                  ), // suppose the image width is 200
                  Expanded(
                    // then, Expanded will tell the Column that its max width would be screensize-200

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.height / 5,
                                child: TextWidget(
                                  text: name,
                                  styleParam: ThemeClass.headline1,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 18,
                              height: MediaQuery.of(context).size.height / 36,
                              alignment: Alignment.topRight,
                              decoration: BoxDecoration(
                                color: online,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(width: 1, color: online),
                              ),
                            ),
                          ],
                        ),
                        TextWidget(
                          text: message,
                          styleParam: ThemeClass.headline4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
