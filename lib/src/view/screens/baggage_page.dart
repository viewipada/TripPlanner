import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/src/view_models/baggage_view_model.dart';

class BaggagePage extends StatefulWidget {
  @override
  _BaggagePageState createState() => _BaggagePageState();
}

class _BaggagePageState extends State<BaggagePage> {
  @override
  void initState() {
    Provider.of<BaggageViewModel>(context, listen: false).getBaggageList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final baggageViewModel = Provider.of<BaggageViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Row(
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
              'เลือกทั้งหมด',
              style: TextStyle(
                fontSize: 12,
                color: Palette.AdditionText,
              ),
            ),
          ],
        ),
        leadingWidth: 150,
        title: Text(
          "กระเป๋าเดินทาง",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 60),
              children: baggageViewModel.baggageList.map((item) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: baggageViewModel.selectedList.contains(item)
                      ? DismissDirection.none
                      : DismissDirection.endToStart,
                  onDismissed: (_) {
                    setState(() {
                      baggageViewModel.baggageList.remove(item);
                    });
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  child: InkWell(
                    onTap: () => {
                      baggageViewModel.toggleSelection(
                        baggageViewModel.selectedList.contains(item),
                        item,
                      ),
                    },
                    child: Container(
                      height: 110,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Stack(
                              children: [
                                Center(
                                  child: Container(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
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
                                        borderRadius: BorderRadius.circular(10),
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
                              padding: EdgeInsets.fromLTRB(10, 5, 15, 5),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 5,
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
                                    Text(
                                      item.description,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Palette.BodyText,
                                      ),
                                    ),
                                    Spacer(
                                      flex: 2,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Palette.TagGrey,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                                      child: Text(
                                        item.category,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
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
            Positioned(
              height: 48,
              bottom: 5,
              left: 15,
              right: 15,
              child: ElevatedButton(
                onPressed: () {
                  baggageViewModel.selectedList
                      .forEach((element) => print(element.locationName));
                  print("-------------------- " +
                      baggageViewModel.selectedList.length.toString() +
                      " --------------------");
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
            )
          ],
        ),
      ),
    );
  }
}
