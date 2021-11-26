import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/response/location_card_response.dart';
import 'package:trip_planner/src/view_models/home_view_model.dart';

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
    SizeConfig().init(context);
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return Container(
      padding: EdgeInsets.only(
        top: getProportionateScreenHeight(15),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(15),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    child: Text(
                      this.header,
                      textAlign: TextAlign.start,
                      style: FontAssets.titleText,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      print('see more ... ');
                    },
                    child: Container(
                      child: Text(
                        "ดูเพิ่มเติม >> ",
                        textAlign: TextAlign.end,
                        style: FontAssets.hintText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: getProportionateScreenHeight(5)),
            alignment: Alignment.centerLeft,
            height: getProportionateScreenHeight(160),
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                getProportionateScreenWidth(15),
                0,
                getProportionateScreenWidth(5),
                0,
              ),
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: locationList.map((location) {
                return InkWell(
                  onTap: () => {
                    homeViewModel.goToLocationDetail(
                        context, location.locationId)
                  },
                  child: Container(
                    margin:
                        EdgeInsets.only(right: getProportionateScreenWidth(5)),
                    child: Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Image.network(
                            location.imageUrl,
                            fit: BoxFit.cover,
                            height: getProportionateScreenHeight(100),
                            width: getProportionateScreenHeight(100),
                          ),
                          clipBehavior: Clip.antiAlias,
                        ),
                        Expanded(
                          child: Container(
                            width: 100,
                            child: Text(
                              location.locationName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: FontAssets.subtitleText,
                            ),
                          ),
                        ),
                      ],
                    ),
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
