import 'dart:developer';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:cahaya/models/history_saldo.dart';
import 'package:cahaya/models/jual_beli_mobil.dart';
import 'package:cahaya/models/keuangan_bulanan.dart';
import 'package:cahaya/models/mobil.dart';
import 'package:cahaya/models/perbaikan.dart';
import 'package:cahaya/models/supir.dart';
import 'package:cahaya/models/user.dart';

import '../models/mutasi_saldo.dart';
import '../models/transaksi.dart';

List<String> list = <String>[
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember'
];

class ProviderData with ChangeNotifier {
  late bool isOwner;
  bool logined = false;
  late User user;
  List<Transaksi> backupTransaksi = [];
  List<Transaksi> listTransaksi = [];

  List<JualBeliMobil> listJualBeliMobil = [];
  List<JualBeliMobil> backuplistJualBeliMobil = [];

  List<Perbaikan> listPerbaikan = [];
  List<Perbaikan> backupListPerbaikan = [];

  List<Mobil> listMobil = [];
  List<Mobil> backupListMobil = [];

  List<Supir> listSupir = [];
  List<Supir> backupListSupir = [];

  List<HistorySaldo> listHistorySaldo = [];
  List<HistorySaldo> backupListHistorySaldo = [];

  List<MutasiSaldo> listMutasiSaldo = [];

  double totalSaldo = 0;
  List<User> listUser = [];
  List<MutasiSaldo> backupListMutasiSaldo = [];

  List<KeuanganBulanan> printedBulanan = [];
  DateTime? startTl;
  DateTime? endTl;
  void sortTransaksiLain() {
    listMutasiSaldo.clear();

    for (var element in backupListMutasiSaldo) {
      bool skipped = false;

      if (startTl != null) {
        if (DateTime.parse(element.tanggal).isBefore(startTl!) ||
            DateTime.parse(element.tanggal).isAfter(endTl!)) {
          skipped = true;
        }
      }
      if (!skipped) {
        listMutasiSaldo.add(element);
      }
    }
    notifyListeners();
  }

  DateTime? startp;
  DateTime? endp;
  void sortp() {
    listPerbaikan.clear();

    for (var element in backupListPerbaikan) {
      bool skipped = false;

      if (startp != null) {
        if (DateTime.parse(element.tanggal).isBefore(startp!) ||
            DateTime.parse(element.tanggal).isAfter(endp!)) {
          skipped = true;
        }
      }
      if (!skipped) {
        listPerbaikan.add(element);
      }
    }
    notifyListeners();
  }

  void owner() {
    isOwner = true;
    notifyListeners();
  }

  void admin() {
    isOwner = false;
    notifyListeners();
  }

  void login() {
    logined = true;
    notifyListeners();
  }

  void logout() {
    logined = false;
    notifyListeners();
  }

  void setData(
      List<User> users,
      List<Transaksi> tras,
      bool listen,
      List<Mobil> mobilData,
      List<Supir> supirData,
      List<Perbaikan> perbaikan,
      List<JualBeliMobil> jualbeli,
      List<MutasiSaldo> listMutasi) {
    //print('set');
    if (users.isNotEmpty) {
      listUser.clear();
      listUser.addAll(users);
    }
    if (jualbeli.isNotEmpty) {
      listJualBeliMobil.clear();
      backuplistJualBeliMobil.clear();
      listJualBeliMobil.addAll(jualbeli);
      backuplistJualBeliMobil.addAll(jualbeli);
    }

    if (perbaikan.isNotEmpty) {
      listPerbaikan.clear();
      backupListPerbaikan.clear();
      listPerbaikan.addAll(perbaikan);
      backupListPerbaikan.addAll(perbaikan);
    }
    if (tras.isNotEmpty) {
      tras.sort(( ((a, b) => DateTime.parse(b.tanggalBerangkat)
        .compareTo(DateTime.parse(a.tanggalBerangkat)))));
      listTransaksi.clear();
      backupTransaksi.clear();
      listTransaksi.addAll(tras);
      backupTransaksi.addAll(tras);
 
    }
    if (mobilData.isNotEmpty) {
      listMobil.clear();
      listMobil.addAll(mobilData);
      backupListMobil.clear();
      backupListMobil.addAll(mobilData);
    }
    if (supirData.isNotEmpty) {
      listSupir.clear();
      backupListSupir.clear();
      listSupir.addAll(supirData);
      backupListSupir.addAll(supirData);
    }
    if (listMutasi.isNotEmpty) {
      listMutasiSaldo.clear();
      backupListMutasiSaldo.clear();
      listMutasiSaldo.addAll(listMutasi);
      backupListMutasiSaldo.addAll(listMutasi);
    }

    calculateSaldo();

    (listen) ? notifyListeners() : () {};
  }

