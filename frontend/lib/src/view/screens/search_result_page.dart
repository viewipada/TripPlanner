import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/response/search_result_response.dart';
import 'package:trip_planner/src/view/widgets/baggage_cart.dart';
import 'package:trip_planner/src/view/widgets/loading.dart';
import 'package:trip_planner/src/view/widgets/tag_category.dart';
import 'package:trip_planner/src/view_models/search_view_model.dart';

class SearchResultPage extends StatefulWidget {
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  List<SearchResultResponse> allLocationList = [];
  final textController = TextEditingController();

  @override
  void initState() {
    Provider.of<SearchViewModel>(context, listen: false)
        .getSearchResultBy(0, 'rating')
        .then((value) => allLocationList =
            Provider.of<SearchViewModel>(context, listen: false)
                .searchResultCard);
    textController.clear();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final searchViewModel = Provider.of<SearchViewModel>(context);

    return WillPopScope(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: DefaultTabController(
          initialIndex: 0,
          length: searchViewModel.tabs.length,
          child: Builder(builder: (context) {
            final tabController = DefaultTabController.of(context)!;
            tabController.addListener(() => searchViewModel.getSearchResultBy(
                searchViewModel.tabs[tabController.index]['value'],
                searchViewModel.dropdownItemList[0]['value']));

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_rounded),
                  color: Palette.BackIconColor,
                  onPressed: () {
                    searchViewModel.goBack(context);
                  },
                ),
                title: Text(
                  "???????????????",
                  style: FontAssets.headingText,
                ),
                centerTitle: true,
                actions: [
                  BaggageCart(),
                ],
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              body: SafeArea(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(15),
                          vertical: getProportionateScreenHeight(10),
                        ),
                        child: TextField(
                          controller: textController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              size: 30,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.cancel_rounded,
                                  color: Palette.Outline),
                              onPressed: () {
                                textController.clear();
                                searchViewModel.isSearchMode();
                              },
                            ),
                            hintText: '???????????????????????????????????????????????????',
                          ),
                          onChanged: (value) {
                            if (value == "") {
                              searchViewModel.isSearchMode();
                            } else {
                              searchViewModel.isQueryMode();
                              searchViewModel.query(allLocationList, value);
                            }
                          },
                        ),
                      ),
                      Visibility(
                        visible: !searchViewModel.isQuery,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          child: TabBar(
                            labelColor: Palette.BodyText,
                            labelStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sukhumvit',
                            ),
                            unselectedLabelStyle: TextStyle(
                              fontSize: 16,
                              color: Palette.AdditionText,
                              fontFamily: 'Sukhumvit',
                            ),
                            tabs: searchViewModel.tabs
                                .map(
                                  (item) => Tab(
                                    text: item['label'],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !searchViewModel.isQuery,
                        child: Expanded(
                          child: TabBarView(
                            children: <Widget>[
                              buildTabBarView(context, searchViewModel, 0),
                              buildTabBarView(context, searchViewModel, 1),
                              buildTabBarView(context, searchViewModel, 2),
                              buildTabBarView(context, searchViewModel, 3),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: searchViewModel.isQuery,
                        child: Expanded(
                          child: searchViewModel.queryResult.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom:
                                              getProportionateScreenHeight(10)),
                                      child: Text(
                                        '????????????????????????????????????\n???????????????????????????????????????????????????????????????????????????',
                                        style: FontAssets.bodyText,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      label: Text(
                                        '????????????????????????????????????',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: Palette.SecondaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          getProportionateScreenHeight(10)),
                                  itemCount: searchViewModel.queryResult.length,
                                  itemBuilder: (context, index) =>
                                      buildSearchResultCard(
                                          context,
                                          searchViewModel,
                                          searchViewModel.queryResult[index]),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
      onWillPop: () async {
        searchViewModel.goBack(context);
        return false;
      },
    );
  }
}

Widget buildTabBarView(
    BuildContext context, SearchViewModel searchViewModel, int tabIndex) {
  return SingleChildScrollView(
    padding: EdgeInsets.only(bottom: getProportionateScreenHeight(10)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(15),
            vertical: getProportionateScreenHeight(10),
          ),
          child: CoolDropdown(
            dropdownList: searchViewModel.dropdownItemList,
            defaultValue: searchViewModel.dropdownItemList[0],
            dropdownHeight: 120,
            dropdownItemGap: 0,
            dropdownWidth: getProportionateScreenWidth(150),
            resultWidth: getProportionateScreenWidth(170),
            triangleHeight: 0,
            gap: getProportionateScreenHeight(5),
            resultTS: TextStyle(
              color: Palette.AdditionText,
              fontSize: 14,
              fontFamily: 'Sukhumvit',
            ),
            selectedItemTS: TextStyle(
              color: Palette.PrimaryColor,
              fontSize: 14,
              fontFamily: 'Sukhumvit',
            ),
            unselectedItemTS: TextStyle(
              color: Palette.BodyText,
              fontSize: 14,
              fontFamily: 'Sukhumvit',
            ),
            onChange: (selectedItem) {
              searchViewModel.getSearchResultBy(
                  searchViewModel.tabs[tabIndex]['value'],
                  selectedItem['value']);
            },
          ),
        ),
        searchViewModel.searchResultCard.isEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) => ShimmerTripCard())
            : ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: searchViewModel.searchResultCard
                    .map(
                      (item) =>
                          buildSearchResultCard(context, searchViewModel, item),
                    )
                    .toList(),
              )
      ],
    ),
  );
}

