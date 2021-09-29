import 'dart:html';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trip_planner/assets.dart';

import '../../palette.dart';

class Baggage extends StatefulWidget {
  @override
  _BaggageState createState() => _BaggageState();
}

class _BaggageState extends State<Baggage> {
  bool _checkbox = false;
  // List selectedItems = [];

  List placesData = [];

  final List<String> items =
      List<String>.generate(20, (index) => "สถานที่ $index");
  // List items = getBaggageList();
  @override
  void initState() {
    super.initState();
    this._fetchData();
  }

  Future<void> _fetchData() async {
    const API_URL =
        'https://run.mocky.io/v3/24c98bfb-d4e0-4eb9-9a3a-81931d94f824';

    final response = await http.get(Uri.parse(API_URL));
    final data = json.decode(response.body);

    setState(() {
      placesData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                ListView.builder(
                  padding: EdgeInsets.only(bottom: 60),
                  // itemCount: items.length,
                  itemCount: placesData == null ? 0 : placesData.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        print('${items[index]}');
                      },
                      child: Container(
                        height: 110,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image(
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topLeft,
                                    image: NetworkImage(
                                        placesData[index]['imageUrl']),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 15, 5),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${placesData[index]["name"]}",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        "${placesData[index]["description"]}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Spacer(
                                        flex: 2,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(8, 3, 8, 3),
                                        child: Text(
                                          "ที่เที่ยว",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
