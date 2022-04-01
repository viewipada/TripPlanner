import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/response/baggage_response.dart';
import 'package:trip_planner/src/view/widgets/loading.dart';
import 'package:trip_planner/src/view/widgets/tag_category.dart';
import 'package:trip_planner/src/view_models/baggage_view_model.dart';

class BaggagePage extends StatefulWidget {
  @override
  _BaggagePageState createState() => _BaggagePageState();
}

class _BaggagePageState extends State<BaggagePage> {
  final SlidableController slidableController = SlidableController();
  List<BaggageResponse>? baggageList;

  @override
  void initState() {
    // Future.delayed(Duration(seconds: 1));
    Provider.of<BaggageViewModel>(context, listen: false)
        .getBaggageList()
        .then((value) {
      setState(() {
        baggageList =
            Provider.of<BaggageViewModel>(context, listen: false).baggageList;
      });
    });
    super.initState();
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
            child: baggageList == null
                ? Loading()
                : baggageViewModel.baggageList.isEmpty
                    ? Center(
                        child: Text(
                          'ไม่มีรายการในกระเป๋าเดินทาง',
                          style: FontAssets.bodyText,
                        ),
                      )
                    : Stack(
                        children: [
                          ListView(
                            padding: EdgeInsets.fromLTRB(
                              0,
                              getProportionateScreenHeight(10),
                              0,
                              getProportionateScreenHeight(70),
                            ),
                            children: baggageViewModel.baggageList.map((item) {
                              return Slidable.builder(
                                key: UniqueKey(),
                                controller: slidableController,
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                enabled: baggageViewModel.selectedList
                                            .contains(item) ||
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
                                secondaryActionDelegate:
                                    SlideActionBuilderDelegate(
                                  actionCount: 1,
                                  builder: (context, index, animation,
                                      renderingMode) {
                                    return IconSlideAction(
                                      caption: 'ลบรายการ',
                                      color: Palette.DeleteColor,
                                      icon: Icons.delete,
                                      onTap: () => {
                                        if (slidableController.activeState !=
                                            null)
                                          Slidable.of(context)?.dismiss(
                                              actionType:
                                                  SlideActionType.secondary)
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
                                          baggageViewModel.selectedList
                                              .contains(item),
                                          item,
                                        ),
                                        baggageViewModel.changeMode(
                                            baggageViewModel.selectMode)
                                      }
                                  },
                                  onTap: () => {
                                    baggageViewModel.selectMode
                                        ? baggageViewModel.toggleSelection(
                                            baggageViewModel.selectedList
                                                .contains(item),
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
                                            left:
                                                getProportionateScreenWidth(15),
                                          ),
                                          child: Stack(
                                            children: [
                                              Center(
                                                child: Container(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image(
                                                      width:
                                                          getProportionateScreenHeight(
                                                              100),
                                                      height:
                                                          getProportionateScreenHeight(
                                                              100),
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          item.imageUrl),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: baggageViewModel
                                                    .selectedList
                                                    .contains(item),
                                                child: Center(
                                                  child: Container(
                                                    width:
                                                        getProportionateScreenHeight(
                                                            100),
                                                    height:
                                                        getProportionateScreenHeight(
                                                            100),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 0.4),
                                                    ),
                                                    child: Container(
                                                      width: 24,
                                                      height: 24,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Palette
                                                            .PrimaryColor,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          (baggageViewModel
                                                                      .selectedList
                                                                      .indexOf(
                                                                          item) +
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    item.locationName,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        FontAssets.subtitleText,
                                                  ),
                                                  Text(
                                                    item.description,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                              bottom: getProportionateScreenHeight(15),
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
