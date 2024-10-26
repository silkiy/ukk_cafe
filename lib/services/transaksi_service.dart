import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../models/transaction.dart';
import '../controllers/cart_notifier.dart';
import '../pages/kasir/receipt_dialog.dart';

class TransaksiService {
  // Fungsi untuk menambahkan transaksi ke Firestore
  static Future<void> tambahTransaksi(BuildContext context, Transaksi transaksi,
      List<CartItem> cartItems) async {
    try {
      final int idTransaksi =
          DateTime.now().millisecondsSinceEpoch; // Tetap sebagai int

      // Menyimpan transaksi utama ke koleksi transaksi di Firestore
      DocumentReference transaksiRef =
          await FirebaseFirestore.instance.collection('transaksi').add({
        'id_transaksi': idTransaksi,
        'tgl_transaksi': FieldValue.serverTimestamp(), // Timestamp saat ini
        'id_user': transaksi.idUser,
        'id_meja': transaksi.idMeja,
        'nama_pelanggan': transaksi.namaPelanggan,
        'status': transaksi.status,
      });

      // Menghitung total harga
      double totalHarga = cartItems.fold(0, (
        total,
        item,
      ) {
        return total + (item.harga * item.quantity);
      });
// Buat detailPesanan dengan totalHarga
      List<Map<String, dynamic>> detailPesanan = cartItems.map((item) {
        return {
          'id_menu': item.idMenu,
          'name': item.name,
          'harga': item.harga,
          'quantity': item.quantity,
        };
      }).toList();

// Jika Anda ingin menyimpan totalHarga dalam detail transaksi
      await FirebaseFirestore.instance.collection('detail_transaksi').add({
        'id_transaksi': transaksiRef.id, // Menghubungkan dengan id_transaksi
        'items': detailPesanan, // Menyimpan semua detail pesanan
        'total_harga': totalHarga, // Menyimpan total harga
      });

      context.read<CartNotifier>().clearCart();

      // Tampilkan pesan sukses
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Pesana berhasil di prosses'),
            content: Text(
              "Silahkan menuju meja yang telah anda pilih",
            ),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/landing_page',
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          );
        },
      );
    } catch (error) {
      // Tangani kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menambahkan transaksi: $error'),
        ),
      );
    }
  }

  // Fungsi untuk mencetak nota transaksi
  static void cetakNota(
    BuildContext context,
    Transaksi transaksi,
  ) {
    // Template nota
    String nota = '''
  ====================================
            Wikusama Cafe
  ====================================
  Tanggal: ${transaksi.tglTransaksi.toDate().toLocal()}
  Kasir: ${transaksi.idUser}
  Pelanggan: ${transaksi.namaPelanggan}
  Meja: ${transaksi.idMeja}
  ------------------------------------
  Daftar Pesanan:
  ''';

    // Mengambil detail transaksi dari Firestore
    FirebaseFirestore.instance
        .collection('detail_transaksi')
        .where(
          'id_transaksi',
          isEqualTo: transaksi.idTransaksi,
        )
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      double total = 0.0; // Inisialisasi total

      if (snapshot.docs.isEmpty) {
        nota += 'Tidak ada pesanan.\n';
      } else {
        snapshot.docs.forEach((doc) {
          final data = doc.data() as Map<String, dynamic>;

          // Mengambil item dari array
          final items = data['items'] as List;
          for (var item in items) {
            final harga = item['harga'] ?? 0.0; // Gunakan 0.0 jika null
            final quantity = item['quantity'] ?? 0; // Gunakan 0 jika null

            nota +=
                '${item['name']} - ${quantity}x @ ${harga}\n'; // Tampilkan harga satuan
            total += harga * quantity; // Hitung total
          }
        });
      }

      // Ambil status terbaru dari Firestore
      FirebaseFirestore.instance
          .collection('transaksi')
          .doc(transaksi.idTransaksi)
          .get()
          .then((DocumentSnapshot doc) {
        if (doc.exists) {
          final transaksiData = doc.data() as Map<String, dynamic>;
          String status = transaksiData['status'] ?? 'belum bayar';

          nota += '''
        ------------------------------------
        Total: ${total.toStringAsFixed(2)}
        Status: $status
        ====================================
        ''';

          // Tampilkan atau cetak nota
          print(nota);

          // Tampilkan dalam SnackBar (opsional)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Nota berhasil dicetak!'),
            ),
          );
        }
      });
    }, onError: (error) {
      // Tangani kesalahan jika gagal mengambil data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mencetak nota: $error'),
        ),
      );
    });
  }

  // Fungsi untuk mengambil detail transaksi
  static Future<List<Map<String, dynamic>>> fetchDetailTransaksi(
    String idTransaksi,
  ) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('detail_transaksi')
          .where(
            'id_transaksi',
            isEqualTo: idTransaksi,
          )
          .get();

      return snapshot.docs
          .map(
            (doc) => doc.data() as Map<String, dynamic>,
          )
          .toList();
    } catch (e) {
      print('Gagal mengambil detail transaksi: $e');
      throw Exception('Gagal mengambil detail transaksi');
    }
  }

  // Di dalam TransaksiService
  static Future<void> updateStatusTransaksi(
    BuildContext context,
    String idTransaksi,
    String userName,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('transaksi')
          .doc(idTransaksi)
          .update({
        'status': 'sudah di bayar',
        'id_user': userName,
      });

      // Jika update sukses, tampilkan snack bar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status transaksi berhasil diperbarui!'),
        ),
      );

      // Ambil transaksi terbaru dari Firestore
      final transaksi = await FirebaseFirestore.instance
          .collection('transaksi')
          .doc(idTransaksi)
          .get();

      if (transaksi.exists) {
        Transaksi transaksiData = Transaksi.fromFirestore(transaksi);

        // Tampilkan pop-up nota
        await showDialog(
          context: context,
          builder: (context) {
            return ReceiptDialog(transaksi: transaksiData);
          },
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui status: $e'),
        ),
      );
    }
  }
}
