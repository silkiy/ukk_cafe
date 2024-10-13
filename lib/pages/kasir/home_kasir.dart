import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ukk_cafe/components/user/menu_card.dart';
import 'package:ukk_cafe/pages/kasir/detail_transaksi_karsir_page.dart';

import '../../components/kasir/transaction_card.dart';
import '../../models/menu.dart';
import '../../models/transaction.dart';
import '../../services/auth_service.dart';
import '../../services/menu_service.dart';

class HomeKasirPage extends StatefulWidget {

  const HomeKasirPage({super.key});

  @override
  State<HomeKasirPage> createState() => _HomeKasirPageState();
}

class _HomeKasirPageState extends State<HomeKasirPage> {
  
  void _handleLogout() {
    AuthService().logout(context);
  }

  final MenuService menuService = MenuService();
  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 244, 248, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Daftar Transaksi',
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
      body:  SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('transaksi').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            // Mengambil data transaksi dari snapshot
            final transactions = snapshot.data!.docs
                .map((doc) => Transaksi.fromFirestore(doc))
                .toList();

            // Pisahkan transaksi berdasarkan status
            final paidTransactions = transactions
                .where((transaksi) => transaksi.status == 'sudah di bayar')
                .toList();
            final unpaidTransactions = transactions
                .where((transaksi) => transaksi.status == 'belum bayar')
                .toList();

            return Column(
              children: [
                // Bagian Transaksi Belum Dibayar
                Expanded(
                  child: ListView.builder(
                    itemCount: unpaidTransactions.length,
                    itemBuilder: (context, index) {
                      final transaksi = unpaidTransactions[index];
                      return TransactionCard(transaction: transaksi);

                    },
                  ),
                ),
                Divider(), // Pembatas antara dua bagian
                // Bagian Transaksi Sudah Dibayar
                Expanded(
                  child: ListView.builder(
                    itemCount: paidTransactions.length,
                    itemBuilder: (context, index) {
                      final transaksi = paidTransactions[index];

                      return TransactionCard(transaction: transaksi);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
