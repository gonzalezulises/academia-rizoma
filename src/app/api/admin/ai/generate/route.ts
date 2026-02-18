import { NextResponse } from 'next/server'
import { requireAdmin, isAuthError } from '@/lib/auth/helpers'
import { createAIService } from '@/lib/ai/service'
import { AI_PROMPTS } from '@/lib/ai/prompts'

// Allow up to 120s for large model inference (DGX 72B cold start)
export const maxDuration = 120

export async function POST(request: Request) {
  const auth = await requireAdmin()
  if (isAuthError(auth)) return auth

  const ai = createAIService()
  if (!ai.isAvailable()) {
    return NextResponse.json({ error: 'No AI provider configured' }, { status: 503 })
  }

  try {
    const { action, context } = await request.json()

    if (!action || !context) {
      return NextResponse.json({ error: 'Missing action or context' }, { status: 400 })
    }

    const promptFn = AI_PROMPTS[action as keyof typeof AI_PROMPTS]
    if (!promptFn) {
      return NextResponse.json({ error: `Unknown action: ${action}` }, { status: 400 })
    }

    const { system, user: userPrompt } = promptFn(context)
    const raw = await ai.generate(system, userPrompt)
    const parsed = ai.parseJSONResponse(raw)

    return NextResponse.json({
      data: parsed,
      provider: ai.getLastUsedProvider(),
    })
  } catch (error) {
    console.error('AI generate error:', error)
    return NextResponse.json(
      { error: error instanceof Error ? error.message : 'AI generation failed' },
      { status: 500 }
    )
  }
}
