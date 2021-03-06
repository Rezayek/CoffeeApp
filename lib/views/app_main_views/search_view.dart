//import 'dart:developer';

import 'package:coffee_app/services/search_history_local_database/search_history_database.dart';

import 'package:flutter/material.dart';

import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class SearchView extends StatefulWidget {
  SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  static const historyLength = 5;

  final List<String> _searchHistory = [];

  late List<String> filteredSearchHistory;
  late String selectedTerm;

  late SearchHistoryDatabase _historySearch;

  void getTerms() async {
    final terms = await _historySearch.getAllTerms();
    for (int index = 0; index < terms.length; index++) {
      _searchHistory.add(terms.elementAt(index).searchTerm);
    }
  }

  void deleteTerms() async {
    await _historySearch.deleteAllTerms();
    await _historySearch.createTerms(newTerms: _searchHistory);
  }

  List<String> filterSearchTerms({required String filter}) {
    getTerms();
    if (filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }
    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }
    filteredSearchHistory = filterSearchTerms(filter: '');
    deleteTerms();
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: '');
    
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
    deleteTerms();
  }

  late FloatingSearchBarController controller;
  @override
  void initState() {
    _historySearch = SearchHistoryDatabase();
    controller = FloatingSearchBarController();
    selectedTerm = '';
    filteredSearchHistory = filterSearchTerms(filter: '');
    super.initState();
  }

  @override
  void dispose() {
    
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloatingSearchBar(
        controller: controller,
        body: FloatingSearchBarScrollNotifier(
          child: Container(),
        ),
        transition: CircularFloatingSearchBarTransition(),
        physics: const BouncingScrollPhysics(),
        title: Text(
          selectedTerm,
          style: const TextStyle(fontSize: 22),
        ),
        hint: 'search',
        actions: [
          FloatingSearchBarAction.searchToClear(),
        ],
        onQueryChanged: (query) {
          setState(() {
            filteredSearchHistory = filterSearchTerms(filter: query);
          });
        },
        onSubmitted: (query) {
          setState(() {
            addSearchTerm(query);
            selectedTerm = query;
          });
          controller.close();
        },
        builder: (BuildContext context, Animation<double> transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4,
              child: Builder(builder: (context) {
                if (filteredSearchHistory.isEmpty && controller.query.isEmpty) {
                  return Container(
                    height: 56,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'start searching',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  );
                } else if (filteredSearchHistory.isEmpty) {
                  return ListTile(
                    title: Text(controller.query),
                    leading: const Icon(Icons.search),
                    onTap: () {
                      setState(() {
                        addSearchTerm(controller.query);
                        selectedTerm = controller.query;
                      });
                      controller.close();
                    },
                  );
                } else {

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: filteredSearchHistory
                        .map(
                          (term) => ListTile(
                            title: Text(term),
                            leading: const Icon(Icons.history),
                            trailing: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  deleteSearchTerm(term);
                                });
                                deleteTerms();
                              },
                            ),
                            onTap: () {
                              
                              setState(() {
                                putSearchTermFirst(term);
                                selectedTerm = term;
                              });
                              deleteTerms();
                              controller.clear();
                            },
                          ),
                        )
                        .toList(),
                  );
                }
              }),
            ),
          );
        },
      ),
    );
  }
}
