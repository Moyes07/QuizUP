import 'package:flutter/material.dart';
import 'package:quizup/quizform.dart'; // Import the QuizForm if it's in a different file
import 'package:quizup/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizOptionsScreen extends StatefulWidget {
  @override
  _QuizOptionsScreenState createState() => _QuizOptionsScreenState();
}

class _QuizOptionsScreenState extends State<QuizOptionsScreen> {
  int selectedOption = -1; // Variable to store the selected option index

  final List<String> options = [
    'General knowledge',
    'Entertainment: Books',
    'Entertainment: Film',
    'Entertainment: Music',
    'Entertainment: Television',
    'Entertainment: Musical & Theater',
    'Entertainment: Video Games',
    'Entertainment: Board Games',
    'Science & Nature',
    'Science: Computer',
    'Science: Mathematics',
    'Methodology',
    'Sports',
    'Geography',
    'History',
    'Politics',
    'Arts',
    'Celebraties',
    'Animals',
    'Vehicles',
    'Entertainment: Comics',
    'Science: Gadgets',
    'Entertainment: Japanese Manga & Anime',
    'Entertainment: Cartoon & Animations'
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QuizUp'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              handleSignOut(); // Call the sign-out logic
            },
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: (options.length / 2).ceil(),
          itemBuilder: (context, rowIndex) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildOptionWidget(rowIndex * 2),
                  SizedBox(width: 8.0),
                  buildOptionWidget(rowIndex * 2 + 1),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildOptionWidget(int index) {
    if (index < options.length) {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedOption = index + 9; // Store the numerical value (starting from 9)
          });
          navigateToQuizForm(selectedOption);
        },
        child: Container(
          width: 180,
          height: 100,
          decoration: BoxDecoration(
            color: selectedOption == index + 9 ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                options[index],
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: selectedOption == index + 9 ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  void navigateToQuizForm(int category) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuizForm(selectedCategory: category)),
    );
  }

  void handleSignOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
