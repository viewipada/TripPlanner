import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/src/view/screens/baggage_page.dart';
import 'package:trip_planner/src/view/widgets/location_card.dart';
import 'package:trip_planner/src/view/widgets/trip_card.dart';
import 'package:trip_planner/src/view_models/home_view_model.dart';

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
  void initState() {
    Provider.of<HomeViewModel>(context, listen: false).getHotLocationList();
    Provider.of<HomeViewModel>(context, listen: false)
        .getLocationRecommendedList();
    Provider.of<HomeViewModel>(context, listen: false).getTripRecommendedList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

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
                LocationCard(
                  header: " สถานที่ยอดฮิต",
                  locationList: homeViewModel.hotLocationList,
                ),
                Divider(),
                LocationCard(
                  header: " แนะนำสำหรับคุณ",
                  locationList: homeViewModel.locationRecommendedList,
                ),
                Divider(),
                TripCard(
                    header: " ทริปที่คุณอาจถูกใจ",
                    tripList: homeViewModel.tripRecommendedList),
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
