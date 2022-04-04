import 'dart:developer';

import 'package:coffee_app/services/search_history_local_database/search_history_constants.dart';
import 'package:coffee_app/services/search_history_local_database/search_history_exceptions.dart';
import 'package:coffee_app/services/search_history_local_database/search_history_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

class SearchHistoryDatabase {
  Database? _db;

  List<SearchTermModel> _terms = [];

  static final _shared = SearchHistoryDatabase._sharedInstance();
  SearchHistoryDatabase._sharedInstance();
  factory SearchHistoryDatabase() => _shared;

  Future<Iterable<SearchTermModel>> getAllTerms() async {
    await _ensureDbIsOpen();
    final db = _getDatabase();
    final terms = await db.query(searchTermsTable);
    log('get');
    return terms.map((term) => SearchTermModel.fromRow(term));
  }

  Future<void> deleteAllTerms() async {
    await _ensureDbIsOpen();
    final db = _getDatabase();

    try {
      log('deleted');
      await db.delete(searchTermsTable);
      log('deleted');
    } catch (e) {
      throw SearchDatabaseDoesNotExists();
    }
  }

  Future<void> createTerms({required List<String> newTerms}) async {
    await _ensureDbIsOpen();
    final db = _getDatabase();
     log('here');
    try {
      for (int index = 0; index < newTerms.length; index++) {
        log('add-1');
        await db.insert(searchTermsTable, {searchTermColumn: newTerms[index]});
        log('add-2');
      }
    } catch (e) {
      throw SomethingWrongException();
    }
  }

  Database _getDatabase() {
    final db = _db;
    if (db == null) {
      throw SearchDatabaseIsAlreadyclosed();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;

    if (db == null) {
      throw SearchDatabaseIsAlreadyclosed();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } catch (e) {
      throw SearchDatabaseIsAlreadyOpen();
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw SearchHistoryDatabase();
    }

    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbSearchName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createSearchTermTable);
    } catch (e) {
      throw EnableTocreateSearchHistory();
    }
  }
}
