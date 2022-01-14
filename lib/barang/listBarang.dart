import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inventory/barang/tambahBarang.dart';
import 'package:inventory/helper/config.dart';
import 'package:inventory/helper/network.dart';
import 'package:inventory/helper/route.dart';
import 'package:inventory/layout/sidemenu.dart';
import 'package:inventory/modal/tambahPemasukan.dart';
import 'package:inventory/modal/tambahPengeluaran.dart';
import 'package:inventory/model/home.dart';
import 'package:inventory/repository/repo_barang.dart';

class ListBarang extends StatefulWidget {
  ListBarang({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListBarangState createState() => _ListBarangState();
}

class _ListBarangState extends State<ListBarang> {
  Future<List<Barang>> listBarang;

  TextEditingController txtNama = new TextEditingController();
  BarangRepository barangRepository = new BarangRepository();
  bool load = true;
  String searchString = "";

  void _tambahPemasukan(String id) async {
    return showModalBottomSheet(
        context: context,
        builder: (builder) {
          return TambahPemasukan(
            id: id,
          );
        });
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

    listBarang = barangRepository.listBarang();
    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
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
  Widget build(BuildContext context) {
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
                    Container(
                      width: 140,
                      alignment: Alignment.center,
                      child: Text('Gambar'),
                    ),
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
                  child: FutureBuilder<List<Barang>>(
                      future: listBarang,
                      builder: (builder, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return snapshot.hasData
                              ? ListView.builder(
                                  itemCount: snapshot.data.length,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int i) {
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
                                  })
                              : Text('Tidak ada data barang');
                          // : Container(height: 100, child: Config.emptyData('Belum ada barang', context));
                        }
                      }),
                ),
              ],
            ),
          )),
    );
  }
}
