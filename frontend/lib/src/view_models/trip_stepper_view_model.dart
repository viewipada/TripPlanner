import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TripStepperViewModel with ChangeNotifier {
  int _index = 0;
  List _steps = [
    {
      'icon': Icons.directions_car_outlined,
      'iconActived': Icons.directions_car_rounded,
      'title': 'พาหนะ'
    },
    {
      'icon': Icons.camera_alt_outlined,
      'iconActived': Icons.camera_alt_rounded,
      'title': 'ที่เที่ยว'
    },
    {
      'icon': Icons.fastfood_outlined,
      'iconActived': Icons.fastfood_rounded,
      'title': 'ที่กิน'
    },
    {
      'icon': Icons.hotel_outlined,
      'iconActived': Icons.hotel_rounded,
      'title': 'ที่พัก'
    },
    {
      'icon': Icons.shopping_bag_outlined,
      'iconActived': Icons.shopping_bag_rounded,
      'title': 'ที่ช้อป'
    },
  ];

  List _vehicles = [
    {
      'icon': Icons.directions_car_outlined,
      'isSelected': true,
      'title': 'รถยนต์ส่วนตัว'
    },
    {
      'icon': Icons.directions_bike_outlined,
      'isSelected': false,
      'title': 'จักรยาน'
    },
    {
      'icon': Icons.directions_bus_filled_outlined,
      'isSelected': false,
      'title': 'ขนส่งสาธารณะ'
    },
    {
      'icon': Icons.directions_walk_outlined,
      'isSelected': false,
      'title': 'เดินเท้า'
    },
  ];
  List _items = [
    {
      "locationId": 1,
      "locationName": "วัดม่วง",
      "imageUrl":
          "https://cms.dmpcdn.com/travel/2020/05/26/fafac540-9f50-11ea-81a6-432b2bbc8436_original.jpg",
      "startTime": "7.00",
      "distance": "จุดเริ่มต้น",
      "duration": "1 hr",
      "drivingDuration": null,
    },
    {
      "locationId": 2,
      "locationName": "บ้านหุ่นเหล็ก",
      "imageUrl":
          "https://storage.googleapis.com/swapgap-bucket/post/5190314163699712-babbd605-e3ed-407f-bdc8-dba57e81c76e",
      "startTime": "7.00",
      "distance": "5 km",
      "duration": "1 hr",
      "drivingDuration": 10,
    },
    {
      "locationId": 3,
      "locationName": "วัดขุนอินทประมูล",
      "imageUrl":
          "https://tiewpakklang.com/wp-content/uploads/2018/09/33716.jpg",
      "startTime": "7.00",
      "distance": "5 km",
      "duration": "1 hr",
      "drivingDuration": 10,
    },
    {
      "locationId": 4,
      "locationName": "ทะเลอ่างทอง",
      "imageUrl":
          "https://cf.bstatic.com/xdata/images/hotel/max1024x768/223087771.jpg?k=ef100bbbc40124f71134caaad8504c038caf28f281cf01b419ac191630ce1e01&o=&hp=1",
      "startTime": "7.00",
      "distance": "5 km",
      "duration": "1 hr",
      "drivingDuration": 10,
    },
    {
      "locationId": 5,
      "locationName": "พระตำหนักคำหยาด",
      "imageUrl":
          "https://woodychannel.com/wp-content/uploads/2015/09/kam-yard-750x500.jpg",
      "startTime": "7.00",
      "distance": "5 km",
      "duration": "1 hr",
      "drivingDuration": 10,
    },
    {
      "locationId": 6,
      "locationName": "ตลาดศาลเจ้าโรงทอง",
      "imageUrl": "https://i.ytimg.com/vi/lZSah_8XQB8/maxresdefault.jpg",
      "startTime": "7.00",
      "distance": "5 km",
      "duration": "1 hr",
      "drivingDuration": 10,
    },
    {
      "locationId": 7,
      "locationName": "ศูนย์ตุ๊กตาชาววังบ้านบางเสด็จ",
      "imageUrl":
          "https://www.m-culture.go.th/angthong/images/article/news464/n20170324142021_1734.jpg",
      "startTime": "7.00",
      "distance": "5 km",
      "duration": "1 hr",
      "drivingDuration": 10,
    },
    {
      "locationId ": 8,
      "locationName": "วัดท่าสุทธาวาส",
      "imageUrl":
          "https://tatapi.tourismthailand.org/tatfs/Image/CustomPOI/Picture/P03013541_1.jpeg",
      "startTime": "7.00",
      "distance": "5 km",
      "duration": "1 hr",
      "drivingDuration": 10,
    },
    {
      "locationId": 9,
      "locationName": "วัดป่าโมกวรวิหาร",
      "imageUrl":
          "https://www.paiduaykan.com/province/central/angthong/pic/watpampke.jpg",
      "startTime": "7.00",
      "distance": "5 km",
      "duration": "1 hr",
      "drivingDuration": 10,
    },
    {
      "locationId": 10,
      "locationName": "หมู่บ้านทำกลองเอกราช",
      "imageUrl":
          "https://www.museumsiam.org/upload/MUSEUM_211/2016_01/1451733871_734.jpg",
      "startTime": "7.00",
      "distance": "5 km",
      "duration": "1 hr",
      "drivingDuration": 10,
    }
  ];

  IconData _vehiclesSelected = Icons.directions_car_outlined;

  void go(int index) {
    if (index == -1 && _index <= 0) {
      print("it's first Step!");
      return;
    }

    if (index == 1 && _index >= _steps.length - 1) {
      print("it's last Step!");
      return;
    }

    _index += index;
    notifyListeners();
  }

  void setStepOnTapped(int index) {
    _index = index;
    notifyListeners();
  }

  void selectedVehicle(vehicle) {
    vehicles.forEach((element) {
      element['isSelected'] = false;
    });
    vehicle['isSelected'] = true;
    _vehiclesSelected = vehicle['icon'];
    notifyListeners();
  }

  void onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = _items.removeAt(oldIndex);
    _items.insert(newIndex, item);
    notifyListeners();
  }

  List get steps => _steps;
  int get index => _index;
  List get vehicles => _vehicles;
  List get items => _items;
  IconData get vehiclesSelected => _vehiclesSelected;
}
