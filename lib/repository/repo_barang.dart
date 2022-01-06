import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:inventory/helper/network.dart';
import 'package:inventory/helper/pref.dart';
import 'package:inventory/model/detail.dart';
import 'package:inventory/model/histori.dart';
import 'package:inventory/model/home.dart';
import 'package:async/async.dart';

class BarangRepository {
  Future<List<Barang>> listBarang() async {
    String token = await Pref.getToken();
    http.Response res = await http.get(Uri.parse(EndPoint.barang), headers: {'Authorization': token});
    var data = json.decode(res.body);

    List<dynamic> list = data['data'];
    print(data['data']);
    if (res.statusCode == 200) {
      return list.map((e) => Barang.fromJson(e)).toList();
    } else {
      return [];
      // return Barang.fromJson(data['message']);
    }
  }

  Future<Detail> detailBarang(String id) async {
    String token = await Pref.getToken();
    http.Response res = await http.get(Uri.parse(EndPoint.detailBarang(id)), headers: {'Authorization': token});
    var data = json.decode(res.body);

    if (res.statusCode == 200) {
      print(data);
      return Detail.fromJson(data);
    } else {
      return Detail.fromJson(data);
      // return Barang.fromJson(data['message']);
    }
  }

  Future<bool> store(File image, Barang barang) async {
    String token = await Pref.getToken();
    // var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
    Map<String, String> headers = {
      'Authorization': token,
    };
    final request = http.MultipartRequest('POST', Uri.parse(EndPoint.addBarang));
    request.files.add(await http.MultipartFile.fromPath('foto', image.path));
    request.fields['nama_barang'] = barang.namaBarang;
    request.fields['stok'] = barang.stok;
    request.fields['status'] = barang.status;
    request.fields['keterangan'] = barang.keterangan;
    request.headers.addAll(headers);

    // http.Response response = await http.Response.fromStream(await request.send());
    // send
    var response = await request.send();
    // print(response.statusCode);

    // listen for response
    // response.stream.transform(utf8.decoder).listen((value) {
    //   print(value);
    // });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> update(File image, Barang barang) async {
    String token = await Pref.getToken();

    Map<String, String> headers = {
      'Authorization': token,
    };
    // return true;
    if (image == null) {
      print(barang.toJson());

      http.Response res = await http.post(EndPoint.updateBarang(barang.id), body: barang.toJson(), headers: {'Authorization': token});
      print(res.body);
      if (res.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } else {
      print(headers);
      final request = http.MultipartRequest('POST', Uri.parse(EndPoint.updateBarang(barang.id)));
      request.files.add(await http.MultipartFile.fromPath('foto', image.path));
      request.fields['nama_barang'] = barang.namaBarang;
      request.fields['stok'] = barang.stok;
      request.fields['status'] = barang.status;
      request.fields['keterangan'] = barang.keterangan;
      request.headers.addAll(headers);
      // http.Response response = await http.Response.fromStream(await request.send());
      // send
      var response = await request.send();
      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<bool> addPemasukan(Barang barang) async {
    String token = await Pref.getToken();
    final request = await http.post(EndPoint.addPemasukan, body: barang.addInventori(), headers: {'Authorization': token});

    if (request.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addPengeluaran(Barang barang) async {
    String token = await Pref.getToken();
    final request = await http.post(EndPoint.addPengeluaran, body: barang.addInventori(), headers: {'Authorization': token});

    if (request.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Histori>> listPengeluaran() async {
    String token = await Pref.getToken();
    final request = await http.get(EndPoint.listPengeluaran, headers: {'Authorization': token});
    var data = json.decode(request.body);
    print(data);
    List<dynamic> list = data['data'];
    if (request.statusCode == 200) {
      return list.map((e) => Histori.fromJson(e)).toList();
    } else {
      return [];
      // return Barang.fromJson(data['message']);
    }
  }

  Future<List<Histori>> listPemasukan() async {
    String token = await Pref.getToken();
    final request = await http.get(EndPoint.listPemasukan, headers: {'Authorization': token});
    var data = json.decode(request.body);
    print(data);
    List<dynamic> list = data['data'];
    if (request.statusCode == 200) {
      return list.map((e) => Histori.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<List<Histori>> filterPengeluaran(String tanggal) async {
    print(tanggal);
    String token = await Pref.getToken();
    final request = await http.get(EndPoint.filterPengeluaran(tanggal), headers: {'Authorization': token});
    var data = json.decode(request.body);
    print(data);
    List<dynamic> list = data['data'];
    if (request.statusCode == 200) {
      return list.map((e) => Histori.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<List<Histori>> filterPemasukan(String tanggal) async {
    print(tanggal);
    String token = await Pref.getToken();
    final request = await http.get(EndPoint.filterPemasukan(tanggal), headers: {'Authorization': token});
    var data = json.decode(request.body);
    print(data);
    List<dynamic> list = data['data'];
    if (request.statusCode == 200) {
      return list.map((e) => Histori.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<bool> deletePemasukan(String id) async {
    String token = await Pref.getToken();
    final request = await http.get(EndPoint.deletePemasukan(id), headers: {'Authorization': token});

    if (request.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deletePengeluaran(String id) async {
    String token = await Pref.getToken();
    final request = await http.get(EndPoint.deletePengeluaran(id), headers: {'Authorization': token});

    if (request.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> editPemasukan(String id, Barang barang) async {
    String token = await Pref.getToken();
    final request = await http.post(EndPoint.editPemasukan(id), body: barang.updatePemasukan(), headers: {'Authorization': token});

    if (request.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> editPengeluaran(String id, Barang barang) async {
    String token = await Pref.getToken();
    final request = await http.post(EndPoint.editPengeluaran(id), body: barang.updarePengeluaran(), headers: {'Authorization': token});

    if (request.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
