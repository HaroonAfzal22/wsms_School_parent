import 'dart:io';
import 'package:wsms/ChildrenModel.dart';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class LocalDb {

  LocalDb._privateConstructor();

  static final LocalDb instance = LocalDb._privateConstructor();

  static Database? _database;

  Future<Database> get database async =>_database ??= await _initDatabase();

  Future<Database> _initDatabase() async {

    Directory docxDirectory = await getApplicationDocumentsDirectory();

    String path =join(docxDirectory.path,'children.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate (Database db, int version) async {

    await db.execute('''
    Create TABLE children (
    id  INTEGAR PRIMARY KEY AUTO_INCREMENT,
    st_id  Text,
    avatar  Text,
    name  Text,
    roll_no Text
    )
    ''');
  }
/*

  Future<List<Children>> getChildren ()async {

    return null;
  }
*/


}
