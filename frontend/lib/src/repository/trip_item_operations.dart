import 'dart:convert';

import 'package:trip_planner/src/models/trip.dart';
import 'package:trip_planner/src/models/trip_item.dart';
import 'package:trip_planner/src/repository/database.dart';

class TripItemOperations {
  late TripItemOperations contactOperations;

  final dbProvider = DatabaseRepository.instance;

  Future<int> createTripItem(TripItem item) async {
    final db = await dbProvider.database;
    print('item inserted');
    return db!.insert('tripitem', item.toMap());
  }

  updateTripItem(TripItem item) async {
    final db = await dbProvider.database;
    db!.update('tripitem', item.toMap(),
        where: "itemId=?", whereArgs: [item.itemId]);
  }

  deleteTripItem(TripItem item) async {
    final db = await dbProvider.database;
    await db!.delete('tripitem', where: 'itemId=?', whereArgs: [item.itemId]);
  }

  Future<List<TripItem>> getAllTripItemsByTripId(int tripId) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await db!.rawQuery('''
    SELECT * FROM tripitem 
    WHERE tripitem.FK_tripItem_trip = ${tripId} ORDER BY no ASC
    ''');
    List<TripItem> items =
        allRows.map((item) => TripItem.fromMap(item)).toList();
    return items;
  }

  // Future<List<Contact>> searchContacts(String keyword) async {
  //   final db = await dbProvider.database;
  //   List<Map<String, dynamic>> allRows = await db!
  //       .query('contact', where: 'contactName LIKE ?', whereArgs: ['%$keyword%']);
  //   List<Contact> contacts =
  //   allRows.map((contact) => Contact.fromMap(contact)).toList();
  //   return contacts;
  // }
}

//WHERE name LIKE 'keyword%'
//--Finds any values that start with "keyword"
//WHERE name LIKE '%keyword'
//--Finds any values that end with "keyword"
//WHERE name LIKE '%keyword%'
//--Finds any values that have "keyword" in any position
