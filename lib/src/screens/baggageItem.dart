import 'package:flutter/material.dart';
import 'package:trip_planner/src/models/place.dart';

class BaggageItem extends StatelessWidget {
  final Place place;
  final bool isSelected;
  final ValueChanged<Place> onSelectedItem;

  const BaggageItem({
    Key? key,
    required this.place,
    required this.isSelected,
    required this.onSelectedItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(place.id);
      },
      child: Container(
        height: 110,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    alignment: Alignment.topLeft,
                    image: NetworkImage(place.imageUrl),
                  ),
                ),
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
                        place.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        place.description,
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
