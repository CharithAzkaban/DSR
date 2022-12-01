import 'package:dsr_app/providers/login_provider.dart';
import 'package:dsr_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  final TextEditingController newPasswordController;
  final GlobalKey<FormState> formKey;
  const ChangePassword({
    Key? key,
    required this.newPasswordController,
    required this.formKey,
  }) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _obsecureText = true;
  @override
  Widget build(BuildContext context) {
    LoginProvider _loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Form(
          key: widget.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Change password',
                  style: TextStyle(fontSize: 20.0, color: Colors.grey[700])),
              SizedBox(
                height: 10.0,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5.0)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 2, bottom: 2),
                  child: Text(
                    _loginProvider.currentUser.email,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: 'New password',
                  suffixIcon: IconButton(
                      splashRadius: 20.0,
                      onPressed: () {
                        setState(() {
                          _obsecureText = !_obsecureText;
                        });
                      },
                      icon: Icon(_obsecureText
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
                controller: widget.newPasswordController,
                onFieldSubmitted: (_) async {
                  if (widget.formKey.currentState!.validate()) {
                    await changePassword(
                        context, widget.newPasswordController.text);
                    return;
                  }
                },
                validator: (newPassword) {
                  if (newPassword!.isNotEmpty) {
                    if (newPassword.length < 6) {
                      return 'At least 6 characters required!';
                    } else if (newPassword ==
                        _loginProvider.currentUser.password) {
                      return 'Password is same as current one!';
                    }
                    return null;
                  }
                  return 'Password must not be empty!';
                },
                obscureText: _obsecureText,
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    widget.newPasswordController.dispose();
    super.dispose();
  }
}
