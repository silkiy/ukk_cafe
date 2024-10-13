import 'package:cloud_firestore/cloud_firestore.dart';

class Meja {
  final String idMeja;
  final String nomorMeja;
  final String status; // 'available' or 'occupied'

  Meja(
      {required this.idMeja,
      required this.nomorMeja,
      this.status = 'available'});

  factory Meja.fromFirestore(DocumentSnapshot doc) {
    return Meja(
      idMeja: doc['id_meja'],
      nomorMeja: doc['nomor_meja'],
      status: doc['status'] ?? 'available',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id_meja': idMeja,
      'nomor_meja': nomorMeja,
      'status': status,
    };
  }
}
