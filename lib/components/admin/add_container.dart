import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddContainerAdmin extends StatelessWidget {
  final String jenis; // jenis misal pemain etc
  final IconData icon; //icon
  final String route; // pindah halaman

  const AddContainerAdmin({
    super.key,
    required this.jenis,
    required this.icon,
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
              color: Colors.grey,
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.2,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
