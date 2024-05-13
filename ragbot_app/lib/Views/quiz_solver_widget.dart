import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:ragbot_app/Controllers/quiz_controller.dart';
import 'package:ragbot_app/Models/question.dart';
import 'package:ragbot_app/Views/quiz_question_widget.dart';

class QuizSolverWidget extends StatefulWidget {
  final List<Question> questions;
  const QuizSolverWidget({super.key, required this.questions});

  @override
  State<StatefulWidget> createState() => _QuizSolverWidgetState();
}

class _QuizSolverWidgetState extends State<QuizSolverWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext build) {
    return Consumer<QuizController>(builder: (context, quizController, child) {
      return Scaffold(
        body: Stack(
          children: [
            Positioned(
              right: 30,
              top: 60,
              child: IconButton(
                  icon: const Icon(Icons.exit_to_app, color: Colors.white),
                  onPressed: () {
                    _confirmExitQuiz(context);
                  }),
            ),
            Stack(
              children: [
                QuizQuestionWidget(questions: quizController.questions),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 25, right: 25, bottom: 200),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: navigationButtons(
                        quizController,
                        quizController.isLastQuestion,
                        quizController.isNextButtonDisabled),
                  ),
                )
              ],
            )
          ],
        ),
      );
    });
  }

  Widget navigationButtons(QuizController quizController, bool isLastQuestion,
      bool isNextButtonDisabled) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
            onPressed: quizController.currentIndex == 0
                ? null
                : quizController.navigateToPreviousQuestion,
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6738FF),
                disabledBackgroundColor: const Color(0x0FFFFFFF)),
            child: const Icon(Icons.arrow_back)),
        ElevatedButton(
          onPressed: isNextButtonDisabled
              ? (isLastQuestion
                  ? quizController.submitQuiz
                  : quizController.navigateToNextQuestion)
              : null,
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6738FF),
              disabledBackgroundColor: const Color(0x0FFFFFFF)),
          child: isLastQuestion
              ? const Text("Submit")
              : const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }
}

void _confirmExitQuiz(BuildContext context) {
  Widget cancelButton = TextButton(
    child: const Text(
      "Cancel",
      style: TextStyle(
        color: Color(0xFF6738FF),
        fontSize: 18,
      ),
    ),
    onPressed: () {
      Navigator.of(context).pop(); //pop dialog
    },
  );
  Widget continueButton = TextButton(
    child: const Text(
      "Continue",
      style: TextStyle(
        color: Color.fromARGB(255, 224, 83, 73),
        fontSize: 18,
      ),
    ),
    onPressed: () {
      Navigator.of(context).pop(); //pop dialog
      Navigator.of(context).pop(); //pop quiz
    },
  );
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      content: const Padding(
        padding: EdgeInsets.only(top: 20),
        child: Text(
          "If you leave now, all your answers will be lost. Are you sure you want to exit?",
          style: TextStyle(fontSize: 20, height: 1.5),
        ),
      ),
      actions: [
        continueButton,
        cancelButton,
      ],
    ),
  );
}
