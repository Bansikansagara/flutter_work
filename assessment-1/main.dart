import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Home_Page.dart';

void main()
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      home: Home_Page(),
      debugShowCheckedModeBanner: false,
    );
  }

}