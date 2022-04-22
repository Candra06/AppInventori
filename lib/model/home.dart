import 'dart:io';

class Barang {
  Barang({
    this.id,
    this.namaBarang,
    this.foto,
    this.stok,
    this.jumlahMasuk,
    this.tanggalMasuk,
    this.jumlahKeluar,
    this.tanggalKeluar,
    this.image,
    this.status,
    this.keterangan,
    this.hargaBarang,
    this.ongkosPembuatan,
  });

  int id;
  String namaBarang;
  String foto;
  String stok;
  String status;
  String jumlahMasuk;
  String tanggalMasuk;
  String jumlahKeluar;
  String tanggalKeluar;
  String keterangan;
  String hargaBarang;
  String ongkosPembuatan;
  File image;

  factory Barang.fromJson(Map<String, dynamic> json) => Barang(
        id: json["id"] == null ? null : json["id"],
        namaBarang: json["nama_barang"] == null ? null : json["nama_barang"],
        foto: json["foto"] == null ? null : json["foto"],
        stok: json["stok"] == null ? null : json["stok"].toString(),
        keterangan: json["keterangan"] == null ? null : json["keterangan"],
        jumlahMasuk: json["jumlah_masuk"] == null ? null : json["jumlah_masuk"].toString(),
        tanggalMasuk: json["tanggal_masuk"] == null ? null : json["tanggal_masuk"],
        jumlahKeluar: json["jumlah_keluar"] == null ? null : json["jumlah_keluar"].toString(),
        tanggalKeluar: json["tanggal_keluar"] == null ? null : json["tanggal_keluar"],
        hargaBarang: json["harga_barang"] == null ? null : json["harga_barang"].toString(),
        ongkosPembuatan: json["ongkos_pembuatan"] == null ? null : json["ongkos_pembuatan"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "nama_barang": namaBarang == null ? null : namaBarang,
        "stok": stok == null ? null : stok,
        "foto": foto == null ? null : foto,
        "status": status == null ? null : status,
        "keterangan": keterangan == null ? null : keterangan,
        "harga_barang": hargaBarang == null ? null : hargaBarang,
        "ongkos_pembuatan": ongkosPembuatan == null ? null : ongkosPembuatan,
      };

  Map<String, dynamic> addInventori() => {"id_barang": id == null ? null : id.toString(), "jumlah": stok == null ? null : stok};
  Map<String, dynamic> updatePemasukan() => {"id_barang": id == null ? null : id.toString(), "jumlah": stok == null ? null : stok};
  Map<String, dynamic> updarePengeluaran() => {"id_barang": id == null ? null : id.toString(), "jumlah": stok == null ? null : stok};
}
