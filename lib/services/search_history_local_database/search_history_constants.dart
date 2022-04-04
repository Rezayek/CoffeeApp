const String dbSearchName = 'searchhistory.db';

const String searchTermsTable = 'searchterms';

const String searchTermColumn = 'term';

const String createSearchTermTable = '''
            CREATE TABLE IF NOT EXISTS "searchterms"(
              "term"  TEXT NOT NULL,
              PRIMARY KEY("term")
            );''';