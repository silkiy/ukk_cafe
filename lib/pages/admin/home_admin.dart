import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ukk_cafe/components/admin/add_container.dart';
import 'package:ukk_cafe/services/menu_service.dart';

import '../../components/admin/information_container.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  final UserService _userService = UserService();
  final MenuService _menuService = MenuService();

  Future<Map<String, int>> _getDashboardCounts() async {
    final int totalUser = await _userService.getUserCount();
    final int totalMenu = await _menuService.getMenuCount();

    return {
      'totalUser': totalUser,
      'totalMenu': totalMenu,
    };
  }

  void _handleLogout() {
    AuthService().logout(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 244, 248, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Admin',
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.035,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _handleLogout();
            },
            icon: Icon(
              Icons.logout,
              size: 30,
            ),
          ),
        ],
      ),
      body: Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: FutureBuilder<Map<String, int>>(
              future: _getDashboardCounts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  ); // Loading state
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  ); // Error state
                } else if (!snapshot.hasData) {
                  return Center(
                    child: Text('Tidak ada data yang tersedia'),
                  );
                }

                final int totalUser = snapshot.data!['totalUser']!;
                final int totalMenu = snapshot.data!['totalMenu']!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Total User dan menu",
                      style: GoogleFonts.poppins(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        InformationContainer(
                          route: '/page_data_menu_admin',
                          icon: Icons.food_bank,
                          jumlah: totalMenu.toString(),
                          jenis: "Total Menu",
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        InformationContainer(
                          route: '',
                          icon: Icons.person,
                          jumlah: totalUser.toString(),
                          jenis: "Total User",
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Tambah user dan menu",
                      style: GoogleFonts.poppins(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        AddContainerAdmin(
                          route: '/tambah_pemain',
                          jenis: "Tambah User",
                          icon: Icons.add,
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        AddContainerAdmin(
                          route: '/tambah_menu_admin',
                          jenis: "Tambah Menu",
                          icon: Icons.add,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Tambah meja",
                      style: GoogleFonts.poppins(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    AddContainerAdmin(
                      route: '/jadwal_admin',
                      jenis: "Tambah Meja",
                      icon: Icons.table_restaurant_rounded,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
