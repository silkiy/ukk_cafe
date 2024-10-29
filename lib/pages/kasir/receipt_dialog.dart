import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
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
          items.add(item);
          total += harga * quantity;
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Gagal mengambil detail transaksi: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> generatePDF(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Nota Transaksi',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Transaksi ID: ${widget.transaksi.idTransaksi}'),
              pw.Text('Nama Kasir: ${widget.transaksi.idUser}'),
              pw.Text('Tanggal: ${widget.transaksi.tglTransaksi.toDate()}'),
              pw.Text('Meja: ${widget.transaksi.idMeja}'),
              pw.Text('Pelanggan: ${widget.transaksi.namaPelanggan}'),
              pw.SizedBox(height: 20),
              pw.Text(
                'Detail Item:',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Column(
                children: items.map((item) {
                  final name = item['name'] ?? 'Unknown';
                  final quantity = item['quantity'] ?? 0;
                  final harga = item['harga'] ?? 0.0;
                  return pw.Text(
                    '$name x $quantity = Rp${(harga * quantity).toStringAsFixed(2)}',
                  );
                }).toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Total: Rp${total.toStringAsFixed(2)}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nota Transaksi'),
      content: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('Transaksi ID: ${widget.transaksi.idTransaksi}'),
                  Text('Nama Kasir: ${widget.transaksi.idUser}'),
                  Text('Tanggal: ${widget.transaksi.tglTransaksi.toDate()}'),
                  Text('Meja: ${widget.transaksi.idMeja}'),
                  Text('Pelanggan: ${widget.transaksi.namaPelanggan}'),
                  SizedBox(height: 10),
                  Text(
                    'Detail Item:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...items.map((item) {
                    return Text(
                      '${item['name']} x ${item['quantity']} = Rp ${item['harga'] * item['quantity']}',
                    );
                  }).toList(),
                  SizedBox(height: 10),
                  Text(
                    'Total: Rp ${total.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Tutup'),
        ),
        TextButton(
          onPressed: () {
            generatePDF(context);
          },
          child: Text('Print'),
        ),
      ],
    );
  }
}