  void calculateSaldo() {
    totalSaldo = 0;
    for (var e in listTransaksi) {
      totalSaldo += e.sisa;
    }
    for (var e in listPerbaikan) {
      totalSaldo -= e.harga;
    }

    for (var e in listJualBeliMobil) {
      if (e.beli) {
        totalSaldo -= e.harga;
      } else {
        totalSaldo += e.harga;
      }
    }
    for (var e in listMutasiSaldo) {
      if (e.pendapatan) {
        totalSaldo += e.harga;
      } else {
        totalSaldo -= e.harga;
      }
    }

    //  notifyListeners();
  }

  void calculateMutasi() {
    listHistorySaldo.clear();
    backupListHistorySaldo.clear();
    backupTransaksi.every((e) {
      listHistorySaldo.add(HistorySaldo('Transaksi', 0, e.mobil, e.keterangan,
          e.sisa, e.tanggalBerangkat, true));
      return true;
    });

    listPerbaikan.every((e) {
      listHistorySaldo.add(HistorySaldo(
          e.adminitrasi ? "Administrasi" : 'Perbaikan',
          0,
          e.mobil,
          e.keterangan,
          -e.harga,
          e.tanggal,
          false));
      return true;
    });

    listJualBeliMobil.every((e) {
      if (e.beli) {
        listHistorySaldo.add(HistorySaldo('Beli Mobil', 0, e.mobil,
            e.keterangan, -e.harga, e.tanggal, false));
      } else {
        listHistorySaldo.add(HistorySaldo(
            'Jual Mobil', 0, e.mobil, e.keterangan, e.harga, e.tanggal, true));
      }

      return true;
    });

    listMutasiSaldo.every((e) {
      if (e.pendapatan) {
        listHistorySaldo.add(HistorySaldo('Nota Pemasukan', 0, e.nota,
            e.keterangan, e.harga, e.tanggal, true));
      } else {
        listHistorySaldo.add(HistorySaldo('Nota Pengeluaran', 0, e.nota,
            e.keterangan, -e.harga, e.tanggal, false));
      }
      return true;
    });
    listHistorySaldo.sort((a, b) =>
        DateTime.parse(b.tanggal).compareTo(DateTime.parse(a.tanggal)));
    backupListHistorySaldo.addAll(listHistorySaldo);
    double incrementMutasi = 0;
    incrementMutasi += totalSaldo;
    for (var i = 0; i < listHistorySaldo.length; i++) {
      //print(incrementMutasi);
      // if (i == 0) {
      //   listHistorySaldo[0].sisaSaldo = totalSaldo;
      //   return;
      // }

      listHistorySaldo[i].sisaSaldo =
          incrementMutasi -= listHistorySaldo[i].harga;

      // if (i == 0) {
      //   listHistorySaldo[0].sisaSaldo = totalSaldo;
      // }
    }
    //  notifyListeners();
    calculateSaldo();
  }

  void addmutasi(MutasiSaldo mutasi) {
    listMutasiSaldo.add(mutasi);
    notifyListeners();
  }

  void deleteMutasi(MutasiSaldo mobil) {
    listMutasiSaldo.removeWhere(
      (element) => mobil.id == element.id,
    );

    notifyListeners();
  }

  void updateMutasi(MutasiSaldo mobil) {
    int data = listMutasiSaldo.indexWhere((element) => element.id == mobil.id);

    listMutasiSaldo[data] = mobil;

    notifyListeners();
  }

  void addMobil(Mobil mobil) {
    listMobil.add(mobil);
    backupListMobil.add(mobil);
    notifyListeners();
  }

  void deleteMobil(String id) {
    listMobil.removeWhere(
      (element) => id == element.id,
    );
    backupListMobil.removeWhere(
      (element) => id == element.id,
    );

    notifyListeners();
  }

  void updateMobil(Mobil mobil) {
    int data = listMobil.indexWhere((element) => element.id == mobil.id);

    listMobil[data] = mobil;

    notifyListeners();
  }

  void addUser(User supir) {
    listUser.add(supir);

    notifyListeners();
  }

