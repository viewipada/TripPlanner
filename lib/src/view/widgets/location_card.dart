import 'package:flutter/material.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/src/models/response/location_card_response.dart';

class LocationCard extends StatelessWidget {
  LocationCard({
    required this.header,
    required this.locationList,
    // @required this.onTapped,
  });

  final String header;
  final List<LocationCardResponse> locationList;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    child: Text(
                      this.header,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      "ดูเพิ่มเติม >> ",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Palette.AdditionText,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            alignment: Alignment.centerLeft,
            height: 140,
            child: ListView(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: locationList.map((location) {
                return Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Image.network(
                        location.imageUrl,
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                      ),
                      clipBehavior: Clip.antiAlias,
                    ),
                    Container(
                      width: 100,
                      child: Text(
                        location.locationName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Palette.DarkGrey,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
