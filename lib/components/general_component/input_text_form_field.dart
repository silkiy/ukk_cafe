import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class InputFormField extends StatelessWidget {
  final String leading; // bio, ttl. umur dkk e
  final String hintText; // hint text
  final TextEditingController controller;
  final TextInputType keyboardType;
  final FormFieldValidator<String>?
      validator; // added optional validator parameter
  final Function(String)? onChanged;

  const InputFormField({
    super.key,
    required this.leading,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator, // added optional validator parameter,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            leading,
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.035,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(60, 60, 60, 1),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            decoration: BoxDecoration(
              color: Colors.white, // Warna background Container
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  offset: Offset(0.4, 0.4),
                  blurRadius: 0.2,
                ),
              ],
            ),
            child: TextFormField(
              // Changed from TextField to TextFormField
              keyboardType: keyboardType,
              controller: controller,
              cursorColor: Colors.black,
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintStyle: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(37, 37, 37, 1),
                ),
                hintText: hintText,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none, // Border color
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ), // Default border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Color.fromRGBO(203, 24, 28, 1),
                    width: 2.0,
                  ), // Border when focused
                ),
              ),
              validator: validator, // Corrected property name
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
        ],
      ),
    );
  }
}
