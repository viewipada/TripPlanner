import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/src/models/place.dart';
import 'package:trip_planner/src/notifiers/baggage_notifier.dart';

import 'package:trip_planner/src/services/api_service.dart';
import 'package:trip_planner/src/view/widgets/baggage_item.dart';

class Baggage extends StatefulWidget {
  // final bool isMultiSelection;

  // Baggage({
  //   Key? key,
  //   this.isMultiSelection = false,
  // }) : super(key: key);

  @override
  _BaggageState createState() => _BaggageState();
}

class _BaggageState extends State<Baggage> {
  bool _checkbox = false;

  @override
  void initState() {
    BaggageNotifire baggageNotifire =
        Provider.of<BaggageNotifire>(context, listen: false);
    ApiService.getBaggageList(baggageNotifire);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BaggageNotifire>(context);
    final baggageList = provider.getBaggageList();
    final itemSelectedList = provider.getItemSelectionList();
    
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
                      isSelected: itemSelectedList.contains(item),
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
