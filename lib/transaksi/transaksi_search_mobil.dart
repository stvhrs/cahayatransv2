import 'package:flutter/material.dart'; 
import 'package:cahaya/providerData/providerData.dart';
import 'package:provider/provider.dart';

class SearchMobil extends StatefulWidget {
  const SearchMobil({super.key});

  @override
  State<SearchMobil> createState() => _SearchMobilState();
}

class _SearchMobilState extends State<SearchMobil> {
  String value='';
  @override
  Widget build(BuildContext context) {
    return Container(height: 36,
        margin: const EdgeInsets.only(left: 35),
        width: MediaQuery.of(context).size.width * 0.15,
        child: TextFormField(controller: context.read<ProviderData>().mobilConttoler,
                              style: const TextStyle(fontSize:13),textInputAction: TextInputAction.next,
          onChanged: (val) {
            Provider.of<ProviderData>(context, listen: false).searchmobile =
                val;
          value=val;
          },
          decoration:  InputDecoration(
            hintText: 'Mobil',)
        ));
  }
}