  void deleteUser(String id) {
    listUser.removeWhere(
      (element) => element.id == id,
    );

    notifyListeners();
  }

  void updateUser(User supir) {
    int data = listUser.indexWhere((element) => element.id == supir.id);
    listUser[data] = supir;

    notifyListeners();
  }

  void addSupir(Supir supir) {
    listSupir.add(supir);
    backupListSupir.add(supir);

    notifyListeners();
  }

  void deleteSupir(String id) {
    listSupir.removeWhere(
      (element) => element.id == id,
    );
    backupListSupir.removeWhere(
      (element) => element.id == id,
    );
    notifyListeners();
  }

  void updateSupir(Supir supir) {
    int data = listSupir.indexWhere((element) => element.id == supir.id);
    listSupir[data] = supir;

    notifyListeners();
  }

  void addJualBeliMobil(JualBeliMobil jualBeliMobil) {
    listJualBeliMobil.add(jualBeliMobil);
    backuplistJualBeliMobil.add(jualBeliMobil);
    notifyListeners();
  }

  void deleteJualBeliMobil(JualBeliMobil supir) {
    listJualBeliMobil.remove(supir);
    backuplistJualBeliMobil.remove(supir);
    notifyListeners();
  }

  void updateJualBeliMobil(JualBeliMobil jualBeliMobil) {
    int data = listJualBeliMobil
        .indexWhere((element) => element.id == jualBeliMobil.id);
    listJualBeliMobil[data] = jualBeliMobil;
    notifyListeners();
  }

  void addPerbaikan(Perbaikan Perbaikan) {
    listPerbaikan.add(Perbaikan);
    backupListPerbaikan.add(Perbaikan);
    searchperbaikan('', false);
    notifyListeners();
  }

  void deletePerbaikan(String id) {
    listPerbaikan.removeWhere(
      (element) => element.id == id,
    );
    backupListPerbaikan.removeWhere(
      (element) => element.id == id,
    );
    notifyListeners();
  }

  void updatePerbaikan(Perbaikan perbaikan) {
    int data =
        listPerbaikan.indexWhere((element) => (element.id) == (perbaikan.id));
    listPerbaikan[data] = perbaikan;
     int data2 =
        backupListPerbaikan.indexWhere((element) => (element.id) == (perbaikan.id));
    backupListPerbaikan [data2] = perbaikan;
    searchperbaikan('', false);
    notifyListeners();
  }

  void addTransaksi(Transaksi transaksi) {
    listTransaksi.insert(0,transaksi);
    backupTransaksi.insert(0,transaksi);

 
    notifyListeners();
  }

  void deleteTransaksi(String id) {
    listTransaksi.removeWhere(
      (element) => element.id == id,
    );
    backupTransaksi.removeWhere(
      (element) => element.id == id,
    );
    notifyListeners();
  }

  void updateTransaksi(Transaksi transaksi) {
    //   log(transaksi.id);
    //  log( listTransaksi.first.id);
    //  log( listTransaksi.last.id);

    try {
      int data =
          listTransaksi.indexWhere((element) => element.id == transaksi.id);
      listTransaksi[data] = transaksi;
      notifyListeners();
    } catch (e) {}

    //  searchTransaksi("",false);
  }

  TextEditingController mobilConttoler = TextEditingController();
  TextEditingController superConttoler = TextEditingController();
  TextEditingController tujuanConttoler = TextEditingController();

  String rentangTransaksi = "Pilih Rentang";
  String searchmobile = '';
  String searchsupir = '';
  String searchtujuan = '';
  bool searchPerbaikan = false;

  DateTime? start;
  DateTime? end;
  DateTime? startMutasi;
  DateTime? endMutasi;
  void searchHistorySaldo() {
    listHistorySaldo.clear();
    for (var element in backupListHistorySaldo) {
      bool skipped = false;

      if (startMutasi != null) {
        if (DateTime.parse(element.tanggal).isBefore(startMutasi!) ||
            DateTime.parse(element.tanggal).isAfter(endMutasi!)) {
          skipped = true;
        }
      }

      if (!skipped) {
        listHistorySaldo.add(element);
      }
    }
    notifyListeners();
  }

