import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DataMenuAdminListDetail extends StatelessWidget {
  final String detail;
  final String type;
  DataMenuAdminListDetail({
    super.key,
    required this.detail,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            "$type:",
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.035,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(37, 37, 37, 1),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              detail,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.03,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(60, 60, 60, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
