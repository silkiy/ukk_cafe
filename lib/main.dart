import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukk_cafe/pages/admin/detail_menu_admin.dart';

import 'package:ukk_cafe/pages/admin/home_admin.dart';
import 'package:ukk_cafe/pages/admin/page_data_menu_admin.dart';
import 'package:ukk_cafe/pages/admin/page_tambah_menu_admin.dart';
import 'package:ukk_cafe/pages/kasir/home_kasir.dart';
import 'package:ukk_cafe/pages/manajer/home_manajer.dart';
import 'package:ukk_cafe/pages/user/detail_transaksi_page.dart';
import 'package:ukk_cafe/pages/user/landing_page.dart';
import 'package:ukk_cafe/pages/user/menu_detail_page.dart';

import 'controllers/cart_notifier.dart';
import 'controllers/menu_notifier.dart';
import 'pages/admin/page_update_menu_admin.dart';
import 'pages/auth/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CartNotifier(),
        ),
        ChangeNotifierProvider(
          create: (_) => MenuNotifier(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/landing_page",
      debugShowCheckedModeBanner: false,
      routes: {
        //landing page
        '/landing_page': (context) => LandingPage(),
        '/detail_transaksi': (context) => DetailTransaksiPage(),
        //login page
        '/login_page': (context) => LoginPage(),
        //admin
        '/home_admin': (context) => HomeAdminPage(),
        '/page_data_menu_admin': (context) => PageDataMenuAdmin(),
        '/detail_menu_admin': (context) => DetailMenuAdmin(),
        '/tambah_menu_admin': (context) => PageTambahMenuAdmin(),
        '/update_menu': (context) => UpdateMenuPage(),
        //kasir
        '/home_kasir': (context) => HomeKasirPage(),
        //manajer
        '/home_manajer': (context) => HomeManajerPage(),
      },
    );
  }
}
