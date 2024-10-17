import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleTambahData extends StatelessWidget {
  final String title;
  final IconData icon; //icon

  const TitleTambahData({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Color.fromRGBO(203, 24, 28, 1),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.04,
        ),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        )
      ],
    );
  }
}
