import 'package:flutter/material.dart';
import 'package:trip_planner/palette.dart';

class TripCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 110,
      child: Row(
        children: [
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Image.network(
              'https://cf.bstatic.com/xdata/images/hotel/max1024x768/223087771.jpg?k=ef100bbbc40124f71134caaad8504c038caf28f281cf01b419ac191630ce1e01&o=&hp=1',
              fit: BoxFit.cover,
              height: 100,
              width: 100,
            ),
            clipBehavior: Clip.antiAlias,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'อ่างทองไม่เหงา มีเรา 3 4 5 คน',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Palette.DarkGrey,
                            ),
                          ),
                          Icon(
                            Icons.note_alt_outlined,
                            color: Palette.DarkGrey,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'จาก ไหน ไปยัง ไหน',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '15 ที่เที่ยว',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '3 วัน 2 คืน',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
