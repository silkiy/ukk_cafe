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
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            ClipOval(
              child: Image.network(
                imagePath,
                width: 60, // Set a fixed width and height
                height: 60,
                fit: BoxFit.cover, // Cover the circle
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.fastfood,
                    size: 60,
                  ); // Placeholder icon
                },
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    namaMenu,
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    jenisMenu,
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromRGBO(60, 60, 60, 1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
