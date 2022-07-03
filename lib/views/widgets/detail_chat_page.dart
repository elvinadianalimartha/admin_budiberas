import 'package:budiberas_admin_9701/models/message_detail_model.dart';
import 'package:budiberas_admin_9701/views/widgets/chat_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/message_service.dart';
import '../../theme.dart';

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

    //clear after send message
    setState(() {
      messageController.text = '';
    });
  }

  Widget content() {
    return StreamBuilder<List<MessageDetailModel>>(
        stream: MessageService().getMessagesByDocId(widget.docId),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return ListView( //spy list chatnya bisa discroll
              padding: EdgeInsets.symmetric(
                horizontal: defaultMargin,
              ),
              children:
              snapshot.data!.map(
                (MessageDetailModel message) => ChatBubble(
                  isSender: !message.isFromUser,
                  text: message.message,
                  product: message.product,
                )
              ).toList(),
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
                      style: primaryTextStyle,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Ketik pesanmu di sini...',
                        hintStyle: greyTextStyle,
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
        toolbarHeight: 80,
        title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.userImage
                ),
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
                    const SizedBox(height: 2,),
                    Text(
                      'Aktif',
                      style: whiteTextStyle.copyWith(
                        fontSize: 14,
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
