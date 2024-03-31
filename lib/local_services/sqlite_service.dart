import 'package:flutter/material.dart';
import 'package:shaka/features/chats/model/chat_model.dart';
import 'package:shaka/features/history/model/chat_history_model.dart';
import 'package:shaka/features/image_generator/model/chat_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteService {
  static final SqliteService _singleton = SqliteService._internal();
  late Database _database;

  factory SqliteService() {
    return _singleton;
  }

  SqliteService._internal();

  Future<Database> _getDatabase() async {
    if (_database.isOpen) {
      return _database;
    } else {
      return initializeDB();
    }
  }

  Future<Database> initializeDB() async {
    print("initial");  
    String path = await getDatabasesPath();
    _database = await openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        print('exec');
        await database.execute(
            "CREATE TABLE IF NOT EXISTS chats(id INTEGER PRIMARY KEY AUTOINCREMENT, first_message TEXT, updated_at TEXT, model_name TEXT, img_model TEXT, local TEXT)");
        await database.execute(
            "CREATE TABLE IF NOT EXISTS chat_detail(chat_id INTEGER, role TEXT, content TEXT, created_at TEXT, image_url TEXT, local TEXT)");
      },
      onUpgrade: (database, oldVersion, newVersion) async {
        print("on");
        print(oldVersion);
        if (oldVersion < 10) {
          // await database.execute(
          //   "ALTER TABLE chat_detail ADD COLUMN image_url TEXT"
          // );
          // await database.execute(
          //   "ALTER TABLE chat_detail ADD COLUMN local TEXT"
          // );
        }
      },
      version: 10, // Update versi database di sini
    );
    return _database;
  }

  static Future<void> printChatTableColumns() async {
    final db = await SqliteService()._getDatabase();
    final List<Map<String, dynamic>> columns = await db.rawQuery("PRAGMA table_info(chat_detail)");
    columns.forEach((column) {
      print("Column name: ${column['name']}, Type: ${column['type']}");
    });
  }

  static Future<int> createItem(ChatHistoryModel chat) async {
    final Database db = await SqliteService()._getDatabase();
    final id = await db.insert(
      'chats',
      chat.toMapInsert(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<ChatHistoryModel>> getItems() async {
    // await Future.delayed(Duration(seconds: 2));
    try {
      final db = await SqliteService()._getDatabase();
      final List<Map<String, Object?>> queryResult =
          await db.query('chats', orderBy: 'updated_at DESC');
      return queryResult.map((e) => ChatHistoryModel.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> editItem(ChatHistoryModel updatedChat) async {
    final db = await _singleton._getDatabase();
    try {
      await db.update(
        'chats', 
        updatedChat.toMapInsert(),
        where: 'id = ?',
        whereArgs: [updatedChat.id],
      );
    } catch (err) {
      debugPrint("Something went wrong when editing an item: $err");
    }
  }

  static Future<void> deleteItem(int id) async {
    final db = await SqliteService()._getDatabase();
    try {
      await db.delete("chats", where: "id = ?", whereArgs: [id]);
      await db.delete("chat_detail", where: "chat_id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  // CHAT DETAIL
  static Future<int> createItemDetail(ChatModel chat) async {
    final Database db = await SqliteService()._getDatabase();
    final id = await db.insert(
      'chat_detail',
      chat.toMapInsert(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<ChatModel>> getItemsDetail(int chatId) async {
    try {
      final db = await SqliteService()._getDatabase();
      final List<Map<String, Object?>> queryResult = await db.query(
        'chat_detail',
        where: 'chat_id = ?',
        whereArgs: [chatId],
        orderBy: 'created_at',
      );
      return queryResult.map((e) => ChatModel.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
}
  static Future<List<ChatModel>> getItemsAll() async {
    try {
      final db = await SqliteService()._getDatabase();
      final List<Map<String, Object?>> queryResult = await db.query(
        'chat_detail',
        orderBy: 'created_at',
      );
      return queryResult.map((e) => ChatModel.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
}
  // CHAT DETAIL IMAGE
  static Future<int> createItemDetailImage(ChatModelImage chat) async {
    final Database db = await SqliteService()._getDatabase();
    final id = await db.insert(
      'chat_detail',
      chat.toMapInsert(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<ChatModelImage>> getItemsDetailImage(int chatId) async {
    try {
      final db = await SqliteService()._getDatabase();
      final List<Map<String, Object?>> queryResult = await db.query(
        'chat_detail',
        where: 'chat_id = ?',
        whereArgs: [chatId],
        orderBy: 'created_at',
      );
      return queryResult.map((e) => ChatModelImage.fromMap(e)).toList();
    } catch (e) {
      print(e);
      return [];
    }
}
  static Future<List<ChatModelImage>> getItemsAllImage() async {
    try {
      final db = await SqliteService()._getDatabase();
      final List<Map<String, Object?>> queryResult = await db.query(
        'chat_detail',
        orderBy: 'created_at',
      );
      return queryResult.map((e) => ChatModelImage.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
}


}
