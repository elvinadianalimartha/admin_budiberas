import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:budiberas_admin_9701/constants.dart' as constants;

import '../models/gallery_model.dart';

class GalleryProductService{
  String baseUrl = constants.baseUrl;

  Future<List<GalleryModel>> getPhotos(int productId) async{
    var url = '$baseUrl/productGallery/$productId';
    var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
    };

    var response = await http.get(
        Uri.parse(url),
        headers: headers
    );

    print(response.body);

    if(response.statusCode == 200) {
      List data = jsonDecode(response.body)['data'];

      List<GalleryModel> gallery = [];

      for(var item in data) {
        gallery.add(GalleryModel.fromJson(item));
      }

      return gallery;
    } else {
      throw Exception('Data foto produk gagal diambil!');
    }
  }

  Future<bool> addPhoto({
    required int productId,
    required File photoUrl,
  }) async {
    var url = '$baseUrl/productGallery/$productId';
    var headers = {'Content-Type': 'multipart/form-data'};

    var body = {
      'product_id': productId.toString(),
    };

    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..headers.addAll(headers)
      ..fields.addAll(body)
      ..files.add(await http.MultipartFile.fromPath('photo_url', photoUrl.path));

    var response = await request.send();

    if(response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Foto produk gagal ditambahkan');
    }
  }

  Future<bool> updatePhoto({
    required int id,
    required File photoUrl,
  }) async {
    var url = '$baseUrl/updatePhoto/$id';
    var headers = {'Content-Type': 'multipart/form-data'};

    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('photo_url', photoUrl.path));

    var response = await request.send();

    if(response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Foto produk gagal diperbarui');
    }
  }

  Future<bool> deletePhoto({
    required int id,
  }) async {
    var url = '$baseUrl/productGallery/$id';
    var headers = {'Content-Type': 'application/json'};

    var response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    if(response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Foto produk gagal dihapus');
    }
  }
}