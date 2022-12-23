import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosterinsight/MainComponents/constant.dart';
import 'package:rosterinsight/MainComponents/sharePreferences.dart';
import 'package:rosterinsight/Models/booking.dart';
import 'package:rosterinsight/screens/NavigationScreens/BookingScreen/HomeScreen.dart';
import 'package:rosterinsight/screens/NavigationScreens/MyNavigationScreen.dart';
import 'package:rosterinsight/services/Api_Call_Service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool isFieldFull = false;
  bool isPasswordChange = false;
  TextEditingController _confirmPassword = TextEditingController();
  TextEditingController _password = TextEditingController();
  String confirmPassword = "";
  String password = "";
  bool isShow = true;
  bool isPassMatch = false;

  isFieldNotEmpty() {
    setState(() {
      isFieldFull = confirmPassword != "" && password != "";
    });
  }

  @override
  void initState() {
    isFieldNotEmpty();
    super.initState();
  }

  @override
  void dispose() {
    _confirmPassword.dispose();
    _password.dispose();
    super.dispose();
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Change Password ',
                        style: TextStyle(fontSize: 25, color: primaryColor),
                      ),
                      SizedBox(
                        height: size.height / 20,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _password,
                                  onChanged: (value) {
                                    setState(() {
                                      password = value;
                                    });
                                    isFieldNotEmpty();
                                  },
                                  cursorColor: primaryColor,
                                  obscureText: isShow,
                                  decoration: InputDecoration(

                                      // hintStyle: TextStyle(color: Colors.blue),
                                      hintText: "Password"),
                                ),
                                SizedBox(
                                  height: size.height / 30,
                                ),
                                TextFormField(
                                  controller: _confirmPassword,
                                  obscureText: isShow,
                                  onChanged: (value) {
                                    setState(() {
                                      confirmPassword = value;
                                    });
                                    isFieldNotEmpty();
                                  },
                                  cursorColor: primaryColor,
                                  decoration: InputDecoration(
                                      errorText: (password == confirmPassword)
                                          ? null
                                          : 'Passwords are not match',
                                      hintText: "Confirm Password"),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height / 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(children: [
                              Checkbox(
                                value: !isShow,
                                focusColor: primaryColor,
                                fillColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return primaryColor.withOpacity(10);
                                  }
                                  return primaryColor;
                                }),
                                onChanged: ((value) {
                                  setState(() {
                                    isShow ? isShow = false : isShow = true;
                                  });
                                }),
                              ),
                              Text('Show Password')
                            ]),
                          ),
                          SizedBox(
                            height: size.height / 30,
                          ),
                          MaterialButton(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0))),
                              disabledColor: Colors.grey,
                              disabledTextColor: Colors.white,
                              onPressed: !isFieldFull ||
                                      password != confirmPassword
                                  ? null
                                  : () async {
                                      setState(() {
                                        isPasswordChange = true;
                                      });
                                      if (password == confirmPassword) {
                                        String isValid =
                                            await ApiCall.apiForChangePassword(
                                                password: password);
                                        bool response =
                                            await exceptionSnackBar(isValid);
                                        if (response) {
                                          await UserSharePreferences
                                              .setLoginStts(true);

                                          setState(() {
                                            isPasswordChange = false;
                                          });
                                          Get.to(MyNavigationScreen());
                                        }
                                      }
                                    },
                              minWidth: double.infinity,
                              height: 40,
                              color: primaryColor,
                              child: isPasswordChange
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        // value: 12,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      "Change Password",
                                      style: TextStyle(color: Colors.white),
                                    )),
                        ],
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
