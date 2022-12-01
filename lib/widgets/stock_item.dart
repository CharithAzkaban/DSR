import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StocktItem extends StatefulWidget {
  final DateTime date;
  final List items;
  final void Function() onTap;
  const StocktItem({
    Key? key,
    required this.date,
    required this.items, required this.onTap,
  }) : super(key: key);

  @override
  State<StocktItem> createState() => _StocktItemState();
}

class _StocktItemState extends State<StocktItem> {
  @override
  Widget build(BuildContext context) {
    ShapeBorder _shapeBorder = RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10)));

    return Material(
      shape: _shapeBorder,
      elevation: 2.0,
      child: ListTile(
        title: Text(
          DateFormat('EEEE, dd MMMM yyyy').format(widget.date),
          style: TextStyle(
              color: Colors.grey[700],
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
        trailing: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 27.0,
            minHeight: 27.0,
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(50.0))),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                widget.items.length.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              DateFormat('hh:mm:ss a').format(widget.date),
              style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 20,
            ),
            DateFormat('yyyyMMdd').format(widget.date) ==
                    DateFormat('yyyyMMdd').format(DateTime.now())
                ? Text(
                    'TODAY',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  )
                : Container(),
          ],
        ),
        onTap: widget.onTap,
        shape: _shapeBorder,
      ),
    );
  }
}
