import 'package:flutter/material.dart';

const textDecoration = InputDecoration(
  fillColor: Color(0xFFFAF4F4),
  filled: true,
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
    borderSide: BorderSide(color: Colors.white, width: 1.0),
  ),

  // border: OutlineInputBorder(
  //   borderRadius: const BorderRadius.all(
  //     const Radius.circular(10.0),
  //   ),
  // )
);
