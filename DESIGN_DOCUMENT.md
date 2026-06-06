# 한능검 AI 마스터 - 실행 가능한 MVP 설계서

## 📋 목표
- 한능검(한국사능력검정시험) 2급 이상 대비
- AI 문제 생성 및 해설
- 오답 해설 및 분석
- 사용자 학습 기록 저장
- 부드러운 UI/UX 애니메이션

## 🛠 기술 스택
- **Frontend**: Flutter (모바일 & 데스크톱)
- **Backend**: Flask/FastAPI
- **Database**: Supabase (PostgreSQL)
- **AI**: OpenAI API (GPT-4)
- **Authentication**: Supabase Auth
- **Real-time**: Supabase Realtime

---

## 🗄 데이터베이스 설계

### 1. users 테이블
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  nickname VARCHAR(100) NOT NULL,
  xp INTEGER DEFAULT 0,
  streak INTEGER DEFAULT 0,
  total_correct INTEGER DEFAULT 0,
  total_attempts INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 2. topics 테이블 (시대별 주제)
```sql
CREATE TABLE topics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  era VARCHAR(100) NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  order_index INTEGER,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 3. questions 테이블
```sql
CREATE TABLE questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  topic_id UUID REFERENCES topics(id) ON DELETE CASCADE,
  question TEXT NOT NULL,
  choice1 VARCHAR(255) NOT NULL,
  choice2 VARCHAR(255) NOT NULL,
  choice3 VARCHAR(255) NOT NULL,
  choice4 VARCHAR(255) NOT NULL,
  answer INTEGER NOT NULL, -- 1, 2, 3, 4
  explanation TEXT NOT NULL,
  explanation_choice1 TEXT,
  explanation_choice2 TEXT,
  explanation_choice3 TEXT,
  explanation_choice4 TEXT,
  keywords VARCHAR(500), -- JSON array
  difficulty VARCHAR(20) DEFAULT 'normal', -- easy, normal, hard
  ai_generated BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 4. attempts 테이블 (사용자 시험 기록)
```sql
CREATE TABLE attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  question_id UUID REFERENCES questions(id) ON DELETE CASCADE,
  selected_answer INTEGER,
  correct BOOLEAN,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, question_id)
);
```

### 5. user_stats 테이블 (사용자 통계)
```sql
CREATE TABLE user_stats (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID UNIQUE REFERENCES users(id) ON DELETE CASCADE,
  total_study_time INTEGER DEFAULT 0, -- 초 단위
  current_streak INTEGER DEFAULT 0,
  best_streak INTEGER DEFAULT 0,
  topics_completed VARCHAR(500), -- JSON array
  last_studied_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 6. ai_generated_questions 테이블
```sql
CREATE TABLE ai_generated_questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  topic_id UUID REFERENCES topics(id) ON DELETE CASCADE,
  question TEXT NOT NULL,
  choice1 VARCHAR(255) NOT NULL,
  choice2 VARCHAR(255) NOT NULL,
  choice3 VARCHAR(255) NOT NULL,
  choice4 VARCHAR(255) NOT NULL,
  answer INTEGER NOT NULL,
  explanation TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 🔌 API 명세

### Authentication (인증)

#### 1. 회원가입
```
POST /api/auth/signup
Content-Type: application/json

Request:
{
  "email": "user@example.com",
  "password": "password123",
  "nickname": "학생1"
}

Response:
{
  "success": true,
  "user_id": "uuid",
  "token": "jwt_token",
  "message": "회원가입 성공"
}
```

#### 2. 로그인
```
POST /api/auth/login
Content-Type: application/json

Request:
{
  "email": "user@example.com",
  "password": "password123"
}

Response:
{
  "success": true,
  "user_id": "uuid",
  "token": "jwt_token",
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "nickname": "학생1",
    "xp": 1250,
    "streak": 5
  }
}
```

#### 3. 로그아웃
```
POST /api/auth/logout
Authorization: Bearer {token}

Response:
{
  "success": true,
  "message": "로그아웃 성공"
}
```

---

### Topics (시대별 주제)

#### 1. 모든 주제 조회
```
GET /api/topics
Authorization: Bearer {token}

Response:
{
  "success": true,
  "topics": [
    {
      "id": "uuid",
      "era": "삼국시대",
      "title": "고구려, 백제, 신라",
      "description": "한반도 삼국의 형성과 발전",
      "order_index": 1
    },
    ...
  ]
}
```

#### 2. 특정 주제 조회
```
GET /api/topics/{topic_id}
Authorization: Bearer {token}

Response:
{
  "success": true,
  "topic": {
    "id": "uuid",
    "era": "삼국시대",
    "title": "고구려, 백제, 신라",
    "questions_count": 25
  }
}
```

