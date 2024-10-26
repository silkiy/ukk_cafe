import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ukk_cafe/components/admin/user_detail_card.dart';
import 'package:ukk_cafe/services/menu_service.dart';
import 'package:ukk_cafe/services/user_service.dart';
import '../../models/users.dart';

class DetailUserAdmin extends StatefulWidget {
  const DetailUserAdmin({super.key});

  @override
  State<DetailUserAdmin> createState() => _DetailUserAdminState();
}

class _DetailUserAdminState extends State<DetailUserAdmin> {
  late Future<List<UserModel>> _getUser;
  final UserService _userService = UserService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getUser = _userService.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;

    // Memeriksa tipe args
    if (args is! Map<String, dynamic>) {
      
      return Scaffold(
        appBar: AppBar(
          title: Text("Error"),
        ),
        body: Center(
          child: Text('Invalid arguments received'),
        ),
      );
    }

    // Mengambil data dari args
    final String uid = args['uid'] ?? 'uid';

    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 244, 248, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Details user",
          style: GoogleFonts.cambo(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _getUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('Tidak ada user yang ditemukan'),
            );
          }

          final userList = snapshot.data!;
          final user = userList.firstWhere(
            (user) => user.uid == uid,
            orElse: () => UserModel(
              uid: uid,
              name: '',
              email: '',
              role: '',
            ),
          );

          return Padding(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  UserDetailCard(
                    nama: user.name,
                    role: user.role,
                    email: user.email,
                    uid: user.uid,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
