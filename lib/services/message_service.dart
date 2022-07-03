import 'package:budiberas_admin_9701/models/message_detail_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class MessageService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<MessageDetailModel>> getMessagesByDocId(String docId) {
    try {
      return firestore.collection('messages')
          .doc(docId) //tiap user punya docId yg unik
          .collection('messageContent')
          .orderBy('createdAt')
          .snapshots()
          .map((QuerySnapshot listDetail) {
            var result = listDetail.docs.map<MessageDetailModel>((DocumentSnapshot detailMessage) {
              return MessageDetailModel.fromJson(detailMessage.data() as Map<String, dynamic>);
            }).toList();

            print('cek masuk 3');
            return result;
          });
    } catch(e) {
      throw Exception(e);
    }
  }

  Stream<QuerySnapshot<Object>> getUser() {
    try {
      return firestore.collection('messages')
          .orderBy('lastUpdatedByCustAt', descending: true) //spy chat baru dari pelanggan bisa ada di urutan teratas
          .snapshots();
    } catch(e) {
      throw Exception(e);
    }
  }

  Future<void> addMessage({
    required int userId,
    required String message,
    String? imageUrl,
  }) async {
      var uuid = const Uuid();
      try {
        //get doc id
        QuerySnapshot querySnapshot = await firestore.collection('messages').where('userId', isEqualTo: userId).get();
        String docId = querySnapshot.docs[0].id;

        //add data ke subcollection
        firestore.collection('messages')
          .doc(docId)
          .collection('messageContent')
          .add({
            'id': uuid.v4(),
            'isFromUser': false, //NOTE: sbg pemilik: false, pelanggan: true
            'message': message,
            'product': {},
            'imageUrl': imageUrl,
            'createdAt': DateTime.now().toString(),
            'updatedAt': DateTime.now().toString(),
            'isRead': false, //NOTE: isRead awalnya diset false dulu, nanti saat dibuka chatnya baru diupdate jadi true
          }).then((value) => print('Pesan berhasil dikirim'));
      } catch(e) {
        throw Exception('Pesan gagal dikirim');
      }
  }
}