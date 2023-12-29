import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizForm extends StatefulWidget {
  final int selectedCategory;

  const QuizForm({Key? key, required this.selectedCategory}) : super(key: key);

  @override
  _QuizFormState createState() => _QuizFormState();
}

class _QuizFormState extends State<QuizForm> {
  List<Map<String, dynamic>> quizQuestions = [];
  int currentQuestionIndex = 0;
  List<int> correctlyAnswered = []; // Track correctly answered questions
  List<int> answeredQs = [];

  @override
  void initState() {
    super.initState();
    fetchQuizQuestions();
  }

  Future<void> fetchQuizQuestions() async {
    final url =
        'https://opentdb.com/api.php?amount=5&category=${widget.selectedCategory}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        if (decodedData['results'] != null) {
          setState(() {
            quizQuestions = List<Map<String, dynamic>>.from(
              decodedData['results'],
            );
            shuffleAnswers();
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void shuffleAnswers() {
    for (var question in quizQuestions) {
      List<String> answers = [];
      answers.add(question['correct_answer'] ?? '');
      answers.addAll(question['incorrect_answers']?.cast<String>() ?? []);
      answers.shuffle();
      question['shuffled_answers'] = answers;
    }
  }

  void answerQuestion(int answerIndex) {
    setState(() {
      quizQuestions[currentQuestionIndex]['selected_answer'] = answerIndex;
      if (isAnswerCorrect(answerIndex)) {
        correctlyAnswered.add(currentQuestionIndex);
      }
      answeredQs.add(currentQuestionIndex);
    });
    if (currentQuestionIndex < quizQuestions.length - 1) {
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          currentQuestionIndex++;
        });
      });
    } else {
      //saveUserScore(); // Save user score when quiz is completed
    }
  }

  bool isAnswerCorrect(int selectedAnswerIndex) {
    return selectedAnswerIndex ==
        quizQuestions[currentQuestionIndex]['shuffled_answers']
            ?.indexOf(
          quizQuestions[currentQuestionIndex]['correct_answer'],
        );
  }

  int calculateScore() {
    return correctlyAnswered.length;
  }

  Future<void> saveUserScore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        CollectionReference userScores = users.doc(user.uid).collection('scores');

        // Query the scores collection for the current category
        QuerySnapshot querySnapshot = await userScores
            .where('category', isEqualTo: widget.selectedCategory)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // If a document exists, update its data
          querySnapshot.docs.forEach((doc) async {
            await doc.reference.update({
              'user_id': user.uid,
              'category': widget.selectedCategory,
              'score': calculateScore(),
            });
            print('User score updated in Firestore!');
          });
        } else {
          // If no document exists, create a new one
          await userScores.add({
            'user_id': user.uid,
            'category': widget.selectedCategory,
            'score': calculateScore(),
          });
          print('New user score added to Firestore!');
        }
      }
    } catch (e) {
      print('Error saving user score: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    int totalScore = calculateScore();

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Questions'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: quizQuestions.isEmpty
            ? CircularProgressIndicator()
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Question ${currentQuestionIndex + 1}:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                quizQuestions[currentQuestionIndex]['question'] ??
                    'Question $currentQuestionIndex',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Answer Choices:',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount:
                quizQuestions[currentQuestionIndex]
                ['shuffled_answers']
                    ?.length ??
                    0,
                itemBuilder: (BuildContext context, int answerIndex) {
                  return GestureDetector(
                    onTap: () => answerQuestion(answerIndex),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: quizQuestions[currentQuestionIndex]
                            ['selected_answer'] ==
                                answerIndex
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                          color:
                          quizQuestions[currentQuestionIndex]
                          ['selected_answer'] ==
                              answerIndex
                              ? Colors.blue.withOpacity(0.5)
                              : Colors.transparent,
                        ),
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          quizQuestions[currentQuestionIndex]
                          ['shuffled_answers']?[answerIndex] ??
                              'Not available',
                          style: TextStyle(
                            fontSize: 14.0,
                            color:
                            quizQuestions[currentQuestionIndex]
                            ['selected_answer'] ==
                                answerIndex
                                ? Colors.blueAccent
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total Score: $totalScore',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (currentQuestionIndex >= 4 &&
                answeredQs.contains(4))
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    saveUserScore();
                    Navigator.pop(context);
                  },
                  child: Text('Return to Home'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
