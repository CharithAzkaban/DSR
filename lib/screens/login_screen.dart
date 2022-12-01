import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dsr_app/common.dart';
import 'package:dsr_app/models/user.dart';
import 'package:dsr_app/providers/login_provider.dart';
import 'package:dsr_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();

  bool _obsecureText = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    LoginProvider _loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        bottomNavigationBar: StreamBuilder(
            stream: Connectivity().onConnectivityChanged,
            builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
              bool visibility = snapshot.hasData &&
                  !(snapshot.data == ConnectivityResult.mobile ||
                      snapshot.data == ConnectivityResult.wifi);

              return Visibility(
                visible: visibility,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 30.0,
                  color: Colors.red,
                  child: Text(
                    'No connection!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(child: Lottie.asset('assets/login.json')),
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                      onFieldSubmitted: (username) {
                        if (username.trim().isNotEmpty) {
                          _passwordFocus.requestFocus();
                        }
                        if (_formKey.currentState!.validate()) {
                          return;
                        }
                      },
                      controller: _usernameController,
                      validator: (username) {
                        if (username!.trim().isNotEmpty) {
                          return null;
                        }
                        return 'Username is required';
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          splashRadius: 20.0,
                          onPressed: () {
                            setState(() {
                              _obsecureText = !_obsecureText;
                            });
                          },
                          icon: Icon(
                            _obsecureText
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                      ),
                      controller: _passwordController,
                      onFieldSubmitted: (_) async {
                        if (_formKey.currentState!.validate()) {
                          _passwordFocus.requestFocus();
                          _loginProvider.setSignin(true);
                          await login(
                              User(
                                  email: _usernameController.text.trim(),
                                  password: _passwordController.text),
                              context);
                          return;
                        }
                        _loginProvider.setSignin(false);
                      },
                      validator: (password) {
                        if (password != null) {
                          return password.isEmpty && _passwordFocus.hasFocus
                              ? 'Password is required'
                              : null;
                        }
                        return 'Username is required';
                      },
                      focusNode: _passwordFocus,
                      obscureText: _obsecureText,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      width: double.infinity,
                      height: 60.0,
                      child: Consumer<LoginProvider>(
                        builder: (context, data, child) => OutlinedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _passwordFocus.requestFocus();
                              _loginProvider.setSignin(true);
                              await login(
                                User(
                                  email: _usernameController.text.trim(),
                                  password: _passwordController.text,
                                ),
                                context,
                              );
                              return;
                            }
                            _loginProvider.setSignin(false);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue[800]),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          child: data.loadSignin
                              ? CircularProgressIndicator()
                              : Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                        width: double.infinity,
                        height: 60.0,
                        child: OutlinedButton(
                            onPressed: () async {
                              callAdmin(context);
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                            child: Text(
                              'Login problem?',
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.blue[800]),
                            ))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
