import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../components/admin/text_field_admin.dart';
import '../../models/meja.dart';
import '../../services/meja_service.dart';

class PageTambahMeja extends StatefulWidget {
  const PageTambahMeja({super.key});

  @override
  State<PageTambahMeja> createState() => _PageTambahMejaState();
}

class _PageTambahMejaState extends State<PageTambahMeja> {
  final MejaService _mejaService = MejaService();
  final TextEditingController idMejaController = TextEditingController();
  final TextEditingController nomorMejaController = TextEditingController();

  late Future<List<Meja>> _mejaFuture;

  @override
  void initState() {
    super.initState();
    _mejaFuture = _mejaService.getMeja();
  }

  Future<void> addNewMeja(Meja meja) async {
    try {
      await _mejaService.createMeja(meja);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Meja berhasil ditambahkan!'),
        ),
      );
      idMejaController.clear();
      nomorMejaController.clear();

      // Memperbarui future dengan memanggil kembali data meja
      setState(() {
        _mejaFuture = _mejaService.getMeja();
      });
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
        title: Text(
          'Tambah Meja',
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Daftar Meja
            FutureBuilder<List<Meja>>(
              future: _mejaFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('Tidak ada meja yang ditambahkan.'),
                  );
                } else {
                  List<Meja> mejaList = snapshot.data!;
                  mejaList.sort(
                    (a, b) => a.nomorMeja.compareTo(b.nomorMeja),
                  );

                  return Expanded(
                    child: ListView.builder(
                      itemCount: mejaList.length,
                      itemBuilder: (context, index) {
                        final meja = mejaList[index];
                        return Card(
                          color: Colors.white,
                          elevation: 2,
                          margin: EdgeInsets.symmetric(
                            vertical: 6,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.table_chart,
                                      color: Colors.blue,
                                      size: 24,
                                    ),
                                    SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ID Meja: ${meja.idMeja}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          'Nomor Meja: ${meja.nomorMeja}',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),

            SizedBox(height: 24.0),

            // Input ID Meja
            buildTextField(
              idMejaController,
              'ID Meja (id_meja)',
              true,
            ),
            SizedBox(height: 16.0),

            // Input Nomor Meja
            buildTextField(
              nomorMejaController,
              'Nomor Meja',
              true,
            ),
            SizedBox(height: 24.0),

            // Tombol Tambah Meja
            ElevatedButton(
              onPressed: () {
                if (idMejaController.text.isNotEmpty &&
                    nomorMejaController.text.isNotEmpty) {
                  String idMeja = idMejaController.text;
                  int nomorMeja = int.parse(nomorMejaController.text);

                  Meja newMeja = Meja(
                    idMeja: "meja_$idMeja",
                    nomorMeja: nomorMeja,
                    status: true,
                  );

                  addNewMeja(newMeja);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Semua field harus diisi!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(203, 24, 28, 1),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
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
          ],
        ),
      ),
    );
  }
}