Widget buildSearchResultCard(BuildContext context,
    SearchViewModel searchViewModel, SearchResultResponse item) {
  return InkWell(
    onTap: () => searchViewModel.goToLocationDetail(context, item.locationId),
    child: Container(
      height: getProportionateScreenHeight(110),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: getProportionateScreenWidth(15),
            ),
            child: Center(
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    width: getProportionateScreenHeight(100),
                    height: getProportionateScreenHeight(100),
                    fit: BoxFit.cover,
                    image: NetworkImage(item.imageUrl),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(
                getProportionateScreenWidth(10),
                getProportionateScreenHeight(5),
                getProportionateScreenWidth(15),
                getProportionateScreenHeight(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.locationName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FontAssets.subtitleText,
                  ),
                  searchViewModel.sortedBy == "rating"
                      ? Row(
                          children: [
                            Text(
                              '${item.rating} ',
                              style: FontAssets.hintText,
                            ),
                            RatingBarIndicator(
                              unratedColor: Palette.Outline,
                              rating: item.rating,
                              itemBuilder: (context, index) => Icon(
                                Icons.star_rounded,
                                color: Palette.CautionColor,
                              ),
                              itemCount: 5,
                              itemSize: 16,
                            ),
                          ],
                        )
                      : Text(
                          '????????????????????????????????? ${item.totalCheckin} ???????????????',
                          style: TextStyle(
                              fontSize: 14, color: Palette.PrimaryColor),
                        ),
                  Text(
                    item.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: FontAssets.bodyText,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TagCategory(
                          category: item.category == 1
                              ? "???????????????????????????"
                              : item.category == 2
                                  ? "??????????????????"
                                  : "??????????????????",
                        ),
                        // ElevatedButton.icon(
                        //   onPressed: () {},
                        //   icon: Icon(
                        //     Icons.add,
                        //     color: Colors.white,
                        //     size: 20,
                        //   ),
                        //   label: Text(
                        //     '??????????????????????????????????????????',
                        //     style: TextStyle(
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 14,
                        //     ),
                        //   ),
                        //   style: ElevatedButton.styleFrom(
                        //       primary: Palette.PrimaryColor,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(5),
                        //       ),
                        //       elevation: 0),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
