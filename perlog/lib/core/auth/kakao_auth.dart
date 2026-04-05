import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

Future<String?> kakaoLogin() async {
  try {
    OAuthToken token;

    if (await isKakaoTalkInstalled()) {
      token = await UserApi.instance.loginWithKakaoTalk();
    } else {
      token = await UserApi.instance.loginWithKakaoAccount();
    }

    final user = await UserApi.instance.me();

    final kakaoId = user.id.toString();
    return "kakao_$kakaoId";
  } catch (e) {
    print('카카오 로그인 실패: $e');
    return null;
  }
}