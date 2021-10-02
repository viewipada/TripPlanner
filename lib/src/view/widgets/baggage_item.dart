import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/src/models/place.dart';
import 'package:trip_planner/src/notifiers/baggage_notifier.dart';
import 'package:trip_planner/src/view_models/baggage_item.vm.dart';

class BaggageItem extends StatefulWidget {
  final Place place;
  final bool isSelected;
  // final onSelectedItem

  BaggageItem({
    required this.place,
    required this.isSelected,
  });

  @override
  _BaggageItemState createState() =>
      _BaggageItemState(this.place, this.isSelected);
}

class _BaggageItemState extends State<BaggageItem> {
  // bool isSelected = false;
  BaggageItemVM baggageItemVM = new BaggageItemVM();

  _BaggageItemState(Place place, bool isSelected) {
    baggageItemVM.setItem(place, isSelected);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BaggageNotifire>(context);
    return InkWell(
      onTap: () => provider.toggleSelection(baggageItemVM),
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
                          image: NetworkImage(baggageItemVM.place.imageUrl),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: baggageItemVM.isSelected,
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
                              baggageItemVM.place.id.toString(),
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
                padding: EdgeInsets.fromLTRB(10, 10, 15, 5),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        baggageItemVM.place.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        baggageItemVM.place.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Spacer(
                        flex: 2,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                        child: Text(
                          "ที่เที่ยว",
                          style: TextStyle(
                            color: Colors.grey,
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
    );
  }
}
