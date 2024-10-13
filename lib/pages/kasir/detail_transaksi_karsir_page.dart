import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/transaction.dart';
import '../../services/transaksi_service.dart';

class DetailTransaksiKarsirPage extends StatefulWidget {
  final Transaksi transaksi;

  DetailTransaksiKarsirPage({
    super.key,
    required this.transaksi,
  });

  @override
  State<DetailTransaksiKarsirPage> createState() =>
      _DetailTransaksiKarsirPageState();
}

class _DetailTransaksiKarsirPageState extends State<DetailTransaksiKarsirPage> {
  List<Map<String, dynamic>> _detailTransaksi = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchDetailTransaksi();
  }

  Future<void> _fetchDetailTransaksi() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Mengambil detail transaksi menggunakan service
      _detailTransaksi = await TransaksiService.fetchDetailTransaksi(
        widget.transaksi.idTransaksi,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil detail transaksi: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Transaksi'),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('transaksi')
            .doc(widget.transaksi.idTransaksi)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.exists == false) {
            return Center(child: Text('Transaksi tidak ditemukan.'));
          }

          // Ambil data transaksi langsung dari snapshot
          final transaksiData = snapshot.data!.data() as Map<String, dynamic>;
          final transaksi = Transaksi.fromMap(transaksiData, snapshot.data!.id);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaksi ID: ${transaksi.idTransaksi}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Tanggal: ${transaksi.tglTransaksi.toDate()}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Meja: ${transaksi.idMeja}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Pelanggan: ${transaksi.namaPelanggan}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Text(
                          'Status: ',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "${transaksi.status}",
                          style: TextStyle(
                            fontSize: 16,
                            color: transaksi.status == 'sudah di bayar'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _detailTransaksi.length,
                  itemBuilder: (context, index) {
                    // Ambil array 'items' dari setiap detail transaksi
                    final List items = _detailTransaksi[index]['items'] ?? [];

                    // Periksa jika ada item yang ditampilkan
                    if (items.isEmpty) {
                      return ListTile(
                        title: Text('No items available'),
                      );
                    }

                    // Kembalikan Column untuk menampilkan semua item dalam transaksi ini
                    return Column(
                      children: items.map<Widget>((item) {
                        // Ambil nilai dengan aman dari item
                        final String name = item['name'] ?? 'Unknown';
                        final int quantity = item['quantity'] ?? 0;
                        final double harga = item['harga'] != null
                            ? item['harga'].toDouble()
                            : 0.0;

                        return ListTile(
                          title: Text(name),
                          subtitle: Text('$quantity x Rp $harga'),
                          trailing: Text('Subtotal: Rp ${quantity * harga}'),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        TransaksiService.cetakNota(
                          context,
                          widget.transaksi,
                        );
                      },
                      child: Text('Cetak Nota'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true; // Mulai loading
                        });

                        await TransaksiService.updateStatusTransaksi(
                          context,
                          widget.transaksi.idTransaksi,
                        );

                        // Opsional: Segarkan detail setelah pembaruan status
                        _fetchDetailTransaksi();
                      },
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text('Tandai sebagai Sudah di Bayar'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
