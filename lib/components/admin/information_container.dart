import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InformationContainer extends StatelessWidget {
  final IconData icon;
  final String jumlah;
  final String jenis;
  final String route;

  const InformationContainer({
    super.key,
    required this.icon,
    required this.jumlah,
    required this.jenis,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          route,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              offset: Offset(0.4, 0.4),
              blurRadius: 0.2,
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.2,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(203, 24, 28, 0.2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    icon,
                    color: Color.fromRGBO(203, 24, 28, 1),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                jumlah,
                style: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.width * 0.055,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              Text(
                jenis,
                style: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                  color: Color.fromRGBO(203, 24, 28, 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
