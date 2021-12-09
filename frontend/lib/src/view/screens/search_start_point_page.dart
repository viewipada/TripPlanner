import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/response/baggage_response.dart';
import 'package:trip_planner/src/view/widgets/start_point_card.dart';
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

  late GooglePlace googlePlace;
  final String googleAPI = "AIzaSyC3IbO2CjNOMP1g1F_Y7jamCp0aEu4asKE";

  @override
  void initState() {
    googlePlace = GooglePlace(googleAPI);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final searchStartPointViewModel =
        Provider.of<SearchStartPointViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "เลือกจุดเริ่มต้น",
          style: FontAssets.headingText,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(15),
                vertical: getProportionateScreenHeight(10),
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Palette.AdditionText,
                    size: 30,
                  ),
                  hintText: 'ค้นหาจุดเริ่มต้น',
                ),
                onChanged: (value) {
                  if (searchStartPointViewModel.sessionToken == null) {
                    searchStartPointViewModel.createSessionToken();
                  }
                  if (value.isNotEmpty) {
                    searchStartPointViewModel.autoCompleteSearch(
                        googlePlace, value);
                  } else {
                    searchStartPointViewModel.clearPredictions();
                  }
                },
              ),
            ),
            Expanded(
              child: searchStartPointViewModel.predictions.isEmpty
                  ? ListView(
                      padding: EdgeInsets.symmetric(
                          vertical: getProportionateScreenHeight(10)),
                      children: startPointList.map((item) {
                        return InkWell(
                            onTap: () => {
                                  searchStartPointViewModel.selectedStartPoint(
                                      context, startPointList, item)
                                },
                            child: StartPointCard(item: item));
                      }).toList(),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                          vertical: getProportionateScreenHeight(10)),
                      itemCount: searchStartPointViewModel.predictions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            child: Icon(
                              Icons.pin_drop,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            searchStartPointViewModel
                                .predictions[index].description!,
                            style: FontAssets.bodyText,
                          ),
                          onTap: () {
                            searchStartPointViewModel.closeSessionToken();
                            searchStartPointViewModel.getDetils(
                                googlePlace,
                                searchStartPointViewModel
                                    .predictions[index].placeId!);
                            // debugPrint(predictions[index].placeId);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => DetailsPage(
                            //       placeId: predictions[index].placeId!,
                            //       googlePlace: googlePlace,
                            //     ),
                            //   ),
                            // );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
