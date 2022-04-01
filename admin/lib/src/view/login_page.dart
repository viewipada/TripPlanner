import 'package:admin/src/assets.dart';
import 'package:admin/src/palette.dart';
import 'package:admin/src/size_config.dart';
import 'package:admin/src/view_models/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final loginViewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Text(
              "EZtrip",
              style: FontAssets.headingText,
            ),
            Text(
              " Admin",
              style: TextStyle(
                fontSize: 20,
                color: Palette.webText,
              ),
            )
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            color: const Color(0xffECF5FF),
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight,
            alignment: Alignment.center,
            child: Opacity(
              opacity: 0.25,
              child: Image.asset(
                ImageAssets.loginBackground,
                fit: BoxFit.cover,
                width: SizeConfig.screenWidth,
                alignment: Alignment.center,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: SizeConfig.screenWidth / 3.0,
                  padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(10)),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                    color: Palette.webBackground,
                  ),
                  child: const Text(
                    'เข้าสู่ระบบ',
                    style: FontAssets.subtitleText,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: SizeConfig.screenWidth / 3.0,
                  padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(10)),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16)),
                    color: Colors.white,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(10),
                              vertical: getProportionateScreenHeight(10)),
                          child: TextFormField(
                            decoration: const InputDecoration(
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
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(10),
                              vertical: getProportionateScreenHeight(10)),
                          child: TextFormField(
                            focusNode: passwordFocusNode,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                  passwordFocusNode.requestFocus();
                                },
                                icon: _passwordVisible
                                    ? const Icon(Icons.visibility_off_outlined)
                                    : const Icon(Icons.visibility_outlined),
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
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: getProportionateScreenHeight(15),
                              horizontal: getProportionateScreenWidth(10)),
                          child: SizedBox(
                            width: double.infinity,
                            height: getProportionateScreenHeight(50),
                            child: ElevatedButton(
                              onPressed: () {
                                // if (_errorDialog != null) {
                                if (_formKey.currentState!.validate()) {
                                  // setState(() {
                                  //   _errorDialog = null;
                                  // });
                                  // loginViewModel
                                  //     .tryToRegister(context)
                                  //     .then((status) {
                                  //   setState(() {
                                  //     if (status == 201) {
                                  //       _errorDialog = "";
                                  //     } else if (status == 409) {
                                  //       _errorDialog =
                                  //           "ชื่อผู้ใช้นี้ มีอยู่แล้ว";
                                  //     } else {
                                  //       _errorDialog =
                                  //           "กรุณาลองใหม่อีกครั้ง";
                                  //     }
                                  //   });
                                  // });
                                  // }
                                }
                              },
                              child: const Text(
                                'เข้าสู่ระบบ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Palette.webText,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
