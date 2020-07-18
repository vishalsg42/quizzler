import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzler/quizbrain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(QuizApp());

QuizBrain quizBrain = QuizBrain();

class QuizApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10.0, bottom: 10.0, right: 10.0),
            child: QuizHomePage(),
          ),
        ),
      ),
    );
  }
}

class QuizHomePage extends StatefulWidget {
  @override
  _QuizHomePageState createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  List<Icon> scoreKeeper = [];

  void resetApp() {
    setState(() {
      quizBrain.reset();
      scoreKeeper = [];
      print(scoreKeeper);
    });
  }

  void generateBadge() {}

  void checkAnswer(bool userPickedAnswer) {
    if (quizBrain.isFinished()) {
      Alert(
        context: context,
        title: 'Finished!',
        desc: 'Quiz is completed.',
        style: AlertStyle(
//          animationType: AnimationType.fromTop,
          isCloseButton: true,
          isOverlayTapDismiss: false,
        ),
        closeFunction: () {
          resetApp();
        },
        buttons: [
          DialogButton(
            child: Text('Cancel'),
            onPressed: () {
              resetApp();
              Navigator.pop(context);
            },
          ),
        ],
      ).show();
    } else {
      bool correctAnswer = quizBrain.getQuestionAnswer();
      setState(() {
        if (correctAnswer == userPickedAnswer) {
          scoreKeeper.add(
            Icon(
              Icons.check,
              color: Colors.green,
            ),
          );
        } else {
          scoreKeeper.add(
            Icon(
              Icons.close,
              color: Colors.red,
            ),
          );
        }

        quizBrain.nextQuestion();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: RaisedButton(
              onPressed: () {
                checkAnswer(true);
              },
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: RaisedButton(
              onPressed: () {
                checkAnswer(false);
              },
              textColor: Colors.white,
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        ),
//        Expanded(
//          child: Row(
//            children: scoreKeeper,
//          ),
//        )
      ],
    );
  }
}
