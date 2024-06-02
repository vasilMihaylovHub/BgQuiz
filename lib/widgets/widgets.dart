import 'package:flutter/material.dart';

Widget appBar(BuildContext context){
  return RichText(
    text: const TextSpan(
      style: TextStyle(fontSize: 26),
      children: <TextSpan>[
        TextSpan(text: 'Bg', style: TextStyle(fontWeight: FontWeight.w500,
        color: Colors.black)),
        TextSpan(text: 'Quiz', style: TextStyle(fontWeight: FontWeight.w500,
        color: Colors.blue)),
      ],
    ),
  );
}


Widget blueButton({required BuildContext context, required String label, double? buttonWidth}) {
  return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(30)
      ),
      alignment: Alignment.center,
      width: buttonWidth ?? MediaQuery.of(context).size.width - 48,
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
}