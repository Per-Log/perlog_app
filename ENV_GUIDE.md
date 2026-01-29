## Environment

- Flutter: 3.32.4 (FVM 사용)
- Dart: 3.8.1
- Channel: stable


## Prerequisites

### FVM 설치
```
dart pub global activate fvm
```

#### 설치 확인:
```
fvm --version
```

## Project Setup
1. Repository Clone
```
git clone git@github.com:Per-Log/perlog_app.git
cd perlog_app
```

2. Flutter SDK 설치 (프로젝트 기준)
```
fvm install
```

3. 의존성 설치
```
fvm flutter pub get
```

4. 앱 실행
```
fvm flutter run
```


## Quick Start
```
dart pub global activate fvm
export PATH="$PATH":"$HOME/.pub-cache/bin"

git clone git@github.com:Per-Log/perlog_app.git
cd perlog_app

fvm install
fvm flutter pub get
fvm flutter run
```