import 'package:cloud_firestore/cloud_firestore.dart';

class CustomException implements Exception {
  String message;
  FirebaseException? error;
  CustomException(this.message, [this.error]);
}
