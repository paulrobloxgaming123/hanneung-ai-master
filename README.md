# 한능검 AI 마스터

한국사능력검정시험 2급 이상 대비를 위한 AI 기반 학습 앱입니다.

## 🚀 주요 기능

- ✅ **회원가입/로그인**: Supabase 인증
- ✅ **문제 풀이**: 한능검 2급 대비 문제
- ✅ **오답 노트**: 틀린 문제 정리
- ✅ **학습 기록 저장**: 자동 동기화
- ✅ **AI 문제 생성**: OpenAI API 활용
- ✅ **약점 분석**: 주제별 정확도 분석
- ✅ **통계 대시보드**: 학습 진행 시각화
- ✅ **부드러운 애니메이션**: 최적화된 UX

## 📱 기술 스택

- **Frontend**: Flutter (모바일 & 데스크톱)
- **Backend**: Flask
- **Database**: Supabase (PostgreSQL)
- **AI**: OpenAI API (GPT-4)
- **Authentication**: Supabase Auth

## 🛠 설치 및 실행

### 사전 준비

1. **Supabase 계정 생성**
   - https://supabase.com 에서 가입
   - 프로젝트 생성
   - API URL과 Anon Key 복사

2. **OpenAI API 키 발급**
   - https://platform.openai.com에서 가입
   - API 키 생성

3. **환경 변수 설정**

**backend/.env**
```
SUPABASE_URL=your_supabase_url
SUPABASE_KEY=your_supabase_key
OPENAI_API_KEY=your_openai_api_key
JWT_SECRET_KEY=your_jwt_secret_key
```

### 백엔드 설정

```bash
cd backend

# Python 3.8+ 필요
python -m venv venv

# Windows
venv\Scripts\activate
# macOS/Linux
source venv/bin/activate

# 의존성 설치
pip install -r requirements.txt

# 서버 실행
python app.py
```

### Flutter 앱 설정

```bash
cd flutter

# 의존성 설치
flutter pub get

# 모바일 앱 실행
flutter run

# 또는 빌드
flutter build apk  # Android
flutter build ios  # iOS
```

## 📚 데이터베이스 마이그레이션

Supabase에서 다음 SQL을 실행하세요:

```sql
-- migrations/init.sql 파일 참조
```

## 🔌 API 문서

전체 API 명세는 `DESIGN_DOCUMENT.md` 참조

### 주요 엔드포인트

- `POST /api/auth/signup` - 회원가입
- `POST /api/auth/login` - 로그인
- `GET /api/topics` - 모든 주제 조회
- `GET /api/topics/<id>/questions` - 주제별 문제
- `POST /api/questions/<id>/submit` - 답변 제출
- `GET /api/user/stats` - 통계 조회
- `POST /api/ai/generate-question` - AI 문제 생성

## 📊 프로젝트 구조

```
hanneung-ai-master/
├── flutter/                 # Flutter 프론트엔드
│   ├── lib/
│   │   ├── screens/        # UI 화면
│   │   ├── services/       # 비즈니스 로직
│   │   ├── widgets/        # 재사용 가능한 위젯
│   │   ├── models/         # 데이터 모델
│   │   └── utils/          # 유틸리티
│   └── pubspec.yaml
├── backend/                # Flask 백엔드
│   ├── routes/            # API 라우트
│   ├── services/          # 서비스 레이어
│   ├── app.py
│   └── requirements.txt
├── supabase/              # 데이터베이스
│   ├── migrations/
│   └── config.toml
├── DESIGN_DOCUMENT.md     # 설계 문서
└── README.md
```

## 🎯 로드맵

### V1 (MVP)
- ✅ 회원가입/로그인
- ✅ 기본 문제 풀이
- ✅ 오답 노트
- ✅ 학습 기록 저장

### V2
- [ ] AI 문제 생성
- [ ] 약점 분석
- [ ] 통계 대시보드

### V3
- [ ] 영상 요약
- [ ] 플래시카드 모드
- [ ] 소셜 기능

## 🔐 보안

- JWT 토큰 기반 인증
- Supabase RLS (Row Level Security)
- CORS 설정
- Rate limiting

## 📝 라이선스

MIT License

## 👨‍💻 기여

버그 리포트 및 기능 제안은 Issues를 통해 등록해주세요.

## 📞 문의

문제가 발생하거나 질문이 있으시면 Issues를 생성해주세요.

---

**마지막 업데이트**: 2026년 6월 6일
