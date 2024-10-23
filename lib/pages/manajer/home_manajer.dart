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
            fontSize: MediaQuery.of(context).size.width * 0.045,
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
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDatePicker(
                  label: 'Tanggal Mulai',
                  date: _startDate,
                  isStartDate: true,
                ),
                _buildDatePicker(
                  label: 'Tanggal Akhir',
                  date: _endDate,
                  isStartDate: false,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getTransaksiStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'Tidak ada transaksi.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var transaksi = snapshot.data!.docs[index];

                    return Card(
                      margin: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                          'Transaksi ID: ${transaksi.id}',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          'Tanggal: ${(transaksi['tgl_transaksi'] as Timestamp).toDate()}',
                          style: GoogleFonts.poppins(color: Colors.grey[700]),
                        ),
                        trailing: Chip(
                          label: Text(
                            'Status: ${transaksi['status']}',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor:
                              transaksi['status'] == 'sudah di bayar'
                                  ? Colors.green
                                  : Colors.red,
                        ),
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

  Widget _buildDatePicker({
    required String label,
    required DateTime? date,
    required bool isStartDate,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _selectDate(
              context,
              isStartDate,
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0), // Add horizontal padding
              child: Text(
                date == null ? 'Pilih Tanggal' : date.toString().split(' ')[0],
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
