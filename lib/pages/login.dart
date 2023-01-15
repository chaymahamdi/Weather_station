import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project_cert/pages/home.dart';
import 'package:project_cert/pages/register.dart';
import '../Widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_cert/Network_front_back/api.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  bool hidePassword = true;
  TextEditingController textController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String valeur = "data";

  _showMsg(msg) {
    //
    final snackBar = SnackBar(
      backgroundColor: Color(0xFF363f93),
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _login() async {
    var data = {
      'email': emailController.text,
      'password': textController.text,
    };

    var res = await CallApi().postData(data, 'login');
    var body = json.decode(res.body);

    setState(() {
      valeur = res.toString();
    });
    if (body['success']) {
      var data = body['data'];
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', data['token']);
      localStorage.setString('user', data['name']);
      localStorage.setString('email', data['email']);
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => Home()));
    } else {
      _showMsg(body['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/back.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
                bottom: MediaQuery.of(context).size.width * 0.01,
              ),
              child: Column(
                children: [
                  const Text(
                    'Welcome Back :',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 33,
                        fontWeight: FontWeight.bold),
                  ),
                  Image(
                    image: AssetImage('assets/logo.png'),
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 35, right: 35),
                            child: Column(
                              children: [
                                TextField(
                                  controller: emailController,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.email),
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      hintText: "Email",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  onChanged: (value) {
                                    print(value);
                                  },
                                  controller: textController,
                                  obscureText: hidePassword,
                                  style: TextStyle(),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.lock),
                                      suffixIcon: IconButton(
                                        icon: hidePassword
                                            ? Icon(Icons.visibility_off)
                                            : Icon(Icons.visibility),
                                        onPressed: () {
                                          setState(() {
                                            hidePassword = !hidePassword;
                                          });
                                        },
                                      ),
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      hintText: "Password",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                button(
                                    val: 'login',
                                    onTap: () {
                                      _login();
                                    }),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextButton(
                                  onPressed: () {
                                    //forgot password screen
                                  },
                                  child: const Text(
                                    'Forgot your Password ?',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                ),
                                Row(
                                  children: <Widget>[
                                    const Text("Don't have account?"),
                                    TextButton(
                                      child: const Text(
                                        'Sign up',
                                        style: TextStyle(
                                            color: Colors.indigo, fontSize: 20),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Register()),
                                        );
                                      },
                                    )
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
