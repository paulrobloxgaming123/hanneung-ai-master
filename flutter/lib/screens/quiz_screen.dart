import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/question.dart';
import '../services/supabase_service.dart';
import '../widgets/animated_question_card.dart';
import '../widgets/progress_bar.dart';
import '../utils/theme.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String topicId;
  final String topicTitle;

  const QuizScreen({
    Key? key,
    required this.topicId,
    required this.topicTitle,
  }) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Question> questions = [];
  int currentQuestionIndex = 0;
  int? selectedAnswer;
  bool isAnswered = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final supabaseService = context.read<SupabaseService>();
    try {
      final questionsData =
          await supabaseService.getQuestionsByTopic(widget.topicId);
      
      setState(() {
        questions = questionsData
            .map((q) => Question.fromJson(q))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('문제를 불러올 수 없습니다')),
      );
    }
  }

  void _handleAnswerSelected(int answer) {
    if (!isAnswered) {
      setState(() {
        selectedAnswer = answer;
        isAnswered = true;
      });
    }
  }

  void _handleNextQuestion() async {
    if (currentQuestionIndex < questions.length - 1) {
      // 다음 문제로
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        isAnswered = false;
      });
    } else {
      // 완료! 결과 화면으로
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            topic: widget.topicTitle,
            totalQuestions: questions.length,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('문제 풀이')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('문제 풀이')),
        body: const Center(
          child: Text('문제가 없습니다'),
        ),
      );
    }

    final question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topicTitle),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 진행률 바
              ProgressBar(
                current: currentQuestionIndex + 1,
                total: questions.length,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 24),

              // 문제 카드
              AnimatedQuestionCard(
                question: question.question,
                choices: question.choices,
                selectedAnswer: selectedAnswer,
                onSelectAnswer: _handleAnswerSelected,
                isAnswered: isAnswered,
                correctAnswer: isAnswered ? question.answer : null,
              ),
              const SizedBox(height: 32),

              // 정답 해설 (정답한 경우만)
              if (isAnswered)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: selectedAnswer == question.answer
                        ? Colors.green[50]
                        : Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selectedAnswer == question.answer
                          ? Colors.green[500]!
                          : Colors.red[500]!,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedAnswer == question.answer ? '✅ 정답!' : '❌ 오답',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: selectedAnswer == question.answer
                              ? Colors.green[700]
                              : Colors.red[700],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '해설',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        question.explanation,
                        style: const TextStyle(fontSize: 14),
                      ),
                      if (question.explanationChoices != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            const Text(
                              '선택지별 설명',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...question.explanationChoices!.entries.map((e) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${e.key}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        e.value,
                                        style: const TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                    ],
                  ),
                ),

              const SizedBox(height: 32),

              // 다음 버튼
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isAnswered ? _handleNextQuestion : null,
                  child: Text(
                    currentQuestionIndex == questions.length - 1
                        ? '완료'
                        : '다음',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
