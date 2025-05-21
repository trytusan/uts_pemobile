import 'package:flutter/material.dart';
import 'package:uts_aplication/ui_planease/dashboard_planease.dart';
import 'package:uts_aplication/ui/dashboard_petani.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: PagePetani(),
    );
  }
}
