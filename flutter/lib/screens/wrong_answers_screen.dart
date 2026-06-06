import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../utils/theme.dart';

class WrongAnswersScreen extends StatefulWidget {
  const WrongAnswersScreen({Key? key}) : super(key: key);

  @override
  State<WrongAnswersScreen> createState() => _WrongAnswersScreenState();
}

class _WrongAnswersScreenState extends State<WrongAnswersScreen> {
  List<Map<String, dynamic>> wrongAnswers = [];
  bool isLoading = true;
  String filterTopic = '전체';

  @override
  void initState() {
    super.initState();
    _loadWrongAnswers();
  }

  Future<void> _loadWrongAnswers() async {
    // 오답 데이터 로드 (실제 구현)
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      wrongAnswers = [
        {
          'topic': '조선시대 후기',
          'question': '임진왜란이 일어난 연도는?',
          'selected': 2,
          'correct': 1,
          'choices': ['1592년', '1597년', '1600년', '1610년'],
          'explanation': '임진왜란은 1592년 도요토미 히데요시의 도요토미 히데요시의 도일본군에 의해 발발했습니다.',
        },
        {
          'topic': '고려시대',
          'question': '팔만대장경이 제작된 시기는?',
          'selected': 2,
          'correct': 3,
          'choices': ['11세기', '12세기', '13세기', '14세기'],
          'explanation': '팔만대장경은 13세기 강화도에서 몽골의 침입을 피해 제작되었습니다.',
        },
        {
          'topic': '근대',
          'question': '일제강점기의 시작 연도는?',
          'selected': 1,
          'correct': 3,
          'choices': ['1905년', '1908년', '1910년', '1915년'],
          'explanation': '일제강점기는 1910년 한일병합으로 시작되었습니다.',
        },
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오답 노트'),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 통계
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryColor,
                            AppTheme.secondaryColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              const Text(
                                '총 오답',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${wrongAnswers.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                '정확도',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '77%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 오답 목록
                    const Text(
                      '오답 분석',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: wrongAnswers.length,
                      itemBuilder: (context, index) {
                        final answer = wrongAnswers[index];
                        return _buildWrongAnswerCard(answer);
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildWrongAnswerCard(Map<String, dynamic> answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 주제 태그
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              answer['topic'],
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 문제
          Text(
            answer['question'],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // 선택지 비교
          Row(
            children: [
              Expanded(
                child: _buildAnswerComparison(
                  '내가 선택',
                  answer['choices'][answer['selected'] - 1],
                  Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAnswerComparison(
                  '정답',
                  answer['choices'][answer['correct'] - 1],
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 해설
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '해설',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  answer['explanation'],
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerComparison(String label, String answer, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
