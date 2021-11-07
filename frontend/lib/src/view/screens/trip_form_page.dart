import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/models/response/baggage_response.dart';
import 'package:trip_planner/src/view/widgets/start_point_card.dart';
import 'package:trip_planner/src/view_models/trip_form_view_model.dart';

class TripFormPage extends StatefulWidget {
  final List<BaggageResponse> startPointList;

  TripFormPage({
    required this.startPointList,
  });

  @override
  _TripFormPageState createState() => _TripFormPageState(this.startPointList);
}

class _TripFormPageState extends State<TripFormPage> {
  final List<BaggageResponse> startPointList;
  _TripFormPageState(this.startPointList);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final textStyle = TextStyle(
      fontSize: 16,
      color: Palette.AdditionText,
    );
    final tripFormViewModel = Provider.of<TripFormViewModel>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: TextButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text(
                  'ต้องการยกเลิกทริปหรือไม่',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Palette.BodyText,
                  ),
                  textAlign: TextAlign.center,
                ),
                content: const Text(
                  'ทริปที่คุณสร้างไว้ยังไม่สำเร็จ หากคุณยกเลิกทริปจะไม่สามารถนำกลับมาทำต่อได้',
                  style: TextStyle(
                    fontSize: 14,
                    color: Palette.AdditionText,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'ทำต่อ'),
                    child: const Text(
                      'ทำต่อ',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'ยกเลิกทริป'),
                    child: const Text(
                      'ยกเลิกทริป',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Palette.NotificationColor,
                    ),
                  ),
                ],
              ),
            ),
            child: Text("ยกเลิก"),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(15),
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          leadingWidth: getProportionateScreenWidth(70),
          title: Text(
            "สร้างทริป",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.bottomLeft,
                        margin: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(15),
                        ),
                        padding: EdgeInsets.only(
                            top: getProportionateScreenHeight(15)),
                        child: Text(
                          'ตั้งชื่อทริป',
                          style: textStyle,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(15),
                          vertical: getProportionateScreenHeight(10),
                        ),
                        child: TextField(
                          maxLength: 30,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 12),
                            hintText:
                                'ตั้งชื่อทริป... เช่น ลำโพงมันดัง ลำปางมันดี',
                            hintStyle: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          onChanged: (value) => {},
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(15),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                'ไปกี่คน',
                                style: textStyle,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 12),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                            SizedBox(
                              width: getProportionateScreenWidth(15),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'ไปกี่วัน',
                                style: textStyle,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 12),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            tripFormViewModel.startDate,
                            style: textStyle,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(15),
                              vertical: getProportionateScreenHeight(30),
                            ),
                            child: IconButton(
                              onPressed: () {
                                tripFormViewModel.pickDate(context);
                              },
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: Icon(
                                Icons.calendar_today_rounded,
                                color: Palette.PrimaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(15),
                        ),
                        margin: EdgeInsets.only(
                            bottom: getProportionateScreenHeight(15)),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'จุดเริ่มต้นการท่องเที่ยว',
                          style: textStyle,
                        ),
                      ),
                      startPointList.isEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(15),
                              ),
                              child: OutlinedButton(
                                onPressed: () {
                                  print('เลือกจุดเริ่มต้น');
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                    ),
                                    Text(
                                      ' เลือกจุดเริ่มต้น',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.all(12),
                                  primary: Palette.AdditionText,
                                  alignment: Alignment.center,
                                  side: BorderSide(color: Palette.AdditionText),
                                ),
                              ),
                            )
                          : StartPointCard(item: startPointList[0])
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: getProportionateScreenHeight(48),
                margin: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(15),
                  horizontal: getProportionateScreenWidth(15),
                ),
                child: ElevatedButton(
                  onPressed: () {},
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
            ],
          ),
        ),
      ),
    );
  }
}
