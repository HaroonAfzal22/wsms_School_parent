import 'dart:io';
import 'package:wsms/ChildrenModel.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class LocalDb extends ChangeNotifier {
  int initCount=0;


  void updateCount(int count) {
    initCount = count;
    print('initcount $initCount');
    print('count $count');
    notifyListeners();
  }
}
