import 'dart:developer';

import 'package:cahaya/helper/format_tanggal.dart';
import 'package:cahaya/transaksi/transaksi_delete.dart';
import 'package:cahaya/transaksi/transaksi_edit.dart';
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
import 'package:collection/collection.dart';
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
    Provider.of<ProviderData>(context, listen: false).filtered = false;

    // listTransaksi = await Service.getAllTransaksi();
    Provider.of<ProviderData>(context, listen: false)
        .searchTransaksi("", false);
    // Provider.of<ProviderData>(context, listen: false)
    //     .setData([], listTransaksi, false, [], [], [], [], []);

    loading = false;

    if (mounted) {
      setState(() {});
    }
  }

// @override
  void dispose() {
    log("dispose");

    super.dispose();
  }

  @override
  void initState() {
    initData();

    super.initState();
  }

  TextStyle style = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return loading == true
        ? Center(
            child: CustomPaints(),
          )
        : Consumer<ProviderData>(builder: (context, prov, _) {
            return Scaffold(
                resizeToAvoidBottomInset: false,
                body: Padding(
                    padding: const EdgeInsets.all(16),
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
                         
                          child: Card(
                            color: Theme.of(context).colorScheme.secondary,
                            shadowColor: Theme.of(context).colorScheme.primary,
                            surfaceTintColor:
                                Theme.of(context).colorScheme.secondary,
                            child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
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
                                            child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 20),
                                                child: ElevatedButton.icon(
                                                    label: Text(
                                                      "Terapkan Filter",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onPressed: () {
                                                      Provider.of<ProviderData>(
                                                              context,
                                                              listen: false)
                                                          .searchTransaksi(
                                                              "value", true);
                                                      Provider.of<ProviderData>(
                                                              context,
                                                              listen: false)
                                                          .searchTransaksi(
                                                              "value", true);
                                                    },
                                                    icon: Icon(
                                                      Icons.search,
                                                      color: Colors.white,
                                                    )))),
                                        Expanded(
                                          flex: 4,
                                          child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: ElevatedButton.icon(
                                                  label: Text(
                                                    "Reset",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () {
                                                    Provider.of<ProviderData>(
                                                            context,
                                                            listen: false)
                                                        .turnOffFilter(true);
                                                  },
                                                  icon: Icon(
                                                    Icons.restart_alt,
                                                    color: Colors.white,
                                                  ))),
                                        ),
                                      ]),
                                
                                ])),
                          ),
                        ),

                        Container(margin: EdgeInsets.symmetric(vertical: 16),padding: EdgeInsets.all(8),
                          color: Colors.white,
                          child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(flex: 2,
                                child:   Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: 10,
                                              ),
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
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(right: 0),
                                              child: TransaksiAdd(),
                                            )
                                            // Expanded(child: SearchPerbaikan()),
                                          ],
                                        ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Column(children: [
                                  Container(
                                      margin: EdgeInsets.only(right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: SizedBox(),
                                          ),
                                          Expanded(
                                              flex: 2,
                                              child: Text(
                                                "Total Tarif    :",
                                                style: style,
                                              )),
                                          Expanded(
                                              child: Text("Rp.", style: style)),
                                          Expanded(
                                            child: Text(
                                                textAlign: TextAlign.right,
                                                Rupiah.format2(prov.totalTarif),
                                                style: style),
                                          )
                                        ],
                                      )),
                                 
                                  Container(
                                      margin: EdgeInsets.only(right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: SizedBox(),
                                          ),
                                          Expanded(
                                              flex: 2,
                                              child: Text("Total Keluar :",
                                                  style: style)),
                                          Expanded(
                                              child: Text("Rp.", style: style)),
                                          Expanded(
                                            child: Text(
                                                textAlign: TextAlign.right,
                                                Rupiah.format2(prov.totalKeluar),
                                                style: style),
                                          )
                                        ],
                                      )),
                                 
                                  Container(
                                      margin: EdgeInsets.only(right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: SizedBox(),
                                          ),
                                          Expanded(
                                              flex: 2,
                                              child: Text("Total Sisa    :",
                                                  style: style)),
                                          Expanded(
                                              child: Text("Rp.", style: style)),
                                          Expanded(
                                            child: Text(
                                                textAlign: TextAlign.right,
                                                Rupiah.format2(prov.totalSisa),
                                                style: style),
                                          )
                                        ],
                                      )),
                                ]),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: CustomPaginatedTable(
                              data: prov.filtered
                                  ? prov.listTransaksi
                                  : prov.backupTransaksi,
                              columns: [
                                "No",
                                "Tanggal",
                                "No Pol",
                                "Driver",
                                "Tujuan",
                                "Keterangan",
                                "Tarif",
                                "Keluar",
                                "Sisa",
                                "           Action"
                              ]),
                        )
                      ],
                    )));
          });
  }
}

