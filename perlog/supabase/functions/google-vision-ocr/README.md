# google-vision-ocr Edge Function

앱에 Google Vision API Key를 넣지 않고 OCR을 수행하기 위한 서버 함수입니다.

이 함수는 Python 예시와 유사하게 동작합니다.
1. `imageUrl`의 이미지를 서버에서 다운로드
2. 이미지를 base64로 인코딩
3. Vision API `images:annotate`에 `image.content` + `TEXT_DETECTION`으로 요청

## 배포 전 설정

```bash
npx supabase --version
npx supabase login
npx supabase link --project-ref uzpfybxalroyynjhbfis
npx supabase secrets set GOOGLE_CLOUD_VISION_API_KEY=""
npx supabase functions deploy google-vision-ocr
```

## 호출 payload

```json
{ "imageUrl": "https://..." }
```

## 응답

```json
{ "text": "추출된 OCR 텍스트" }
```

## 보안

- Vision API Key는 **반드시 Supabase Secret**(`GOOGLE_CLOUD_VISION_API_KEY`)으로만 저장하세요.
- Flutter 앱 코드/`.env`/git에는 Vision API Key를 넣지 않습니다.