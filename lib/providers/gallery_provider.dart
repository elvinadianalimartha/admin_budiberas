import 'dart:io';

import 'package:budiberas_admin_9701/models/gallery_model.dart';
import 'package:budiberas_admin_9701/services/gallery_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class GalleryProvider with ChangeNotifier {
  List<GalleryModel> _galleriesTemp = [];
  List<GalleryModel> _productGalleries = [];

  List<GalleryModel> get galleriesTemp => _galleriesTemp;
  List<GalleryModel> get productGalleries => _productGalleries;

  set galleriesTemp(List<GalleryModel> galleries) {
    _galleriesTemp = galleries;
    notifyListeners();
  }

  set productGalleries(List<GalleryModel> productGalleries) {
    _productGalleries = productGalleries;
    notifyListeners();
  }

  bool loading = false;

  addPhotoTemp(String photo) {
    var uuid = const Uuid();
    _galleriesTemp.add(
      GalleryModel(
        tempId: uuid.v4(),
        url: photo,
      )
    );
    notifyListeners();
  }
  
  removePhotoTemp(String? tempId) {
    if(_galleriesTemp.isNotEmpty) {
      _galleriesTemp.removeWhere((element) => element.tempId == tempId);
      notifyListeners();
    }
  }

  Future<void> getGalleries(int productId) async {
    loading = true;
    try{
      List<GalleryModel> productGalleries = await GalleryProductService().getPhotos(productId);
      _productGalleries = productGalleries;
    } catch(e) {
      print(e);
      _productGalleries = [];
    }
    loading = false;
    notifyListeners();
  }

  Future<bool> addNewPhoto({
    required int productId,
    required File photoUrl,
  }) async {
    try{
      if(await GalleryProductService().addPhoto(productId: productId, photoUrl: photoUrl)) {
        return true;
      } else {
        return false;
      }
    } catch(e) {
      print(e);
      return false;
    }
  }

  Future<bool> editPhoto({
    required int idPhoto,
    required File photoUrl,
  }) async {
    try{
      if(await GalleryProductService().updatePhoto(id: idPhoto, photoUrl: photoUrl)) {
        return true;
      } else {
        return false;
      }
    } catch(e) {
      print(e);
      return false;
    }
  }

  Future<bool> deletePhoto({
    required int idPhoto,
  }) async {
    try{
      if(await GalleryProductService().deletePhoto(id: idPhoto)) {
        _productGalleries.removeWhere((e) => e.id == idPhoto);
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch(e) {
      print(e);
      return false;
    }
  }
}