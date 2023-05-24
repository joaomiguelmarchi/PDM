import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SpeakForMe(),
    );
  }
}

class SpeakForMe extends StatefulWidget {
  const SpeakForMe({super.key});

  @override
  SpeakForMeState createState() => SpeakForMeState();
}

class SpeakForMeState extends State<SpeakForMe> {
  final TextEditingController ttsController = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();

  Future<void> speak(String text, String lang) async {
    print(lang);
    await flutterTts.setLanguage(lang);
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }
  String lang = "pt-BR";

  @override
  Widget build(BuildContext context) {
    final linguagem = lang == 'pt-BR' ? 'Português' : 'English';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Speak for me'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Choose the language:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        lang = "pt-BR";
                      });
                    },
                    child: const Text('PORTGUÊS'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        lang = "en-US";
                      });
                    },
                    child: const Text('ENGLISH'),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 108.0),
              child: Text('Linguagem: $linguagem'),
            ),
            const Text('Type the text to speak:'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                width: 400,
                child: TextField(
                  controller: ttsController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => speak(ttsController.text, lang),
        child: const Text('Speak!'),
      ),
    );
  }
}
