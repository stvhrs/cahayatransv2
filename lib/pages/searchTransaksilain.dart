import 'package:flutter/material.dart';
import 'package:cahaya/helper/format_tanggal.dart';
import 'package:cahaya/providerData/providerData.dart';
import 'package:provider/provider.dart';

class SearchTl extends StatefulWidget {
const SearchTl({super.key});
@override
State<SearchTl> createState() => _SearchTlState();
}


class _SearchTlState extends State<SearchTl> {
  String _selecteRange = 'Pilih Rentang';
  DateTimeRange? picked;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade200,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.date_range_rounded,size: 25),
            InkWell(
              child: Text(
                _selecteRange,
              ),
              onTap: () async {
                dateTimeRangePicker() async {
                  picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(DateTime.now().year - 4),
                      lastDate: DateTime.now().add(const Duration(days: 1)),
                      builder: (context, child) {
                        return Column(
                          children: [
                            ConstrainedBox(
                                constraints: const BoxConstraints(
                                    maxWidth: 600, minHeight: 500),
                                child: Theme(
                                  data: ThemeData(
                                    colorScheme:  ColorScheme.light(
                                    primary: Theme.of(context).primaryColor,
                                      surface: Colors.white,
                                    ),

                                    // Here I Chaged the overline to my Custom TextStyle.
                                    textTheme: const TextTheme(
                                        ),
                                    dialogBackgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  child: child!,
                                ))
                          ],
                        );
                      });
         
                  if (picked != null) {
                    _selecteRange = FormatTanggal.formatTanggal(
                            picked!.start.toIso8601String()) +
                        ' - ' +
                        FormatTanggal.formatTanggal(
                            picked!.end.toIso8601String());
                    Provider.of<ProviderData>(context, listen: false).startTl =
                        picked!.start;
                    Provider.of<ProviderData>(context, listen: false).endTl =
                        picked!.end;
                    Provider.of<ProviderData>(context, listen: false)
                        .sortTransaksiLain();
                    setState(() {});
                  }

                }

                dateTimeRangePicker();
              },
            ),
            _selecteRange == 'Pilih Rentang'
                ? IconButton(onPressed: (){}, icon: const Icon(Icons.r_mobiledata,color: Colors.transparent,))
                : IconButton(
                    onPressed: () {
                      picked = null;
                      _selecteRange = 'Pilih Rentang';
                      Provider.of<ProviderData>(context, listen: false).startTl =
                          null;
                      Provider.of<ProviderData>(context, listen: false).endTl =
                          null;
                      Provider.of<ProviderData>(context, listen: false)
                          .sortTransaksiLain();
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.red,
                    ))
          ],
        ),
      
    );
  }
}
