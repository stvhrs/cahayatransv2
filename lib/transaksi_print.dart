import 'package:flutter/material.dart';
import 'package:cahaya/examples.dart';
import 'package:cahaya/models/history_saldo.dart';
import 'package:cahaya/providerData/providerData.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import 'models/transaksi.dart';

class Trana extends StatefulWidget {
  final List<Transaksi> list;

  const Trana(
    this.list,
  );

  @override
  State<Trana> createState() => _TranaState();
}

class _TranaState extends State<Trana> {
  void _showPrintedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document printed successfully'),
      ),
    );
  }

  void _showSharedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document shared successfully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Theme(
        data: ThemeData(
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            primaryColor: const Color.fromARGB(255, 59, 59, 65)),
        child: PdfPreview(
          loadingWidget: const Text('Loading...'),
          onError: (context, error) => const Text('Error...'),
          maxPageWidth: 700,
          pdfFileName: 'Transaksi',
          canDebug: false,
          build: (format) => transaksion[0].builder(
            format,
            widget.list,
          ),
          onPrinted: _showPrintedToast,
          canChangeOrientation: false,
          canChangePageFormat: false,
          onShared: _showSharedToast,
        ),
      ),
    );
  }
}
