import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:perlog/features/metadata/data/diary_repository.dart';

class TestSupabasePage  extends StatefulWidget {
  const TestSupabasePage({super.key});

  @override
  State<TestSupabasePage> createState() => _TestState();
}

class _TestState extends State<TestSupabasePage> {
  final repo = DiaryRepository();
  final uuid = const Uuid();

  String? lastUserId;
  String? lastDiaryId;
  String message = '아직 쓰기 테스트 전';

  Future<void> _insertDummyProfile() async {
    try {
      final userId = uuid.v4();

      await repo.insertProfile(
        id: userId,
        nickname: '테스트유저',
        isLockEnabled: false,
        isNotiEnabled: true,
      );

      setState(() {
        lastUserId = userId;
        message = 'profiles insert 성공: $userId';
      });

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('프로필 저장 성공')));
    } catch (e) {
      setState(() {
        message = 'profiles insert 실패: $e';
      });
    }
  }

  Future<void> _insertDummyDiary() async {
    try {
      if (lastUserId == null) {
        setState(() {
          message = '먼저 profile을 insert 해주세요.';
        });
        return;
      }

      final diaryId = uuid.v4();

      await repo.insertDiary(
        id: diaryId,
        userId: lastUserId!,
        diaryDate: DateTime.now(),
        imageUrl: 'https://example.com/test-image.jpg',
        ocrText: '오늘은 Supabase 쓰기 테스트를 진행했다. 꽤 잘 되고 있는 것 같다.',
        fontFamily: 'DiaryNanumPen',
      );

      setState(() {
        lastDiaryId = diaryId;
        message = 'diaries insert 성공: $diaryId';
      });

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('일기 저장 성공')));
    } catch (e) {
      setState(() {
        message = 'diaries insert 실패: $e';
      });
    }
  }

  Future<void> _insertDummyAnalysis() async {
    try {
      if (lastDiaryId == null) {
        setState(() {
          message = '먼저 diary를 insert 해주세요.';
        });
        return;
      }

      await repo.insertDiaryAnalysis(
        diaryId: lastDiaryId!,
        summary: '가볍고 만족스러운 하루',
        topEmotion: '기쁨',
        scent: 'Peach Breeze',
        description: '상쾌하고 밝은 복숭아 향이 어울리는 하루예요.',
        color: '#F7A6A6',
        tags: ['#기쁨', '#산뜻함', '#테스트'],
        emotionsScore: [
          {'label': '기쁨', 'score': 0.82},
          {'label': '평온', 'score': 0.12},
          {'label': '슬픔', 'score': 0.06},
        ],
      );

      setState(() {
        message = 'diary_analyses insert 성공: $lastDiaryId';
      });

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('분석 저장 성공')));
    } catch (e) {
      setState(() {
        message = 'diary_analyses insert 실패: $e';
      });
    }
  }

  Future<void> _insertAllAtOnce() async {
    try {
      final userId = uuid.v4();
      final diaryId = uuid.v4();

      await repo.insertProfile(
        id: userId,
        nickname: '통합테스트유저',
        isLockEnabled: false,
        isNotiEnabled: true,
      );

      await repo.insertDiary(
        id: diaryId,
        userId: userId,
        diaryDate: DateTime.now(),
        imageUrl: 'https://example.com/test-image.jpg',
        ocrText: '오늘은 쓰기/읽기 통합 테스트를 했다.',
        fontFamily: 'DiaryNanumPen',
      );

      await repo.insertDiaryAnalysis(
        diaryId: diaryId,
        summary: '개발이 순조로운 하루',
        topEmotion: '설렘',
        scent: 'Fresh Cotton',
        description: '새 출발 같은 맑고 깨끗한 향이 어울려요.',
        color: '#A8D5BA',
        tags: ['#설렘', '#개발', '#테스트'],
        emotionsScore: [
          {'label': '설렘', 'score': 0.64},
          {'label': '기쁨', 'score': 0.23},
          {'label': '불안', 'score': 0.13},
        ],
      );

      setState(() {
        lastUserId = userId;
        lastDiaryId = diaryId;
        message = '전체 insert 성공\nuserId: $userId\ndiaryId: $diaryId';
      });
    } catch (e) {
      setState(() {
        message = '전체 insert 실패: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Supabase Write Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _insertDummyProfile,
              child: const Text('1. profile 쓰기'),
            ),
            ElevatedButton(
              onPressed: _insertDummyDiary,
              child: const Text('2. diary 쓰기'),
            ),
            ElevatedButton(
              onPressed: _insertDummyAnalysis,
              child: const Text('3. analysis 쓰기'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _insertAllAtOnce,
              child: const Text('한 번에 전체 쓰기'),
            ),
            const SizedBox(height: 24),
            Text('lastUserId: ${lastUserId ?? '-'}'),
            Text('lastDiaryId: ${lastDiaryId ?? '-'}'),
            const SizedBox(height: 12),
            Text(message),
          ],
        ),
      ),
    );
  }
}
