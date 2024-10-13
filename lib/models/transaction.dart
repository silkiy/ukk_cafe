import 'package:cloud_firestore/cloud_firestore.dart';

class Transaksi {
  final String idTransaksi; // Change to String
  final Timestamp tglTransaksi;
  final String idUser;
  final String idMeja;
  final String namaPelanggan;
  late final String status;

  Transaksi({
    required this.idTransaksi,
    required this.tglTransaksi,
    required this.idUser,
    required this.idMeja,
    required this.namaPelanggan,
    required this.status,
  });

  // Factory constructor to create Transaksi from Firestore document
  factory Transaksi.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Transaksi(
      idTransaksi: doc.id,
      tglTransaksi: data['tgl_transaksi'],
      idUser: data['id_user'],
      idMeja: data['id_meja'],
      namaPelanggan: data['nama_pelanggan'],
      status: data['status'],
    );
  }

  // Method to create Transaksi from Map and ID
  factory Transaksi.fromMap(Map<String, dynamic> data, String id) {
    return Transaksi(
      idTransaksi: id,
      tglTransaksi: data['tgl_transaksi'],
      idUser: data['id_user'],
      idMeja: data['id_meja'],
      namaPelanggan: data['nama_pelanggan'],
      status: data['status'],
    );
  }
}
