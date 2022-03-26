import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/src/view/screens/home_page.dart';
import 'package:trip_planner/src/view/screens/profile_page.dart';
import 'package:trip_planner/src/view/screens/search_page.dart';
import 'package:trip_planner/src/view_models/navigation_bar_view_model.dart';

class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  void initState() {
    super.initState();
    Provider.of<NavigationBarViewModel>(context, listen: false)
        .initSelectedIndex();
  }

  @override
  Widget build(BuildContext context) {
    final navigationBarViewModel = Provider.of<NavigationBarViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return PageView(
              controller: navigationBarViewModel.pageController,
              onPageChanged: (index) {
                navigationBarViewModel.onSlidePageView(index);
              },
              children: [
                HomePage(),
                SearchPage(),
                // Container(),
                ProfilePage(),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black54,
                  blurRadius: 10,
                  offset: Offset(0.0, 0.75))
            ],
          ),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: navigationBarViewModel.selectedIndex == 0
                    ? Icon(Icons.home_rounded)
                    : Icon(Icons.home_outlined),
                label: 'หน้าแรก',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'สำรวจ',
              ),
              // BottomNavigationBarItem(
              //   icon: navigationBarViewModel.selectedIndex == 2
              //       ? Icon(Icons.backpack_rounded)
              //       : Icon(Icons.backpack_outlined),
              //   label: 'จัดทริปเที่ยว',
              // ),
              BottomNavigationBarItem(
                icon: navigationBarViewModel.selectedIndex == 2
                    ? Icon(Icons.person_rounded)
                    : Icon(Icons.person_outline_rounded),
                label: 'ข้อมูลผู้ใช้',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Palette.SecondaryColor,
            unselectedItemColor: Colors.grey,
            currentIndex: navigationBarViewModel.selectedIndex,
            onTap: navigationBarViewModel.onIconTapped,
          ),
        ),
      ),
    );
  }
}
