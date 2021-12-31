class EndPoint {
  static final String server = 'https://waserdajaya.store/';
  static final String api = server + 'api/';
  static final String login = api + 'login';
  static final String barang = api + 'barang/list';
  static final String addBarang = api + 'barang/create';
  static final String addPemasukan = api + 'pemasukan/create';
  static final String addPengeluaran = api + 'pengeluaran/create';
  static final String listPemasukan = api + 'pemasukan/list';
  static final String listPengeluaran = api + 'pengeluaran/list';

  static String detailBarang(var id) => api + 'barang/detail/$id';

  static String updateBarang(var id) => api + 'barang/update/$id';
  static String editPemasukan(var id) => api + 'pemasukan/update/$id';
  static String editPengeluaran(var id) => api + 'pengeluaran/update/$id';
  static String deletePemasukan(var id) => api + 'pemasukan/delete/$id';
  static String deletePengeluaran(var id) => api + 'pengeluaran/delete/$id';
  static String filterPemasukan(var bulan) => api + 'pemasukan/filter/$bulan';
  static String filterPengeluaran(var bulan) => api + 'pengeluaran/filter/$bulan';
}
