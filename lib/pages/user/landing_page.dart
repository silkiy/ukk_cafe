import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../components/user/menu_list.dart';
import '../../services/menu_service.dart';
import '../../models/menu.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MenuService menuService = MenuService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<List<Menu>> _fetchMenus(String jenis) {
    return menuService.getMenuByJenis(jenis);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 244, 248, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Wikusama Cafe",
          style: GoogleFonts.bebasNeue(
            fontSize: MediaQuery.of(context).size.width * 0.09,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login_page');
            },
            icon: Icon(
              Icons.login,
              size: 30,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // TabBar di body
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color.fromRGBO(152, 3, 6, 1),
            tabs: [
              Tab(text: "Makanan"),
              Tab(text: "Minuman"),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                FutureBuilder<List<Menu>>(
                  future: _fetchMenus('makanan'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    }
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return MenuList(
                          menus: snapshot.data!); // Panggil MenuList
                    }
                    return Center(
                      child: Text('Tidak ada menu makanan'),
                    );
                  },
                ),
                FutureBuilder<List<Menu>>(
                  future: _fetchMenus('minuman'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    }
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return MenuList(menus: snapshot.data!);
                    }
                    return Center(
                      child: Text('Tidak ada menu minuman'),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.pushNamed(
            context,
            '/detail_transaksi',
          );
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.shopping_bag_outlined),
      ),
    );
  }
}
