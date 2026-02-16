// AI Service — dual provider: local DGX (OpenAI-compatible) → Claude API fallback

interface AIResponse {
  content: string
  provider: 'local' | 'cloud' | 'none'
}

interface AIService {
  generate(system: string, user: string): Promise<string>
  parseJSONResponse<T = unknown>(raw: string): T
  isAvailable(): boolean
  getProvider(): 'local' | 'cloud' | 'none'
}

async function callLocal(system: string, user: string): Promise<string> {
  const endpoint = process.env.AI_LOCAL_ENDPOINT
  const model = process.env.AI_LOCAL_MODEL || 'qwen2.5:72b'
  const apiKey = process.env.AI_LOCAL_API_KEY || ''

  const controller = new AbortController()
  const timeout = setTimeout(() => controller.abort(), 120000) // 2min for large models (72B cold start)

  try {
    const res = await fetch(`${endpoint}/chat/completions`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        ...(apiKey && { Authorization: `Bearer ${apiKey}` }),
      },
      body: JSON.stringify({
        model,
        messages: [
          { role: 'system', content: system },
          { role: 'user', content: user },
        ],
        temperature: 0.7,
        max_tokens: 4096,
      }),
      signal: controller.signal,
    })

    if (!res.ok) throw new Error(`Local AI error: ${res.status}`)

    const data = await res.json()
    return data.choices[0].message.content
  } finally {
    clearTimeout(timeout)
  }
}

async function callCloud(system: string, user: string): Promise<string> {
  const apiKey = process.env.ANTHROPIC_API_KEY
  if (!apiKey) throw new Error('ANTHROPIC_API_KEY not set')

  const controller = new AbortController()
  const timeout = setTimeout(() => controller.abort(), 60000)

  try {
    const res = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: JSON.stringify({
        model: 'claude-sonnet-4-5-20250929',
        max_tokens: 4096,
        system,
        messages: [{ role: 'user', content: user }],
      }),
      signal: controller.signal,
    })

    if (!res.ok) throw new Error(`Cloud AI error: ${res.status}`)

    const data = await res.json()
    return data.content[0].text
  } finally {
    clearTimeout(timeout)
  }
}

function parseJSONResponse<T = unknown>(raw: string): T {
  // Strip markdown code fences if present
  let cleaned = raw.trim()
  if (cleaned.startsWith('```json')) {
    cleaned = cleaned.slice(7)
  } else if (cleaned.startsWith('```')) {
    cleaned = cleaned.slice(3)
  }
  if (cleaned.endsWith('```')) {
    cleaned = cleaned.slice(0, -3)
  }
  return JSON.parse(cleaned.trim())
}

export function createAIService(): AIService {
  const hasLocal = !!process.env.AI_LOCAL_ENDPOINT
  const hasCloud = !!process.env.ANTHROPIC_API_KEY

  return {
    async generate(system: string, user: string): Promise<string> {
      if (hasLocal) {
        try {
          return await callLocal(system, user)
        } catch {
          // Fall through to cloud
        }
      }
      if (hasCloud) {
        return await callCloud(system, user)
      }
      throw new Error('No AI provider configured')
    },

    parseJSONResponse,

    isAvailable(): boolean {
      return hasLocal || hasCloud
    },

    getProvider(): 'local' | 'cloud' | 'none' {
      if (hasLocal) return 'local'
      if (hasCloud) return 'cloud'
      return 'none'
    },
  }
}

export type { AIService, AIResponse }
