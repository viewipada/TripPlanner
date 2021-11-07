import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/response/baggage_response.dart';
import 'package:trip_planner/src/view/screens/trip_form_page.dart';
import 'package:trip_planner/src/view/widgets/start_point_card.dart';
import 'package:trip_planner/src/view/widgets/tag_category.dart';
import 'package:trip_planner/src/view_models/baggage_view_model.dart';
import 'package:trip_planner/src/view_models/search_start_point_view_model.dart';

class SearchStartPointPage extends StatefulWidget {
  SearchStartPointPage({
    required this.startPointList,
  });

  final List<BaggageResponse> startPointList;
  @override
  _SearchStartPointPageState createState() =>
      _SearchStartPointPageState(this.startPointList);
}

class _SearchStartPointPageState extends State<SearchStartPointPage> {
  final List<BaggageResponse> startPointList;
  _SearchStartPointPageState(this.startPointList);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final searchStartPointViewModel =
        Provider.of<SearchStartPointViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "เลือกจุดเริ่มต้น",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 70,
              color: Colors.amber,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(10)),
                child: ListView(
                  children: startPointList.map((item) {
                    return InkWell(
                        onTap: () => {
                              searchStartPointViewModel.selectedStartPoint(
                                  context, startPointList, item)
                            },
                        child: StartPointCard(item: item));
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
