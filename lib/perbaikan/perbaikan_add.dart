import "dart:async";
import 'dart:developer';

import "package:cahaya/helper/rupiah_format.dart";
import "package:cahaya/models/mobil.dart";
import 'package:cahaya/models/perbaikan.dart';

import "package:cahaya/providerData/providerData.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import "package:provider/provider.dart";


import '../helper/dropdown.dart';
import '../helper/format_tanggal.dart';
import '../helper/input_currency.dart';
import '../services/service.dart';
import '../transaksi/datepicer.dart';

class PerbaikanAdd extends StatefulWidget {
  final bool isPerbaikan;
  PerbaikanAdd(this.isPerbaikan);
  @override
  State<PerbaikanAdd> createState() => _PerbaikanAddState();
}

class _PerbaikanAddState extends State<PerbaikanAdd> {
  final List<Perbaikan> bulkperbaikan = [];
  FocusNode fd = FocusNode();

  TextEditingController controlerHarga = TextEditingController();

  TextEditingController controlerKeterangan = TextEditingController();
  TextEditingController nomorNota = TextEditingController();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  late Perbaikan perbaikan;
  TextStyle small = const TextStyle(fontSize: 13.5);

  Widget _buildSize(widget, String ket, int flex) {
    return
        //  Container(height: 50,
        //   // margin: EdgeInsets.only(
        //   //     right: ket == 'Jenis Mobil' || ket == "Ketik Tujuan" ? 0 : 50,
        //   //     bottom: ket == "ket_perbaikan" ? 20 : 5),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Container(
        //           margin: const EdgeInsets.only(
        //             right: 7,
        //           ),
        //           child: Text(
        //             "$ket :",
        //             style: const TextStyle(fontSize: 13.5),
        //           )),
        Container(
      margin: const EdgeInsets.only(bottom: 15, left: 10),
      height: 28,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // clipBehavior: Clip.none,
        // alignment: Alignment.centerLeft,
        children: [
          Expanded(
            child: Text(
              "$ket :",
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Nunito"),
            ),
          ),
          Expanded(
            child: widget,
          )
        ],
      ),
    );
  }
