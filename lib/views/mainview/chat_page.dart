import 'package:budiberas_admin_9701/services/message_service.dart';
import 'package:budiberas_admin_9701/views/widgets/chat_tile.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController searchController = TextEditingController(text: '');
  var documents = [];
  String valueSearch = '';
  bool searchFilled = false;

  @override
  Widget build(BuildContext context) {
    Widget searchChat() {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: TextFormField(
          style: primaryTextStyle,
          controller: searchController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            isCollapsed: true,
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: secondaryTextColor),
            ),
            hintText: 'Cari nama pembeli',
            hintStyle: secondaryTextStyle,
            prefixIcon: Icon(Icons.search, color: secondaryTextColor, size: 20,),
            suffixIcon: searchFilled
                ? InkWell(
                    onTap: () {
                      searchFilled = false;
                      searchController.clear();
                      setState(() {
                        valueSearch = '';
                      });
                    },
                    child: Icon(Icons.cancel, color: secondaryTextColor, size: 20,)
                  )
                : null,
            contentPadding: const EdgeInsets.all(12),
          ),
          onChanged: (value) {
            setState(() {
              valueSearch = value;
            });
            value.isNotEmpty ? searchFilled = true : searchFilled = false;
          },
        ),
      );
    }

    Widget emptyChat(){
      return Center(
        child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity, //spy warna selebar layar
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icon_headset.png', width: 80, color: secondaryColor,),
                  const SizedBox(height: 20,),
                  Text(
                    'Belum ada obrolan saat ini',
                    style: primaryTextStyle.copyWith(
                      fontWeight: medium,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
      );
    }

    Widget contentChat() {
      return StreamBuilder<QuerySnapshot>(
        stream: MessageService().getUser(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            documents = snapshot.data!.docs.where(
                (doc) => doc.get('userName').toString().toLowerCase()
                    .contains(valueSearch.toLowerCase())
            ).toList();

            if(documents.isEmpty) {
              return emptyChat();
            }

            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var document = documents[index];
                return ChatTile(user: document, docId: document.id,);
              },
            );
          } else {
            return const SizedBox(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        }
      );
    }

    return Scaffold(
      appBar: customAppBar(text: 'Daftar Obrolan'),
      body: Column(
        children: [
          searchChat(),
          Flexible(child: contentChat()),
        ],
      )
    );
  }
}
