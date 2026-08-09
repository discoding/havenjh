import 'dart:convert';
import 'package:http/http.dart' as http;

class TideService {
  // Tijdelijk voor testen op de Mac.
  // Dit vullen we in met het adres van de Raspberry Pi.
  static const String apiUrl =
      'http://100.123.203.120:5000/api/tides';

  Future<List<Map<String, dynamic>>> getTides() async {
    final response = await http.get(
      Uri.parse(apiUrl),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Tides API fout: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body);

    final getijden = data['getijden'];

    if (getijden == null) {
      throw Exception(
        'Geen getijgegevens ontvangen',
      );
    }

    return List<Map<String, dynamic>>.from(
      getijden,
    );
  }
}