  bool filtered = false;
  turnOffFilter(bool listen) {
    filtered = false;
    totalTarif = 0;
    totalKeluar = 0;
    totalSisa = 0;
    // backupTransaksi.sort((a, b) => DateTime.parse(b.tanggalBerangkat)
    //     .compareTo(DateTime.parse(a.tanggalBerangkat)));
    for (var element in backupTransaksi) {
      totalTarif += element.ongkos;
      totalKeluar += element.keluar;
      totalSisa += element.sisa;
      superConttoler.clear();
      mobilConttoler.clear();
      tujuanConttoler.clear();
      rentangTransaksi = "Pilih Rentang";
      start = null;
      end = null;

      searchmobile = '';
      searchsupir = '';
      searchtujuan = '';
    }
    if (listen) notifyListeners();
  }

  double totalTarif = 0;
  double totalKeluar = 0;
  double totalSisa = 0;
  void searchTransaksi(String val, bool listen) {
    if (val.isEmpty) {
      filtered = false;
     
      listTransaksi
        ..clear()
        ..addAll(backupTransaksi);
      totalTarif = 0;
      totalKeluar = 0;
      totalSisa = 0;

      for (var element in listTransaksi) {
        totalTarif += element.ongkos;
        totalKeluar += element.keluar;
        totalSisa += element.sisa;
      }

      if (listen) notifyListeners();
      return;
    }

    filtered = true;

    listTransaksi = backupTransaksi.where((data) {
      // Optimize date parsing by handling it outside the loop if needed
      DateTime? tanggalBerangkat;
      if (start != null) {
        tanggalBerangkat = DateTime.parse(data.tanggalBerangkat);
      }

      // Apply filters
      if (searchmobile.isNotEmpty &&
          !data.mobil.toLowerCase().startsWith(searchmobile.toLowerCase())) {
        return false;
      }
      if (searchsupir.isNotEmpty &&
          !data.supir.toLowerCase().startsWith(searchsupir.toLowerCase())) {
        return false;
      }
      if (searchtujuan.isNotEmpty &&
          !data.tujuan.toLowerCase().startsWith(searchtujuan.toLowerCase())) {
        return false;
      }
      if (start != null &&
          (tanggalBerangkat!.isBefore(start!) ||
              tanggalBerangkat.isAfter(end!))) {
        return false;
      }
      if (searchPerbaikan) {
        return false;
      }
      totalTarif = 0;
      totalKeluar = 0;
      totalSisa = 0;

      for (var element in listTransaksi) {
        totalTarif += element.ongkos;
        totalKeluar += element.keluar;
        totalSisa += element.sisa;
      }
      return true;
    }).toList();

    filtered = true;
    if (listen) notifyListeners();
  }

  refres() {
    for (Transaksi data in backupTransaksi) {
      data.keterangan_mobill = backupListMobil.firstWhere(
        (element) => element.id == data.id_mobil,
        orElse: () {
          //log(errot");
          return backupListMobil[0];
        },
      ).keterangan_mobill;
    }
  }

  void searchSupir(String val, bool listen) {
    if (val.isEmpty) {
      listSupir.clear();
      listSupir.addAll(backupListSupir);
    } else {
      listSupir = backupListSupir
          .where((element) =>
              element.nama_supir.toLowerCase().startsWith(val.toLowerCase()))
          .toList();
    }
    listen ? notifyListeners() : '';
  }

  void searchperbaikan(String val, bool listen) {
    for (var data in listPerbaikan) {
      data.mobil = backupListMobil
          .firstWhere((element) => element.id == data.id_mobil)
          .nama_mobil;
    }
    if (val.isEmpty) {
      listPerbaikan.clear();
      listPerbaikan.addAll(backupListPerbaikan);
    } else {
      listPerbaikan = backupListPerbaikan
          .where((element) =>
              element.mobil.toLowerCase().startsWith(val.toLowerCase()))
          .toList();
    }
    listen ? notifyListeners() : '';
  }

  void searchJual(String val, bool listen) {
    if (val.isEmpty) {
      listJualBeliMobil.clear();
      listJualBeliMobil.addAll(backuplistJualBeliMobil);
    } else {
      listJualBeliMobil = backuplistJualBeliMobil
          .where((element) =>
              element.mobil.toLowerCase().startsWith(val.toLowerCase()))
          .toList();
    }
    listen ? notifyListeners() : '';
  }

  void searchMobil(String val, bool listen) {
    if (val.isEmpty) {
      listMobil.clear();
      listMobil.addAll(backupListMobil);
    } else {
      listMobil = backupListMobil
          .where((element) =>
              element.nama_mobil.toLowerCase().startsWith(val.toLowerCase()))
          .toList();
    }
    listen ? notifyListeners() : '';
  }
}
