import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/response/baggage_response.dart';
import 'package:trip_planner/src/view/widgets/tag_category.dart';
import 'package:trip_planner/src/view_models/baggage_view_model.dart';

class BaggagePage extends StatefulWidget {
  @override
  _BaggagePageState createState() => _BaggagePageState();
}

class _BaggagePageState extends State<BaggagePage> {
  final SlidableController slidableController = SlidableController();

  @override
  void initState() {
    Provider.of<BaggageViewModel>(context, listen: false).getBaggageList();
    saveUserInfo();
    getUserInfo();
    saveLocationsInTrip();
    super.initState();
  }

  Future<void> saveUserInfo() async {
    final BaggageResponse user = BaggageResponse.fromJson({
      "locationId": 1,
      "locationName": "วัดม่วง",
      "imageUrl":
          "https://cms.dmpcdn.com/travel/2020/05/26/fafac540-9f50-11ea-81a6-432b2bbc8436_original.jpg",
      "category": "ที่ไหว้",
      "description":
          "เป็นวัดโบราณ โดยสันนิษฐานว่าสร้างในสมัยกรุงศรีอยุธยาตอนปลาย ปี พ.ศ.2230 ที่นี่เป็น วัดสวยในจังหวัดอ่างทอง ที่เราจะได้เห็นพระพุทธรูปองค์ใหญ่ สีทองอร่ามสวยงามได้จากระยะไกลๆ เลย ซึงก็คือ หลวงพ่อใหญ่ หรือ พระพุทธมหานวมินทร์ศากยมุนีศรีวิเศษชัยชาญ พระพุทธรูปองค์ใหญ่ที่สุดในโลก ที่มีขนาดหน้าตักกว้าง 62 เมตร และสูงถึง 93 เมตร เลยทีเดียวค่ะ และใช้เวลาก่อสร้างนานถึง 16 ปี"
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String rawJson = jsonEncode(user);
    // print(rawJson);
    prefs.setString('user', rawJson);
  }

  Future<BaggageResponse> getUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> userMap;
    final String userStr = prefs.getString('user') ?? '';
    userMap = jsonDecode(userStr) as Map<String, dynamic>;
    final BaggageResponse user = BaggageResponse.fromJson(userMap);
    print(user.locationId);
    return user;
  }

  Future<void> saveLocationsInTrip() async {
    List<String> rawSelectedList = [];
    List<BaggageResponse> selectedList = [
      BaggageResponse.fromJson({
        "locationId": 1,
        "locationName": "วัดม่วง",
        "imageUrl":
            "https://cms.dmpcdn.com/travel/2020/05/26/fafac540-9f50-11ea-81a6-432b2bbc8436_original.jpg",
        "category": "ที่ไหว้",
        "description":
            "เป็นวัดโบราณ โดยสันนิษฐานว่าสร้างในสมัยกรุงศรีอยุธยาตอนปลาย ปี พ.ศ.2230 ที่นี่เป็น วัดสวยในจังหวัดอ่างทอง ที่เราจะได้เห็นพระพุทธรูปองค์ใหญ่ สีทองอร่ามสวยงามได้จากระยะไกลๆ เลย ซึงก็คือ หลวงพ่อใหญ่ หรือ พระพุทธมหานวมินทร์ศากยมุนีศรีวิเศษชัยชาญ พระพุทธรูปองค์ใหญ่ที่สุดในโลก ที่มีขนาดหน้าตักกว้าง 62 เมตร และสูงถึง 93 เมตร เลยทีเดียวค่ะ และใช้เวลาก่อสร้างนานถึง 16 ปี"
      }),
      BaggageResponse.fromJson({
        "locationId": 2,
        "locationName": "บ้านหุ่นเหล็ก",
        "imageUrl":
            "https://storage.googleapis.com/swapgap-bucket/post/5190314163699712-babbd605-e3ed-407f-bdc8-dba57e81c76e",
        "category": "ที่เที่ยว",
        "description":
            " ใครที่มาเที่ยวอ่างทอง ต้องไม่พลาดมาแวะที่นี่! บ้านหุ่นเหล็ก ค่ะ โดยที่นี่เป็นการนำอะไหล่รถยนต์เก่า เครื่องยนต์เก่าต่างๆ มารวบรวม และนำมาประดิษฐ์ใหม่เป็นหุ่นเหล็กและอื่นๆ ที่อลังการสุดๆ เหมือนเป็นพิพิธภัณฑ์ขนาดย่อมๆ เลยทีเดียวค่ะ"
      }),
      BaggageResponse.fromJson({
        "locationId": 3,
        "locationName": "วัดขุนอินทประมูล",
        "imageUrl":
            "https://tiewpakklang.com/wp-content/uploads/2018/09/33716.jpg",
        "category": "ที่ไหว้",
        "description":
            "เป็นวัดเก่าแก่อีกแห่งในอ่างทองที่สวยงามมากๆ สันนิษฐานว่าสร้างขึ้นในสมัยสุโขทัย และเป็นที่ประดิษฐาน พระพุทธไสยาสน์ ที่ใหญ่เป็นอันดับ 2 ในประเทศไทย ที่มีชื่อว่า พระศรีเมือง ซึ่งมีความยาวถึง 50 เมตร รองจาก พระนอน วัดบางพลีใหญ่กลาง ที่จังหวัดสมุทรปราการค่ะ"
      }),
      BaggageResponse.fromJson({
        "locationId": 4,
        "locationName": "ทะเลอ่างทอง",
        "imageUrl":
            "https://cf.bstatic.com/xdata/images/hotel/max1024x768/223087771.jpg?k=ef100bbbc40124f71134caaad8504c038caf28f281cf01b419ac191630ce1e01&o=&hp=1",
        "category": "ที่เที่ยว",
        "description":
            "กุ้ง หอย ปู ปลา หาได้ที่ทะเลอ่างทอง มีหมูริมหาด และกิจกรรมพายเรือคายัค"
      }),
    ];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedList.forEach((e) => rawSelectedList.add(jsonEncode(e)));
    prefs.setStringList('locationsInTrip', rawSelectedList);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final baggageViewModel = Provider.of<BaggageViewModel>(context);

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            leading: Visibility(
              visible: baggageViewModel.selectMode,
              child: Row(
                children: [
                  Checkbox(
                    activeColor: Palette.PrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    value: baggageViewModel.checkboxValue,
                    onChanged: (value) {
                      baggageViewModel.setCheckboxValue(
                        baggageViewModel.checkboxValue,
                      );
                    },
                  ),
                  Text(
                    'ทั้งหมด',
                    style: FontAssets.bodyText,
                  ),
                ],
              ),
            ),
            leadingWidth: getProportionateScreenWidth(150),
            title: Text(
              "กระเป๋าเดินทาง",
              style: FontAssets.headingText,
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            actions: [
              TextButton(
                onPressed: () {
                  baggageViewModel.selectMode
                      ? baggageViewModel.changeMode(baggageViewModel.selectMode)
                      : baggageViewModel.clearWidget(context);
                },
                child: baggageViewModel.selectMode
                    ? Text("เสร็จสิ้น")
                    : Text("ยกเลิก"),
              ),
            ],
          ),
          body: SafeArea(
            child: Stack(
              children: [
                ListView(
                  padding: EdgeInsets.fromLTRB(
                    0,
                    getProportionateScreenHeight(10),
                    0,
                    getProportionateScreenHeight(60),
                  ),
                  children: baggageViewModel.baggageList.map((item) {
                    return Slidable.builder(
                      key: Key(item.locationName),
                      controller: slidableController,
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      enabled: baggageViewModel.selectedList.contains(item) ||
                              baggageViewModel.selectMode
                          ? false
                          : true,
                      movementDuration: Duration(milliseconds: 500),
                      dismissal: SlidableDismissal(
                        child: SlidableDrawerDismissal(),
                        closeOnCanceled: true,
                        onDismissed: (_) {
                          baggageViewModel.deleteItem(item);
                        },
                      ),
                      secondaryActionDelegate: SlideActionBuilderDelegate(
                        actionCount: 1,
                        builder: (context, index, animation, renderingMode) {
                          return IconSlideAction(
                            caption: 'ลบรายการ',
                            color: Palette.DeleteColor,
                            icon: Icons.delete,
                            onTap: () => {
                              if (slidableController.activeState != null)
                                Slidable.of(context)?.dismiss(
                                    actionType: SlideActionType.secondary)
                              else
                                Slidable.of(context)?.close()
                            },
                          );
                        },
                      ),
                      child: InkWell(
                        onLongPress: () => {
                          if (!baggageViewModel.selectMode)
                            {
                              baggageViewModel.toggleSelection(
                                baggageViewModel.selectedList.contains(item),
                                item,
                              ),
                              baggageViewModel
                                  .changeMode(baggageViewModel.selectMode)
                            }
                        },
                        onTap: () => {
                          baggageViewModel.selectMode
                              ? baggageViewModel.toggleSelection(
                                  baggageViewModel.selectedList.contains(item),
                                  item,
                                )
                              : baggageViewModel.goToLocationDetail(
                                  context, item.locationId)
                        },
                        child: Container(
                          height: getProportionateScreenHeight(110),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: getProportionateScreenWidth(15),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Container(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image(
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            image: NetworkImage(item.imageUrl),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: baggageViewModel.selectedList
                                          .contains(item),
                                      child: Center(
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Color.fromRGBO(0, 0, 0, 0.4),
                                          ),
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Palette.PrimaryColor,
                                            ),
                                            child: Center(
                                              child: Text(
                                                (baggageViewModel.selectedList
                                                            .indexOf(item) +
                                                        1)
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    getProportionateScreenWidth(10),
                                    getProportionateScreenHeight(5),
                                    getProportionateScreenWidth(15),
                                    getProportionateScreenHeight(5),
                                  ),
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item.locationName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: FontAssets.subtitleText,
                                        ),
                                        Text(
                                          item.description,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: FontAssets.bodyText,
                                        ),
                                        Spacer(
                                          flex: 2,
                                        ),
                                        TagCategory(
                                          category: item.category,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                Visibility(
                  visible: !baggageViewModel.selectMode,
                  child: Positioned(
                    height: getProportionateScreenHeight(48),
                    bottom: getProportionateScreenHeight(5),
                    left: getProportionateScreenWidth(15),
                    right: getProportionateScreenWidth(15),
                    child: ElevatedButton(
                      onPressed: () {
                        baggageViewModel.goToCreateTripForm(
                            context, baggageViewModel.selectedList);
                      },
                      child: Text(
                        'เริ่มสร้างทริป',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Palette.PrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          baggageViewModel.clearWidget(context);
          return true;
        });
  }
}
