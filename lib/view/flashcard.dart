import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'index_home.dart';



class FlashcardScreen extends StatelessWidget {
  final Vocabulary vocabulary;

  const FlashcardScreen({Key? key, required this.vocabulary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(vocabulary.engVocabulary),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FlipCard(
            direction: FlipDirection.HORIZONTAL, // Hướng lật ngang
            front: Card(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    vocabulary.engVocabulary,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            back: Card(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    vocabulary.vnVocabulary,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
