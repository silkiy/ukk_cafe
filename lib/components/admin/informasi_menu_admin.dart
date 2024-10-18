import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InformasiMenuAdmin extends StatelessWidget {
  final String id;
  final String namaMenu;
  final String jenis;
  final String harga;
  final String img;
  final String deskripsi;

  InformasiMenuAdmin({
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
    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        right: 10,
        left: 10,
      ),
      child: Row(
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
          SizedBox(width: 10),
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
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/detail_menu_admin',
                  arguments: {
                    'namaMenu': namaMenu,
                    'jenis': jenis,
                    'id': id, // Pass uid
                    'img': img, // Pass profileImg
                    'harga': harga, // Pass profileImg
                    'deskripsi': deskripsi, // Ensure this is included
                  },
                );
              },
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(203, 24, 28, 1),
                    ),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(
                      child: Text(
                        "Details",
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(203, 24, 28, 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
