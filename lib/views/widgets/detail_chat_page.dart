import 'package:budiberas_admin_9701/models/message_detail_model.dart';
import 'package:budiberas_admin_9701/views/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../services/message_service.dart';
import '../../services/notification_service.dart';
import '../../theme.dart';

import 'package:budiberas_admin_9701/constants.dart' as constants;

class DetailChatPage extends StatefulWidget {
  final int userId;
  final String userName;
  final String userImage;
  final String docId;

  DetailChatPage({
    Key? key,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.docId,
  }) : super(key: key);

  @override
  _DetailChatPageState createState() => _DetailChatPageState();
}

class _DetailChatPageState extends State<DetailChatPage> {
  TextEditingController messageController = TextEditingController(text: '');

  handleAddMessage() async {
    await MessageService().addMessage(
      message: messageController.text,
      userId: widget.userId,
      imageUrl: null,
    );
    //save sent message utk dipanggil saat send notif
    String sentMessage = messageController.text;

    //clear after send message
    setState(() {
      messageController.text = '';
    });

    //get fcm token from userId
    await context.read<AuthProvider>().getFcmToken(widget.userId);

    if(context.read<AuthProvider>().fcmTokenUser != null) {
      NotificationService().sendFcm(
          title: 'Ada pesan baru dari Budi Beras',
          body: sentMessage,
          fcmToken: context.read<AuthProvider>().fcmTokenUser!
      );
    }
  }

  Future<void> seeMsg() async{
    final query = await FirebaseFirestore.instance
        .collection('messages')
        .doc(widget.docId)
        .collection('messageContent')
        .where('isFromUser', isEqualTo: true)
        .where('isRead', isEqualTo: false)
        .get();

    query.docs.forEach((doc) {
      doc.reference.update({'isRead': true});
    });
  }

  Widget content() {
    return StreamBuilder<List<MessageDetailModel>>(
        stream: MessageService().getMessagesByDocId(widget.docId),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              reverse: true,
              padding: EdgeInsets.symmetric(
                horizontal: defaultMargin,
              ),
              itemBuilder: (context, index) {
                MessageDetailModel message = snapshot.data![index];
                seeMsg();
                return ChatBubble(
                  isSender: !message.isFromUser,
                  text: message.message,
                  product: message.product,
                  createdAt: message.createdAt,
                  isRead: message.isRead,
                );
              }
            );
          } else {
            return const Center(child: CircularProgressIndicator(),);
          }
        }
    );
  }

  Widget chatInput() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: MediaQuery.of(context).viewInsets, //supaya gak ketutupan keyboard
      child: Column(
        mainAxisSize: MainAxisSize.min, //supaya ngambil ruang seminimal mungkin
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: formColor,
                  ),
                  child: Center(
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      maxLines: null,
                      controller: messageController,
                      style: primaryTextStyle.copyWith(fontSize: 14),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Ketik pesanmu di sini...',
                        hintStyle: greyTextStyle.copyWith(fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20,),
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: btnColor,
                ),
                child: IconButton(
                  icon: const Icon(Icons.send, size: 20,),
                  color: Colors.white,
                  onPressed: () {
                    if(messageController.text != '') {
                      handleAddMessage();
                    }
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        toolbarHeight: 65,
        title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(constants.getAvatarLink(widget.userName))
              ),
              const SizedBox(width: 20,),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.userName,
                      style: whiteTextStyle.copyWith(
                        fontWeight: semiBold,
                        fontSize: 16,
                      ),
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      body: content(),
      bottomNavigationBar: chatInput(),
    );
  }
}
