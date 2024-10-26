import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserDetailCard extends StatelessWidget {
  final String uid;
  final String nama;
  final String role;
  final String email;

  UserDetailCard({
    super.key,
    required this.uid,
    required this.nama,
    required this.role,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
              "UID",
              uid,
              context,
            ),
            _buildDetailRow(
              "Nama",
              nama,
              context,
            ),
            _buildDetailRow(
              "Role",
              role,
              context,
            ),
            _buildDetailRow(
              "Email",
              email,
              context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.035,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(60, 60, 60, 1),
              ),
              overflow: TextOverflow.ellipsis, // untuk teks yang lebih panjang
              maxLines: 1, // maksimum satu baris
            ),
          ),
        ],
      ),
    );
  }
}
