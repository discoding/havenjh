import 'dart:convert';
import 'package:http/http.dart' as http;

class ScheepvaartMelding {
  final String beperking;
  final int? geldigVanaf;
  final int? geldigTot;
  final int? id;
  final String locatie;
  final String vaarweg;

  ScheepvaartMelding({
    required this.beperking,
    this.geldigVanaf,
    this.geldigTot,
    this.id,
    required this.locatie,
    required this.vaarweg,
  });

  factory ScheepvaartMelding.fromJson(Map<String, dynamic> json) {
    return ScheepvaartMelding(
      beperking: json['beperking'] ?? '',
      geldigVanaf: json['geldigVanaf'],
      geldigTot: json['geldigTot'],
      id: json['id'],
      locatie: json['locatie'] ?? '',
      vaarweg: json['vaarweg'] ?? '',
    );
  }
}

class MessageService {
  static const String baseUrl = 'http://100.123.203.120:5001';
  Future<List<ScheepvaartMelding>> getMessages() async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/messages'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception(
        'Fout bij ophalen scheepvaartberichten: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    final List<dynamic> meldingen = data['meldingen'] ?? [];

    return meldingen
        .map(
          (json) => ScheepvaartMelding.fromJson(
        json as Map<String, dynamic>,
      ),
    )
        .toList();
  }
}