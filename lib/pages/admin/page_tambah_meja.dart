import 'package:flutter/material.dart';

import '../../models/meja.dart';
import '../../services/meja_service.dart';

class PageTambahMeja extends StatefulWidget {
  const PageTambahMeja({super.key});

  @override
  State<PageTambahMeja> createState() => _PageTambahMejaState();
}

class _PageTambahMejaState extends State<PageTambahMeja> {
  final TextEditingController idMejaController = TextEditingController();
  final TextEditingController nomorMejaController = TextEditingController();

  Future<void> addNewMeja(Meja meja) async {
    try {
      await MejaService().createMeja(meja);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Meja berhasil ditambahkan!'),
        ),
      );
      // Reset input fields
      idMejaController.clear();
      nomorMejaController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menambahkan meja: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 244, 248, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Tambah Meja'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ID Meja Input
            _buildTextField(
              idMejaController,
              'ID Meja (id_meja)',
              false,
            ),
            SizedBox(height: 16.0), // Jarak antar input

            // Nomor Meja Input
            _buildTextField(
              nomorMejaController,
              'Nomor Meja',
              true,
            ),
            SizedBox(height: 24.0), // Jarak sebelum tombol

            // Tambah Meja Button menggunakan GestureDetector
            GestureDetector(
              onTap: () {
                if (idMejaController.text.isNotEmpty &&
                    nomorMejaController.text.isNotEmpty) {
                  String idMeja = idMejaController.text;
                  int nomorMeja = int.parse(nomorMejaController.text);

                  Meja newMeja = Meja(
                    idMeja: "meja_$idMeja",
                    nomorMeja: nomorMeja,
                    status: true, // Status awal meja
                  );

                  addNewMeja(newMeja);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Semua field harus diisi!'),
                    ),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Tambah Meja',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, bool isNumber) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16.0),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      ),
    );
  }
}
