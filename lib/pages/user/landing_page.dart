import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../controllers/cart_notifier.dart';
import '../../models/menu.dart';
import '../../services/menu_service.dart';
import '../../components/user/menu_card.dart';
import 'menu_detail_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final MenuService menuService = MenuService();
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<Menu>>(
                future: menuService
                    .getMenu(), // Panggil method getMenu dari MenuService
                builder: (
                  context,
                  snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  } else {
                    final menuList = snapshot.data!;

                    // Pisahkan menu menjadi dua kategori: minuman dan makanan
                    List<Menu> minumanList = menuList
                        .where((menu) => menu.jenis == 'minuman')
                        .toList();
                    List<Menu> makananList = menuList
                        .where((menu) => menu.jenis == 'makanan')
                        .toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Bagian Minuman
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Minuman",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14.0,
                              mainAxisSpacing: 14.0,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: minumanList.length,
                            itemBuilder: (context, index) {
                              final minuman = minumanList[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MenuDetailPage(menu: minuman),
                                    ),
                                  );
                                },
                                child: MenuCard(
                                  harga: "Rp${minuman.harga}",
                                  id: minuman.id,
                                  img: minuman.img,
                                  jenis: minuman.jenis,
                                  name: minuman.name,
                                ),
                              );
                            },
                          ),
                        ),

                        // Bagian Makanan
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Makanan",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14.0,
                              mainAxisSpacing: 14.0,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: makananList.length,
                            itemBuilder: (context, index) {
                              final makanan = makananList[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MenuDetailPage(menu: makanan),
                                    ),
                                  );
                                },
                                child: MenuCard(
                                  harga: "Rp${makanan.harga}",
                                  id: makanan.id,
                                  img: makanan.img,
                                  jenis: makanan.jenis,
                                  name: makanan.name,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.pushNamed(context, '/detail_transaksi');
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.width * 0.14,
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.5, 0.5),
                                    blurRadius: 0.5,
                                  )
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  "Check your cart",
                                  style: GoogleFonts.poppins(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
