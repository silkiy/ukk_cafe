import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/transaction.dart';

class ReceiptDialog extends StatefulWidget {
  final Transaksi transaksi;

  const ReceiptDialog({
    Key? key,
    required this.transaksi,
  }) : super(key: key);

  @override
  _ReceiptDialogState createState() => _ReceiptDialogState();
}

class _ReceiptDialogState extends State<ReceiptDialog> {
  List<Map<String, dynamic>> items = [];
  double total = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetailTransaksi();
  }

  Future<void> fetchDetailTransaksi() async {
    try {
      // Mengambil detail transaksi dari Firestore
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('detail_transaksi')
          .where('id_transaksi', isEqualTo: widget.transaksi.idTransaksi)
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final itemsList = data['items'] as List;

        for (var item in itemsList) {
          final harga = item['harga'] ?? 0.0;
          final quantity = item['quantity'] ?? 0;

          items.add(item); // Menyimpan item
          total += harga * quantity; // Hitung total
        }
      }

      setState(() {
        isLoading = false; // Set loading menjadi false
      });
    } catch (e) {
      // Tangani kesalahan
      print('Gagal mengambil detail transaksi: $e');
      setState(() {
        isLoading = false; // Set loading menjadi false meski terjadi kesalahan
      });
    }
  }

  Future<void> _confirmPrint(BuildContext context) async {
    final shouldPrint = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi Cetak Nota'),
          content: Text('Apakah Anda ingin mencetak nota transaksi ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true
              },
              child: Text('Ya'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false
              },
              child: Text('Tidak'),
            ),
          ],
        );
      },
    );

    if (shouldPrint == true) {
      // Call your print function here
      // For example: printNota(widget.transaksi);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nota berhasil dicetak!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nota Transaksi'),
      content: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('Transaksi ID: ${widget.transaksi.idTransaksi}'),
                  Text('Nama Kasir: ${widget.transaksi.idUser}'),
                  Text('Tanggal: ${widget.transaksi.tglTransaksi.toDate()}'),
                  Text('Meja: ${widget.transaksi.idMeja}'),
                  Text('Pelanggan: ${widget.transaksi.namaPelanggan}'),
                  SizedBox(height: 10),
                  Text('Detail Item:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...items.map((item) {
                    return Text(
                        '${item['name']} x ${item['quantity']} = Rp ${item['harga'] * item['quantity']}');
                  }).toList(),
                  SizedBox(height: 10),
                  Text('Total: Rp ${total.toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Tutup dialog
          },
          child: Text('Tutup'),
        ),
        TextButton(
          onPressed: () {
            _confirmPrint(context); // Tampilkan dialog konfirmasi cetak
          },
          child: Text('Print'),
        ),
      ],
    );
  }
}
