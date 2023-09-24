import 'package:cloud_firestore/cloud_firestore.dart';

class BancoDadosFirestore {
  BancoDadosFirestore._();
  static final BancoDadosFirestore _instance = BancoDadosFirestore._();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static FirebaseFirestore get() {
    return BancoDadosFirestore._instance._firestore;
  }
}
