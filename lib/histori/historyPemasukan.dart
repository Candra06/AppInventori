import 'package:flutter/material.dart';
import 'package:inventory/helper/config.dart';
import 'package:inventory/helper/database.dart';
import 'package:inventory/layout/sidemenu.dart';
import 'package:inventory/modal/tambahPemasukan.dart';
import 'package:inventory/model/histori.dart';
import 'package:inventory/repository/repo_barang.dart';
import 'package:sqflite/sqlite_api.dart';

class HistoriPemasukan extends StatefulWidget {
  const HistoriPemasukan({Key key}) : super(key: key);

  @override
  _HistoriPemasukanState createState() => _HistoriPemasukanState();
}

class _HistoriPemasukanState extends State<HistoriPemasukan> {
  // get connection from db
  Database db;
  Connection conn = new Connection();

  List<String> _listBulan = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
  List<String> _listValBulan = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];
  String _valBulan, _valIndex;
  Future<List<Histori>> _listData;
  BarangRepository barangRepository = new BarangRepository();

  Future<List<Histori>> getHistori() async {
    final _data = await conn.listHistori('pemasukan');

    return _data;
  }

  Future<List<Histori>> filterData(String bulan) async {
    final _data = await conn.filterHistori('pemasukan', bulan);

    return _data;
  }

  void getData() async {
    _listData = barangRepository.listPemasukan();
  }

  void filter(String bulan) async {
    print(_valIndex);
    _listData = filterData(bulan);
    // _listData = barangRepository.filterPemasukan(bulan);
  }

  void delete(String id) async {
    setState(() {
      Config.loading(context);
    });

    final initDB = conn.initDB();
    // bool response = await barangRepository.deletePemasukan(id);
    try {
      initDB.then((value) {
        conn.deleteHistory('pemasukan', id);
      });
      setState(() {
        Navigator.pop(context);
        Config.alert(1, 'Berhasil menghapus data');
        // getData();
        _listData = getHistori();
      });
    } catch (e) {
      setState(() {
        Navigator.pop(context);
        Config.alert(2, 'Gagal menghapus data');
      });
    }

    // bool response = await barangRepository.deletePemasukan(id);
    // if (response == true) {
    //   setState(() {
    //     Navigator.pop(context);
    //     Config.alert(1, 'Berhasil menghapus data');
    //     getData();
    //   });
    // } else {
    //   setState(() {
    //     Navigator.pop(context);
    //     Config.alert(2, 'Gagals menghapus data');
    //   });
    // }
  }

  @override
  void initState() {
    // getData();
    super.initState();
    _listData = getHistori();
  }

  showAlertDialog(BuildContext context, String id) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Batal"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Konfirmasi"),
      onPressed: () {
        delete(id);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Konfirmasi"),
      content: Text("Apakah anda yakin ingin menghapus data?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _editPemasukan(String id, value, barangId) async {
    return showModalBottomSheet(
        context: context,
        builder: (builder) {
          return TambahPemasukan(
            id: id,
            tipe: 'Update',
            value: value,
            barangId: barangId,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Data Barang Masuk'),
        ),
        drawer: SideMenu(),
        body: FutureBuilder<List<Histori>>(
            future: _listData,
            builder: (builder, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LinearProgressIndicator();
              } else {
                return Container(
                  margin: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(),
                            DropdownButton<String>(
                              hint: Text('Pilih Bulan'),
                              value: _valBulan,
                              items: _listBulan.map((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _valIndex = _listValBulan[_listBulan.indexOf(val)];
                                  _valBulan = val;
                                  filter(_valIndex);
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      DataTable(
                        columns: <DataColumn>[
                          DataColumn(
                            label: Text("Nama Barang"),
                          ),
                          DataColumn(label: Text("Jumlah")),
                          DataColumn(label: Text("Created At")),
                          DataColumn(label: Text("Updated At")),
                          DataColumn(label: Text("Aksi")),
                        ],
                        rows: [
                          if (snapshot.data.isNotEmpty) ...{
                            for (var i = 0; i < snapshot.data.length; i++) ...{
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(snapshot.data[i].namaBarang)),
                                  DataCell(Text(snapshot.data[i].jumlah)),
                                  DataCell(Text(Config.formatDateTime(snapshot.data[i].createdAt))),
                                  DataCell(Text(Config.formatDateTime(snapshot.data[i].updatedAt))),
                                  DataCell(Row(children: [
                                    IconButton(
                                        onPressed: () {
                                          _editPemasukan(
                                            snapshot.data[i].id.toString(),
                                            snapshot.data[i].jumlah.toString(),
                                            snapshot.data[i].barangId.toString(),
                                          );
                                        },
                                        icon: Icon(Icons.edit)),
                                    IconButton(
                                        onPressed: () {
                                          showAlertDialog(context, snapshot.data[i].id.toString());
                                        },
                                        icon: Icon(Icons.delete))
                                  ])),
                                ],
                              ),
                            }
                          }
                        ],
                      ),
                      if (snapshot.data.isEmpty) ...{
                        Divider(),
                        Center(
                          child: Text('Tidak ada data'),
                        )
                      }
                    ],
                  ),
                );
              }
            }));
  }
}
