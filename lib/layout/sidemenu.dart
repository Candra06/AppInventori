import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory/helper/config.dart';
import 'package:inventory/helper/pref.dart';
import 'package:inventory/helper/route.dart';
import 'package:inventory/login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key key}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String nama = '', username = '';
  void getInfo() async {
    var tmpNama = await Pref.getName();
    var tmpUsername = await Pref.getUsername();
    print(tmpNama);
    setState(() {
      nama = tmpNama;
      username = tmpUsername;
    });
  }

  void logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    setState(() {
      Navigator.pushReplacement(context, PageTransition(child: LoginPIN(), type: PageTransitionType.bottomToTop));
    });
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.account_circle_rounded,
              size: 50,
              color: Colors.blue,
            ),
            title: Text(nama == '' || nama == null ? '-' : nama, style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
            subtitle: Text(username == '' || username == null ? '-' : username, style: GoogleFonts.lato(color: Config.textGrey)),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text(
              'List Barang',
            ),
            onTap: () {
              Navigator.pushNamed(context, Routes.HOME);
            },
          ),
          ListTile(
            leading: Icon(Icons.inbox_rounded),
            title: Text(
              'Data Pemasukan',
            ),
            onTap: () {
              Navigator.pushNamed(context, Routes.HISTORY_BARANG_MASUK);
            },
          ),
          ListTile(
            leading: Icon(Icons.outbox_rounded),
            title: Text(
              'Data Pengeluaran',
            ),
            onTap: () {
              Navigator.pushNamed(context, Routes.HISTORY_BARANG_KELUAR);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(
              'Log Out',
            ),
            onTap: () {
              logOut();
            },
          ),
        ],
      ),
    );
  }
}
