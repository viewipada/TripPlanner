import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/assets.dart';
import 'package:trip_planner/palette.dart';
import 'package:trip_planner/size_config.dart';
import 'package:trip_planner/src/view_models/login_view_model.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  String? _errorDialog = "";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final _formKey = GlobalKey<FormState>();
    final loginViewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: getProportionateScreenHeight(50),
            horizontal: getProportionateScreenWidth(15),
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageAssets.loginBackground),
              fit: BoxFit.fitHeight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: getProportionateScreenHeight(50),
                    height: getProportionateScreenHeight(50),
                    margin: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(35)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(ImageAssets.logo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(35),
                      vertical: getProportionateScreenHeight(15),
                    ),
                    child: Text(
                      'สนุกทุกการเดินทาง\nกับ EZtrip',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: getProportionateScreenHeight(48),
                    child: ElevatedButton(
                      onPressed: () {
                        bool _passwordVisible = false;
                        bool _confirmPasswordVisible = false;
                        showModalBottomSheet(
                          //register modal
                          isScrollControlled: true,
                          isDismissible: false,
                          enableDrag: false,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return Container(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                margin: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(15),
                                  vertical: getProportionateScreenHeight(15),
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(),
                                          icon: Icon(
                                            Icons.cancel_outlined,
                                            color: Palette.AdditionText,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _errorDialog = "";
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                      Text(
                                        'สร้างบัญชีใหม่',
                                        style: FontAssets.headingText,
                                      ),
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(15),
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          prefixIcon:
                                              Icon(Icons.person_outline),
                                          labelText: 'ชื่อผู้ใช้',
                                          counterText: "",
                                        ),
                                        textInputAction: TextInputAction.next,
                                        maxLength: 15,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(
                                            RegExp(r'\s'),
                                          ),
                                        ],
                                        validator: (value) {
                                          if (value!.trim().isEmpty) {
                                            return 'โปรดระบุ';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) => loginViewModel
                                            .userNameChanged(value),
                                      ),
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(10),
                                      ),
                                      TextFormField(
                                        focusNode: passwordFocusNode,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        obscureText: !_confirmPasswordVisible,
                                        decoration: InputDecoration(
                                          prefixIcon:
                                              Icon(Icons.lock_outline_rounded),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() =>
                                                  _confirmPasswordVisible =
                                                      !_confirmPasswordVisible);
                                              passwordFocusNode.requestFocus();
                                            },
                                            icon: _confirmPasswordVisible
                                                ? Icon(Icons
                                                    .visibility_off_outlined)
                                                : Icon(
                                                    Icons.visibility_outlined),
                                          ),
                                          labelText: 'รหัสผ่าน',
                                        ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(
                                            RegExp(r'\s'),
                                          ),
                                        ],
                                        validator: (value) {
                                          RegExp regex = RegExp(
                                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
                                          if (value!.trim().isEmpty) {
                                            return 'โปรดระบุ';
                                          } else if (value.length < 8) {
                                            return 'กรุณาระบุอย่างน้อย 8 ตัวอักษร';
                                          } else {
                                            if (regex.hasMatch(value)) {
                                              return null;
                                            } else {
                                              return 'กรุณาระบุตามรูปแบบที่กำหนด';
                                            }
                                          }
                                        },
                                        onChanged: (value) => loginViewModel
                                            .passwordChanged(value),
                                      ),
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(10),
                                      ),
                                      TextFormField(
                                        focusNode: confirmPasswordFocusNode,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        obscureText: !_passwordVisible,
                                        decoration: InputDecoration(
                                          prefixIcon:
                                              Icon(Icons.lock_outline_rounded),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() => _passwordVisible =
                                                  !_passwordVisible);
                                              confirmPasswordFocusNode
                                                  .requestFocus();
                                            },
                                            icon: _passwordVisible
                                                ? Icon(Icons
                                                    .visibility_off_outlined)
                                                : Icon(
                                                    Icons.visibility_outlined),
                                          ),
                                          labelText: 'ยืนยันรหัสผ่าน',
                                        ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(
                                            RegExp(r'\s'),
                                          ),
                                        ],
                                        validator: (value) {
                                          if (value!.trim().isEmpty) {
                                            return 'โปรดระบุ';
                                          } else if (value !=
                                              loginViewModel.password) {
                                            return 'รหัสผ่านไม่ตรงกัน';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) => loginViewModel
                                            .confirmPasswordChanged(value),
                                      ),
                                      _errorDialog == null
                                          ? SizedBox()
                                          : _errorDialog == ''
                                              ? SizedBox()
                                              : instruction(_errorDialog!),
                                      SizedBox(
                                        height:
                                            getProportionateScreenHeight(48),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height:
                                            getProportionateScreenHeight(48),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (_errorDialog != null) {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  _errorDialog = null;
                                                });
                                                loginViewModel
                                                    .tryToRegister(context)
                                                    .then((status) {
                                                  setState(() {
                                                    if (status == 201) {
                                                      _errorDialog = "";
                                                    } else if (status == 409) {
                                                      _errorDialog =
                                                          "ชื่อผู้ใช้นี้ มีอยู่แล้ว";
                                                    } else {
                                                      _errorDialog =
                                                          "กรุณาลองใหม่อีกครั้ง";
                                                    }
                                                  });
                                                });
                                              }
                                            }
                                          },
                                          child: Text(
                                            'ลงทะเบียน',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary: _errorDialog == null
                                                ? Palette.InfoText
                                                : Palette.PrimaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                          },
                        );
                      },
                      child: Text(
                        'ลงทะเบียน',
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
                  SizedBox(
                    height: getProportionateScreenHeight(15),
                  ),
                  Container(
                    width: double.infinity,
                    height: getProportionateScreenHeight(48),
                    child: OutlinedButton(
                      onPressed: () {
                        bool _passwordVisible = false;
                        showModalBottomSheet(
                          //login madal
                          isScrollControlled: true,
                          isDismissible: false,
                          enableDrag: false,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          context: context,
                          builder: (BuildContext context) => StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                            return Container(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(15),
                                vertical: getProportionateScreenHeight(15),
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        icon: Icon(
                                          Icons.cancel_outlined,
                                          color: Palette.AdditionText,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _errorDialog = "";
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    Text(
                                      'เข้าสู่ระบบ',
                                      style: FontAssets.headingText,
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(15),
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.person_outline),
                                        labelText: 'ชื่อผู้ใช้',
                                        counterText: "",
                                      ),
                                      textInputAction: TextInputAction.next,
                                      maxLength: 15,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(
                                          RegExp(r'\s'),
                                        ),
                                      ],
                                      validator: (value) {
                                        if (value!.trim().isEmpty) {
                                          return 'โปรดระบุ';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) =>
                                          loginViewModel.userNameChanged(value),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(10),
                                    ),
                                    TextFormField(
                                      focusNode: passwordFocusNode,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: !_passwordVisible,
                                      decoration: InputDecoration(
                                        prefixIcon:
                                            Icon(Icons.lock_outline_rounded),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() => _passwordVisible =
                                                !_passwordVisible);
                                            passwordFocusNode.requestFocus();
                                          },
                                          icon: _passwordVisible
                                              ? Icon(
                                                  Icons.visibility_off_outlined)
                                              : Icon(Icons.visibility_outlined),
                                        ),
                                        labelText: 'รหัสผ่าน',
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(
                                          RegExp(r'\s'),
                                        ),
                                      ],
                                      validator: (value) {
                                        RegExp regex = RegExp(
                                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
                                        if (value!.trim().isEmpty) {
                                          return 'โปรดระบุ';
                                        } else if (value.length < 8) {
                                          return 'กรุณาระบุอย่างน้อย 8 ตัวอักษร';
                                        } else {
                                          if (regex.hasMatch(value)) {
                                            return null;
                                          } else {
                                            return 'กรุณาระบุตามรูปแบบที่กำหนด';
                                          }
                                        }
                                      },
                                      onChanged: (value) =>
                                          loginViewModel.passwordChanged(value),
                                    ),
                                    _errorDialog == null
                                        ? SizedBox()
                                        : _errorDialog == ''
                                            ? SizedBox()
                                            : instruction(_errorDialog!),
                                    SizedBox(
                                      height: getProportionateScreenHeight(48),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: getProportionateScreenHeight(48),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_errorDialog != null) {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                _errorDialog = null;
                                              });
                                              loginViewModel
                                                  .tryToLogin(context)
                                                  .then((status) {
                                                setState(() {
                                                  if (status == 200) {
                                                    _errorDialog = "";
                                                  } else if (status == 400) {
                                                    _errorDialog =
                                                        "ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง";
                                                  } else if (status == 401) {
                                                    _errorDialog =
                                                        "ไม่พบชื่อผู้ใช้ในระบบ";
                                                  } else {
                                                    _errorDialog =
                                                        "กรุณาลองใหม่อีกครั้ง";
                                                  }
                                                });
                                              });
                                            }
                                          }
                                        },
                                        child: Text(
                                          'เข้าสู่ระบบ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: _errorDialog == null
                                              ? Palette.InfoText
                                              : Palette.PrimaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        );
                      },
                      child: Text(
                        'เข้าสู่ระบบ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        alignment: Alignment.center,
                        side: BorderSide(color: Palette.PrimaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget instruction(String text) {
  return Container(
    padding: EdgeInsets.symmetric(
      vertical: getProportionateScreenHeight(10),
      horizontal: getProportionateScreenWidth(10),
    ),
    margin: EdgeInsets.symmetric(
      vertical: getProportionateScreenHeight(10),
    ),
    decoration: BoxDecoration(
      color: Color(0xffFEFFE1),
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      border: Border.all(color: Palette.LightOrangeColor),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.lightbulb_outline_rounded,
          color: Palette.LightOrangeColor,
          size: 20,
        ),
        Text(
          text,
          style: TextStyle(
              color: Palette.LightOrangeColor,
              fontWeight: FontWeight.bold,
              fontSize: 12),
        ),
      ],
    ),
  );
}
