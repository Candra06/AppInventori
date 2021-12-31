import 'package:flutter/material.dart';
import 'package:inventory/helper/config.dart';
import 'package:inventory/helper/network.dart';
import 'package:inventory/model/detail.dart';
import 'package:inventory/model/home.dart';
import 'package:inventory/repository/repo_barang.dart';

class DetailBarang extends StatefulWidget {
  final Barang barang;
  const DetailBarang({Key key, this.barang}) : super(key: key);

  @override
  _DetailBarangState createState() => _DetailBarangState();
}

class _DetailBarangState extends State<DetailBarang> with SingleTickerProviderStateMixin {
  Future<Detail> _detail;
  BarangRepository barangRepository = new BarangRepository();
  bool load = true;
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
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detail Barang'),
        ),
        body: FutureBuilder<Detail>(
          future: _detail,
          builder: (builder, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator();
            } else {
              return snapshot.hasData
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              child: Image.network(
                                EndPoint.server + widget.barang.foto,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                            ),
                            Positioned(
                                bottom: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        widget.barang.namaBarang,
                                        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        widget.barang.stok.toString(),
                                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Histori Barang Masuk'),
                            )),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Histori Barang Keluar'),
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
                                child: snapshot.data.data.pemasukan.isEmpty
                                    ? Center(child: Text('Belum ada pemasukan stok barang'))
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data.data.pemasukan.length,
                                        itemBuilder: (BuildContext context, int i) {
                                          print(snapshot.data.data.pemasukan.length);
                                          if (snapshot.data.data.pemasukan.isEmpty) {
                                            return Config.emptyData('Belum ada pemasukan stok barang', context);
                                          } else {
                                            return Card(
                                              child: Container(
                                                padding: EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(Config.formatDateInput(snapshot.data.data.pemasukan[i].createdAt.toString())),
                                                    // Text(snapshot.data.data.pemasukan[i].createdAt.toString()),
                                                    Text('Jumlah : ' + snapshot.data.data.pemasukan[i].jumlah.toString()),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        })),
                            Expanded(
                                child: snapshot.data.data.pengeluaran.isEmpty
                                    ? Center(child: Text('Belum ada pengeluaran stok barang'))
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data.data.pengeluaran.length,
                                        itemBuilder: (BuildContext context, int i) {
                                          if (snapshot.data.data.pengeluaran.length == 0) {
                                            return Text('Belum ada pengeluaran stok barang');
                                          } else {
                                            return Card(
                                              child: Container(
                                                padding: EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(Config.formatDateInput(snapshot.data.data.pengeluaran[i].createdAt.toString())),
                                                    // Text(snapshot.data.data.pengeluaran[i].createdAt.toString()),
                                                    Text('Jumlah : ' + snapshot.data.data.pengeluaran[i].jumlah.toString()),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        })),
                          ],
                        )
                      ],
                    )
                  : Text('Gagal menampilkan data barang');
            }
          },
        ));
  }
}
