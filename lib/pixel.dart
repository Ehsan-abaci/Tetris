import 'package:flutter/material.dart';

class Pixel extends StatelessWidget {
  const Pixel({Key? key, required this.color})
      : super(key: key);
  final Color color;



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color,borderRadius: BorderRadius.all(Radius.circular(5))),
      margin: const EdgeInsets.all(1),
      child:  Center(
        child: Text(
          "",style: TextStyle(color: Colors.white,fontSize: 8),
        ),
      ),
    );
  }
}
