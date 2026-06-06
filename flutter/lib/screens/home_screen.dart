import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../screens/advanced_stats_screen.dart';
import '../screens/flashcard_screen.dart';
import '../screens/leaderboard_screen.dart';
import '../screens/wrong_answers_screen.dart';
import '../utils/theme.dart';
import 'study_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: '학습'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '통계'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_selectedIndex == 0) {
      return _buildHomeTab();
    } else if (_selectedIndex == 1) {
      return const StudyScreen();
    } else if (_selectedIndex == 2) {
      return const StatsScreen();
    } else {
      return _buildProfileTab();
    }
  }

  Widget _buildHomeTab() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 사용자 정보
              Consumer<AuthService>(
                builder: (context, authService, _) {
                  return Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Text('👤', style: TextStyle(fontSize: 32)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authService.currentUser?.email ?? '사용자',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'XP: 2250 | Lv.5 | 🔥 7일',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),

              // 빠른 메뉴
              const Text(
                '빠른 메뉴',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _buildQuickMenuCard(
                    '📝 문제 풀이',
                    Colors.blue,
                    () {
                      setState(() => _selectedIndex = 1);
                    },
                  ),
                  _buildQuickMenuCard(
                    '🎴 플래시카드',
                    Colors.purple,
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const FlashcardScreen(
                            topicId: '1',
                            topicTitle: '삼국시대',
                          ),
                        ),
                      );
                    },
                  ),
                  _buildQuickMenuCard(
                    '✨ AI 문제',
                    Colors.orange,
                    () {
                      // AI 문제 화면으로
                    },
                  ),
                  _buildQuickMenuCard(
                    '📊 상세 통계',
                    Colors.green,
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AdvancedStatsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // 소셜 기능
              const Text(
                '소셜',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LeaderboardScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.leaderboard),
                  label: const Text('순위표 보기'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const WrongAnswersScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.note),
                  label: const Text('오답 노트'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickMenuCard(
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(
                child: Text('👤', style: TextStyle(fontSize: 48)),
              ),
            ),
            const SizedBox(height: 24),
            Consumer<AuthService>(
              builder: (context, authService, _) {
                return Column(
                  children: [
                    Text(
                      authService.currentUser?.email ?? '사용자',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          authService.logout();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          '로그아웃',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
