import 'package:cloud_firestore/cloud_firestore.dart';

class Meja {
  final String idMeja;
  final int nomorMeja;
  final bool status; // Change status to bool

  Meja({
    required this.idMeja,
    required this.nomorMeja,
    required this.status,
  });

  factory Meja.fromFirestore(DocumentSnapshot doc) {
    return Meja(
      idMeja: doc['id_meja'],
      nomorMeja: doc['nomer_meja'],
      status: doc['status'] ?? true, // Status is now a boolean
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_meja' : idMeja,
      'nomer_meja': nomorMeja,
      'status': status,
    };
  }
}
