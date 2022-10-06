import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

import 'package:pusher_client/pusher_client.dart';

class CheckboxFilterState{
  String title;
  String statusName;
  bool value;

  CheckboxFilterState({
    required this.title,
    required this.statusName,
    this.value = false
  });
}

class TransactionProvider with ChangeNotifier{
  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  set transactions(List<TransactionModel> value) {
    _transactions = value;
    notifyListeners();
  }

  bool loadingGetData = false;

  List<String> labelSelectedStatusShown = [];

  //=========================== GET DATA =======================================
  int endPage = 1;

  Future<void> getTransactions({
    String? shippingType,
    String? searchQuery,
  }) async{
    loadingGetData = true;

    //NOTE: label status yg terpilih terupdate setelah user mengklik "terapkan filter"
    labelSelectedStatusShown = selectedFilterStatus.map((e) => e.title.toString()).toList();
    try {
      var transactions = await TransactionService().getTransactions(
          shippingType: shippingType,
          searchQuery: searchQuery,
          status: selectedFilterStatus.map((e) => e.statusName.toString()).toList(),
          page: 1
      );
      List<TransactionModel> transactionData = transactions['data'];
      _transactions = transactionData;
      endPage = transactions['totalPage'];
      if(endPage == 1) {
        noMoreData = true;
      }
    } catch (e) {
      print(e);
      _transactions = [];
    }
    loadingGetData = false;
    notifyListeners();
  }

  //=========================== PAGINATION =====================================
  int currentPage = 2;
  bool noMoreData = false;

  Future<void> getNextPageTransaction({
    String? shippingType,
    String? searchQuery,
  }) async{
    if(currentPage > endPage) {
      print('end of data');
      noMoreData = true;
    } else {
      try {
        var transactions = await TransactionService().getTransactions(
            shippingType: shippingType,
            searchQuery: searchQuery,
            status: selectedFilterStatus.map((e) => e.statusName.toString()).toList(),
            page: currentPage
        );

        List<TransactionModel> transactionData = transactions['data'];
        _transactions.addAll(transactionData);
        currentPage += 1;
      } catch (e) {
        print(e);
      }
    }
    notifyListeners();
  }

  disposePage() {
    currentPage = 2;
    endPage = 1;
    noMoreData = false;
  }

  //=========================== LIST FILTER ====================================

  List<CheckboxFilterState> transactionStatus = [];

  filterTransactionStatus() {
    transactionStatus = [
      CheckboxFilterState(title: 'Menunggu konfirmasi', statusName: 'success'),
      CheckboxFilterState(title: 'Diproses', statusName: 'processed'),
      CheckboxFilterState(title: 'Siap diambil', statusName: 'ready to take'),
      CheckboxFilterState(title: 'Sedang diantar', statusName: 'delivered'),
      CheckboxFilterState(title: 'Tiba di tujuan', statusName: 'arrived'),
      CheckboxFilterState(title: 'Selesai', statusName: 'done'),
    ];
  }

  filterStatusShown(String selectedShippingType) {
    //saat ganti shipping type, filter statusnya di-reset
    selectedFilterStatus.clear();

    filterTransactionStatus();

    if(selectedShippingType.toLowerCase() == 'ambil mandiri') {
      transactionStatus.removeWhere((e) => e.statusName == 'delivered' || e.statusName == 'arrived');
    } else if(selectedShippingType.toLowerCase() == 'pesan antar') {
      transactionStatus.removeWhere((e) => e.statusName == 'ready to take');
    }
    notifyListeners();
  }

  List<CheckboxFilterState> selectedFilterStatus = [];

  addToFilterStatus(CheckboxFilterState filter) {
    selectedFilterStatus.add(filter);
    notifyListeners();
    print(selectedFilterStatus.map((e) => e.statusName.toString()).toList());
  }

  removeFilterStatus(CheckboxFilterState filter) {
    selectedFilterStatus.remove(filter);
    notifyListeners();
    print(selectedFilterStatus.map((e) => e.statusName.toString()).toList());
  }

  resetAllFilter() {
    for(var status in transactionStatus) {
      status.value = false;
    }
    selectedFilterStatus.clear();
    labelSelectedStatusShown.clear();
    notifyListeners();
  }

  //init value?? -> where any selectedFilterStatus, valuenya true

  //============================================================================

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

      if(checkIDTransactionExist(int.parse(data['transId'].toString()))) {
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