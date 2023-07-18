import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';

import '../user.dart';

class DataProvider with ChangeNotifier {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "gsheets-362709",
  "private_key_id": "4c6ee55dfb60a8108033327183737120e8aa3ac8",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCvq5GbiaaYKMpD\nFeL1pZZvtwkAcSUDDyO1kM9U8lBkfHDnv/Kh3GaC40d4ReEjJ5PXcxnufRCxaDcc\nTj1LAWxxzYRkODGoFuwEzvp+5uW90hin3SVNsqmEs33aHwTl77KoYURMORqGkfjm\naHm0P2Fjzo6Zft9UWYvhGHGY3+Kk2eSsbd0n9CV2MxIKqTQpIbkQ1QQu66sIo2ml\nQlhhCa7YQdwSeW+0OkoAAzoph8sdn3Tj9Ve5sJ3afqC4Hl3+v7pr5yyJZyFhE0HM\nfWVjeI8lfHZXWf6HcxjO+qmw0+R+C81T+ki5Ee7Xem3Xu+NUQaYQjLFiOLUDTXhK\nm2SR8pNlAgMBAAECggEAHBR46yuS314fzJ7mPz1XgWZ40CMF10oXe2mZFptAGfvh\nQU4nntNf6HqjfThwTyH/qg/6PGqt3SnLK2FfP0rMNpmzGKD54QQ++FrMZDYM0a2Q\nZt683IFbQvy8+H1+VzHcNTmNBQEYuhuBtXTMRXFfJCjLlwIWeUFyEEpLuDPLYu20\nBVJkZyqn9HhQMcCho6jGTow7xuUnelrJ3erVl+CQjPJax2Zc2KLv6OUDTa0COigO\nVcTlJr5R9LnA7lmNW3onTiv7qoA6JpniI6W732NcbNzsKS+WRUXme7C4dHjkkDlP\nZXM3mai1nNUt/8RWErmuL0eRsiQi7j2P+WdZ3sG5KQKBgQDzVqsLR3Dux3sPHutc\nuVm+fnfX4qMRgaOKt4wfLYdoKbX+OkTECXMaZ39rKMLF+LAFY2ON+HVatWoi7XQ8\nSL6p1dUj9sz4EsjoyA4fupa7cgQZGjQsLMcPYLRVQkeJAMJqbpmi6HB7T7hAebv/\nQy5MXw4E4+ZGcEUd3VdKLa3/6QKBgQC4z4pv8VYUtJCjhZRGtIghfhxIqRk2bWnD\nzEt8nNk4UYcaFSYt5mw9tNPWErFjE9veFe/6VTy8YjxQe3HwXwNMzeDekkAeOkgO\nlI0Y8tFfeKpR3FCLoTNEYK0ryBjBY/Xcy6qntj4xMzjw4T0OM4zw2H8udWTsVQj+\n3eoZf0AmHQKBgQCjV5IJSDNulUjtpXuoCmNLk+kuaVu87KCzBPJyG0XBjf40YTi3\nvwAcwUyuyfW0nnLJqyWwrw9XjF9qgqp7rPkPWBJyycBc5X8nguK4Oa/ks2w8zXIo\nFQaqM+fZM1yBgpj+iK9ow059981euliPyLDTYxst/S0eK0659VIa4P7jwQKBgA6A\nCiaaUtyxBiAuXOHnTD8EfAefbOD+WKwKHWobjFeE3grH2gUD7T4yL+S99rkFV9zm\n77s+cNN/Cahu5xOrAMFH7frIkstMW1b5hNCOTKsm9oYRuSgbb8BPrYaf3oFd7G50\ndGFQRTTrBe6wXW/9z3MeKWxlvZNlYJ1OoA18FHZpAoGAAxAt4/bM3GN/mfrnpHRd\n3tyQKxa3d+ZWbeLctsDShHTS9rr5G7M+h4jfWQLyzh8jnAXGs9rubdtcfKjAXfS3\nmMAeyhJS1aeBW6Q451VZHy+xk84tHoMX+UCvZrzuSQKq8zB5oERr/mhMxbjGznlo\n5teDdtn4Hqo5dXBU7BktokI=\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheets@gsheets-362709.iam.gserviceaccount.com",
  "client_id": "103941031928699738279",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40gsheets-362709.iam.gserviceaccount.com"
}

  ''';
  final _spartsheetid = '1m_4XchqNLsqgEJhM9TJaqwzLq4njRpW_b0UEOMcjCOo';
  final _spartsheetid2 = '1FRDmUYkf0i4r0SPW0UNI3UYNNi1VJmwBCIYeu8lB9Wk';

  final _gsheets = GSheets(_credentials);
  List<List<dynamic>> rowData = [];
  final sheetTitle2 = 'July';
  final sheetTitle = '2023';

  String entry = '';
  String cost = '';
  String bal = '';
  Worksheet? _usersheet;
  init() {
    _allrowData();
    _balance();
    _expense();
    _have();
  }

  bool get hasLoaded =>
      cost.isNotEmpty &&
      entry.isNotEmpty &&
      bal.isNotEmpty &&
      rowData.isNotEmpty;

  inite() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(_spartsheetid);
      _usersheet = await _getWorksheet(spreadsheet, title: '2023');
      final firstrow = Userfields.getfields();
      _usersheet!.values.insertRow(1, firstrow);
    } catch (e) {
      return e;
    }
  }

  _getWorksheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  insert(List<Map<String, dynamic>> rowlist) async {
    if (_usersheet == null) return;
    _usersheet!.values.map.appendRows(rowlist);
    notifyListeners();
  }

  insertData(List<dynamic> data) async {
    final ss = await _gsheets.spreadsheet(_spartsheetid);
    final sheet = ss.worksheetByTitle(sheetTitle);

    await sheet?.values.appendRow(data);
  }

  _allrowData() async {
    final ss = await _gsheets.spreadsheet(_spartsheetid);
    final sheet = ss.worksheetByTitle(sheetTitle);
    final data = await sheet?.values.allRows();

    rowData = data!;
    notifyListeners();
  }

  _have() async {
    final ss = await _gsheets.spreadsheet(_spartsheetid);
    final sheet = ss.worksheetByTitle(sheetTitle);
    final value = await sheet?.values.value(column: 7, row: 1);

    entry = value.toString();
    notifyListeners();
  }

  _expense() async {
    final ss = await _gsheets.spreadsheet(_spartsheetid);
    final sheet = ss.worksheetByTitle(sheetTitle);
    final value = await sheet?.values.value(column: 8, row: 1);

    cost = value.toString();
    notifyListeners();
  }

  _balance() async {
    final ss = await _gsheets.spreadsheet(_spartsheetid);
    final sheet = ss.worksheetByTitle(sheetTitle);
    final value = await sheet?.values.value(column: 9, row: 1);

    bal = value.toString();
    notifyListeners();
  }

  String formatCurrency(double value) {
    final format = NumberFormat.decimalPattern('en_US');
    return format.format(value);
  }
}
