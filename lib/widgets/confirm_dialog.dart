import 'package:flutter/material.dart';

class Confirm extends StatefulWidget {
  final String message;
  final void Function() onConfirm;
  const Confirm({Key? key, required this.message, required this.onConfirm})
      : super(key: key);

  @override
  State<Confirm> createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: 300.0,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.message,
                      style:
                          TextStyle(fontSize: 16.0, color: Colors.grey[800])),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.red, fontSize: 18.0),
                          )),
                      TextButton(
                          onPressed: widget.onConfirm,
                          child: Text(
                            'Confirm',
                            style: TextStyle(fontSize: 18.0),
                          )),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
