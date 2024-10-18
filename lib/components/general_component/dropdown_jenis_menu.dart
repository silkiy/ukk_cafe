import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DropdownJenisMenu extends StatefulWidget {
  final Function(String)? onJenisMenuSelected;
  const DropdownJenisMenu({
    super.key,
    this.onJenisMenuSelected,
  });

  @override
  State<DropdownJenisMenu> createState() => _DropdownJenisMenuState();
}

class _DropdownJenisMenuState extends State<DropdownJenisMenu> {
  String _jenisMenus = 'Pilih jenis menu';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromRGBO(243, 244, 248, 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Jenis Menu",
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.035,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(60, 60, 60, 1),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          ExpansionTile(
            title: Text(
              _jenisMenus, // This changes dynamically based on the selection
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: _jenisMenus != "Pilih Jenis Menu"
                    ? Colors.black
                    : Color.fromRGBO(101, 101, 101, 1),
              ),
            ),
            children: [
              _buildersJenisMenuOption("minuman", context),
              _buildersJenisMenuOption("makanan", context)
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildersJenisMenuOption(String jenisMenu, BuildContext context) {
    bool isSelected = _jenisMenus == jenisMenu;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: TextButton(
          onPressed: () {
            setState(() {
              _jenisMenus = jenisMenu;
            });
            if (widget.onJenisMenuSelected != null) {
              widget.onJenisMenuSelected!(jenisMenu);
            }
          },
          child: Text(
            jenisMenu,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Colors.black // Color for selected option
                  : Color.fromRGBO(
                      154, 154, 154, 1), // Color for unselected options
            ),
          ),
        ),
        trailing: isSelected
            ? Icon(
                Icons.check,
                color: Colors.black,
              ) // Show a check mark if selected
            : null, // No icon if unselected
      ),
    );
  }
}
