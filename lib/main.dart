import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(GeoQuizApp());
}

class GeoQuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoQuiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuestionScreen(),
    );
  }
}

class Question {
  final String text;
  final bool answer;

  Question(this.text, this.answer);
}

class QuestionBank {
  static final List<Question> questions = [
    Question('Canberra is the capital of Australia.', true),
    Question('The Pacific Ocean is larger than the Atlantic Ocean.', true),
    Question(
        'The Suez Canal connects the Red Sea and the Indian Ocean.', false),
    Question('The source of the Nile River is in Egypt.', true),
    Question('The Amazon River is the longest river in the Americas.', true),
    Question('Lake Baikal is the world\'s oldest and deepest freshwater lake.',
        true),
  ];
}

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  Random random = Random();
  int currentQuestionIndex = 0;
  bool cheated = false;

  Question getCurrentQuestion() {
    return QuestionBank.questions[currentQuestionIndex];
  }

  void nextQuestion() {
    setState(() {
      currentQuestionIndex = random.nextInt(QuestionBank.questions.length);
      cheated = false;
    });
  }

  void showCheatScreen() async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheatScreen(answer: getCurrentQuestion().answer),
      ),
    );

    if (result != null && result) {
      setState(() {
        cheated = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Question currentQuestion = getCurrentQuestion();

    return Scaffold(
      appBar: AppBar(
        title: Text('GeoQuiz'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                currentQuestion.text,
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (currentQuestion.answer) {
                  nextQuestion();
                } else {
                  showCheatScreen();
                }
              },
              child: Text('True'),
            ),
            ElevatedButton(
              onPressed: () {
                if (!currentQuestion.answer) {
                  nextQuestion();
                } else {
                  showCheatScreen();
                }
              },
              child: Text('False'),
            ),
            if (cheated) Text('You cheated!', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

class CheatScreen extends StatelessWidget {
  final bool answer;

  CheatScreen({required this.answer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cheat'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'The answer is:',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              answer.toString(),
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('I cheated'),
            ),
          ],
        ),
      ),
    );
  }
}