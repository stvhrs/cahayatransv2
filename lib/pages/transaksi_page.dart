import 'package:cahaya/transaksi_print.dart';
import 'package:flutter/material.dart';
import 'package:cahaya/models/transaksi.dart';
import 'package:cahaya/providerData/providerData.dart';
import 'package:cahaya/transaksi/transaksi_add.dart';
import 'package:cahaya/transaksi/transaksi_search_mobil.dart';
import 'package:cahaya/transaksi/transaksi_search_nama.dart';
import 'package:cahaya/transaksi/transaksi_search_tanggal.dart';
import 'package:cahaya/transaksi/transaksi_search_tujuan.dart';
import 'package:cahaya/transaksi/transaksi_tile.dart';

import 'package:provider/provider.dart';

import '../helper/rupiah_format.dart';
import '../print_dynamic.dart';
import '../services/service.dart';
import 'package:cahaya/helper/custompaint.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  late List<Transaksi> listTransaksi;

  bool loading = true;
  initData() async {
//    test=      await Service.test2();
// await Service.test();
// await Service.postSupir();
// await Service.deleteSupir();
// await Service.test3();
    listTransaksi = await Service.getAllTransaksi();

    Provider.of<ProviderData>(context, listen: false)
        .setData([], listTransaksi, false, [], [], [], [], []);

    Provider.of<ProviderData>(context, listen: false).start = null;
    Provider.of<ProviderData>(context, listen: false).end = null;
    Provider.of<ProviderData>(context, listen: false).searchsupir = '';
    Provider.of<ProviderData>(context, listen: false).searchtujuan = '';
    Provider.of<ProviderData>(context, listen: false).searchmobile = '';
    Provider.of<ProviderData>(context, listen: false).searchMobil('', false);
    Provider.of<ProviderData>(context, listen: false)
        .searchTransaksi("", false);
    loading = false;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    initData();

    super.initState();
  }
TextStyle style=TextStyle(fontSize: 14,fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return loading == true
        ? Center(
            child: CustomPaints(),
          )
        : Consumer<ProviderData>(builder: (context, prov, _) {
            List<Transaksi> data = prov.listTransaksi;
            double totalTarif = 0;
            double totalKeluar = 0;
            double totalSisa = 0;
            data.sort((a, b) => DateTime.parse(b.tanggalBerangkat)
                .compareTo(DateTime.parse(a.tanggalBerangkat)));
            for (var element in data) {
              totalTarif += element.ongkos;
              totalKeluar += element.keluar;
              totalSisa += element.sisa;
            }
            return Scaffold(
                resizeToAvoidBottomInset: false,
                body: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // FutureBuilder(
                        //   future: Service.test(),
                        //   builder: (context, snapshotx) => snapshotx
                        //               .connectionState ==
                        //           ConnectionState.waiting
                        //       ? const CustomPaints()
                        //       : Text(

                        //           jsonDecode(snapshotx.data!)['data'].toString()),
                        Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          child: Card(
                            color: Theme.of(context).colorScheme.secondary,
                            shadowColor: Theme.of(context).colorScheme.primary,
                            surfaceTintColor:
                                Theme.of(context).colorScheme.secondary,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20),
                                            child: TransaksiAdd(),
                                          )),
                                      const Expanded(
                                          flex: 4, child: SearchTanggal()),
                                      const Expanded(
                                          flex: 4, child: SearchNama()),
                                      const Expanded(
                                          flex: 4, child: SearchMobil()),
                                      const Expanded(
                                          flex: 4, child: SearchTujuan()),
                                      Expanded(
                                        flex: 4,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 10, left: 10),
                                          child: ElevatedButton.icon(
                                              icon: const Icon(
                                                Icons.print,
                                                color: Colors.white,
                                              ),
                                              label: Text(
                                                "Print Transaksi",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) => Trana(
                                                      prov.listTransaksi
                                                          .map((e) => e)
                                                          .toList()),
                                                ));
                                              }),
                                        ),
                                      ),
                                      // Expanded(child: SearchPerbaikan()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              Container(
                                  margin: EdgeInsets.only(right: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(flex:4,child: SizedBox(),),
                                      Expanded(flex: 2,child: Text("Total Tarif    :",style: style,)),
                                      Expanded(child: Text("Rp.",style: style)),
                                      Expanded(
                                        child: Text(
                                          textAlign: TextAlign.right,
                                          Rupiah.format2(totalTarif),style: style
                                        ),
                                      )
                                    ],
                                  )),
                              Divider(),
                              Container(
                                  margin: EdgeInsets.only(right: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [    Expanded(flex:4,child: SizedBox(),),
                                      Expanded(flex: 2,child: Text("Total Keluar :",style: style)),
                                      Expanded(child: Text("Rp.",style: style)),
                                      Expanded(
                                        child: Text(
                                          textAlign: TextAlign.right,
                                          Rupiah.format2(totalKeluar),style: style
                                        ),
                                      )
                                    ],
                                  )),
                              Divider(),
                              Container(
                                  margin: EdgeInsets.only(right: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [     Expanded(flex:4,child: SizedBox(),),
                                      Expanded(flex: 2,child: Text("Total Sisa    :",style: style)),
                                      Expanded(child: Text("Rp.",style: style)),
                                      Expanded(
                                        child: Text(
                                          textAlign: TextAlign.right,
                                          Rupiah.format2(totalSisa),style: style
                                        ),
                                      )
                                    ],
                                  )),
                            ]),
                          ),
                        ),

                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5))),
                          margin: const EdgeInsets.only(top: 5),
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 12.5, left: 15, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    'No',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  )),
                              Expanded(
                                  flex: 5,
                                  child: Text(
                                    'Tanggal',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  )),
                              Expanded(
                                  flex: 5,
                                  child: Text(
                                    'No Pol',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  )),
                              Expanded(
                                  flex: 5,
                                  child: Text(
                                    'Driver',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  )),
                              Expanded(
                                  flex: 5,
                                  child: Text(
                                    'Tujuan',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  )),
                              Expanded(
                                  flex: 5,
                                  child: Text(
                                    'Keterangan',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  )),
                              Expanded(
                                  flex: 5,
                                  child: Text(
                                    'Tarif',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  )),
                              Expanded(
                                  flex: 5,
                                  child: Text(
                                    'Keluar',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  )),
                              Expanded(
                                  flex: 5,
                                  child: Text(
                                    'Sisa',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  )),
                              Expanded(
                                  flex: 5,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    'Action',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  )),
                            ],
                          ),
                        ),
                        Expanded(
                          // height: MediaQuery.of(context).size.height * 0.7,
                          child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) =>
                                  TransaksiTile(data[index], index + 1)),
                        ),
                      ],
                    )));
          });
  }
}
