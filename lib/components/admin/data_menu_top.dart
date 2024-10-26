import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DataMenuTop extends StatelessWidget {
  final String textLeading;
  final String textAction;
  final VoidCallback onTap; // Mengganti 'route' dengan 'onTap'

  DataMenuTop({
    super.key,
    required this.textLeading,
    required this.textAction,
    required this.onTap, // Tambahkan parameter onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
        color: Color.fromRGBO(203, 24, 28, 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Text(
              textLeading,
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text(
                textAction,
                style: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(203, 24, 28, 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
