import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../components/kasir/transaction_card.dart';
import '../../models/transaction.dart';
import '../../services/auth_service.dart';

class HomeKasirPage extends StatefulWidget {
  const HomeKasirPage({super.key});

  @override
  State<HomeKasirPage> createState() => _HomeKasirPageState();
}

class _HomeKasirPageState extends State<HomeKasirPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          'Data Transaksi - Kasir',
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.035,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _handleLogout,
            icon: Icon(
              Icons.logout,
              size: 30,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Color.fromRGBO(152, 3, 6, 1),
          tabs: [
            Tab(text: "Belum Bayar"),
            Tab(text: "Sudah Bayar"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Transaksi Belum Dibayar
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('transaksi')
                .where('status', isEqualTo: 'belum bayar')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final transactions = snapshot.data!.docs
                  .map((doc) => Transaksi.fromFirestore(doc))
                  .toList();

              if (transactions.isEmpty) {
                return Center(
                  child: Text('Tidak ada transaksi belum bayar'),
                );
              }

              return ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaksi = transactions[index];
                  return TransactionCard(transaction: transaksi);
                },
              );
            },
          ),
          // Transaksi Sudah Dibayar
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('transaksi')
                .where('status', isEqualTo: 'sudah di bayar')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final transactions = snapshot.data!.docs
                  .map((doc) => Transaksi.fromFirestore(doc))
                  .toList();

              if (transactions.isEmpty) {
                return Center(
                  child: Text('Tidak ada transaksi sudah bayar'),
                );
              }

              return ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaksi = transactions[index];
                  return TransactionCard(transaction: transaksi);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
