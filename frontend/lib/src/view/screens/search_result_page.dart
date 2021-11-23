import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view/widgets/baggage_cart.dart';
import 'package:trip_planner/src/view/widgets/tag_category.dart';
import 'package:trip_planner/src/view_models/search_view_model.dart';

class SearchResultPage extends StatefulWidget {
  SearchResultPage({
    required this.category,
    required this.filtered,
  });

  final String category;
  final String filtered;

  _SearchResultPageState createState() =>
      _SearchResultPageState(this.category, this.filtered);
}

class _SearchResultPageState extends State<SearchResultPage> {
  final String category;
  final String filtered;
  _SearchResultPageState(this.category, this.filtered);

  @override
  void initState() {
    Provider.of<SearchViewModel>(context, listen: false)
        .getSearchResultBy('all', 'rating');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final searchViewModel = Provider.of<SearchViewModel>(context);

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: DefaultTabController(
        initialIndex: 0,
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              color: Palette.BackIconColor,
              onPressed: () {
                searchViewModel.goBack(context);
              },
            ),
            title: Text(
              "ค้นหา",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
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
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          size: 30,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.cancel_rounded,
                              color: Palette.Outline),
                          onPressed: () {
                            /* Clear the search field */
                          },
                        ),
                        hintText: 'ค้นหาที่เที่ยวเลย',
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: Palette.AdditionText,
                      ),
                    ),
                  ),
                  Container(
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
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sukhumvit',
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontSize: 14,
                        color: Palette.AdditionText,
                        fontFamily: 'Sukhumvit',
                      ),
                      tabs: <Widget>[
                        Tab(
                          text: 'ทั้งหมด',
                        ),
                        Tab(
                          text: 'ที่เที่ยว',
                        ),
                        Tab(
                          text: 'ที่กิน',
                        ),
                        Tab(
                          text: 'ที่พัก',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        buildTabBarView(searchViewModel),
                        buildTabBarView(searchViewModel),
                        buildTabBarView(searchViewModel),
                        buildTabBarView(searchViewModel),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildTabBarView(SearchViewModel searchViewModel) {
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
            dropdownHeight: 170,
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
              print(selectedItem);
            },
          ),
        ),
        ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: searchViewModel.searchResultCard
              .map(
                (item) => InkWell(
                  onTap: () {},
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
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: getProportionateScreenHeight(5),
                                  ),
                                  child: Text(
                                    item.locationName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: getProportionateScreenHeight(5),
                                  ),
                                  child: Text(
                                    item.description,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Palette.BodyText,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      TagCategory(
                                        category: item.category,
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        label: Text(
                                          'เพิ่มลงกระเป๋า',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            primary: Palette.PrimaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            elevation: 0),
                                      ),
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
                ),
              )
              .toList(),
        )
      ],
    ),
  );
}
