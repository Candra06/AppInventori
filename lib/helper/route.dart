import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory/barang/detailBarang.dart';
import 'package:inventory/barang/listBarang.dart';
import 'package:inventory/barang/tambahBarang.dart';
import 'package:inventory/histori/historyPemasukan.dart';
import 'package:inventory/histori/historyPengeluaran.dart';
import 'package:inventory/splash.dart';
import 'package:page_transition/page_transition.dart';

class Routes {
  static const String SPLASH = '/splash';
  static const String LOGIN = '/login';
  static const String REGISTER = '/register';
  static const String HOME = '/home';
  static const String DETAIL_BARANG = '/detail_barang';
  static const String EDIT_BARANG = '/edit_barang';
  static const String HISTORY_BARANG_KELUAR = '/barang_keluar';
  static const String HISTORY_BARANG_MASUK = '/barang_masuk';
  static const String LIST_CHAT = '/list_room';
  static const String ROOM_CHAT = '/room_chat';
  static const String DETAIL_CHALLENGE = '/detail_challenge';
  static const String MEMBERSHIP = '/membership';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SPLASH:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case HOME:
        return PageTransition(child: ListBarang(), type: PageTransitionType.bottomToTop);
      case HISTORY_BARANG_KELUAR:
        return PageTransition(child: HistoriPengeluaran(), type: PageTransitionType.bottomToTop);
      case HISTORY_BARANG_MASUK:
        return PageTransition(child: HistoriPemasukan(), type: PageTransitionType.bottomToTop);
      case DETAIL_BARANG:
        return PageTransition(
            child: DetailBarang(
              barang: settings.arguments,
            ),
            type: PageTransitionType.bottomToTop);
      case EDIT_BARANG:
        return PageTransition(
            child: TambahDataBarang(
              data: settings.arguments,
            ),
            type: PageTransitionType.bottomToTop);

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('Page ${settings.name} not defined'),
                  ),
                ));
    }
  }
}
