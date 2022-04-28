import 'package:budiberas_admin_9701/models/gallery_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class GalleryProvider with ChangeNotifier {
  List<GalleryModel> _galleries = [];

  List<GalleryModel> get galleries => _galleries;

  set galleries(List<GalleryModel> galleries) {
    _galleries = galleries;
    notifyListeners();
  }

  addPhotoTemp(String photo) {
    var uuid = const Uuid();
    _galleries.add(
      GalleryModel(
        tempId: uuid.v4(),
        url: photo,
      )
    );
    notifyListeners();
  }
  
  removePhotoTemp(String? tempId) {
    if(_galleries.isNotEmpty) {
      _galleries.removeWhere((element) => element.tempId == tempId);
      notifyListeners();
    }
  }

  // @override
  // void dispose() {
  //   _galleries.clear();
  //   super.dispose();
  // }
}