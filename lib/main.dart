import 'package:flutter/material.dart';
import 'home.dart'; // Import your updated home.dart

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),                  
    theme: ThemeData.dark(),          
  ));
}
