## 🖥️ 데스크톱 앱 실행 방법

### **가장 간단한 방법: 실행 파일 다운로드**

#### Windows 유저
1. GitHub Releases에서 `hanneung-ai-master-windows.zip` 다운로드
2. 압축 해제
3. `hanneung_ai_master.exe` 더블클릭 → 실행! 🎉

#### macOS 유저
1. GitHub Releases에서 `hanneung-ai-master-macos.dmg` 다운로드
2. `.dmg` 파일 더블클릭
3. `한능검 AI 마스터` 앱 실행! 🎉

---

### **직접 빌드해서 실행하는 방법**

#### 준비물
- Flutter 3.13.0 이상 설치
- Git 설치

#### 1단계: 코드 다운로드
```bash
git clone https://github.com/paulrobloxgaming123/hanneung-ai-master.git
cd hanneung-ai-master/flutter
```

#### 2단계: 데스크톱 모드 활성화

**Windows:**
```bash
flutter config --enable-windows-desktop
```

**macOS:**
```bash
flutter config --enable-macos-desktop
```

#### 3단계: 의존성 설치
```bash
flutter pub get
```

#### 4단계: 앱 실행

**Windows:**
```bash
flutter run -d windows
```

**macOS:**
```bash
flutter run -d macos
```

#### 5단계: 빌드 (선택사항 - 배포용)

**Windows:**
```bash
flutter build windows --release
# 빌드 완료 후: build/windows/runner/Release/hanneung_ai_master.exe
```

**macOS:**
```bash
flutter build macos --release
# 빌드 완료 후: build/macos/Build/Products/Release/hanneung_ai_master.app
```

---

### ⚙️ 시스템 요구사항

#### Windows
- Windows 10 이상
- Visual Studio 2019 또는 2022 (C++ 빌드 도구)

#### macOS
- macOS 10.15 이상
- Xcode 12 이상

---

### 🚀 자동 빌드

`.github/workflows/build-desktop.yml`에서 자동으로:
- **Windows EXE 생성**
- **macOS DMG 생성**
- **GitHub Releases에 업로드**

매 커밋마다 자동 빌드되므로 최신 버전 사용 가능!

---

### 📝 주의사항

- 첫 실행 시 느릴 수 있음 (정상)
- Supabase 프로젝트 필수
- 인터넷 연결 필요

---

**문제가 있으면 Issues 등록해주세요!** 😊
