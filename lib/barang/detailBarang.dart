import 'package:flutter/material.dart';
import 'package:inventory/helper/config.dart';
import 'package:inventory/helper/database.dart';
import 'package:inventory/helper/network.dart';
import 'package:inventory/model/detail.dart';
import 'package:inventory/model/home.dart';
import 'package:inventory/repository/repo_barang.dart';
import 'package:sqflite/sqlite_api.dart';

class DetailBarang extends StatefulWidget {
  final Barang barang;
  const DetailBarang({Key key, this.barang}) : super(key: key);

  @override
  _DetailBarangState createState() => _DetailBarangState();
}

class _DetailBarangState extends State<DetailBarang> with SingleTickerProviderStateMixin {
  Database db;
  Connection conn = new Connection();
  Future<Detail> _detail;
  TabController controller;
  BarangRepository barangRepository = new BarangRepository();
  bool load = true;

  Future<Detail> getDetail() async {
    print(widget.barang.id);
    final _data = await conn.detailBarang(widget.barang.id);
    return _data;
  }

  void getData() async {
    setState(() {
      load = true;
    });

    _detail = barangRepository.detailBarang(widget.barang.id.toString());
    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    controller = new TabController(vsync: this, length: 2);
    // getData();
    _detail = getDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detail Barang'),
          bottom: new TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            controller: controller,
            tabs: <Widget>[
              new Tab(
                text: "Detail",
              ),
              new Tab(
                text: "Riwayat",
              ),
            ],
          ),
        ),
        body: FutureBuilder<Detail>(
          future: _detail,
          builder: (builder, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator();
            } else {
              return snapshot.hasData
                  ? TabBarView(controller: controller, children: [
                      Container(
                        margin: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Container(
                            //   width: 500,
                            //   height: 500,
                            //   child: Image.network(
                            //     EndPoint.server + widget.barang.foto,
                            //     fit: BoxFit.fill,
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nama Barang'),
                                  Text(
                                    widget.barang.namaBarang,
                                    style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('Stok'),
                                  Text(
                                    widget.barang.stok.toString(),
                                    style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('Harga Barang'),
                                  Text(
                                    Config.formatRupiah(int.parse(widget.barang.hargaBarang)),
                                    style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('Ongkos Pembuatan'),
                                  Text(
                                    Config.formatRupiah(int.parse(widget.barang.ongkosPembuatan)),
                                    style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('Keterangan'),
                                  Text(
                                    widget.barang.keterangan,
                                    style: TextStyle(fontSize: 14, color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Riwayat Barang Masuk'),
                                )),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Riwayat Barang Keluar'),
                                )),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: snapshot.data.pemasukan.isEmpty
                                        ? Center(child: Text('Belum ada pemasukan stok barang'))
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapshot.data.pemasukan.length,
                                            itemBuilder: (BuildContext context, int i) {
                                              print(snapshot.data.pemasukan.length);
                                              if (snapshot.data.pemasukan.isEmpty) {
                                                return Config.emptyData('Belum ada pemasukan stok barang', context);
                                              } else {
                                                return Card(
                                                  child: Container(
                                                    padding: EdgeInsets.all(16),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(Config.formatDateInput(snapshot.data.pemasukan[i].createdAt.toString())),
                                                        // Text(snapshot.data.data.pemasukan[i].createdAt.toString()),
                                                        Text('Jumlah : ' + snapshot.data.pemasukan[i].jumlah.toString()),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }
                                            })),
                                Expanded(
                                    child: snapshot.data.pengeluaran.isEmpty
                                        ? Center(child: Text('Belum ada pengeluaran stok barang'))
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapshot.data.pengeluaran.length,
                                            itemBuilder: (BuildContext context, int i) {
                                              if (snapshot.data.pengeluaran.length == 0) {
                                                return Text('Belum ada pengeluaran stok barang');
                                              } else {
                                                return Card(
                                                  child: Container(
                                                    padding: EdgeInsets.all(16),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(Config.formatDateInput(snapshot.data.pengeluaran[i].createdAt.toString())),
                                                        // Text(snapshot.data.pengeluaran[i].createdAt.toString()),
                                                        Text('Jumlah : ' + snapshot.data.pengeluaran[i].jumlah.toString()),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }
                                            })),
                              ],
                            )
                          ],
                        ),
                      )
                    ])
                  : Text('Gagal menampilkan data barang');
            }
          },
        ));
  }
}
