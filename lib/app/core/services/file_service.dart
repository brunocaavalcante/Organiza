import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:organiza2/app/core/models/custom_exception.dart';

class FileService extends ChangeNotifier {
  String destino = '';
  String refImage = '';

  UploadTask uploadFile(String destination, File file) {
    try {
      refImage = destination;
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      throw CustomException("Ocorreu um erro: ${e.message}");
    }
  }

  UploadTask uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putData(data);
    } on FirebaseException catch (e) {
      throw CustomException("Ocorreu um erro: ${e.message}");
    }
  }

  Future<void> excluirFile(String urlRef) async {
    try {
      final ref = FirebaseStorage.instance.ref(urlRef);
      await ref.delete();
    } on FirebaseException catch (e) {
      throw CustomException("Ocorreu um erro: ${e.message}");
    }
  }
}
