import 'package:flutter/material.dart';

class NumericStepButton extends StatefulWidget {
  final int minValue;
  final int maxValue;

  final ValueChanged<int> onChanged;

  NumericStepButton(
      {Key key, this.minValue = 1, this.maxValue = 999, this.onChanged})
      : super(key: key);

  @override
  State<NumericStepButton> createState() {
    return _NumericStepButtonState();
  }
}

class _NumericStepButtonState extends State<NumericStepButton> {

  int counter= 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.remove,
              color: Theme.of(context).accentColor,
            ),
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
            iconSize: 50.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              setState(() {
                if (counter > widget.minValue) {
                  counter--;
                }
                widget.onChanged(counter);
              });
            },
          ),
          Text(
            '$counter',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 28.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: Theme.of(context).accentColor,
            ),
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
            iconSize: 50.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              setState(() {
                if (counter < widget.maxValue) {
                  counter++;
                }
                widget.onChanged(counter);
              });
            },
          ),
        ],
      ),
    );
  }
}