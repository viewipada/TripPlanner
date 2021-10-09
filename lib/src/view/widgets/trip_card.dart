import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/src/models/response/trip_card_response.dart';
import 'package:trip_planner/src/view_models/home_view_model.dart';

class TripCard extends StatelessWidget {
  TripCard({
    required this.header,
    required this.tripList,
    // @required this.onTapped,
  });

  final String header;
  final List<TripCardResponse> tripList;

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

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
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: tripList.map((trip) {
                return Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 110,
                  child: Row(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: Image.network(
                          trip.imageUrl,
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100,
                        ),
                        clipBehavior: Clip.antiAlias,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        trip.tripName,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Palette.DarkGrey,
                                        ),
                                      ),
                                      Icon(
                                        Icons.note_alt_outlined,
                                        color: Palette.DarkGrey,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'จาก ' +
                                      trip.startedPoint +
                                      ' ไปยัง ' +
                                      trip.endedPoint,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  trip.sumOfLocation.toString() + ' ที่เที่ยว',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  homeViewModel
                                      .showTravelingDay(trip.travelingDay),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
