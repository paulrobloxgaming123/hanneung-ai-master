CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255),
  nickname VARCHAR(100) NOT NULL,
  xp INTEGER DEFAULT 0,
  streak INTEGER DEFAULT 0,
  best_streak INTEGER DEFAULT 0,
  total_correct INTEGER DEFAULT 0,
  total_attempts INTEGER DEFAULT 0,
  avatar_url VARCHAR(500),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS topics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  era VARCHAR(100) NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  order_index INTEGER,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  topic_id UUID REFERENCES topics(id) ON DELETE CASCADE,
  question TEXT NOT NULL,
  choice1 VARCHAR(255) NOT NULL,
  choice2 VARCHAR(255) NOT NULL,
  choice3 VARCHAR(255) NOT NULL,
  choice4 VARCHAR(255) NOT NULL,
  answer INTEGER NOT NULL,
  explanation TEXT NOT NULL,
  explanation_choice1 TEXT,
  explanation_choice2 TEXT,
  explanation_choice3 TEXT,
  explanation_choice4 TEXT,
  keywords VARCHAR(500),
  difficulty VARCHAR(20) DEFAULT 'normal',
  ai_generated BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  question_id UUID REFERENCES questions(id) ON DELETE CASCADE,
  selected_answer INTEGER,
  correct BOOLEAN,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, question_id)
);

CREATE TABLE IF NOT EXISTS user_stats (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID UNIQUE REFERENCES users(id) ON DELETE CASCADE,
  total_study_time INTEGER DEFAULT 0,
  current_streak INTEGER DEFAULT 0,
  best_streak INTEGER DEFAULT 0,
  topics_completed VARCHAR(500),
  last_studied_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ai_generated_questions (
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

-- 인덱스 생성
CREATE INDEX idx_questions_topic_id ON questions(topic_id);
CREATE INDEX idx_attempts_user_id ON attempts(user_id);
CREATE INDEX idx_attempts_question_id ON attempts(question_id);
CREATE INDEX idx_ai_generated_user_id ON ai_generated_questions(user_id);
CREATE INDEX idx_ai_generated_topic_id ON ai_generated_questions(topic_id);

-- 초기 데이터 추가
INSERT INTO topics (era, title, description, order_index) VALUES
('삼국시대', '고구려, 백제, 신라', '한반도 삼국의 형성과 발전', 1),
('통일신라', '통일신라의 문화와 정치', '신라의 삼국통일과 이후 발전', 2),
('고려시대', '고려의 건국과 발전', '고려 왕조의 정치, 경제, 문화', 3),
('조선시대 전기', '조선의 건국과 세종시대', '조선 초기의 정치와 문화 발전', 4),
('조선시대 후기', '조선 후기의 변화', '임진왜란, 병자호란 이후의 조선', 5),
('근대', '한말과 일제강점기', '근대 개화기부터 일제강점기까지', 6),
('현대', '광복 이후의 한국', '분단과 현대 한국의 발전', 7);
