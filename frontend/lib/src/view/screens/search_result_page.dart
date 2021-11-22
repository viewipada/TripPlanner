import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view/widgets/baggage_cart.dart';
import 'package:trip_planner/src/view_models/search_view_model.dart';

class SearchResultPage extends StatefulWidget {
  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  List dropdownItemList = [
    {'label': 'เรียงตามคะแนน', 'value': 'เรียงตามคะแนน'},
    {'label': 'เรียงตามระยะทาง', 'value': 'เรียงตามระยะทาง'},
    {'label': 'เรียงตามยอดเช็คอิน', 'value': 'เรียงตามยอดเช็คอิน'},
  ];
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
                crossAxisAlignment: CrossAxisAlignment.end,
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
                    margin: EdgeInsets.only(
                        bottom: getProportionateScreenHeight(10)),
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(15)),
                    child: CoolDropdown(
                      dropdownList: dropdownItemList,
                      defaultValue: dropdownItemList[0],
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
                  Expanded(
                    child: TabBarView(
                      children: <Widget>[
                        Center(
                          child: Text("It's cloudy here"),
                        ),
                        Center(
                          child: Text("It's rainy here"),
                        ),
                        Center(
                          child: Text("It's sunny here"),
                        ),
                        Center(
                          child: Text("It's sunny here"),
                        ),
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
