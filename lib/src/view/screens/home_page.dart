import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/src/view/screens/baggage_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  PageController pageController = PageController();

  void _onIconTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
          child: Image.asset(
            ImageAssets.logo,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        title: Text(
          "เริ่มต้นความสนุกกับ EZtrip",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 15, 5),
            child: CircleAvatar(
              backgroundColor: Palette.SecondaryColor,
              radius: 20,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.shopping_bag_outlined),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BaggagePage()),
                  );
                },
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Image.asset(
                    ImageAssets.homeBanner,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                //สถานที่ยอดฮิต
                Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              child: Text(
                                " สถานที่ยอดฮิต",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                "ดูเพิ่มเติม >> ",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.centerLeft,
                        height: 140,
                        child: ListView(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Column(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: Image.network(
                                    'https://cf.bstatic.com/xdata/images/hotel/max1024x768/223087771.jpg?k=ef100bbbc40124f71134caaad8504c038caf28f281cf01b419ac191630ce1e01&o=&hp=1',
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                ),
                                Container(
                                  width: 100,
                                  child: Text(
                                    'ทะเลอ่างทองทองทองอทอง',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Palette.DarkGrey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                //สถานที่แนะนำ
                Container(
                  // color: Colors.pink,
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              child: Text(
                                " แนะนำสำหรับคุณ",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                "ดูเพิ่มเติม >> ",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        alignment: Alignment.centerLeft,
                        height: 140,
                        child: ListView(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Column(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: Image.network(
                                    'https://cf.bstatic.com/xdata/images/hotel/max1024x768/223087771.jpg?k=ef100bbbc40124f71134caaad8504c038caf28f281cf01b419ac191630ce1e01&o=&hp=1',
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                ),
                                Container(
                                  width: 100,
                                  child: Text(
                                    'ทะเลอ่างทองทองทองอทอง',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Palette.DarkGrey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                //ทริปที่คุณอาจถูกใจ
                Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              child: Text(
                                " ทริปที่คุณอาจถูกใจ",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                "ดูเพิ่มเติม >> ",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 110,
                        child: Row(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(bottom: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.amber,
          ),
          Container(
            color: Colors.green,
          ),
          Container(
            color: Colors.red,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? Icon(Icons.home_rounded)
                : Icon(Icons.home_outlined),
            label: 'หน้าแรก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'สำรวจ',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? Icon(Icons.backpack_rounded)
                : Icon(Icons.backpack_outlined),
            label: 'จัดทริปเที่ยว',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 3
                ? Icon(Icons.person_rounded)
                : Icon(Icons.person_outline_rounded),
            label: 'ข้อมูลผู้ใช้',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Palette.SecondaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onIconTapped,
      ),
    );
  }
}
