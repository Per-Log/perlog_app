include .env
export

deploy:
	npx supabase --version
	npx supabase login
	npx supabase link --project-ref $(PROJECT_REF)
	npx supabase secrets set GOOGLE_CLOUD_VISION_API_KEY=$(GOOGLE_CLOUD_VISION_API_KEY)
	npx supabase functions deploy google-vision-ocr