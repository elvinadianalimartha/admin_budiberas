import 'package:budiberas_admin_9701/views/widgets/detail_chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../theme.dart';

class ChatTile extends StatelessWidget {
  final DocumentSnapshot user;
  final String docId;

  ChatTile({
    Key? key,
    required this.user,
    required this.docId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    QueryDocumentSnapshot<Object?> data;

    Widget lastMessagePreview(List doc) {
        if(doc.isNotEmpty) {
          data = doc.last;
          return Text(
            data.get('message'),
            style: data.get('isRead') ? greyTextStyle : priceTextStyle
          );
        } else {
          return const SizedBox();
        }
      }

    Widget textCreatedAt(String text) {
      return Text(
        text,
        style: greyTextStyle.copyWith(fontSize: 13),
      );
    }

    String formatCreatedAt(List doc) {
      var createdAt = DateTime.parse(doc.last.get('createdAt'));
      var diffDay = DateTime.now().day - createdAt.day;
      if(diffDay == 0) {
        return DateFormat("HH:mm").format(createdAt);
      } else if(diffDay == 1) {
        return 'Kemarin';
      } else {
        return DateFormat("dd/MM/yyyy").format(createdAt);
      }
    }

    return Column(
      children: [
        GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => DetailChatPage(
                    userId: user.get('userId'),
                    userName: user.get('userName'),
                    userImage: user.get('userImage'),
                    docId: docId,
                  )
              ));
            },
            child: StreamBuilder<QuerySnapshot>(
              stream: user.reference.collection('messageContent').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var doc = snapshot.data!.docs.where(
                          (element) => element.get('isFromUser') == true
                  ).toList();

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.get('userImage')),
                    ),
                    title: Text(user.get('userName'), style: primaryTextStyle,),
                    subtitle: lastMessagePreview(doc),
                    trailing: doc.isNotEmpty ? textCreatedAt(formatCreatedAt(doc)) : const SizedBox(),
                  );
                } else {
                  return const SizedBox();
                }
              }
            ),
        ),
        const SizedBox(height: 10,),
        const Divider(thickness: 1,),
      ],
    );
  }
}
