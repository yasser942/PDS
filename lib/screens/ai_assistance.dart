import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gemini_flutter/gemini_flutter.dart';

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
    var snapshot = widget.textData; // Assuming it returns a string
    if (snapshot.isNotEmpty) {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setVolume(0.5);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setPitch(1);
      await flutterTts.speak(snapshot);
      setState(() => _isPlaying = true);
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
      appBar: AppBar(
        title: const Text('AI Assistance'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  AnimatedSwitcher(
                    switchInCurve: Curves.elasticOut,
                    switchOutCurve: Curves.ease,
                    reverseDuration: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 1200),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                    child: loading
                        ? CircularProgressIndicator.adaptive()
                        :  const Center(
                      child: Image(
                        image: AssetImage('assets/Innovation-pana.png'),
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  AnimatedTextKit(

                    onFinished: () {
                      _speak();
                    },
                    animatedTexts: [
                      TypewriterAnimatedText(
                        widget.textData,
                        speed: const Duration(milliseconds: 25),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        cursor: "|",
                        curve: Curves.easeInOut,
                      ),
                    ],
                    totalRepeatCount: 1,
                    pause: const Duration(milliseconds: 1000),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: SizedBox(
              width: 50,
              child: FloatingActionButton(
                onPressed: _isPlaying ? _stop : _speak,
                child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
