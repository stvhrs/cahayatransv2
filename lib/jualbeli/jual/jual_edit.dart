import 'dart:async';

import 'package:cahaya/helper/rupiah_format.dart';

import 'package:cahaya/models/jual_beli_mobil.dart';

import 'package:cahaya/providerData/providerData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';import 'package:provider/provider.dart';


import '../../helper/input_currency.dart';
import '../../services/service.dart';
import '../../transaksi/datepicer.dart';

class JualEdit extends StatefulWidget {
  final JualBeliMobil jualBeliMobil;
  const JualEdit(this.jualBeliMobil);
  @override
  State<JualEdit> createState() => _JualEditState();
}

class _JualEditState extends State<JualEdit> {
  List<String> listMobil = [];

  @override
  void initState() {
    Provider.of<ProviderData>(context, listen: false)
        .listMobil
        .where((element) => element.terjual == false)
        .map((e) => e.nama_mobil)
        .toList()
        .forEach((element) {
      if (listMobil.contains(element)) {
      } else {
        listMobil.add(element);
      }
    });

    super.initState();
  }

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  TextStyle small = const TextStyle(fontSize: 13.5);
  Widget _buildSize(widget, String ket, int flex) {
    return Container(
        margin: const EdgeInsets.only(bottom: 7, top: 7),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '$ket :',
                style: const TextStyle(fontSize: 13.5),
              ),
            ),
            Expanded(flex: 2, child: SizedBox(height: 36, child: widget)),
          ],
        ));
  }

  Widget _buildSize2(widget, String ket, int flex) {
    return Container(
        margin: const EdgeInsets.only(bottom: 7, top: 7),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '$ket :',
                style: const TextStyle(fontSize: 13.5),
              ),
            ),
            Expanded(flex: 2, child: widget),
          ],
        ));
  }
 FocusNode fd = FocusNode();
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(
          Icons.edit,
          color: Colors.green,
        ),
        onPressed: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                    backgroundColor: Theme.of(context).primaryColor,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        const Text(
                          'Edit Jual Unit',
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
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    content: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: StatefulBuilder(
                            builder: (BuildContext context,
                                    StateSetter setState) =>
                                IntrinsicHeight(
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        bottom: 20,
                                        left: 20,
                                        right: 20,
                                        top: 15),
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: SingleChildScrollView(
                                        child: Column(children: [
                                      _buildSize(
                                           Picker(fd: fd,
                                            lastDate: DateTime.now(),
                                            height: 60,
                                            initialDate: DateTime.parse(
                                                widget.jualBeliMobil.tanggal),
                                            dateformat: 'dd/MM/yyyy',
                                            onChange: (value) {
                                              if (value != null) {
                                                widget.jualBeliMobil.tanggal =
                                                    value.toIso8601String();
                                              }
                                            },
                                          ),
                                          'Tanggal',
                                          1),
                                      _buildSize(
                                          TextFormField(
                                            initialValue:
                                                widget.jualBeliMobil.mobil,
                                            enabled: false,
                                            onChanged: (val) {
                                              widget.jualBeliMobil.mobil = val;
                                            },
                                          ),
                                          'Pilih No Pol',
                                          1),
                                      _buildSize(
                                          TextFormField(
                                            style:
                                                const TextStyle(fontSize: 13),
                                            textInputAction:
                                                TextInputAction.next,
                                            readOnly: true,
                                            initialValue:
                                                widget.jualBeliMobil.ketMobil,
                                            onChanged: (va) {
                                              widget.jualBeliMobil.ketMobil =
                                                  va;
                                            },
                                          ),
                                          'Jenis Mobil',
                                          1),
                                      _buildSize(
                                          TextFormField(
                                            style:
                                                const TextStyle(fontSize: 13),
                                            textInputAction:
                                                TextInputAction.next,
                                            initialValue: Rupiah.format(
                                                widget.jualBeliMobil.harga),
                                            onChanged: (va) {
                                              widget.jualBeliMobil.harga =
                                                  Rupiah.parse(va);
                                            },
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              CurrencyInputFormatter()
                                            ],
                                          ),
                                          'Harga',
                                          1),
                                      _buildSize(
                                          TextFormField(
                                            style:
                                                const TextStyle(fontSize: 13),
                                            textInputAction:
                                                TextInputAction.next,
                                            initialValue:
                                                widget.jualBeliMobil.keterangan,
                                            onChanged: (va) {
                                              widget.jualBeliMobil.keterangan =
                                                  va;
                                            },
                                          ),
                                          'Keterangan',
                                          2),
                                      Container(
                                        margin: const EdgeInsets.only(top: 30),
                                        child:  Row(
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
                                                  if (widget.jualBeliMobil
                                                              .harga ==
                                                          0 ||
                                                      widget.jualBeliMobil
                                                          .tanggal.isEmpty ||
                                                      widget.jualBeliMobil.mobil
                                                          .isEmpty) {
                                                    _btnController.error();
                                                    await Future.delayed(
                                                        const Duration(
                                                            seconds: 1));
                                                    _btnController.reset();
                                                    return;
                                                  }
                                                  var data =
                                                      await Service.updateJb({
                                                    'id_jb':
                                                        widget.jualBeliMobil.id,
                                                    "id_mobil": widget
                                                        .jualBeliMobil.id_mobil,
                                                    'plat_mobil': widget
                                                        .jualBeliMobil.mobil,
                                                    'ket_mobil': widget
                                                        .jualBeliMobil.ketMobil,
                                                    'harga_jb': widget
                                                        .jualBeliMobil.harga
                                                        .toString(),
                                                    'tgl_jb': widget
                                                        .jualBeliMobil.tanggal,
                                                    'jualOrBeli': "false",
                                                    'ket_jb': widget
                                                        .jualBeliMobil
                                                        .keterangan
                                                  });

                                                  if (data != null) {
                                                    Provider.of<ProviderData>(
                                                            context,
                                                            listen: false)
                                                        .updateJualBeliMobil(
                                                            data);
                                                  } else {
                                                    _btnController.error();
                                                    await Future.delayed(
                                                        const Duration(
                                                            seconds: 1),
                                                        () {});
                                                    _btnController.reset();
                                                    return;
                                                  }

                                                  Provider.of<ProviderData>(
                                                          context,
                                                          listen: false)
                                                      .updateJualBeliMobil(
                                                          widget.jualBeliMobil);

                                                  _btnController.success();

                                                  await Future.delayed(
                                                      const Duration(
                                                          seconds: 1), () {
                                                    Navigator.of(context).pop();
                                                  });
                                                  _btnController.success();

                                                  await Future.delayed(
                                                      const Duration(
                                                          seconds: 1), () {
                                                    Navigator.of(context).pop();
                                                  });
                                                },
                                                child: const Text('Edit',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              )
                                            ],
                                          ),
                                        ),
                                    
                                    ])),
                                  ),
                                ))));
              });
        });
  }
}
