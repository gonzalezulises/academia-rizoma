// AI Service — dual provider: local DGX (OpenAI-compatible) → Claude API fallback

type Provider = 'local' | 'cloud' | 'none'

interface AIService {
  generate(system: string, user: string): Promise<string>
  parseJSONResponse<T = unknown>(raw: string): T
  isAvailable(): boolean
  getProvider(): Provider
  getLastUsedProvider(): Provider
}

async function callLocal(system: string, user: string): Promise<string> {
  const endpoint = process.env.AI_LOCAL_ENDPOINT
  const model = process.env.AI_LOCAL_MODEL || 'qwen2.5:72b'
  const apiKey = process.env.AI_LOCAL_API_KEY || ''

  // 8s on Vercel (Hobby plan = 10s limit), 120s in dev (DGX via Tailscale)
  const isVercel = !!process.env.VERCEL
  const timeoutMs = isVercel ? 8000 : 120000

  const controller = new AbortController()
  const timeout = setTimeout(() => controller.abort(), timeoutMs)

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
        max_tokens: 8192,
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

function sanitizeJSONString(raw: string): string {
  // Fix unescaped control characters inside JSON string values.
  // LLMs often emit literal newlines/tabs in code fields instead of \n \t.
  // Strategy: walk the string tracking whether we're inside a JSON string value,
  // and escape any raw control chars (U+0000–U+001F) found there.
  const result: string[] = []
  let inString = false
  let i = 0
  while (i < raw.length) {
    const ch = raw[i]
    if (inString) {
      if (ch === '\\') {
        // Escaped char — pass through both chars
        result.push(ch, raw[i + 1] || '')
        i += 2
        continue
      }
      if (ch === '"') {
        inString = false
        result.push(ch)
        i++
        continue
      }
      const code = ch.charCodeAt(0)
      if (code <= 0x1f) {
        // Raw control character inside string — escape it
        if (code === 0x0a) result.push('\\n')
        else if (code === 0x0d) result.push('\\r')
        else if (code === 0x09) result.push('\\t')
        else result.push(`\\u${code.toString(16).padStart(4, '0')}`)
        i++
        continue
      }
      result.push(ch)
    } else {
      if (ch === '"') {
        inString = true
      }
      result.push(ch)
    }
    i++
  }
  return result.join('')
}

function repairTruncatedJSON(raw: string): string {
  // Attempt to repair JSON truncated by token limits.
  // Strategy: close any open strings, arrays, and objects.
  let sanitized = sanitizeJSONString(raw)
  let inString = false
  const stack: string[] = []

  for (let i = 0; i < sanitized.length; i++) {
    const ch = sanitized[i]
    if (inString) {
      if (ch === '\\') { i++; continue }
      if (ch === '"') inString = false
    } else {
      if (ch === '"') inString = true
      else if (ch === '{' || ch === '[') stack.push(ch)
      else if (ch === '}' || ch === ']') stack.pop()
    }
  }

  // Close open string
  if (inString) sanitized += '"'
  // Close open structures in reverse
  while (stack.length > 0) {
    const open = stack.pop()
    sanitized += open === '{' ? '}' : ']'
  }
  return sanitized
}

function parseJSONResponse<T = unknown>(raw: string): T {
  // Strip Qwen3 thinking tags
  let cleaned = raw.replace(/<think>[\s\S]*?<\/think>/g, '').trim()
  // Strip markdown code fences if present
  if (cleaned.startsWith('```json')) {
    cleaned = cleaned.slice(7)
  } else if (cleaned.startsWith('```')) {
    cleaned = cleaned.slice(3)
  }
  if (cleaned.endsWith('```')) {
    cleaned = cleaned.slice(0, -3)
  }
  cleaned = cleaned.trim()

  // Try parsing in order: raw → sanitized → repaired (truncated)
  try {
    return JSON.parse(cleaned)
  } catch {
    try {
      return JSON.parse(sanitizeJSONString(cleaned))
    } catch {
      return JSON.parse(repairTruncatedJSON(cleaned))
    }
  }
}

export function createAIService(): AIService {
  const hasLocal = !!process.env.AI_LOCAL_ENDPOINT
  const hasCloud = !!process.env.ANTHROPIC_API_KEY
  let lastUsed: Provider = 'none'

  return {
    async generate(system: string, user: string): Promise<string> {
      if (hasLocal) {
        try {
          const result = await callLocal(system, user)
          lastUsed = 'local'
          return result
        } catch {
          // Fall through to cloud
        }
      }
      if (hasCloud) {
        const result = await callCloud(system, user)
        lastUsed = 'cloud'
        return result
      }
      throw new Error('No AI provider configured')
    },

    parseJSONResponse,

    isAvailable(): boolean {
      return hasLocal || hasCloud
    },

    getProvider(): Provider {
      if (hasLocal) return 'local'
      if (hasCloud) return 'cloud'
      return 'none'
    },

    getLastUsedProvider(): Provider {
      return lastUsed
    },
  }
}

export type { AIService }
