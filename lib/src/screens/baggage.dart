import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:trip_planner/src/resources/api_provider.dart';
import 'package:trip_planner/src/screens/baggageItem.dart';

import '../../palette.dart';

class Baggage extends StatefulWidget {
  @override
  _BaggageState createState() => _BaggageState();
}

class _BaggageState extends State<Baggage> {
  bool _checkbox = false;
  // List selectedItems = [];

  // List placesData = [];

  // final List<String> items =
  //     List<String>.generate(20, (index) => "สถานที่ $index");
  // List items = getBaggageList();
  // @override
  // void initState() {
  //   super.initState();
  //   this._fetchData();
  // }

  // Future<void> _fetchData() async {
  //   const API_URL =
  //       'https://run.mocky.io/v3/24c98bfb-d4e0-4eb9-9a3a-81931d94f824';

  //   final response = await http.get(Uri.parse(API_URL));
  //   final data = json.decode(response.body);

  //   setState(() {
  //     placesData = data;
  //   });
  // }
  // @override
  // void initState() {
  //   super.initState();
  //   final postMdl = Provider.of<ApiProvider>(context, listen: false);
  //   postMdl.getBaggageList();
  // }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ApiProvider>(context);
    final baggageList = provider.places;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "กระเป๋าเดินทาง",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 20, 0),
            child: Row(
              children: [
                Checkbox(
                  activeColor: Palette.PrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  value: _checkbox,
                  onChanged: (value) {
                    setState(() {
                      _checkbox = !_checkbox;
                    });
                  },
                ),
                Text(
                  'เลือกทั้งหมดไปสร้างทริป',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                ListView(
                  padding: EdgeInsets.only(bottom: 60),
                  children: baggageList.map((item) {
                    return BaggageItem(
                      place: item,
                      isSelected: false,
                      onSelectedItem: (item) {},
                    );
                  }).toList(),
                ),
                Positioned(
                  height: 48,
                  bottom: 5,
                  left: 15,
                  right: 15,
                  child: ElevatedButton(
                    onPressed: () {
                      print('เริ่มสร้างทริป');
                    },
                    child: Text(
                      'เริ่มสร้างทริป',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Palette.PrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
