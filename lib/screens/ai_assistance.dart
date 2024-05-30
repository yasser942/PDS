import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:music_visualizer/music_visualizer.dart';

class AIAssistance extends StatefulWidget {
  const AIAssistance({super.key, required this.textData});

  final textData;

  @override
  State<AIAssistance> createState() => _AIAssistanceState();
}

class _AIAssistanceState extends State<AIAssistance> {
  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  final List<Color> colors = [
    const Color(0xFFDB4437), // Google Red
    const Color(0xFF4285F4), // Google Blue
    const Color(0xFFF4B400), // Google Yellow
    const Color(0xFF0F9D58), // Google Green
  ];

  final List<int> duration = [900, 700, 600, 800, 500];

  FlutterTts flutterTts = FlutterTts();
  bool _isPlaying = false;

  void textToSpeech(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setVolume(0.5);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  void _speak() async {
    var snapshot = widget.textData;
    snapshot = snapshot!.replaceAll('*', '');
    if (snapshot.isNotEmpty) {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setVolume(0.5);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setPitch(1);
      await flutterTts.speak(snapshot);
      setState(() => _isPlaying = true);
      flutterTts.setCompletionHandler(() {
        setState(() => _isPlaying = false);
      });
    }
  }

  void _stop() async {
    await flutterTts.stop();
    setState(() => _isPlaying = false);
  }

  bool loading = true;

  @override
  void didChangeDependencies() {
    Future.delayed(const Duration(seconds: 1)).then((_) {
      setState(() {
        loading = false;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text('Gemini Recommendations'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Play/Stop',
          mini: true,
          onPressed: () {
            if (_isPlaying) {
              _stop();
            } else {
              _speak();
            }
          },
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Icon(_isPlaying ? Icons.stop : Icons.play_arrow,
              color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25), // Rounded corners
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset('assets/gemini.png',
                      height: 200, width: 200, fit: BoxFit.cover),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MarkdownBody(
                  data: widget.textData,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(fontSize: 16, color: Colors.black),
                    h1: const TextStyle(fontSize: 24, color: Colors.black),
                    h2: const TextStyle(fontSize: 22, color: Colors.black),
                    h3: const TextStyle(fontSize: 20, color: Colors.black),
                    h4: const TextStyle(fontSize: 18, color: Colors.black),
                    h5: const TextStyle(fontSize: 16, color: Colors.black),
                    h6: const TextStyle(fontSize: 14, color: Colors.black),

                  ),

                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Visibility(
          visible: _isPlaying,
          child: Container(
            margin: const EdgeInsets.all(10),
            height: 25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            child: MusicVisualizer(
              barCount: 30,
              colors: colors,
              duration: duration,
            ),
          ),
        ));
  }
}
