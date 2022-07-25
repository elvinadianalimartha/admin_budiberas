import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

import 'package:pusher_client/pusher_client.dart';

class TransactionProvider with ChangeNotifier{
  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  bool loadingGetData = false;

  set carts(List<TransactionModel> value) {
    _transactions = value;
    notifyListeners();
  }

  Future<void> getTransactions({String? shippingType}) async{
    loadingGetData = true;
    try {
      List<TransactionModel> transactions = await TransactionService().getTransactions(shippingType: shippingType);
      _transactions = transactions;
    } catch (e) {
      print(e);
    }
    loadingGetData = false;
    notifyListeners();
  }

  checkIDTransactionExist(int transID) {
    bool exist = _transactions.any((e) => e.id == transID);
    return exist;
  }

  Future<void> pusherTransactionStatus() async {
    PusherClient pusher;
    Channel channel;
    pusher = PusherClient('2243680746c2e59ee156', PusherOptions(cluster: 'ap1'));

    channel = pusher.subscribe('transaction-status');

    pusher.onConnectionStateChange((state) {
      print('previousState: ${state!.previousState}, currentState: ${state.currentState}');
    });

    pusher.onConnectionError((error) {
      print("error: ${error!.message}");
    });

    channel.bind('App\\Events\\TransStatusUpdated', (event) {
      print(event!.data);
      final data = jsonDecode(event.data!);

      if(checkIDTransactionExist(int.parse(data['transId']))) {
        //update data status sesuai dgn id yg dituju
        _transactions.where(
          (e) => e.id == int.parse(data['transId'].toString())
        ).first.transactionStatus = data['status'];
      } else {
        getTransactions(); //reload data jika ada data baru (biasanya krn pembayaran yg sdh sukses)
      }
      notifyListeners();
    });
  }

  Future<bool> updateStatusTransaction({
    required int id,
    required String newStatus,
  }) async {
    try {
      if(await TransactionService().updateStatus(transactionId: id, newStatus: newStatus)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}