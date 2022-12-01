import 'package:flutter/material.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatefulWidget {
  const QuizApp({Key? key}) : super(key: key);

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  final List<QuizModel> _quizes = [
    QuizModel(question: 'System.out.println serve para?', anwsers: [
      AwnserModel(value: 'Chamar a saida padrao do sistema.'),
      AwnserModel(value: 'Redirecinar o buffer de dados para a saida padrao.'),
      AwnserModel(value: 'Imprimir um fluxo de dados na linguagem java.'),
      AwnserModel(
        value: 'Todas as alteranativas estao corretas.',
        isCorrect: true,
      ),
    ]),
    QuizModel(question: 'Linus Torvalds desenvolve?', anwsers: [
      AwnserModel(value: 'Kernel do Linux.', isCorrect: true),
      AwnserModel(value: 'Kernel do Windows.'),
      AwnserModel(value: 'Kernel do IOS.'),
      AwnserModel(value: 'Kernel do Android.'),
    ]),
    QuizModel(question: 'Sprint é um termo usado em?', anwsers: [
      AwnserModel(value: 'Engenharia de Software.'),
      AwnserModel(value: 'Metodologias Ageis.'),
      AwnserModel(value: 'No sistema SCRUM.', isCorrect: true),
      AwnserModel(value: 'Termo em ingles para corrida.'),
    ]),
  ];

  int points = 0;
  int actualQuestion = 0;
  AwnserModel? _radioAwnser;

  void _awnser() {
    if (_radioAwnser != null && _radioAwnser!.isCorrect) {
      points++;
    }
  }

  void _nextQuestion() {
    _awnser();
    setState(() {
      if (actualQuestion < _quizes.length) {
        actualQuestion++;
        _resetRadioAwnser();
      }
    });
  }

  void _resetRadioAwnser() => _radioAwnser = null;

  void _resetPoints() => points = 0;

  void _resetActualQuestion() => actualQuestion = 0;

  bool _disableNextButtton() => _radioAwnser == null;

  void _restart() {
    setState(() {
      _resetRadioAwnser();
      _resetPoints();
      _resetActualQuestion();
    });
  }

  bool _isOverQuestions() => actualQuestion == _quizes.length;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
          centerTitle: true,
        ),
        body: Center(
          child: _isOverQuestions()
              ? FinishScreen(
                  pontuacao: points,
                  reiniciar: _restart,
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 15.0,
                        ),
                        child: Text(
                          _quizes[actualQuestion].question,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        children: _quizes[actualQuestion]
                            .anwsers!
                            .map((e) => Row(
                                  children: [
                                    Radio(
                                        value: e,
                                        groupValue: _radioAwnser,
                                        onChanged: (newValue) {
                                          setState(() {
                                            _radioAwnser = newValue;
                                          });
                                        }),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _radioAwnser = e;
                                        });
                                      },
                                      child: Text(e.value),
                                    )
                                  ],
                                ))
                            .toList(),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed:
                                  _disableNextButtton() ? null : _nextQuestion,
                              child: const Text('Responder'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class FinishScreen extends StatelessWidget {
  final void Function() reiniciar;
  final int pontuacao;

  const FinishScreen({
    required this.pontuacao,
    required this.reiniciar,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/undraw_winners.png"),
        const Text(
          'Todas as perguntas foram respondidas.',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Sua pontuacao final foi de $pontuacao.",
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        OutlinedButton(
          onPressed: reiniciar,
          child: const Text('Reiniciar'),
        )
      ],
    );
  }
}

class QuizModel {
  String question;
  List<AwnserModel>? anwsers;

  QuizModel({required this.question, this.anwsers});
}

class AwnserModel {
  String value;
  bool isCorrect;

  AwnserModel({required this.value, this.isCorrect = false});
}
