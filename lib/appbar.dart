import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


Widget newsappBar(String text, VoidCallback func, double height, double width) {
  return Padding(
    padding: const EdgeInsets.only(top: 15),
    child: Container(
      width: width,
      height: height * 0.09,
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color.fromARGB(255, 47, 235, 248),
              )),
            ),
          ],
        ),
      ),
    ),
  );
}