---

### Questions (문제)

#### 1. 주제별 문제 조회
```
GET /api/topics/{topic_id}/questions
Authorization: Bearer {token}

Response:
{
  "success": true,
  "questions": [
    {
      "id": "uuid",
      "question": "고구려를 건국한 인물은?",
      "choice1": "주몽",
      "choice2": "온조",
      "choice3": "박혁거세",
      "choice4": "김알지",
      "difficulty": "easy"
    },
    ...
  ]
}
```

#### 2. 문제 풀이 제출
```
POST /api/questions/{question_id}/submit
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "selected_answer": 1,
  "time_spent": 30 -- 초 단위
}

Response:
{
  "success": true,
  "correct": true,
  "xp_earned": 10,
  "explanation": "주몽은 고구려의 건국자입니다...",
  "explanation_choices": {
    "1": "정답입니다.",
    "2": "온조는 백제의 건국자입니다.",
    "3": "박혁거세는 신라의 건국자입니다.",
    "4": "김알지는 신라의 초대왕입니다."
  }
}
```

#### 3. 오답 노트 조회
```
GET /api/user/wrong-answers
Authorization: Bearer {token}

Response:
{
  "success": true,
  "wrong_answers": [
    {
      "id": "uuid",
      "question": "고구려를 건국한 인물은?",
      "selected_answer": 2,
      "correct_answer": 1,
      "explanation": "...",
      "attempted_at": "2026-06-06T10:30:00Z"
    },
    ...
  ]
}
```

---

### AI 문제 생성

#### 1. AI 문제 생성 요청
```
POST /api/ai/generate-question
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "topic_id": "uuid",
  "difficulty": "normal", -- easy, normal, hard
  "count": 5
}

Response:
{
  "success": true,
  "questions": [
    {
      "id": "uuid",
      "question": "고려의 팔만대장경은 언제 제작되었는가?",
      "choice1": "11세기",
      "choice2": "12세기",
      "choice3": "13세기",
      "choice4": "14세기",
      "answer": 3,
      "explanation": "팔만대장경은 13세기 몽골의 침입을 피해 강화도에서 제작되었습니다.",
      "keywords": ["팔만대장경", "강화도", "13세기", "불교"]
    },
    ...
  ]
}
```

---

### User Stats (사용자 통계)

#### 1. 사용자 통계 조회
```
GET /api/user/stats
Authorization: Bearer {token}

Response:
{
  "success": true,
  "stats": {
    "total_study_time": 3600, -- 초
    "current_streak": 5,
    "best_streak": 12,
    "accuracy_rate": 78.5, -- %
    "total_attempts": 150,
    "correct_answers": 117,
    "topics_completed": ["삼국시대", "통일신라"],
    "xp": 2500,
    "level": 5,
    "last_studied_at": "2026-06-06T14:30:00Z"
  }
}
```

#### 2. 약점 분석
```
GET /api/user/weak-points
Authorization: Bearer {token}

Response:
{
  "success": true,
  "weak_points": [
    {
      "topic": "고려시대",
      "accuracy": 45.0,
      "attempts": 20,
      "recommendation": "고려시대의 정치 체제를 다시 복습하세요."
    },
    ...
  ]
}
```

---

### User Profile (사용자 프로필)

#### 1. 프로필 조회
```
GET /api/user/profile
Authorization: Bearer {token}

Response:
{
  "success": true,
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "nickname": "학생1",
    "xp": 2500,
    "level": 5,
    "streak": 5,
    "avatar_url": "https://..."
  }
}
```

#### 2. 프로필 수정
```
PUT /api/user/profile
Authorization: Bearer {token}
Content-Type: application/json

Request:
{
  "nickname": "새로운닉네임",
  "avatar_url": "https://..."
}

Response:
{
  "success": true,
  "user": { ... }
}
```

---

## 🎨 UI 화면

### 1. 로그인/회원가입 화면
- 이메일 입력
- 비밀번호 입력
- 회원가입/로그인 버튼
- 부드러운 슬라이드 애니메이션

### 2. 홈 화면
- 사용자 닉네임 & XP 표시
- 현재 스트릭 표시
- 시대별 주제 리스트 (스크롤 가능)
- 하단 네비게이션: 홈, 학습, 통계, 프로필

### 3. 시대 선택 화면
- 시대별 주제 카드 (좌우 스와이프)
- 진행률 표시
- 시작 버튼

