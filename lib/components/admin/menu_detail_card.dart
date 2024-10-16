import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuDetailCard extends StatelessWidget {
  final String imagePath;
  final String namaMenu;
  final String jenisMenu;

  MenuDetailCard({
    super.key,
    required this.imagePath,
    required this.namaMenu,
    required this.jenisMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.black,
              backgroundImage: NetworkImage(
                imagePath,
              ),
              radius: 30,
            ),
            SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  namaMenu,
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  jenisMenu,
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromRGBO(60, 60, 60, 1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
