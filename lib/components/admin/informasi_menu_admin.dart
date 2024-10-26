import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InformasiMenuAdmin extends StatelessWidget {
  final String id;
  final String namaMenu;
  final String jenis;
  final String harga;
  final String img;
  final String deskripsi;

  const InformasiMenuAdmin({
    super.key,
    required this.harga,
    required this.id,
    required this.namaMenu,
    required this.img,
    required this.jenis,
    required this.deskripsi,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                namaMenu,
                style: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 4,
              child: Text(
                jenis,
                style: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/detail_menu_admin',
                    arguments: {
                      'namaMenu': namaMenu,
                      'jenis': jenis,
                      'id': id,
                      'img': img,
                      'harga': harga,
                      'deskripsi': deskripsi,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(203, 24, 28, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(
                  "Details",
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
