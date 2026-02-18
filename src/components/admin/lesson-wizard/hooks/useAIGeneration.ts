'use client'

import { useState, useEffect, useCallback } from 'react'

interface AIGenerationResult<T = unknown> {
  isGenerating: boolean
  error: string | null
  provider: 'local' | 'cloud' | 'none' | null
  generate: (action: string, context: Record<string, unknown>) => Promise<T | null>
}

export function useAIGeneration<T = unknown>(): AIGenerationResult<T> {
  const [isGenerating, setIsGenerating] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [provider, setProvider] = useState<'local' | 'cloud' | 'none' | null>(null)

  // Check availability on mount
  useEffect(() => {
    const basePath = process.env.NEXT_PUBLIC_BASE_PATH || ''
    fetch(`${basePath}/api/admin/ai/generate`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ action: '_ping', context: {} }),
    }).then(res => {
      if (res.status === 503) setProvider('none')
    }).catch(() => {
      // Ignore — will detect on first real call
    })
  }, [])

  const generate = useCallback(async (action: string, context: Record<string, unknown>): Promise<T | null> => {
    setIsGenerating(true)
    setError(null)

    try {
      const basePath = process.env.NEXT_PUBLIC_BASE_PATH || ''
      const res = await fetch(`${basePath}/api/admin/ai/generate`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action, context }),
      })

      if (res.status === 503) {
        setProvider('none')
        return null
      }

      if (!res.ok) {
        let errorMsg = `Error ${res.status}`
        try {
          const text = await res.text()
          // Try parsing as JSON first, fall back to raw text
          try {
            const data = JSON.parse(text)
            errorMsg = data.error || errorMsg
          } catch {
            errorMsg = text.slice(0, 200) || errorMsg
          }
        } catch { /* ignore read errors */ }
        throw new Error(errorMsg)
      }

      const data = await res.json()
      setProvider(data.provider)
      return data.data as T
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Error al generar contenido'
      setError(message)

      // Auto-dismiss error after 10s
      setTimeout(() => setError(null), 10000)
      return null
    } finally {
      setIsGenerating(false)
    }
  }, [])

  return { isGenerating, error, provider, generate }
}