class CustomPaginatedTable extends StatefulWidget {
  final List<Transaksi> data; // Data for the table
  final List<String> columns; // Column headers
  final int rowsPerPage; // Number of rows per page

  const CustomPaginatedTable({
    required this.data,
    required this.columns,
    this.rowsPerPage = 10,
    Key? key,
  }) : super(key: key);

  @override
  _CustomPaginatedTableState createState() => _CustomPaginatedTableState();
}

class _CustomPaginatedTableState extends State<CustomPaginatedTable> {
  late int _currentPage;
  late int _totalPages;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _totalPages = (widget.data.length / widget.rowsPerPage).ceil();
      

  }

  List<Transaksi> get _currentPageData {
    final startIndex = _currentPage * widget.rowsPerPage;
    final endIndex =
        (startIndex + widget.rowsPerPage).clamp(0, widget.data.length);
    return widget.data.sublist(startIndex, endIndex);
  }

  void _goToPage(int pageIndex) {
    setState(() {
      _currentPage = pageIndex.clamp(0, _totalPages - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Table Header
        Container(
          padding: EdgeInsets.all(8),
          color: Colors.grey.shade800,
          child: Row(
            children: widget.columns
                .map(
                  (column) => Expanded(
                    flex: column == "No" ? 1 : 4,
                    child: Text(
                      column,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                )
                .toList(),
          ),
        ),

        // Table Rows
        Expanded(
          child: ListView.builder(
            itemCount: _currentPageData.length,
            itemBuilder: (context, index) {
              final row = _currentPageData[index];
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                color: index.isEven ? Colors.grey.shade300 : Colors.white,
                child: Row(children: [
                  Expanded(flex: 1, child: Text(" " + (index + 1+_currentPageData.length *(_currentPage + 1)-10).toString())),
                  Expanded(
                      flex: 4,
                      child: Text(
                          FormatTanggal.formatTanggal(row.tanggalBerangkat))),
                  Expanded(flex: 4, child: Text(row.mobil)),
                  Expanded(flex: 4, child: Text(row.supir)),
                  Expanded(flex: 4, child: Text(row.tujuan)),
                  Expanded(flex: 4, child: Text(row.keterangan)),
                  Expanded(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Rp. "),
                          Text(Rupiah.format2(row.ongkos) + "       ")
                        ],
                      )),
                  Expanded(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Rp. "),
                          Text(Rupiah.format2(row.keluar) + "       ")
                        ],
                      )),
                  Expanded(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Rp. "),
                          Text(Rupiah.format2(row.sisa) + "       ")
                        ],
                      )),
                  Expanded(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Provider.of<ProviderData>(context, listen: false)
                                  .isOwner
                              ? Expanded(child: TransaksiEdit(row))
                              : DateTime.parse(row.tanggalBerangkat).month !=
                                          DateTime.now().month ||
                                      DateTime.parse(row.tanggalBerangkat)
                                              .year !=
                                          DateTime.now().year
                                  ? const IconButton(
                                      onPressed: null,
                                      icon: Icon(
                                        Icons.dangerous,
                                        color: Colors.transparent,
                                      ),
                                    )
                                  : Expanded(child: TransaksiEdit(row)),
                          Provider.of<ProviderData>(context, listen: false)
                                  .isOwner
                              ? Expanded(child: TransaksiDelete(row))
                              : const SizedBox(),
                        ],
                      )),
                ]),
              );
            },
          ),
        ),
        const Divider(),

        // Pagination Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed:
                  _currentPage > 0 ? () => _goToPage(_currentPage - 1) : null,
              icon: const Icon(Icons.arrow_back),
            ),
             Text('${_currentPageData.length *(_currentPage + 1) }' " dari "+ widget.data.length.toString()),
            // Text('Page ${_currentPage + 1} of $_totalPages'),
            IconButton(
              onPressed: _currentPage < _totalPages - 1
                  ? () => _goToPage(_currentPage + 1)
                  : null,
              icon: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ],
    );
  }
}
