import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InfoFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InfoFragmentState();
}

class InfoFragmentState extends State<InfoFragment> {
  String _base64;


  @override
  void initState() {
    super.initState();
    (() async {
      http.Response response = await http.get(
        'https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/242ce817-97a3-48fe-9acd-b1bf97930b01/09-posterization-opt.jpg',
      );
      if (mounted) {
        setState(() {
          _base64 = base64.encode(response.bodyBytes);
        });
      }
    })();
  }

  @override
  Widget build(BuildContext context) {
    if (_base64 == null)
      return new Container();

    Uint8List bytes = base64.decode(_base64);

    return new Container(
        child: Scaffold(
          body: Image.memory(bytes),
        )
    );
  }
}