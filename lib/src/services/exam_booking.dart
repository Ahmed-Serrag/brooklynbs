import 'package:gsheets/gsheets.dart';

class BookExamAPI {
  static const _credentials = r'''
 {
  "type": "service_account",
  "project_id": "gsheet2-335613",
  "private_key_id": "d3f4dfae1aec06d301ea06a89eb1809376fc4cc2",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDNM3S1eunbAkRs\nOkfhkhpVdw5FwsaklindO45nFVu/bjYct9HA7X6vfskPuO//VRRPBQ5SNWtwKhue\nsXgX5UJT9YsWS/8gSsgRO5E4YdGmz+o8cNOeltVjF7navxJ9Oku2To/Hmw7Wrr3F\n9iWK8U4wInROPZIAQ/X8GQktivEL43zJvyx+fF+/M1FT5yi854Km/ixyjhpM4shr\ng8YHnnVfMwyLAL9bz8s4mPL+1n0BAvXWCTDTVw+3HEohoNtFxBKPYt5OpeBbfrOM\n9NS8HTMFFfGCxfqhlIgZ6gQEF8EsAB6mN+jOJsyIvIJNF50tRi2S/x03t5IGrcnB\nBqyUla+/AgMBAAECggEAC2Jzcy4ik1gI28hP/J/SfjNgw1YPF0qNgAyx1d5FfNVs\ngyNfq8iBYtMx7IFiL1RVEB1DsiPslgiAB8no08qQZ4AT+2Sz/uKnPu2DHRGwRAT9\nBeVsmDveEuVaFlzLdc8qLC8novdjV13SgY0qgA7rO5htw3l/BCzBFP9+ltxCi1o2\nMji5ZLOeuxrd1qB7ZQgx22rSoZZOwrxg98Zj4lWafYLj7sNj1c/xU/8sf3GJW+ur\noofPeW6CQj21tj/Fzy5yvY8HZMHVpXN3T6CCC98Y3oZLa1L6UimKG9VpZPPmdfJg\nBu/YtaKb2ryIkvN4za9p7N76ykBXA38lQ6ha5quzIQKBgQD0U/SZEltNo3O5EK/M\nLH10sGFy8zqlZr/eV3BpG8jsY8oxzzv6og3Spyv1FUNHHo2cat4M+7AcL3axNZsC\nEZZzFhQCY4kiMfUs/D5ppPro5F+2z9MqMdrZ8yvHDX2I1kAEPJW5dGJMODAxHM23\nL4E/oihafn6jUe/2mX39Eg3kIwKBgQDXAP3b+2gUu5nKSYfD0KeHFzuzRc7JCEYj\nhQ3BIT0dvnsO//hntCQJwGwctQyJJNmj5ScOWegHeQEhO558ny3E7g8k4ArUviiX\nht5KrSlHMoNmPMcLx5pmhWdpAy8+Hn4QLoAiAoLG6JmaKqcidbpBSFyO0TjX59iG\nosXmfvfBtQKBgQC+8vpfw1PuGodvpFXwOPkXgF24q9UyvVnImAe3bcqazOaSBQc4\nOvyYnKQjF6oL5BoCnBbMiMu7S3D00BNEC6DMcv3SXB4pxmd57+2LPTAHYaxYQJYl\nDO+glIarO6TXk7JWXU8asJW+Qc+QIpW3y/20ULQ+/UtVsszaql0nsrt+hwKBgAmr\n3b97e58TIUPcMuM4C5EkFmdmCHs6iA0o+wlo+VrRKq/uC7p+e/CEW1ifPEUfBzs8\nH5mhqbJMWySnjeWFM4XcP4olGdegBitqwa0SRP0S5J5AtaNuAyABeDldD074CCuq\nK9Fb044nAGHS8Vm3ef1dx+wUtT3hC/hicgyAQZzRAoGAIO75IZ7dm1NbfzavPUIi\nHtczKaBWMVwHIs6+TXAGTNHqzBYMks0fk2kutYDw+GZch/i61KDlHaOtVzQ0w4rk\n4Vn9a1CKxEDwbiVPhE80mDOsEUdIUoam8T798UzdlTnuUqDpLOgIjowjcViYLiib\nFKdXLdNs7/K8gaMDcqOyrio=\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheets2@gsheet2-335613.iam.gserviceaccount.com",
  "client_id": "110514025143622369326",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets2%40gsheet2-335613.iam.gserviceaccount.com"
}
  ''';

  static const _spreadsheetId =
      '15pkRA0e56bE5P4wQhxyttreF3vuptnPMf7o2FPO1YnQ'; // Replace with your spreadsheet ID
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // Initialize Google Sheets
  static Future<void> init() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      _worksheet = await _getWorksheet(spreadsheet, title: 'Book Exam');
      if (_worksheet != null) {
        print('Google Sheets initialized successfully!');
      }
    } catch (e) {
      print('Google Sheets initialization error: $e');
    }
  }

  static Future<Worksheet?> _getWorksheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title);
    }
  }

  // Insert data into Google Sheets
  static Future<void> insertRow(Map<String, dynamic> row) async {
    if (_worksheet == null) return;

    try {
      await _worksheet!.values.map.appendRow(row);
      print('Row inserted successfully!');
    } catch (e) {
      print('Error inserting row: $e');
    }
  }

  static Future insert(List<Map<String, dynamic>> rowList) async {
    if (_worksheet == null) return;

    _worksheet!.values.map.appendRows(rowList);
  }
}
