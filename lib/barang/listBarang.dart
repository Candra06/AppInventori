import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:inventory/barang/tambahBarang.dart';
import 'package:inventory/helper/config.dart';
import 'package:inventory/helper/database.dart';
import 'package:inventory/helper/network.dart';
import 'package:inventory/helper/route.dart';
import 'package:inventory/layout/sidemenu.dart';
import 'package:inventory/modal/tambahPemasukan.dart';
import 'package:inventory/modal/tambahPengeluaran.dart';
import 'package:inventory/model/home.dart';
import 'package:inventory/repository/repo_barang.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class ListBarang extends StatefulWidget {
  ListBarang({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListBarangState createState() => _ListBarangState();
}

class _ListBarangState extends State<ListBarang> {
  Database db;
  Connection conn = new Connection();
  List<Barang> listBarang;
  Future<List<Barang>> dataBarang;

  TextEditingController txtNama = new TextEditingController();
  BarangRepository barangRepository = new BarangRepository();
  bool load = true;
  String searchString = "";

  permissionServiceCall() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
      _createFolder();
    }
  }

  /*Permission services*/
  Future<Map<Permission, PermissionStatus>> permissionServices() async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.accessMediaLocation,
      Permission.camera,

      // Permission.microphone,
      //add more permission to request here.
    ].request();

    if (statuses[Permission.storage].isPermanentlyDenied) {
      openAppSettings();
      setState(() {});
    } else {
      if (statuses[Permission.storage].isDenied) {
        permissionServiceCall();
      }
    }

    return statuses;
  }

  _createFolder() async {
    // final root = await getApplicationDocumentsDirectory();
    final root = await getExternalStorageDirectory();
    // final fold = await getApplicationDocumentsDirectory();
    String folder = root.path.toString().replaceAll('files', 'databases');
    print("path baru " + folder);

    final path = Directory("storage/emulated/0/inventory/database");
    final pathImage = Directory("storage/emulated/0/inventory/foto");

    SharedPreferences pref = await SharedPreferences.getInstance();
    if ((await path.exists())) {
      print("exist");
      pref.setString("direktori", "storage/emulated/0/inventory/foto");
      pref.setString("db", "storage/emulated/0/inventory/database");
    } else {
      try {
        print("not exist");
        path.create();
        pathImage.create();
        pref.setString("direktori", "storage/emulated/0/inventory/foto");
        pref.setString("db", "storage/emulated/0/inventory/database");
      } catch (e) {
        print(e.toString());
      }
    }
  }

  void _tambahPemasukan(String id) async {
    return showModalBottomSheet(
        context: context,
        builder: (builder) {
          return TambahPemasukan(
            id: id,
          );
        });
  }

  Future<List<Barang>> getBarang() async {
    final _dataBarang = await conn.getBarang();

    return _dataBarang;
  }

  void _tambahPengeluaran(String id) async {
    return showModalBottomSheet(
        context: context,
        builder: (builder) {
          return TambahPengeluaran(
            id: id,
          );
        });
  }

  void getData() async {
    setState(() {
      load = true;
    });

    // listBarang = barangRepository.listBarang();
    // loadList();
    setState(() {
      load = false;
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => exit(0),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    permissionServiceCall();
    _createFolder();
    super.initState();
    dataBarang = getBarang();
  }

  @override
  Widget build(BuildContext context) {
    // if (listBarang == null) {
    //   listBarang = List<Barang>();
    // }

    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
          appBar: AppBar(
            title: Text('List Barang'),
            actions: [
              IconButton(
                  onPressed: () {
                    getData();
                  },
                  icon: Icon(Icons.refresh))
            ],
          ),
          drawer: SideMenu(),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, Routes.ADD_BARANG);
            },
          ),
          body: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      Container(
                        width: 200,
                        child: TextFormField(
                            style: TextStyle(color: Colors.black54),
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            controller: txtNama,
                            onChanged: (value) {
                              setState(() {
                                searchString = value;
                              });
                            },
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              fillColor: Colors.black54,
                              hintText: 'Cari Nama',
                              hintStyle: TextStyle(
                                  // color: Config.textWhite,
                                  fontSize: 14),
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    // Container(
                    //   width: 140,
                    //   alignment: Alignment.center,
                    //   child: Text('Gambar'),
                    // ),
                    Container(
                      width: 145,
                      alignment: Alignment.center,
                      child: Text('Nama'),
                    ),
                    Container(
                      width: 100,
                      alignment: Alignment.center,
                      child: Text('Tgl Masuk'),
                    ),
                    Container(
                      width: 100,
                      alignment: Alignment.center,
                      child: Text('Jumlah Masuk'),
                      // total masuk bulan ini
                    ),
                    Container(
                      width: 100,
                      alignment: Alignment.center,
                      child: Text('Tgl Keluar'),
                    ),
                    Container(
                      width: 100,
                      alignment: Alignment.center,
                      child: Text('Jumlah Keluar'),
                      // total keluar bulan ini
                    ),
                    Container(
                      width: 50,
                      alignment: Alignment.center,
                      child: Text('Stok'),
                    ),
                    Container(
                      width: 125,
                      alignment: Alignment.center,
                      child: Text('Keterangan'),
                      // total keluar bulan ini
                    ),
                    Container(
                      width: 50,
                      alignment: Alignment.center,
                      child: Text('Aksi'),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: new FutureBuilder(
                      future: dataBarang,
                      builder: (builder, AsyncSnapshot<List<Barang>> snapshot) {
                        print(snapshot.data);
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int i) {
                                // return Container();
                                if (searchString != '') {
                                  return snapshot.data[i].namaBarang.toLowerCase().contains(searchString.toLowerCase())
                                      ? Column(
                                          children: [
                                            Container(
                                              height: 90,
                                              margin: EdgeInsets.only(bottom: 8),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 140,
                                                    alignment: Alignment.center,
                                                    child: InkWell(
                                                      onTap: () {
                                                        print('tapped');
                                                        showDialog(
                                                            context: context,
                                                            builder: (_) => AlertDialog(
                                                                  title: Text('Dialog Title'),
                                                                  content: Image.network(
                                                                    EndPoint.server + '' + snapshot.data[i].foto,
                                                                    fit: BoxFit.fill,
                                                                  ),
                                                                ));
                                                      },
                                                      child: Image.network(
                                                        EndPoint.server + '' + snapshot.data[i].foto,
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 145,
                                                    child: Text(snapshot.data[i].namaBarang),
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    alignment: Alignment.center,
                                                    child: Text(snapshot.data[i].tanggalMasuk == '-' ? snapshot.data[i].tanggalMasuk : Config.formatDate(snapshot.data[i].tanggalMasuk)),
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    alignment: Alignment.center,
                                                    child: Text(snapshot.data[i].jumlahMasuk.toString()),
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    alignment: Alignment.center,
                                                    child: Text(snapshot.data[i].tanggalKeluar == '-' ? snapshot.data[i].tanggalKeluar : Config.formatDate(snapshot.data[i].tanggalKeluar)),
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    alignment: Alignment.center,
                                                    child: Text(snapshot.data[i].jumlahKeluar.toString()),
                                                  ),
                                                  Container(
                                                    width: 50,
                                                    alignment: Alignment.center,
                                                    child: Text(snapshot.data[i].stok.toString()),
                                                  ),
                                                  Container(
                                                      width: 125,
                                                      alignment: Alignment.center,
                                                      child: Text(snapshot.data[i].keterangan == null || snapshot.data[i].keterangan == 'null' ? '-' : snapshot.data[i].keterangan,
                                                          maxLines: 3, overflow: TextOverflow.fade, textAlign: TextAlign.center)),
                                                  Container(
                                                    width: 50,
                                                    child: Row(
                                                      children: [
                                                        PopupMenuButton(
                                                            onSelected: (value) {
                                                              if (value == 1) {
                                                                Navigator.pushNamed(context, Routes.DETAIL_BARANG, arguments: snapshot.data[i]);
                                                              } else if (value == 2) {
                                                                Navigator.pushNamed(context, Routes.EDIT_BARANG, arguments: snapshot.data[i]);
                                                              } else if (value == 3) {
                                                                _tambahPemasukan(snapshot.data[i].id.toString());
                                                              } else {
                                                                _tambahPengeluaran(snapshot.data[i].id.toString());
                                                              }
                                                            },
                                                            itemBuilder: (context) => [
                                                                  PopupMenuItem(
                                                                    child: Text("Detail"),
                                                                    value: 1,
                                                                  ),
                                                                  PopupMenuItem(
                                                                    child: Text("Edit"),
                                                                    value: 2,
                                                                  ),
                                                                  PopupMenuItem(
                                                                    child: Text("Tambah Pemasukan"),
                                                                    value: 3,
                                                                  ),
                                                                  PopupMenuItem(
                                                                    child: Text("Tambah Pengeluaran"),
                                                                    value: 4,
                                                                  )
                                                                ])
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Divider(
                                              height: 1,
                                            ),
                                            SizedBox(
                                              height: 8,
                                            )
                                          ],
                                        )
                                      : Container();
                                } else {
                                  return Column(
                                    children: [
                                      Container(
                                        height: 90,
                                        margin: EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          children: [
                                            // Container(
                                            //   width: 140,
                                            //   alignment: Alignment.center,
                                            //   child: InkWell(
                                            //     onTap: () {
                                            //       print('tapped');
                                            //       showDialog(
                                            //           context: context,
                                            //           builder: (_) => AlertDialog(
                                            //                 title: Text('Dialog Title'),
                                            //                 content: Image.network(
                                            //                   EndPoint.server + '' + listBarang[i].foto,
                                            //                   fit: BoxFit.fill,
                                            //                 ),
                                            //               ));
                                            //     },
                                            //     child: Image.network(
                                            //       EndPoint.server + '' + snapshot.data[i].foto,
                                            //       width: 100,
                                            //       height: 100,
                                            //       fit: BoxFit.fill,
                                            //     ),
                                            //   ),
                                            // ),
                                            Container(
                                              width: 145,
                                              child: Text(snapshot.data[i].namaBarang),
                                            ),
                                            Container(
                                              width: 100,
                                              alignment: Alignment.center,
                                              child: Text(snapshot.data[i].tanggalMasuk == '-' ? snapshot.data[i].tanggalMasuk : Config.formatDate(snapshot.data[i].tanggalMasuk)),
                                            ),
                                            Container(
                                              width: 100,
                                              alignment: Alignment.center,
                                              child: Text(snapshot.data[i].jumlahMasuk.toString()),
                                            ),
                                            Container(
                                              width: 100,
                                              alignment: Alignment.center,
                                              child: Text(snapshot.data[i].tanggalKeluar == '-' ? snapshot.data[i].tanggalKeluar : Config.formatDate(snapshot.data[i].tanggalKeluar)),
                                            ),
                                            Container(
                                              width: 100,
                                              alignment: Alignment.center,
                                              child: Text(snapshot.data[i].jumlahKeluar.toString()),
                                            ),
                                            Container(
                                              width: 50,
                                              alignment: Alignment.center,
                                              child: Text(snapshot.data[i].stok.toString()),
                                            ),
                                            Container(
                                              width: 125,
                                              alignment: Alignment.center,
                                              child: Text(snapshot.data[i].keterangan == null || snapshot.data[i].keterangan == 'null' ? '-' : snapshot.data[i].keterangan,
                                                  maxLines: 3, overflow: TextOverflow.fade, textAlign: TextAlign.center),
                                            ),
                                            Container(
                                              width: 50,
                                              child: Row(
                                                children: [
                                                  PopupMenuButton(
                                                      onSelected: (value) {
                                                        if (value == 1) {
                                                          Navigator.pushNamed(context, Routes.DETAIL_BARANG, arguments: snapshot.data[i]);
                                                        } else if (value == 2) {
                                                          Navigator.pushNamed(context, Routes.EDIT_BARANG, arguments: snapshot.data[i]);
                                                        } else if (value == 3) {
                                                          _tambahPemasukan(snapshot.data[i].id.toString());
                                                        } else {
                                                          _tambahPengeluaran(snapshot.data[i].id.toString());
                                                        }
                                                      },
                                                      itemBuilder: (context) => [
                                                            PopupMenuItem(
                                                              child: Text("Detail"),
                                                              value: 1,
                                                            ),
                                                            PopupMenuItem(
                                                              child: Text("Edit"),
                                                              value: 2,
                                                            ),
                                                            PopupMenuItem(
                                                              child: Text("Tambah Pemasukan"),
                                                              value: 3,
                                                            ),
                                                            PopupMenuItem(
                                                              child: Text("Tambah Pengeluaran"),
                                                              value: 4,
                                                            )
                                                          ])
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        height: 1,
                                      ),
                                      SizedBox(
                                        height: 8,
                                      )
                                    ],
                                  );
                                }
                              });
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        // : Container(height: 100, child: Config.emptyData('Belum ada barang', context));
                      }),
                ),
              ],
            ),
          )),
    );
  }

  Future loadList() async {
    final Future futureDB = conn.initDB();
    final Database _db = db;
    try {
      return futureDB.then((data) async {
        Future<List<Barang>> futureTrans = conn.getBarang();
        await futureTrans.then((list) {
          setState(() {
            listBarang = list;
          });
        });
      });
    } catch (e) {
      print(e);
      return null;
    }
  }
}
