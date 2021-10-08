import 'package:flutter/material.dart';
import 'package:trip_planner/palette.dart';

class LocationCard extends StatelessWidget {
  LocationCard({
    required this.header,
    required this.locationName,
    // @required this.onTapped,
  });

  final String header;
  final String locationName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
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
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            alignment: Alignment.centerLeft,
            height: 140,
            child: ListView(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Image.network(
                        'https://cf.bstatic.com/xdata/images/hotel/max1024x768/223087771.jpg?k=ef100bbbc40124f71134caaad8504c038caf28f281cf01b419ac191630ce1e01&o=&hp=1',
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                      ),
                      clipBehavior: Clip.antiAlias,
                    ),
                    Container(
                      width: 100,
                      child: Text(
                        this.locationName,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
