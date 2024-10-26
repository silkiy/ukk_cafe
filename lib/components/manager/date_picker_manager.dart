import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildDatePicker({
  required BuildContext context,
  required String label,
  required DateTime? date,
  required Function() onSelectDate,
}) {
  return Expanded(
    child: Column(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: onSelectDate,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12),
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              date == null ? 'Pilih Tanggal' : date.toString().split(' ')[0],
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}
