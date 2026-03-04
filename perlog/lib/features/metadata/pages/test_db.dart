// import 'dart:convert';
// import 'package:flutter/material.dart';

// import 'package:http/http.dart' as http;
// import 'package:perlog/core/constants/colors.dart';
// import 'package:perlog/core/constants/text_styles.dart';
// import 'package:perlog/core/constants/spacing.dart';
// import 'package:perlog/core/router/routes.dart';
// import 'package:go_router/go_router.dart';
// import 'package:perlog/core/widgets/bottom_button.dart';
// import 'package:perlog/core/models/analysis.dart';

// class DiaryAnalysisPage extends StatefulWidget {
//   final String diaryId; // 특정 일기의 ID를 받아 분석 결과를 조회한다고 가정

//   const DiaryAnalysisPage({super.key, required this.diaryId});

//   @override
//   State<DiaryAnalysisPage> createState() => _DiaryAnalysisPageState();
// }

// class _DiaryAnalysisPageState extends State<DiaryAnalysisPage> {
//   // 1. 네트워크를 통해 DB/서버에서 JSON 데이터를 가져오는 함수
//   Future<EmotionReport> _fetchAnalysisData() async {
//     // 실제 서버 주소로 변경하세요 (예: FastAPI, Firebase 등)
//     final String apiUrl = 'https://api.perlog.com/analysis/${widget.diaryId}';

//     try {
//       final response = await http.get(Uri.parse(apiUrl));

//       if (response.statusCode == 200) {
//         // 한글 깨짐 방지를 위해 utf8.decode 사용
//         final decodedData = json.decode(utf8.decode(response.bodyBytes));
//         return EmotionReport.fromJson(decodedData);
//       } else {
//         throw Exception('서버 응답 오류: ${response.statusCode}');
//       }
//     } catch (e) {
//       // 네트워크 연결 실패 시 처리
//       throw Exception('데이터를 불러오지 못했습니다: $e');
//     }
//   }

//   // 헥사 코드를 Color로 변환
//   Color _hexToColor(String hex) {
//     try {
//       return Color(int.parse(hex.replaceFirst('#', '0xff')));
//     } catch (e) {
//       return Colors.grey; // 변환 실패 시 기본값
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenPadding = AppSpacing.screen(context);

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: FutureBuilder<EmotionReport>(
//           future: _fetchAnalysisData(), // 서버 통신 시작
//           builder: (context, snapshot) {
//             // [상태 1] 로딩 중
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             // [상태 2] 에러 발생
//             if (snapshot.hasError) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(
//                       Icons.error_outline,
//                       size: 48,
//                       color: Colors.red,
//                     ),
//                     const SizedBox(height: 16),
//                     Text('오류 발생: ${snapshot.error}'),
//                     TextButton(
//                       onPressed: () => setState(() {}),
//                       child: const Text('다시 시도'),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             // [상태 3] 데이터 수신 완료
//             final report = snapshot.data!;

//             return SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(
//                   screenPadding.left,
//                   screenPadding.top,
//                   screenPadding.right,
//                   screenPadding.bottom + 20,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       '오늘의 기록,',
//                       style: AppTextStyles.body16.copyWith(
//                         color: AppColors.mainFont,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       '퍼로그님의 하루예요.',
//                       style: AppTextStyles.body22.copyWith(
//                         color: AppColors.mainFont,
//                       ),
//                     ),

//                     const SizedBox(height: 32),

//                     // 2. 서버에서 받은 이미지 URL 표시
//                     Row(
//                       children: [
//                         const SizedBox(width: 24),
//                         // Image.network를 사용하여 서버의 사진을 불러옵니다.
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.network(
//                             report.imageUrl, // 모델에 이미지 URL 필드가 있어야 함
//                             height: 60,
//                             width: 60,
//                             fit: BoxFit.cover,
//                             loadingBuilder: (context, child, loadingProgress) {
//                               if (loadingProgress == null) return child;
//                               return const SizedBox(
//                                 width: 60,
//                                 height: 60,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                 ),
//                               );
//                             },
//                             errorBuilder: (context, error, stackTrace) => Icon(
//                               Icons.image,
//                               size: 52,
//                               color: _hexToColor(report.color),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 20),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 '${report.scent}가 어울리는 하루였군요!',
//                                 style: AppTextStyles.body18SemiBold.copyWith(
//                                   color: AppColors.mainFont,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 report.description,
//                                 style: AppTextStyles.body12.copyWith(
//                                   color: AppColors.mainFont,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 32),

//                     // 3. 해시태그 바 (서버에서 받은 키워드 리스트)
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 12,
//                         horizontal: 16,
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: AppColors.subBackground,
//                       ),
//                       child: Wrap(
//                         alignment: WrapAlignment.center,
//                         spacing: 8,
//                         children: report.tags
//                             .map(
//                               (tag) => Text(
//                                 tag,
//                                 style: AppTextStyles.body18SemiBold.copyWith(
//                                   color: _hexToColor(report.color),
//                                 ),
//                               ),
//                             )
//                             .toList(),
//                       ),
//                     ),

//                     const SizedBox(height: 32),

//                     // 4. 감정 분석 그래프
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: AppColors.subBackground,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '감정 분석 결과',
//                             style: AppTextStyles.body18SemiBold.copyWith(
//                               color: AppColors.mainFont,
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           ...report.emotions.map(
//                             (e) => _buildEmotionBar(
//                               e.label,
//                               e.score,
//                               report.color,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 40),

//                     BottomButton(
//                       text: '홈으로',
//                       onPressed: () => context.go(Routes.home),
//                       enabled: true,
//                       backgroundColor: AppColors.background,
//                       borderColor: AppColors.mainFont,
//                       textColor: AppColors.mainFont,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildEmotionBar(String label, double score, String hexColor) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(label, style: AppTextStyles.body12),
//               Text('${(score * 100).toInt()}%', style: AppTextStyles.body12),
//             ],
//           ),
//           const SizedBox(height: 8),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: LinearProgressIndicator(
//               value: score,
//               minHeight: 12,
//               backgroundColor: AppColors.background,
//               valueColor: AlwaysStoppedAnimation<Color>(_hexToColor(hexColor)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