### 4. 문제 풀이 화면
- 문제 텍스트
- 4개의 선택지 버튼 (터치 애니메이션)
- 진행률 바
- 제출 버튼

### 5. 결과 화면
- ✅ 정답/❌ 오답 표시
- 획득 XP 표시
- 해설 텍스트
- 각 선택지별 해설
- 다음 버튼 (또는 완료)

### 6. 오답 노트 화면
- 오답만 리스트업
- 주제별 필터링
- 정렬 (최근순, 정확도순)

### 7. 통계 화면
- 학습 시간 그래프
- 정확도 비율
- 주제별 성적
- 약점 분석

### 8. 프로필 화면
- 사용자 정보
- 닉네임 수정
- 로그아웃 버튼

---

## 🎬 애니메이션 효과

1. **페이지 전환**: Fade + Slide (300ms)
2. **버튼 터치**: Scale + Shadow (150ms)
3. **카드 나타남**: Stagger animation (100ms 간격)
4. **정답 표시**: 녹색 빛 + 스케일 업 (500ms)
5. **오답 표시**: 빨간색 흔들기 (400ms)
6. **XP 증가**: 숫자 스크롤 애니메이션 (800ms)

---

## 📱 프로젝트 구조

```
hanneung-ai-master/
├── flutter/
│   ├── lib/
│   │   ├── main.dart
│   │   ├── screens/
│   │   │   ├── auth/
│   │   │   │   ├── login_screen.dart
│   │   │   │   └── signup_screen.dart
│   │   │   ├── home_screen.dart
│   │   │   ├── quiz_screen.dart
│   │   │   ├── result_screen.dart
│   │   │   ├── wrong_answers_screen.dart
│   │   │   ├── stats_screen.dart
│   │   │   └── profile_screen.dart
│   │   ├── widgets/
│   │   │   ├── question_card.dart
│   │   │   ├── choice_button.dart
│   │   │   ├── animated_transition.dart
│   │   │   └── progress_bar.dart
│   │   ├── services/
│   │   │   ├── api_service.dart
│   │   │   ├── auth_service.dart
│   │   │   └── supabase_service.dart
│   │   ├── models/
│   │   │   ├── user.dart
│   │   │   ├── question.dart
│   │   │   ├── topic.dart
│   │   │   └── attempt.dart
│   │   └── utils/
│   │       ├── constants.dart
│   │       ├── theme.dart
│   │       └── animations.dart
│   ├── pubspec.yaml
│   └── README.md
├── backend/
│   ├── app.py (Flask)
│   ├── requirements.txt
│   ├── config.py
│   ├── routes/
│   │   ├── auth.py
│   │   ├── questions.py
│   │   ├── topics.py
│   │   ├── ai.py
│   │   └── user.py
│   ├── models/
│   │   └── database.py
│   ├── services/
│   │   ├── openai_service.py
│   │   ├── supabase_service.py
│   │   └── jwt_service.py
│   └── README.md
├── supabase/
│   ├── migrations/
│   │   └── init.sql
│   └── config.toml
├── DESIGN_DOCUMENT.md
├── API_SPEC.md
└── README.md
```

---

## 🚀 로드맵

### V1 (MVP - 2주)
- ✅ 회원가입/로그인
- ✅ 기본 문제 풀이
- ✅ 오답 노트
- ✅ 사용자 기록 저장
- ✅ 기본 애니메이션

### V2 (1주)
- ✅ AI 문제 생성
- ✅ 약점 분석
- ✅ 통계 대시보드

### V3 (1주)
- ✅ 영상 요약 (YouTube 통합)
- ✅ 플래시카드 모드
- ✅ 소셜 기능 (친구 추가, 순위표)

---

## 🔑 주요 기능

| 기능 | 설명 | V |
|------|------|---|
| 회원가입/로그인 | Supabase 인증 | 1 |
| 문제 풀이 | 사지선다 형식 | 1 |
| 오답 노트 | 틀린 문제 정리 | 1 |
| 학습 기록 저장 | 자동 동기화 | 1 |
| AI 문제 생성 | OpenAI API | 2 |
| 약점 분석 | 주제별 분석 | 2 |
| 통계 대시보드 | 학습 진행 시각화 | 2 |
| 부드러운 애니메이션 | Flutter animations | 1 |

---

## 🔐 보안

- JWT 토큰 기반 인증
- Supabase RLS (Row Level Security)
- 비밀번호 해싱 (bcrypt)
- CORS 설정
- Rate limiting

---

## 📦 배포

- **Frontend**: Google Play Store, App Store, Web
- **Backend**: AWS Lambda, Heroku, 또는 Vercel
- **Database**: Supabase (PostgreSQL)

