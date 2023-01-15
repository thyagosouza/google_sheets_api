import 'package:gsheets/gsheets.dart';

import '../../model/user.dart';

class UserSheetsApi {
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "gsheets-374722",
  "private_key_id": "93da41cc74d4321956945ee9c8c8bd06d14a7bb5",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDKw4XuGc3Pb5xk\nD6AApO6qzrk6l+qYmxzaCUQIbphIJt23DkP4pWnxu/O8K3nDkwtSuZBlvIT844xj\ndAjz7MGrg0FFqFHbxNo3bMG5Ct70rsqPciQQgAdm6Y9joizbQtCPIeAKZrIx+Px1\nTW3tsIaYCZTgdtO5QqeU8iesHQppIne5i4Za2x5SMbJnimsr9CPKZltkV4+oTeaZ\nmaR/11o4Gn8mB17oaOA/k7U6TmNPfym0SagsyPln2VwgULzgsQLI7wP3AKPHjXrp\n78NENX08nKQXzvYDDTD5pmsSBYBXflj1Cqy885LWNPEbbVXK18uCwOVrQvdlnUT/\nduzvKcFhAgMBAAECggEAXaIc3u8bk4c++RYeFS4U6Nu9vckZlI9Mq4NL33jy6Z7J\nFBeKW/BHFFJvI54QBLiKqhD3FYQRBZcu5V5YJAxZAxMBuWEZLBujiaS3cPQMMYHm\nGIflD5mP0X5ZsPDbNgWMugwyoZr6/wizzJeNBA5YmS0TivRUoWCecrHAkEJ45EMr\nkOtqpCwfw6iA7zm/nqacEO6TFJ4qcLPxfgssmDriooxK+fDm3nSjH0tyUN+RxrRH\nnV3U5ZA/XicmK69z1VOKNeEHJMCX+hrZvKtI51ZiqNaXDVpNlVrdTYzhYzZa1Wpn\nw1blh6H7eoZNTKodzqR4fq5vzpw9vvAzFDAeYzVo4QKBgQDzqOYVBqfXkrQJGaoQ\n0nqu4Ux4RUFEyEkCEN6BgXzI40EjsgBXvZA0SGMkASRxfKvuJZUVlGXE69Aemnvt\ns8FN6FtBPwGPxMDYHUiSbS3lzYiG3xKCx4215MAgpu9Z10POyFw+KlyIQLHSWbe6\nvSa+Tx9v1yGcAKZ0OwrJ1xq/ZwKBgQDVCGYj2VHl6ZR+zxsImXBMT825I2hRYY4t\nzh9Eh5hlGKF7V16nwafeE5+rcXNHGpKwRrmPqByDvbCN9bY52j9cA1Uwoq6lEzgz\nWV3bFBM2zllXuUzEk3d5HZxVyUl2L4U0dEnu0mh1D3DIYhhRJnCiy8O2tAlup13t\n5XyPNFAj9wKBgQCasqxJwy0DEDBf6rxv68Jaj85mOcojqmm39w/d92FLhgVQbW4M\nRt1sZF0VeegyaW4bSB8sUUh/yxwaogh2tX7QQOrXNPJ/3fJ2A7mUxd6zHVhGEREG\nmT3eszpMQNCMIMD7Y3g1O939391GaRHebMNRZpjWACdljYAhIW9LENf5lwKBgHMs\nn0wyajzLFCWbAxqbGkOnwameov+cpqnNDsqWJKZDsspkaiB4arF+Go0uQQzoKPZ0\nxk4MrZ3sKFAXz/VnMWolwyEQUyucQH5CiqOvLtQqq9Lps79zmtw4ThVzRexHtNSv\nKmmcCC2Bs5AiuNLm3W6mi6FzpMXWZsn/kGA8ADfxAoGBAMHlG5h3taIo+Mo7u5BK\nMzyG8swrlHwdAX/kTgnzkBqEyK116KWeVWyo76iGIkYT0LjjDCuSZTyxm00Ed9Ma\ncBkImQyWSTwnJVlTXCYC8kaIGHZ1pJecfnSqmvPv7imTs0kxnxOqojDNzrUG43Vm\nVx4t/5TQWQoqxWe9CcZffWkL\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheets@gsheets-374722.iam.gserviceaccount.com",
  "client_id": "104342731874285746650",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40gsheets-374722.iam.gserviceaccount.com"
}
''';
  static final _spreadsheetId = '1YtwKcn-0cbfKN_WhwsZbKO7XR53M4L-WTlkZSVOnWjk';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _userSheet;

  static Future init() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      _userSheet = await _getWorkSheet(spreadsheet, title: 'Users');

      final firstRow = UserFields.getFields();
      _userSheet!.values.insertRow(1, firstRow);
    } catch (e) {
      print('Init Error: $e');
    }
  }

  static Future<Worksheet> _getWorkSheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future<int> getRowCount() async {
    if (_userSheet == null) return 0;

    final lastRow = await _userSheet!.values.lastRow();
    return lastRow == null ? 0 : int.tryParse(lastRow.first) ?? 0;
  }

  static Future insert(List<Map<String, dynamic>> rowList) async {
    if (_userSheet == null) return;
    _userSheet!.values.map.appendRows(rowList);
  }
}
