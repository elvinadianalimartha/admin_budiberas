import 'package:budiberas_admin_9701/models/message_detail_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<MessageDetailModel>> getMessagesByDocId(String docId) {
    try {
      return firestore.collection('messages')
          .doc(docId) //tiap user punya docId yg unik
          .collection('messageContent')
          .snapshots()
          .map((QuerySnapshot listDetail) {
            var result = listDetail.docs.map<MessageDetailModel>((DocumentSnapshot detailMessage) {
              //print(detailMessage.data());
              return MessageDetailModel.fromJson(detailMessage.data() as Map<String, dynamic>);
            }).toList();

            print('cek masuk 3');
            return result;
          });
    } catch(e) {
      throw Exception(e);
    }
  }

  // Future<void> addMessage({
  //   required int userId,
  //   required String userName,
  //   String? userImage,
  //   //required bool isFromUser,
  //   required String message,
  //   String? imageUrl,
  // }) async {
  //     var uuid = const Uuid();
  //     try {
  //       //NOTE: collection(nama id yg udah dibikin di firestore console)
  //       firestore.collection('messages').add({
  //         'id': uuid.v4(),
  //         'userId': userId, //apa ini ketoke dari message_model yaa? dibuat to json
  //         'userName': userName,
  //         'userImage': userImage,
  //         'isFromUser': false, //NOTE: sbg pelanggan: true, sbg pemilik: false
  //         'message': message,
  //         'product': null,
  //         'imageUrl': imageUrl,
  //         'createdAt': DateTime.now().toString(),
  //         'updatedAt': DateTime.now().toString(),
  //         'isRead': false, //NOTE: isRead awalnya diset false dulu, nanti saat dibuka chatnya baru diupdate jadi true
  //       }).then((value) => print('Message is delivered'));
  //     } catch(e) {
  //       throw Exception('Message fail to delivered');
  //     }
  // }
}