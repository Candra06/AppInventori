import 'dart:io';

import 'package:intl/intl.dart';
import 'package:inventory/model/detail.dart';
import 'package:inventory/model/histori.dart';
import 'package:inventory/model/home.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';

class Connection {
  Database db;
  DateTime now = DateTime.now();

  Future<Database> get database async {
    if (db != null) return db;
    db = await initDB();
    return db;
  }

  Future initDB() async {
    if (db != null) {
      return db;
    }
    Directory appDocDir = await getExternalStorageDirectory();
    String appDocPath = appDocDir.path;
    print(appDocPath);
    String databasesPath = await getDatabasesPath();
    print(databasesPath);
    db = await openDatabase(
      join(databasesPath, 'inventory.db'),
      onCreate: (db, version) async {
        db.execute(
            "create table barang (id INTEGER primary key autoincrement, nama_barang TEXT not null, foto TEXT not null, stok INTEGER not null, harga_barang INTEGER not null, ongkos_pembuatan INTEGER not null, status TEXT not null, keterangan TEXT not null)");
        db.execute("CREATE TABLE pemasukan (id INTEGER PRIMARY KEY autoincrement, barang_id INTEGER not null, jumlah INTEGER not null, created_at TEXT not null, updated_at TEXT not null)");
        db.execute("CREATE TABLE pengeluaran (id INTEGER PRIMARY KEY autoincrement,barang_id INTEGER not null,jumlah INTEGER not null, created_at TEXT not null,updated_at TEXT not null)");
      },
      version: 1,
    );

    return db;
  }

  Future<dynamic> dataBarang() async {
    final _db = await database;
    var res = await _db.query("barang");
    if (res.length == 0) {
      return null;
    } else {
      var resMap = res[0];
      return resMap.isNotEmpty ? resMap : Null;
    }
  }

  Future<List<Barang>> getBarang() async {
    final Database _db = await database;
    final List<Map<String, dynamic>> list = await _db.query("barang", where: "status = 'Tersedia'");

    // return list;
    List<Map<String, dynamic>> result = [];
    Map<String, dynamic> tmp = {};
    for (var i = 0; i < list.length; i++) {
      final List<Map<String, dynamic>> pemasukan = await _db.query("pemasukan", where: "barang_id = ?", whereArgs: [list[i]['id']], orderBy: 'id DESC');
      final List<Map<String, dynamic>> pengeluaran = await _db.query("pengeluaran", where: "barang_id = ?", whereArgs: [list[i]['id']], orderBy: 'id DESC');
      tmp['id'] = list[i]['id'];
      tmp['nama_barang'] = list[i]['nama_barang'];
      tmp['foto'] = list[i]['foto'];
      tmp['harga_barang'] = list[i]['harga_barang'];
      tmp['ongkos_pembuatan'] = list[i]['ongkos_pembuatan'];
      tmp['stok'] = list[i]['stok'];
      tmp['keterangan'] = list[i]['keterangan'];
      if (pemasukan.length > 0) {
        tmp['jumlah_masuk'] = pemasukan[0]['jumlah'];
        tmp['tanggal_masuk'] = pemasukan[0]['created_at'];
      } else {
        tmp['jumlah_masuk'] = 0;
        tmp['tanggal_masuk'] = '0';
      }
      if (pengeluaran.length > 0) {
        tmp['jumlah_keluar'] = pengeluaran[0]['jumlah'];
        tmp['tanggal_keluar'] = pengeluaran[0]['created_at'];
      } else {
        tmp['jumlah_keluar'] = 0;
        tmp['tanggal_keluar'] = '0';
      }
      result.add(tmp);
    }
    print(result);
    return List.generate(result.length, (i) {
      return Barang(
          id: result[i]['id'],
          namaBarang: result[i]['nama_barang'],
          foto: result[i]['foto'],
          hargaBarang: result[i]['harga_barang'].toString(),
          ongkosPembuatan: result[i]['ongkos_pembuatan'].toString(),
          stok: result[i]['stok'].toString(),
          keterangan: result[i]['keterangan'].toString(),
          jumlahMasuk: result[i]['jumlah_masuk'].toString(),
          jumlahKeluar: result[i]['jumlah_keluar'].toString(),
          tanggalMasuk: result[i]['tanggal_masuk'].toString(),
          tanggalKeluar: result[i]['tanggal_keluar'].toString());
    });
  }

