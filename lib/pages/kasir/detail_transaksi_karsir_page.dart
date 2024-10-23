import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/transaction.dart';
import '../../services/meja_service.dart';
import '../../services/transaksi_service.dart';
import '../../services/user_service.dart';

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

  String userName = '';
  String userRole = '';
  String userUid = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    _fetchDetailTransaksi();
    _getUserDetails();
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

  Future<void> _getUserDetails() async {
    final userService = UserService();
    final userIdentity = await userService.getUserByUid();

    if (userIdentity != null) {
      setState(() {
        userName = userIdentity['name'] ?? 'No Name';
        userRole = userIdentity['role'] ?? 'No Role';
        userEmail = userIdentity['email'] ?? 'No Email';
        userUid = userIdentity['uid'] ?? 'No uid';
      });
      print(
        'User Details: Name: $userName, Role: $userRole, Email: $userEmail, UID: $userUid',
      ); // Debugging statement
    } else {
      print('No user details found'); // Debugging statement
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 244, 248, 1),
      appBar: AppBar(
        title: Text(
          'Detail Transaksi $userName',
        ),
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
          final transaksi = Transaksi.fromMap(
            transaksiData,
            snapshot.data!.id,
          );

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
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
                                      color:
                                          transaksi.status == 'sudah di bayar'
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
                                    trailing: Text(
                                        'Subtotal: Rp ${quantity * harga}'),
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
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        _isLoading = true; // Start loading
                      });

                      try {
                        await TransaksiService.updateStatusTransaksi(
                          context,
                          widget.transaksi.idTransaksi,
                          userName,
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
                    child: Container(
                      height: MediaQuery.of(context).size.width * 0.14,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: _isLoading
                            ? CircularProgressIndicator
                                .adaptive() // Tampilkan loading
                            : Text(
                                "Tandai sebagai Sudah di Bayar\nCetak nota",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
