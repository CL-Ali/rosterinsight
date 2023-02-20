import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosterinsight/MainComponents/constant.dart';
import 'package:rosterinsight/MainComponents/sharePreferences.dart';
import 'package:rosterinsight/Models/booking.dart';
import 'package:rosterinsight/screens/LoginScreen/ChangePasswordScreen.dart';
import 'package:rosterinsight/screens/NavigationScreens/BookingScreen/HomeScreen.dart';
import 'package:rosterinsight/screens/NavigationScreens/MyNavigationScreen.dart';
import 'package:rosterinsight/screens/RegistrationScreen/RegisterationScreen.dart';
import 'package:rosterinsight/services/Api_Call_Service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static bool isDirectLogin = true;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isFieldFull = false;
  TextEditingController _businessID = TextEditingController();
  TextEditingController _employeeID = TextEditingController();
  TextEditingController _password = TextEditingController();
  int businessID = 0;
  String employeeID = "";
  String password = "";
  bool isLoginUserValid = false;
  bool isShow = true;
  isFieldNotEmpty() {
    setState(() {
      isFieldFull = businessID != 0 && employeeID != "" && password != "";
    });
  }

  @override
  void initState() {
    isFieldNotEmpty();
    super.initState();
  }

  @override
  void dispose() {
    _businessID.dispose();
    _employeeID.dispose();
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
                      Column(
                        children: [
                          Text(
                            'Welcome Back!',
                            style: TextStyle(fontSize: 25, color: primaryColor),
                          ),
                          Text(
                            'Login in to  Acount',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[700]),
                          )
                        ],
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
                                TextField(
                                  controller: _businessID,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      setState(() {
                                        businessID = int.parse(value);
                                      });
                                    }
                                    isFieldNotEmpty();
                                    print("your businessID is $value");
                                  },
                                  cursorColor: primaryColor,
                                  decoration: InputDecoration(
                                      // hintStyle: TextStyle(color: Colors.blue),
                                      hintText: "Business Id"),
                                ),
                                SizedBox(
                                  height: size.height / 30,
                                ),
                                TextField(
                                  controller: _employeeID,
                                  onChanged: (value) {
                                    setState(() {
                                      employeeID = value;
                                    });
                                    isFieldNotEmpty();
                                  },
                                  cursorColor: primaryColor,
                                  decoration: InputDecoration(
                                      // hintStyle: TextStyle(color: Colors.blue),
                                      hintText: "Employee Id"),
                                ),
                                SizedBox(
                                  height: size.height / 30,
                                ),
                                TextField(
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
                                      suffixIcon: IconButton(
                                        icon: Icon(isShow
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        onPressed: () {
                                          setState(() {
                                            isShow
                                                ? isShow = false
                                                : isShow = true;
                                          });
                                        },
                                      ),

                                      // hintStyle: TextStyle(color: Colors.blue),
                                      hintText: "Password"),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height / 35,
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
                              onPressed: !isFieldFull
                                  ? null
                                  : () async {
                                      setState(() {
                                        isLoginUserValid = true;
                                      });
                                      if (employeeID.toLowerCase() == 'demo') {
                                        DemoModel demoModel = DemoModel(
                                          employeeID: employeeID,
                                          password: password,
                                          businessID: businessID,
                                        );
                                        bool isValid =
                                            DemoModel.isMatchForDemo(demoModel);
                                        setState(() {
                                          isLoginUserValid = false;
                                        });
                                        if (isValid) {
                                          await UserSharePreferences
                                              .setBusinessId(businessID);
                                          await UserSharePreferences
                                              .setEmployeeId(employeeID);
                                          Get.to(MyNavigationScreen());
                                        }
                                      } else {
                                        String isValid =
                                            await ApiCall.apiForLogin(
                                                employeeId: employeeID,
                                                businessId: businessID,
                                                password: password);
                                        bool response =
                                            await exceptionSnackBar(isValid);
                                        setState(() {
                                          isLoginUserValid = false;
                                        });
                                        if (response) {
                                          await UserSharePreferences
                                              .setBusinessId(businessID);
                                          await UserSharePreferences
                                              .setEmployeeId(employeeID);

                                          Get.to(LoginScreen.isDirectLogin
                                              ? MyNavigationScreen()
                                              : ChangePasswordScreen());
                                        }
                                      }
                                    },
                              minWidth: double.infinity,
                              height: 40,
                              color: primaryColor,
                              child: isLoginUserValid
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
                                      "Login",
                                      style: TextStyle(color: Colors.white),
                                    )),
                          SizedBox(
                            height: size.height / 35,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account?"),
                              TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: primaryColor),
                                child: Text("Sign Up Here"),
                                onPressed: () async {
                                  RegisterationScreen.selectedOption = 1;
                                  LoginScreen.isDirectLogin = false;
                                  Get.to(RegisterationScreen());
                                },
                              ),
                            ],
                          )
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

class DemoModel {
  int businessID;
  String employeeID;
  String password;
  DemoModel(
      {required this.businessID,
      required this.employeeID,
      required this.password});
  static bool isMatchForDemo(DemoModel demoModel) =>
      demoModel.businessID == 1 &&
      demoModel.employeeID.toLowerCase() == "demo" &&
      demoModel.password.toLowerCase() == "demo";
}
