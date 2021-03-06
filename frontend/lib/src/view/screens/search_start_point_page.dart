import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/response/baggage_response.dart';
import 'package:trip_planner/src/view/widgets/start_point_card.dart';
import 'package:trip_planner/src/view_models/search_start_point_view_model.dart';
import 'package:trip_planner/src/view_models/search_view_model.dart';

class SearchStartPointPage extends StatefulWidget {
  SearchStartPointPage({
    required this.startPointList,
    required this.startPointValue,
  });

  final List<BaggageResponse> startPointList;
  final bool startPointValue;
  @override
  _SearchStartPointPageState createState() =>
      _SearchStartPointPageState(this.startPointList, this.startPointValue);
}

class _SearchStartPointPageState extends State<SearchStartPointPage> {
  final List<BaggageResponse> startPointList;
  final bool startPointValue;
  _SearchStartPointPageState(this.startPointList, this.startPointValue);

  final textController = TextEditingController();

  late GooglePlace googlePlace;

  @override
  void initState() {
    googlePlace = GooglePlace(GoogleAssets.googleAPI);
    textController.clear();
    Provider.of<SearchStartPointViewModel>(context, listen: false)
        .initialStartPointValue(startPointValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final searchStartPointViewModel =
        Provider.of<SearchStartPointViewModel>(context);
    final searchViewModel = Provider.of<SearchViewModel>(context);

    return WillPopScope(
      onWillPop: () async {
        searchStartPointViewModel.clearPredictions();
        return true;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              color: Palette.BackIconColor,
              onPressed: () {
                searchStartPointViewModel.goBack(context);
              },
            ),
            title: Text(
              "????????????????????????????????????????????????",
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
                    controller: textController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: Palette.AdditionText,
                        size: 30,
                      ),
                      suffixIcon: IconButton(
                        icon:
                            Icon(Icons.cancel_rounded, color: Palette.Outline),
                        onPressed: () {
                          textController.clear();
                          searchStartPointViewModel.clearPredictions();
                        },
                      ),
                      hintText: '????????????????????????????????????????????????',
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
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(10)),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: searchStartPointViewModel.predictions.isEmpty
                        ? Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  searchViewModel.getUserLocation().then(
                                      (value) => searchStartPointViewModel
                                          .selectedUserLocation(
                                              context,
                                              startPointList,
                                              searchViewModel.userLocation!));
                                },
                                child: StartPointCard(
                                  imageUrl: 'myLocation',
                                  locationName: '???????????????????????????????????????',
                                  description:
                                      '?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????',
                                  category: '',
                                ),
                              ),
                              ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: startPointList.map((item) {
                                  return InkWell(
                                    onTap: () => {
                                      searchStartPointViewModel
                                          .selectedStartPoint(
                                              context, startPointList, item)
                                    },
                                    child: StartPointCard(
                                      imageUrl: item.imageUrl,
                                      locationName: item.locationName,
                                      description: item.description,
                                      category: item.category,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount:
                                searchStartPointViewModel.predictions.length,
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
                                  searchStartPointViewModel.getDetails(
                                    context,
                                    startPointList,
                                    googlePlace,
                                    searchStartPointViewModel
                                        .predictions[index].placeId!,
                                    searchStartPointViewModel
                                        .predictions[index].description!,
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
