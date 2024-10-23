import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/transaction.dart';
import '../../services/meja_service.dart';
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
      _detailTransaksi = await TransaksiService.fetchDetailTransaksi(
        widget.transaksi.idTransaksi,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil detail transaksi: $e'),
        ),
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
      backgroundColor: Color.fromRGBO(243, 244, 248, 1),
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

          final transaksiData = snapshot.data!.data() as Map<String, dynamic>;
          final transaksi = Transaksi.fromMap(transaksiData, snapshot.data!.id);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Transaction Details Card
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transaksi ID: ${transaksi.idTransaksi}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tanggal: ${transaksi.tglTransaksi.toDate()}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Meja: ${transaksi.idMeja}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Pelanggan: ${transaksi.namaPelanggan}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
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
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Items List Card
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: _detailTransaksi.map((detail) {
                          List items = detail['items'] ?? [];
                          if (items.isEmpty) {
                            return ListTile(
                              title: Text('No items available'),
                            );
                          }

                          return Column(
                            children: items.map<Widget>((item) {
                              final String name = item['name'] ?? 'Unknown';
                              final int quantity = item['quantity'] ?? 0;
                              final double harga = item['harga'] != null
                                  ? item['harga'].toDouble()
                                  : 0.0;

                              return ListTile(
                                title: Text(name),
                                subtitle: Text('$quantity x Rp $harga'),
                                trailing:
                                    Text('Subtotal: Rp ${quantity * harga}'),
                              );
                            }).toList(),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                TransaksiService.cetakNota(
                  context,
                  widget.transaksi,
                );
              },
              icon: Icon(Icons.print),
              label: Text('Cetak Nota'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () async {
                setState(() {
                  _isLoading = true; // Start loading
                });

                try {
                  await TransaksiService.updateStatusTransaksi(
                    context,
                    widget.transaksi.idTransaksi,
                  );

                  await MejaService.updateStatusMeja(
                    widget.transaksi.idMeja,
                    true,
                  );

                  _fetchDetailTransaksi();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                    ),
                  );
                } finally {
                  setState(() {
                    _isLoading = false; // Stop loading
                  });
                }
              },
              icon:
                  _isLoading ? CircularProgressIndicator() : Icon(Icons.check),
              label: Text('Tandai sebagai Sudah di Bayar'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
