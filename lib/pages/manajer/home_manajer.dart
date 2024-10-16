import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/auth_service.dart';

class HomeManajerPage extends StatefulWidget {
  const HomeManajerPage({super.key});

  @override
  State<HomeManajerPage> createState() => _HomeManajerPageState();
}

class _HomeManajerPageState extends State<HomeManajerPage> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDate(
    BuildContext context,
    bool isStartDate,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  Stream<QuerySnapshot> _getTransaksiStream() {
    // Ubah tipe variabel query menjadi Query<Map<String, dynamic>>
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection('transaksi');

    if (_startDate != null && _endDate != null) {
      query = query.where(
        'tgl_transaksi',
        isGreaterThanOrEqualTo: Timestamp.fromDate(_startDate!),
        isLessThanOrEqualTo: Timestamp.fromDate(_endDate!),
      );
    }

    return query.snapshots();
  }

  void _handleLogout() {
    AuthService().logout(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 244, 248, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Data Transaksi - Manajer',
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.035,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _handleLogout();
            },
            icon: Icon(
              Icons.logout,
              size: 30,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('Tanggal Mulai:'),
                      TextButton(
                        onPressed: () => _selectDate(context, true),
                        child: Text(_startDate == null
                            ? 'Pilih Tanggal'
                            : _startDate.toString().split(' ')[0]),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text('Tanggal Akhir:'),
                      TextButton(
                        onPressed: () => _selectDate(context, false),
                        child: Text(_endDate == null
                            ? 'Pilih Tanggal'
                            : _endDate.toString().split(' ')[0]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getTransaksiStream(),
              builder: (
                context,
                snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'Tidak ada transaksi.',
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var transaksi = snapshot.data!.docs[index];

                    return ListTile(
                      title: Text(
                        'Transaksi ID: ${transaksi.id}',
                      ),
                      subtitle: Text(
                        'Tanggal: ${(transaksi['tgl_transaksi'] as Timestamp).toDate()}',
                      ),
                      trailing: Text(
                        'Status: ${transaksi['status']}',
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
