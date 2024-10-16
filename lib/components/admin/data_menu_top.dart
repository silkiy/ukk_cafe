import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DataMenuTop extends StatelessWidget {
  final String textLeading;
  final String textAction;
  final String route;

  DataMenuTop({
    super.key,
    required this.textLeading,
    required this.textAction,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Color.fromRGBO(203, 24, 28, 1)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Text(
              textLeading,
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(243, 244, 248, 1),
              ),
            ),
            Expanded(child: Container()),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  route,
                );
              },
              child: Text(
                textAction,
                style: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(243, 244, 248, 1),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
