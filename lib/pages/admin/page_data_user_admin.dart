import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ukk_cafe/components/admin/informasi_user_admin.dart';
import 'package:ukk_cafe/models/users.dart';
import '../../services/user_service.dart';

class PageDataUserAdmin extends StatefulWidget {
  const PageDataUserAdmin({super.key});

  @override
  State<PageDataUserAdmin> createState() => _PageDataUserAdminState();
}

class _PageDataUserAdminState extends State<PageDataUserAdmin> {
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 244, 248, 1),
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text(
          "Data User",
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(203, 24, 28, 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.all(15),
                child: Text(
                  "Data User",
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20), // Spacing between title and table
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Nama",
                          style: GoogleFonts.poppins(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Role",
                          style: GoogleFonts.poppins(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          ""
                          // "Email",
                          // style: GoogleFonts.poppins(
                          //   fontSize: MediaQuery.of(context).size.width * 0.04,
                          //   fontWeight: FontWeight.w600,
                          //   color: Colors.black,
                          // ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10), // Spacing below header
              FutureBuilder<List<UserModel>>(
                future: _userService.getAllUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text('Tidak ada pengguna yang ditemukan'));
                  }
                  final userList = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      final user = userList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: InformasiUserAdmin(
                          uid: user.uid,
                          name: user.name,
                          role: user.role,
                          email: user.email,
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