  Future<Detail> detailBarang(int id) async {
    try {
      final Database _db = await database;
      List<Map<String, dynamic>> result = await _db.query("barang", where: "id = ?", whereArgs: [id], limit: 1);
      List<Map<String, dynamic>> pemasukan = await _db.query("pemasukan", where: "barang_id = ?", whereArgs: [id], limit: 1);
      List<Map<String, dynamic>> pengeluaran = await _db.query("pengeluaran", where: "barang_id = ?", whereArgs: [id], limit: 1);

      Map<String, dynamic> res = {};
      res['detail'] = result[0];
      res['pemasukan'] = pemasukan;
      res['pengeluaran'] = pengeluaran;
      return Detail.fromJson(res);
    } catch (e) {
      print(e);
      return null;
    }
  }

  void inputBarang(Barang barang) async {
    final Database _db = db;

    _db.insert('barang', barang.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool> updateBarang(int id,Barang barang) async {
    final Database _db = db;
    print(barang.id);
    try {
      await _db.update('barang', barang.toJson(), where: "id = ?", whereArgs: [id], conflictAlgorithm: ConflictAlgorithm.replace);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<void> deleteBarang(int id) async {
    final Database _db = db;

    await _db.delete(
      'barang',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<bool> deleteHistory(String tabel, String id) async {
    final Database _db = await database;
    try {
      if (tabel == 'pemasukan') {
        List<Map<String, dynamic>> result = await _db.query("pemasukan", where: "id = ?", whereArgs: [id], limit: 1);
        List<Map<String, dynamic>> data = await _db.query("barang", where: "id = ?", whereArgs: [result[0]['barang_id']], limit: 1);
        var tmpStok = int.parse(data[0]['stok'].toString()) - int.parse(result[0]['jumlah'].toString());
        await _db.update(
          'barang',
          {'stok': tmpStok},
          where: "id = ?",
          whereArgs: [result[0]['barang_id']],
        );
        await _db.delete(
          'pemasukan',
          where: "id = ?",
          whereArgs: [id],
        );
        return true;
      } else {
        List<Map<String, dynamic>> result = await _db.query("pengeluaran", where: "id = ?", whereArgs: [id], limit: 1);
        List<Map<String, dynamic>> data = await _db.query("barang", where: "id = ?", whereArgs: [result[0]['barang_id']]);
        var tmpStok = int.parse(data[0]['stok'].toString()) + int.parse(result[0]['jumlah'].toString());

        await _db.update(
          'barang',
          {'stok': tmpStok},
          where: "id = ?",
          whereArgs: [result[0]['barang_id']],
        );
        await _db.delete(
          'pengeluaran',
          where: "id = ?",
          whereArgs: [id],
        );
        return true;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> addPemasukan(int id, Barang pemasukan) async {
    try {
      final Database _db = db;
      String createdAt = DateFormat('yyyy-MM-dd kk:mm').format(now).toString();

      List<Map<String, dynamic>> result = await _db.query("barang", where: "id=?", whereArgs: [id], limit: 1);
      int stok = int.parse(result[0]['stok'].toString());
      int jumlah = int.parse(pemasukan.stok);
      int hasil = stok + jumlah;

      await _db.update(
        'barang',
        {'stok': hasil},
        where: "id = ?",
        whereArgs: [id],
      );
      await _db.insert('pemasukan', {'barang_id': id, 'jumlah': pemasukan.stok, 'created_at': createdAt, 'updated_at': createdAt});

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> addPengeluaran(int id, Barang pemasukan) async {
    try {
      final Database _db = db;
      String createdAt = DateFormat('yyyy-MM-dd kk:mm').format(now).toString();

      List<Map<String, dynamic>> result = await _db.query("barang", where: "id=?", whereArgs: [id], limit: 1);
      int stok = int.parse(result[0]['stok'].toString());
      int jumlah = int.parse(pemasukan.stok);
      int hasil = stok - jumlah;

      await _db.update(
        'barang',
        {'stok': hasil},
        where: "id = ?",
        whereArgs: [id],
      );
      await _db.insert('pengeluaran', {'barang_id': id, 'jumlah': pemasukan.stok, 'created_at': createdAt, 'updated_at': createdAt});

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updatePemasukan(int id, Barang pemasukan) async {
    try {
      final Database _db = db;
      String createdAt = DateFormat('yyyy-MM-dd kk:mm').format(now).toString();

      List<Map<String, dynamic>> data = await _db.query("pemasukan", where: "id=?", whereArgs: [id], limit: 1);
      await _db.update(
        'pemasukan',
        {'barang_id': pemasukan.id, "jumlah": pemasukan.stok, "updated_at": createdAt},
        where: "id = ?",
        whereArgs: [id],
      ); // proses update pemasukan

      List<Map<String, dynamic>> result = await _db.query("barang", where: "id=?", whereArgs: [pemasukan.id], limit: 1);

      int tmpStok = int.parse(result[0]['stok'].toString()) - int.parse(data[0]['jumlah'].toString()); // mengurangi stok yang ditambahkan
      int jumlah = int.parse(pemasukan.stok);
      int hasil = tmpStok + jumlah; // mengubah menjadi stok baru

      await _db.update(
        'barang',
        {'stok': hasil},
        where: "id = ?",
        whereArgs: [pemasukan.id],
      );

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updatePengeluaran(int id, Barang pemasukan) async {
    try {
      final Database _db = db;
      String createdAt = DateFormat('yyyy-MM-dd kk:mm').format(now).toString();

      List<Map<String, dynamic>> data = await _db.query("pengeluaran", where: "id=?", whereArgs: [id], limit: 1);
      await _db.update(
        'pengeluaran',
        {'barang_id': pemasukan.id, "jumlah": pemasukan.stok, "updated_at": createdAt},
        where: "id = ?",
        whereArgs: [id],
      ); // proses update pemasukan

      List<Map<String, dynamic>> result = await _db.query("barang", where: "id=?", whereArgs: [pemasukan.id], limit: 1);

      int tmpStok = int.parse(result[0]['stok'].toString()) + int.parse(data[0]['jumlah'].toString()); // menambah stok yang dikurangi
      int jumlah = int.parse(pemasukan.stok);
      int hasil = tmpStok - jumlah; // mengubah menjadi stok baru

      await _db.update(
        'barang',
        {'stok': hasil},
        where: "id = ?",
        whereArgs: [pemasukan.id],
      );

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<List<Histori>> listHistori(String tabel) async {
    String sql = '';
    if (tabel == 'pemasukan') {
      sql = "SELECT pemasukan.*, barang.nama_barang FROM pemasukan JOIN barang ON pemasukan.barang_id=barang.id";
    } else {
      sql = "SELECT pengeluaran.*, barang.nama_barang FROM pengeluaran JOIN barang ON pengeluaran.barang_id=barang.id";
    }
    final Database _db = await database;
    final List<Map<String, dynamic>> list = await _db.rawQuery(sql);

    return List.generate(list.length, (i) {
      return Histori(
        namaBarang: list[i]['nama_barang'],
        id: list[i]['id'],
        barangId: list[i]['barang_id'].toString(),
        jumlah: list[i]['jumlah'].toString(),
        createdAt: list[i]['created_at'],
        updatedAt: list[i]['updated_at'],
      );
    });
  }

  Future<List<Histori>> filterHistori(String tabel, String bulan) async {
    if (int.parse(bulan) < 10) {
      bulan = '0' + bulan;
    } else {
      bulan = bulan;
    }

    String sql = '';
    if (tabel == 'pemasukan') {
      sql = "SELECT pemasukan.*, barang.nama_barang FROM pemasukan JOIN barang ON pemasukan.barang_id=barang.id WHERE strftime('%m', pemasukan.created_at) = ?";
    } else {
      sql = "SELECT pengeluaran.*, barang.nama_barang FROM pengeluaran JOIN barang ON pengeluaran.barang_id=barang.id WHERE strftime('%m', pengeluaran.created_at) = ?";
    }
    final Database _db = await database;
    final List<Map<String, dynamic>> list = await _db.rawQuery(sql, [bulan]);

    return List.generate(list.length, (i) {
      return Histori(
        namaBarang: list[i]['nama_barang'],
        id: list[i]['id'],
        barangId: list[i]['barang_id'].toString(),
        jumlah: list[i]['jumlah'].toString(),
        createdAt: list[i]['created_at'],
        updatedAt: list[i]['updated_at'],
      );
    });
  }
}
