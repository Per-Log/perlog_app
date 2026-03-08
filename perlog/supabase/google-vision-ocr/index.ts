declare const Deno: {
    serve: (handler: (req: Request) => Response | Promise<Response>) => void
    env: {
        get: (key: string) => string | undefined
    }
}

const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

function toBase64(bytes: Uint8Array): string {
    let binary = ''
    const chunkSize = 0x8000

    for (let i = 0; i < bytes.length; i += chunkSize) {
        const chunk = bytes.subarray(i, i + chunkSize)
        binary += String.fromCharCode(...chunk)
    }

    return btoa(binary)
}

Deno.serve(async (req: Request) => {
    if (req.method === 'OPTIONS') {
        return new Response('ok', { headers: corsHeaders })
    }

    try {
        const { imageUrl } = await req.json()

        if (!imageUrl || typeof imageUrl !== 'string') {
            return new Response(JSON.stringify({ error: 'imageUrl is required' }), {
                status: 400,
                headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            })
        }

        const visionApiKey = Deno.env.get('GOOGLE_CLOUD_VISION_API_KEY')

        if (!visionApiKey) {
            return new Response(JSON.stringify({ error: 'Server OCR key is missing' }), {
                status: 500,
                headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            })
        }

        const imageRes = await fetch(imageUrl)
        if (!imageRes.ok) {
            return new Response(
                JSON.stringify({ error: `Image download failed: ${imageRes.status}` }),
                {
                    status: 400,
                    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
                },
            )
        }

        const imageBytes = new Uint8Array(await imageRes.arrayBuffer())
        const encodedImage = toBase64(imageBytes)

        const visionRes = await fetch(
            `https://vision.googleapis.com/v1/images:annotate?key=${visionApiKey}`,
            {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    requests: [
                        {
                            image: { content: encodedImage },
                            features: [{ type: 'TEXT_DETECTION' }],
                        },
                    ],
                }),
            },
        )

        const visionJson = await visionRes.json()

        const text =
            visionJson?.responses?.[0]?.fullTextAnnotation?.text ??
            visionJson?.responses?.[0]?.textAnnotations?.[0]?.description ??
            null

        return new Response(JSON.stringify({ text }), {
            status: 200,
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        })
    } catch (error) {
        return new Response(
            JSON.stringify({ error: error instanceof Error ? error.message : 'OCR failed' }),
            {
                status: 500,
                headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            },
        )
    }
})