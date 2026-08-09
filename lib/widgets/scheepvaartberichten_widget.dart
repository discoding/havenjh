import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ScheepvaartberichtenWidget extends StatefulWidget {
  const ScheepvaartberichtenWidget({super.key});

  @override
  State<ScheepvaartberichtenWidget> createState() =>
      _ScheepvaartmededelingenWidgetState();
}

class _ScheepvaartmededelingenWidgetState
    extends State<ScheepvaartberichtenWidget> {
  final ScrollController _scrollController = ScrollController();

  Timer? _scrollTimer;
  Timer? _reloadTimer;

  List<dynamic> _meldingen = [];
  bool _loading = true;
  double _scrollProgress = 0.0;

// Raspberry Pi / Tailscale
  static const String apiUrl = 'http://100.123.203.120:5001/api/messages';

  @override
  void initState() {
    super.initState();

    _loadMeldingen();

// Berichten regelmatig opnieuw ophalen
    _reloadTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _loadMeldingen(),
    );

    _scrollController.addListener(_updateScrollProgress);
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _reloadTimer?.cancel();
    _scrollController.removeListener(_updateScrollProgress);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateScrollProgress() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    if (position.maxScrollExtent <= 0) {
      if (_scrollProgress != 0) {
        setState(() {
          _scrollProgress = 0;
        });
      }
      return;
    }

    final progress =
        (position.pixels / position.maxScrollExtent).clamp(0.0, 1.0);

    if ((progress - _scrollProgress).abs() > 0.001) {
      setState(() {
        _scrollProgress = progress;
      });
    }
  }

  Future<void> _loadMeldingen() async {
    try {
      final response = await http
          .get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final data = jsonDecode(response.body);

      final List<dynamic> nieuweMeldingen =
          List<dynamic>.from(data['meldingen'] ?? []);

// DELAY verwijderen
      nieuweMeldingen.removeWhere(
        (melding) => melding['beperking'] == 'DELAY',
      );

      if (!mounted) return;

      setState(() {
        _meldingen = nieuweMeldingen;
        _loading = false;
      });

      _startAutoScroll();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  void _startAutoScroll() {
    _scrollTimer?.cancel();

    if (_meldingen.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;

      if (_scrollController.position.maxScrollExtent <= 0) return;

      _scrollTimer = Timer.periodic(
        const Duration(milliseconds: 80),
        (_) {
          if (!mounted || !_scrollController.hasClients) return;

          final position = _scrollController.position;

          if (position.pixels >= position.maxScrollExtent - 1) {
            _scrollController.jumpTo(0);
          } else {
            _scrollController.jumpTo(
              position.pixels + 1.0,
            );
          }
        },
      );
    });
  }

  String _beperkingTekst(String? code) {
    switch (code) {
      case 'OBSTRU':
        return 'Obstakel / stremming';
      case 'NOSERV':
        return 'Geen bediening';
      case 'CLEHEI':
        return 'Doorvaarthoogte beperkt';
      case 'VESDRA':
        return 'Diepgang beperkt';
      case 'WAVWAS':
        return 'Waterstand / vaarweg beperkt';
      case 'AVADEP':
        return 'Afvaart beperkt';
      case 'NOLIM':
        return 'Beperking';
      case 'NOSHORE':
        return 'Geen walvoorziening';
      case 'PASSIN':
        return 'Passage beperkt';
      case 'OVRTAK':
        return 'Oversteek beperkt';
      case 'ANCHOR':
        return 'Ankeren beperkt';
      case 'CAUTIO':
        return 'Let op';
      case 'SERVIC':
        return 'Beperkte dienstverlening';
      default:
        return code ?? 'Melding';
    }
  }

  IconData _iconVoorMelding(String? code) {
    switch (code) {
      case 'OBSTRU':
        return Icons.block;
      case 'NOSERV':
        return Icons.build;
      case 'CLEHEI':
        return Icons.height;
      case 'VESDRA':
        return Icons.water;
      case 'WAVWAS':
        return Icons.waves;
      case 'AVADEP':
        return Icons.directions_boat;
      case 'NOSHORE':
        return Icons.warning;
      default:
        return Icons.warning_amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Scheepvaartmededelingen',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (_loading)
              const Padding(
                padding: EdgeInsets.all(12),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_meldingen.isEmpty)
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Geen relevante scheepvaartmededelingen',
                  style: TextStyle(fontSize: 16),
                ),
              )
            else
              SizedBox(
                height: 220,
                child: ClipRect(
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _meldingen.length,
                    itemBuilder: (context, index) {
                      final melding = _meldingen[index];

                      final String vaarweg =
                          melding['vaarweg']?.toString() ?? '';

                      final String locatie =
                          melding['locatie']?.toString() ?? '';

                      final String beperking =
                          melding['beperking']?.toString() ?? '';

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              _iconVoorMelding(beperking),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '${_beperkingTekst(beperking)}: ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: vaarweg,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (locatie.isNotEmpty)
                                      TextSpan(
                                        text: ' – $locatie',
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            if (_meldingen.length > 1) ...[
              const SizedBox(height: 8),

// Scroll-indicator
              Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _meldingen.isEmpty ? 0 : 0.25,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 4),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${_scrollProgress * 100 ~/ 1}%',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
