import 'package:coffee_app/services/search_history_local_database/search_history_constants.dart';

class SearchTermModel {
  final String searchTerm;

  SearchTermModel({required this.searchTerm});

  SearchTermModel.fromRow(Map<String, dynamic?> terms)
      : searchTerm = terms[searchTermColumn] as String;
}