Widget _buildSize2(widget, String ket, int flex) {
    return
        //  Container(height: 50,
        //   // margin: EdgeInsets.only(
        //   //     right: ket == 'Jenis Mobil' || ket == "Ketik Tujuan" ? 0 : 50,
        //   //     bottom: ket == "ket_transaksi" ? 20 : 5),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Container(
        //           margin: const EdgeInsets.only(
        //             right: 7,
        //           ),
        //           child: Text(
        //             "$ket :",
        //             style: const TextStyle(fontSize: 13.5),
        //           )),
        Container(
      margin: const EdgeInsets.only(bottom: 15, left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // clipBehavior: Clip.none,
        // alignment: Alignment.centerLeft,
        children: [
          Expanded(
       
            child: Text(
              "$ket :",
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Nunito"),
            ),
          ),
          Expanded(
         
            child: widget,
          )
        ],
      ),
    );
  }
  final TextEditingController mobilCont = TextEditingController()..text="";
  List<String> listMobil = [];
  @override
  Widget build(BuildContext context) {
    listMobil = Provider.of<ProviderData>(context, listen: false)
        .listMobil
        .where((element) => element.terjual == false)
        .map((e) => e.nama_mobil)
        .toList();

    return ElevatedButton.icon(
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: Text(
         widget.isPerbaikan?   "Input Perbaikan":"Input Administrasi",
          style: TextStyle(color: Colors.white),
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                widget.isPerbaikan ? Colors.green : Colors.red),
            padding: MaterialStateProperty.all(const EdgeInsets.all(10))),
        onPressed: () {
          perbaikan = Perbaikan.fromMap({
            "id_perbaikan": "0",
            "id_mobil": '',
            "plat_mobil": '',
            "ket_mobil": '',
            "jenis_p": '',
            "harga_p": '0',
            "ket_p": '',
            "tgl_p": DateTime.now().toIso8601String(),
            "administrasi": widget.isPerbaikan?"false":"true"
          });
          mobilCont.text = perbaikan.mobil;
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Theme.of(context).primaryColor,
                  contentPadding: const EdgeInsets.all(0),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      Text(
                     widget.isPerbaikan?   "Input Perbaikan":"Input Administrasi",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.white,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: const Icon(
                                Icons.close,
                                size: 13,
                                color: Colors.red,
                              ),
                            )),
                      ),
                    ],
                  ),
                  titlePadding: const EdgeInsets.all(0),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  content: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) =>
                          IntrinsicHeight(
                        child: Container(
                          height: 2000,
                          padding: const EdgeInsets.only(bottom: 20, top: 15),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.26,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ScrollConfiguration(
                                        behavior:
                                            ScrollConfiguration.of(context)
                                                .copyWith(scrollbars: false),
                                        child: SingleChildScrollView(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          child: Column(
                                            children: [
                                              _buildSize(
                                                   Picker( fd: fd,
                                                    lastDate: DateTime.now(),
                                                    height: 36,
                                                    initialDate: DateTime.now(),
                                                    dateformat: "dd/MM/yyyy",
                                                    onChange: (value) {
                                                      if (value != null) {
                                                        perbaikan.tanggal = value
                                                            .toIso8601String();
                                                      }
                                                    },
                                                  ),
                                                  "Tanggal",
                                                  1),
                                              _buildSize2(
                                                  DropDownField(height: 28,
                                                    controller: mobilCont,
                                                    onValueChanged: (val) {
                                                      perbaikan.mobil = val;
                                                      perbaikan
                                                          .id_mobil = Provider
                                                              .of<ProviderData>(
                                                                  context,
                                                                  listen: false)
                                                          .listMobil
                                                          .firstWhere((element) =>
                                                              element
                                                                  .nama_mobil ==
                                                              val)
                                                          .id;
                                                    },
                                                    items: listMobil..add(""),
                                                  ),
                                                  'Pilih No Pol',
                                                  1),
                                              _buildSize(
                                                  TextFormField(
                                                  
                                                    style: const TextStyle(
                                                        fontSize: 13),
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    controller:
                                                        controlerKeterangan,
                                                    onChanged: (va) {
                                                      perbaikan.keterangan = va;
                                                      setState(() {});
                                                    },
                                                  ),
                                               widget.isPerbaikan?  "Jenis Perbaikan":"Jenis Administrasi",
                                                  1), _buildSize(
                                                  TextFormField(
                                                      style: const TextStyle(
                                                          fontSize: 13),
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      controller: nomorNota,
                                                      onChanged: (val) {
                                                        perbaikan.jenis = val;
                                                        setState(() {});
                                                      }),
                                                  "Keterangan",
                                                  2),_buildSize(
                                                  TextFormField(
                                                    style: const TextStyle(
                                                        fontSize: 13),
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    controller: controlerHarga,
                                                    onChanged: (va) {
                                                      if (va.isNotEmpty &&
                                                          va.startsWith("Rp")) {
                                                        perbaikan.harga =
                                                            Rupiah.parse(va);
                                                      } else {
                                                        perbaikan.harga = 0;
                                                      }
                                                      setState(
                                                        () {},
                                                      );
                                                    },
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      CurrencyInputFormatter()
                                                    ],
                                                  ),
                                              widget.isPerbaikan?  "Nominal Perbaikan":"Nominal Administrasi",
                                                  1),
                                              
                                             
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton.icon(
                                              style: const ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStatePropertyAll(
                                                          Colors.red)),
                                              onPressed: () {
                                                controlerKeterangan.text = "";

                                                controlerHarga.text = "";

                                                nomorNota.text = "";
                                                perbaikan.keterangan = "";

                                                perbaikan.harga = 0;
mobilCont.text="";
                                                perbaikan.tanggal =
                                                    DateTime.now()
                                                        .toIso8601String();

                                                fd.requestFocus();

                                                setState(
                                                  () {},
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                              label: const Text(
                                                "Hapus",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13),
                                              )),
                                          Container(
                                            child: ElevatedButton.icon(
                                                icon: const Icon(
                                                  Icons.arrow_right_alt_rounded,
                                                  color: Colors.white,
                                                ),
                                                label: const Text(
                                                  "Masukan",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13),
                                                ),
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            (perbaikan.harga <=
                                                                    0)
                                                                ? Colors.grey
                                                                : Colors.green),
                                                    padding:
                                                        MaterialStateProperty
                                                            .all(
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 15,
                                                                    left: 15))),
                                                onPressed: (perbaikan.harga <=
                                                            0 ||
                                                        perbaikan
                                                            .keterangan.isEmpty)
                                                    ? null
                                                    : () {
                                                        Perbaikan temp =
                                                            Perbaikan(
                                                                "",
                                                                perbaikan
                                                                    .id_mobil,
                                                                perbaikan.mobil,
                                                                perbaikan.jenis,
                                                                perbaikan.harga,
                                                                perbaikan
                                                                    .tanggal,
                                                                perbaikan
                                                                    .keterangan,
                                                                perbaikan
                                                                    .adminitrasi);

                                                        bulkperbaikan.add(temp);

                                                        controlerKeterangan
                                                            .text = "";

                                                        controlerHarga.text =
                                                            "";mobilCont.text="";

                                                        nomorNota.text = "";
                                                        perbaikan.keterangan =
                                                            "";
                                                        perbaikan.jenis = "";
                                                        perbaikan.harga = 0;
                                                        fd.requestFocus();
                                                        setState(
                                                          () {},
                                                        );
                                                      }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const VerticalDivider(),
                              Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Column(children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(5))),
                                      padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 12.5,
                                          left: 15,
                                          right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: Text(
                                            "No",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium,
                                          )),
                                          Expanded(
                                              flex: 4,
                                              child: Text(
                                                "Tanggal",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium,
                                              )), Expanded(
                                              flex: 3,
                                              child: Text(
                                                "No Pol",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium,
                                              )),
                                          Expanded(
                                              flex: 4,
                                              child: Text(
                                                "Jenis",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium,
                                              )),
                                          Expanded(
                                              flex: 4,
                                              child: Text(
                                                "Harga",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium,
                                              )),
                                          Expanded(
                                              flex: 4,
                                              child: Text(
                                                'Keterangan',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium,
                                              )),
                                          Expanded(
                                            flex: 4,
                                            child: Text(
                                            
                                              "         Aksi",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView(
                                          addAutomaticKeepAlives: false,
                                          padding: EdgeInsets.zero,
                                          children: bulkperbaikan.reversed
                                              .toList()
                                              .mapIndexed(
                                                  (index, element) => Container(
                                                        color: index.isEven
                                                            ? Colors
                                                                .grey.shade200
                                                            : const Color
                                                                    .fromARGB(
                                                                255,
                                                                189,
                                                                193,
                                                                221),
                                                        child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5,
                                                                    bottom: 5,
                                                                    left: 15,
                                                                    right: 15),
                                                            child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                      child:
                                                                          Text(
                                                                    style:
                                                                        small,
                                                                    (index + 1)
                                                                        .toString(),
                                                                  )),
                                                                  Expanded(
                                                                      flex: 4,
                                                                      child: Text(
                                                                          style:
                                                                              small,
                                                                          maxLines:
                                                                              1,
                                                                          FormatTanggal.formatTanggal(element.tanggal)
                                                                              .toString())),
                                                                  Expanded(
                                                                      flex: 3,
                                                                      child: Text(
                                                                          style:
                                                                              small,
                                                                          element
                                                                              .mobil)),

                                                                  Expanded(
                                                                      flex: 4,
                                                                      child: Text(
                                                                          style:
                                                                              small,
                                                                          element
                                                                              .jenis)),
                                                                     Expanded(
                                                                        flex: 4,
                                                                        child: Container(
                  margin: EdgeInsets.only(right: 30),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Rp."),
                        Text(Rupiah.format2(element.harga))
                      ]))),
                                                                  Expanded(
                                                                      flex: 4,
                                                                      child: Text(
                                                                          style:
                                                                              small,
                                                                          element
                                                                              .keterangan)),

                                                                  Expanded(
                                                                      flex: 4,
                                                                      child: Shortcuts
                                                                          .manager(
                                                                        manager:
                                                                            ShortcutManager(
                                                                          shortcuts: Map.of(
                                                                              WidgetsApp.defaultShortcuts)
                                                                            ..remove(LogicalKeySet(LogicalKeyboardKey.enter))
                                                                            ..remove(LogicalKeySet(LogicalKeyboardKey.numpadEnter)),
                                                                        ),
                                                                        child: GestureDetector(
                                                                            onTap: () {
                                                                              bulkperbaikan.remove(element);
                                                                              setState(() {});
                                                                            },
                                                                            child: const Icon(
                                                                              Icons.delete_forever,
                                                                              color: Colors.red,
                                                                            )),
                                                                      ))
                                                                  // Expanded(
                                                                  //     child: Text(element.listPerbaikan.isEmpty
                                                                  //         ? "-"
                                                                  //         : Rupiah.format(
                                                                  //             totalPerbaikan(element.listPerbaikan)))),
                                                                ])),
                                                      ))
                                              .toList()),
                                    ),
                                    bulkperbaikan.isEmpty
                                        ? const SizedBox()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              RoundedLoadingButton(
                                                  width: 120,
                                                  color: Colors.red,
                                                  controller:
                                                      RoundedLoadingButtonController(),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Batal',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white))),
                                              RoundedLoadingButton(
                                                width: 120,
                                                color: Colors.green,
                                                elevation: 10,
                                                successColor: Colors.green,
                                                errorColor: Colors.red,
                                                controller: _btnController,
                                                onPressed: () async {
                                                  if (bulkperbaikan.isEmpty ||
                                                      bulkperbaikan.every(
                                                          (element) =>
                                                              element.harga <
                                                              1)) {
                                                    _btnController.error();
                                                    await Future.delayed(
                                                        const Duration(
                                                            seconds: 1));
                                                    _btnController.reset();
                                                    return;
                                                  }

                                                  for (var element
                                                      in bulkperbaikan) {
                                                        log(element.tanggal.toString());
                                                    var data = await Service
                                                        .postPerbaikan({
                                                      "id_perbaikan":
                                                          element.id,
                                                      "id_mobil":
                                                          element.id_mobil,
                                                      "plat_mobil":
                                                          element.mobil,
                                                      "ket_mobil":
                                                          element.mobil,
                                                      "jenis_p": element.jenis,
                                                      "harga_p": element.harga
                                                          .toString(),
                                                      "ket_p":
                                                          element.keterangan,
                                                      "tgl_p":
                                                          element.tanggal,
                                                      "administrasi": widget.isPerbaikan?"false":"true"
                                                    });

                                                    if (data != null) {
                                                      Provider.of<ProviderData>(
                                                              context,
                                                              listen: false)
                                                          .addPerbaikan(data);
                                                      log(data.toString());
                                                    } else {
                                                      _btnController.error();
                                                      await Future.delayed(
                                                          const Duration(
                                                              seconds: 1),
                                                          () {});
                                                      _btnController.reset();
                                                      return;
                                                    }
                                                  }

                                                  _btnController.success();

                                                  await Future.delayed(
                                                      const Duration(
                                                          seconds: 1), () {
                                                    Navigator.of(context).pop();
                                                  });
                                                },
                                                child: const Text("Simpan",
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            ],
                                          ),
                                  ]))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).then((value) => {
                bulkperbaikan.clear(),
                controlerKeterangan.text = "",
                controlerHarga.text = "",
                nomorNota.text = "",
                perbaikan = Perbaikan.fromMap({
                  "id_perbaikan": "0",
                  "id_mobil": '',
                  "plat_mobil": '',
                  "ket_mobil": '',
                  "jenis_p": '',
                  "harga_p": '0',
                  "ket_p": '',
                  "tgl_p": DateTime.now().toIso8601String(),
                  "administrasi": widget.isPerbaikan?"false":"true"
                })
              });
        });
  }
}
