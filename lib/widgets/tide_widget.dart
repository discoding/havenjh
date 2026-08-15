import 'dart:async';

import 'package:flutter/material.dart';
import '../services/tide_service.dart';

class TideWidget extends StatefulWidget {
  const TideWidget({super.key});

  @override
  State<TideWidget> createState() => _TideWidgetState();
}

class _TideWidgetState extends State<TideWidget> {
  final TideService _tideService = TideService();

  Timer? _timer;

  bool loading = true;
  String? error;

  List<Map<String, dynamic>> tides = [];

  @override
  void initState() {
    super.initState();

    loadTides();

// Elk uur opnieuw ophalen.
    _timer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => loadTides(),
    );
  }

  String formatTime(String isoTime) {
    final dateTime = DateTime.parse(isoTime).toLocal();

    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  String formatDay(String isoTime) {
    final dateTime = DateTime.parse(isoTime).toLocal();

    const dagen = [
      'Maandag',
      'Dinsdag',
      'Woensdag',
      'Donderdag',
      'Vrijdag',
      'Zaterdag',
      'Zondag',
    ];

    return dagen[dateTime.weekday - 1];
  }

  String formatHeight(dynamic value) {
    final height = (value as num).toDouble();

    if (height > 0) {
      return '+${height.toStringAsFixed(0)} cm NAP';
    }

    return '${height.toStringAsFixed(0)} cm NAP';
  }

  Future<void> loadTides() async {
    try {
      final result = await _tideService.getTides();

      final now = DateTime.now();

// Tot 3 dagen vooruit.
      final drieDagenLater = now.add(
        const Duration(days: 3),
      );

      final List<Map<String, dynamic>> nieuweTides = [];

      for (final tide in result) {
        final tijdString = tide['tijd']?.toString();
        final type = tide['type']?.toString();

        if (tijdString == null || type == null) {
          continue;
        }

        final tijd = DateTime.parse(tijdString).toLocal();

// Alleen toekomstige getijden.
        if (!tijd.isAfter(now)) {
          continue;
        }

// Maximaal 3 dagen vooruit.
        if (tijd.isAfter(drieDagenLater)) {
          continue;
        }

// Alleen hoog- en laagwater.
        if (type != 'hoogwater' && type != 'laagwater') {
          continue;
        }

        nieuweTides.add(
          Map<String, dynamic>.from(tide),
        );
      }

// Chronologisch sorteren.
      nieuweTides.sort((a, b) {
        final tijdA = DateTime.parse(
          a['tijd'].toString(),
        );

        final tijdB = DateTime.parse(
          b['tijd'].toString(),
        );

        return tijdA.compareTo(tijdB);
      });

      if (!mounted) return;

      setState(() {
        tides = nieuweTides;
        error = null;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildTideRow(Map<String, dynamic> tide) {
    final type = tide['type']?.toString();
    final tijd = tide['tijd']?.toString();
    final hoogte = tide['waterstand_cm_nap'];

    if (tijd == null) {
      return const SizedBox.shrink();
    }

    final bool hoogwater = type == 'hoogwater';

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 85,
            child: Text(
              formatDay(tijd),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 55,
            child: Text(
              formatTime(tijd),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              hoogwater ? '⬆ Hoogwater' : '⬇ Laagwater',
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
          ),
          Text(
            formatHeight(hoogte),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Getijden Kornwerderzand',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (loading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (error != null)
              Text(
                'Fout bij ophalen getijden\n$error',
                style: const TextStyle(
                  color: Colors.red,
                ),
              )
            else if (tides.isEmpty)
              const Text(
                'Geen getijden beschikbaar.',
                style: TextStyle(
                  fontSize: 16,
                ),
              )
            else
              Column(
                children: [
                  for (final tide in tides) _buildTideRow(tide),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
