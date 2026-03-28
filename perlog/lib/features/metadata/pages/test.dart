import 'package:flutter/material.dart';
import 'package:perlog/core/constants/colors.dart';
import 'package:perlog/core/constants/text_styles.dart';
import 'package:perlog/core/constants/spacing.dart';
import 'package:perlog/features/metadata/data/diary_repository.dart';
import 'package:perlog/core/models/profile_model.dart';
import 'package:perlog/core/models/diary_model.dart';
import 'package:perlog/core/models/diary_analysis_model.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final repo = DiaryRepository();

  // 여기에 네가 넣은 dummy profile id를 넣으면 됨
  static const String dummyUserId = '11111111-1111-1111-1111-111111111111';

  Future<
    ({
      ProfileModel? profile,
      List<DiaryModel> diaries,
      DiaryAnalysisModel? analysis,
    })
  >
  _loadData() async {
    final profile = await repo.fetchProfile(dummyUserId);
    final diaries = await repo.fetchDiariesByUser(dummyUserId);

    DiaryAnalysisModel? analysis;
    if (diaries.isNotEmpty) {
      analysis = await repo.fetchAnalysisByDiaryId(diaries.first.id);
    }

    return (profile: profile, diaries: diaries, analysis: analysis);
  }

  Color _hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xff')));
  }

  @override
  Widget build(BuildContext context) {
    final screenPadding = AppSpacing.screen(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Supabase Test'),
        backgroundColor: AppColors.background,
      ),
      body:
          FutureBuilder<
            ({
              ProfileModel? profile,
              List<DiaryModel> diaries,
              DiaryAnalysisModel? analysis,
            })
          >(
            future: _loadData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('에러: ${snapshot.error}'),
                  ),
                );
              }

              final data = snapshot.data!;
              final profile = data.profile;
              final diaries = data.diaries;
              final analysis = data.analysis;

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  screenPadding.left,
                  20,
                  screenPadding.right,
                  40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('프로필', style: AppTextStyles.body22),
                    const SizedBox(height: 8),
                    Text('nickname: ${profile?.nickname ?? '없음'}'),
                    Text('user id: ${profile?.id ?? '없음'}'),

                    const SizedBox(height: 24),

                    Text('일기 목록', style: AppTextStyles.body22),
                    const SizedBox(height: 8),
                    Text('총 ${diaries.length}개'),

                    ...diaries.map(
                      (d) => Card(
                        child: ListTile(
                          title: Text(
                            d.diaryDate.toIso8601String().split('T').first,
                          ),
                          subtitle: Text(
                            d.ocrText,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text('최근 일기 분석', style: AppTextStyles.body22),
                    const SizedBox(height: 8),
                    if (analysis == null)
                      const Text('분석 데이터 없음')
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.subBackground,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('summary: ${analysis.summary}'),
                            Text('topEmotion: ${analysis.topEmotion}'),
                            Text('scent: ${analysis.scent}'),
                            Text('description: ${analysis.description}'),
                            Text('color: ${analysis.color}'),
                            Wrap(
                              spacing: 8,
                              children: analysis.tags
                                  .map((tag) => Chip(label: Text(tag)))
                                  .toList(),
                            ),
                            const SizedBox(height: 12),
                            ...analysis.emotionsScore.map(
                              (e) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${e.label} ${(e.score * 100).toStringAsFixed(0)}%',
                                    ),
                                    LinearProgressIndicator(
                                      value: e.score,
                                      minHeight: 10,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        _hexToColor(analysis.color),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
    );
  }
}
