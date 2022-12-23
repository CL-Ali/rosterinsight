import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rosterinsight/MainComponents/constant.dart';
import 'package:rosterinsight/MainComponents/sharePreferences.dart';

import 'package:rosterinsight/screens/LoginScreen/LoginScreen.dart';
import 'package:rosterinsight/screens/NavigationScreens/MyNavigationScreen.dart';
import 'package:rosterinsight/services/Api_Call_Service.dart';

class RegisterationScreen extends StatefulWidget {
  static int selectedOption = 2;

  static bool isComplete = false;
  @override
  State<RegisterationScreen> createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  List menuOptions = ["Registration", "OTP"];
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  String otp = "";
  bool isEmailSending = false;
  bool isOtpValid = false;
  bool isErrorDuringSending = false;
  static String whichMenuSelect = 'Registration';
  TextEditingController _otpcontroller = TextEditingController();
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _namecontroller = TextEditingController();
  String email = "";
  String name = "";

  @override
  void dispose() {
    // _otpcontroller.dispose();
    _emailcontroller.dispose();
    _namecontroller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      RegisterationScreen.isComplete;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: primaryColor,
        child: Padding(
          padding: EdgeInsets.only(top: size.height / 10),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                )),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                child: Column(children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: size.height / 20),
                        child: Column(
                          children: [
                            Text(
                              'Welcome Officer!',
                              style:
                                  TextStyle(fontSize: 25, color: primaryColor),
                            ),
                            Text(
                              'Register With Email',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height / 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: RegisterationScreen.isComplete
                                ? null
                                : () {
                                    setState(() {
                                      textEditingController.clear();
                                      RegisterationScreen.selectedOption = 1;
                                      whichMenuSelect = menuOptions[
                                          RegisterationScreen.selectedOption -
                                              1];
                                    });
                                  },
                            child: Container(
                              height: 35,
                              width: 35 * 4,
                              decoration: BoxDecoration(
                                border: whichMenuSelect.toLowerCase() ==
                                        'registration'
                                    ? !RegisterationScreen.isComplete
                                        ? Border.all(width: 0)
                                        : Border.all(color: primaryColor)
                                    : Border.all(color: primaryColor),
                                color: whichMenuSelect.toLowerCase() ==
                                        'registration'
                                    ? !RegisterationScreen.isComplete
                                        ? primaryColor
                                        : const Color(0xffffffff)
                                    : const Color(0xffffffff),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Registration',
                                style: TextStyle(
                                  color: whichMenuSelect.toLowerCase() ==
                                          'registration'
                                      ? !RegisterationScreen.isComplete
                                          ? const Color(0xffffffff)
                                          : Colors.black87
                                      : Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: !RegisterationScreen.isComplete
                                ? null
                                : () {
                                    setState(() {
                                      RegisterationScreen.selectedOption = 2;
                                      whichMenuSelect = menuOptions[
                                          RegisterationScreen.selectedOption -
                                              1];

                                      // build(context);
                                    });
                                  },
                            child: Container(
                              height: 35,
                              width: 35 * 4,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: whichMenuSelect.toLowerCase() == 'otp'
                                    ? primaryColor
                                    : RegisterationScreen.isComplete
                                        ? primaryColor
                                        : const Color(0xffffffff),
                                border: whichMenuSelect.toLowerCase() == 'otp'
                                    ? Border.all(width: 0)
                                    : RegisterationScreen.isComplete
                                        ? Border.all(width: 0)
                                        : Border.all(color: primaryColor),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: Text(
                                'OTP',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: whichMenuSelect.toLowerCase() == 'otp'
                                      ? Colors.white
                                      : RegisterationScreen.isComplete
                                          ? Colors.white
                                          : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height / 20,
                  ),
                  whichMenuSelect.toLowerCase() == 'otp'
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Column(
                            children: [
                              PinCodeTextField(
                                appContext: context,
                                length: 4,
                                keyboardType: TextInputType.phone,
                                obscureText: false,
                                animationType: AnimationType.fade,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.underline,
                                  // fieldHeight: 50,
                                  // fieldWidth: 40,
                                  activeFillColor: Colors.white,
                                  activeColor: primaryColor,
                                  inactiveFillColor: Colors.white,
                                  inactiveColor: Colors.grey[700],
                                  selectedFillColor: Colors.white,

                                  selectedColor: primaryColor,
                                  // activeColor: Colors.white,
                                ),
                                animationDuration: Duration(milliseconds: 300),
                                // backgroundColor: Colors.blue.shade50,
                                enableActiveFill: true,
                                errorAnimationController: errorController,
                                controller: _otpcontroller,
                                onCompleted: (v) {
                                  print("Completed");
                                },

                                onChanged: (value) {
                                  print(value);
                                  setState(() {
                                    otp = value;
                                  });
                                },

                                beforeTextPaste: (text) {
                                  print("Allowing to paste $text");
                                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                  return true;
                                },
                              ),
                              SizedBox(
                                height: size.height / 20,
                              ),
                              MaterialButton(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0))),
                                  disabledColor: Colors.grey,
                                  disabledTextColor: Colors.white,
                                  onPressed: otp == ""
                                      ? null
                                      : () async {
                                          try {
                                            setState(() {
                                              isOtpValid = true;
                                            });
                                            String password = await ApiCall
                                                .apiForRegistration(
                                                    name: name,
                                                    email: email,
                                                    token: otp,
                                                    isOtpSend: false);

                                            var isValid =
                                                await exceptionSnackBar(
                                                    password,
                                                    isAuthentication: true);
                                            if (isValid) {
                                              await UserSharePreferences
                                                  .setEmail(email);

                                              await UserSharePreferences
                                                  .setName(name);
                                              setState(() {
                                                isOtpValid = false;
                                              });
                                              var response =
                                                  jsonDecode(password);
                                              password = response['message'];
                                              if (password.length < 7) {
                                                LoginScreen.isDirectLogin =
                                                    false;
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginScreen()),
                                                    (route) => false);
                                              }
                                            } else {
                                              setState(() {
                                                setState(() {
                                                  isOtpValid = false;
                                                });
                                              });
                                            }
                                          } catch (e) {
                                            print(e.toString());
                                          }
                                        },
                                  minWidth: double.infinity,
                                  height: 40,
                                  color: primaryColor,
                                  child: isOtpValid
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child:
                                              const CircularProgressIndicator(
                                            strokeWidth: 2,
                                            // value: 12,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          "Verify",
                                          style: TextStyle(color: Colors.white),
                                        )),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Column(
                            children: [
                              TextField(
                                controller: _emailcontroller,
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                                cursorColor: primaryColor,
                                decoration: InputDecoration(
                                    // hintStyle: TextStyle(color: Colors.blue),
                                    hintText: "Email"),
                              ),
                              SizedBox(
                                height: size.height / 20,
                              ),
                              TextField(
                                controller: _namecontroller,
                                onChanged: (value) {
                                  setState(() {
                                    name = value;
                                  });
                                },
                                cursorColor: primaryColor,
                                decoration: InputDecoration(
                                    // hintStyle: TextStyle(color: Colors.blue),
                                    hintText: "Name"),
                              ),
                              SizedBox(
                                height: size.height / 20,
                              ),
                              MaterialButton(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0))),
                                  disabledColor: Colors.grey,
                                  disabledTextColor: Colors.white,
                                  onPressed: email == "" || name == ""
                                      ? null
                                      : () async {
                                          setState(() {
                                            isEmailSending = true;
                                          });
                                          try {
                                            String code = await ApiCall
                                                .apiForRegistration(
                                                    name: name,
                                                    email: email,
                                                    token: "",
                                                    isOtpSend: true);
                                            var isValid =
                                                await exceptionSnackBar(code,
                                                    isAuthentication: true);
                                            if (isValid) {
                                              // otp = code;
                                              setState(() {
                                                whichMenuSelect == 'otp';
                                                isEmailSending = false;
                                                RegisterationScreen.isComplete =
                                                    true;
                                              });
                                              RegisterationScreen
                                                  .selectedOption = 2;
                                              whichMenuSelect = menuOptions[
                                                  RegisterationScreen
                                                          .selectedOption -
                                                      1];

                                              // build(context);
                                            } else {
                                              setState(() {
                                                isEmailSending = false;
                                              });
                                            }
                                          } catch (e) {
                                            setState(() {
                                              isErrorDuringSending = true;
                                              isEmailSending = false;
                                            });
                                          }
                                        },
                                  minWidth: double.infinity,
                                  height: 40,
                                  color: primaryColor,
                                  child: isEmailSending
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child:
                                              const CircularProgressIndicator(
                                            strokeWidth: 2,
                                            // value: 12,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          "Send OTP",
                                          style: TextStyle(color: Colors.white),
                                        )),
                              SizedBox(
                                height: size.height / 35,
                              ),
                              Center(
                                child: Text('Or'),
                              ),
                              SizedBox(
                                height: size.height / 35,
                              ),
                              MaterialButton(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0))),
                                  disabledColor: Colors.grey,
                                  disabledTextColor: Colors.white,
                                  onPressed: () {
                                    Get.off(MyNavigationScreen());
                                  },
                                  minWidth: double.infinity,
                                  height: 40,
                                  color: primaryColor,
                                  child: const Text(
                                    "Demo Test",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ],
                          ),
                        ),
                  SizedBox(
                    height: size.height / 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      TextButton(
                        style:
                            TextButton.styleFrom(foregroundColor: primaryColor),
                        child: Text("Sign In Here"),
                        onPressed: () async {
                          RegisterationScreen.selectedOption = 2;
                          LoginScreen.isDirectLogin = true;
                          Get.to(LoginScreen());
                        },
                      ),
                    ],
                  )
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
