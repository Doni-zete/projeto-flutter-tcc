import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cripto_github/models/moeda.dart';

class MoedaRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // CARREGANDO A LISTA DE MOEDAS DE UM USUÁRIO

  Future<List<Moeda>> getMoedaList(String userId) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('usuarios')
        .doc(userId)
        .collection('moedas')
        .get();

    List<Moeda> moedas = [];

    querySnapshot.docs.forEach((document) {
      moedas.add(Moeda.fromJson(document.data() as Map<String, dynamic>));
    });

    return moedas;
  }

  // SALVANDO A MOEDA EM UMA LISTA PARA UM USUÁRIO
  // No MoedaRepository
  Future<void> saveMoedaList(String userId, List<Moeda> listaMoeda) async {
    CollectionReference userCollection = firestore.collection('usuarios');
    DocumentReference userDoc = userCollection.doc(userId);
    CollectionReference moedasCollection = userDoc.collection('moedas');

    // Limpe a coleção de moedas existentes antes de adicionar as novas moedas
    await moedasCollection.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });

    listaMoeda.forEach((moeda) async {
      await moedasCollection.add(moeda.moedaJson());
    });
  }
}
