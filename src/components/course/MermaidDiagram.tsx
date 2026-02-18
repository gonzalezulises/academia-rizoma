'use client'

import { useEffect, useRef, useState } from 'react'

interface MermaidDiagramProps {
  code: string
}

export default function MermaidDiagram({ code }: MermaidDiagramProps) {
  const containerRef = useRef<HTMLDivElement>(null)
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(true)
  const idRef = useRef(`mermaid-${Math.random().toString(36).slice(2, 9)}`)

  useEffect(() => {
    let cancelled = false

    async function renderDiagram() {
      try {
        const mermaid = (await import('mermaid')).default

        mermaid.initialize({
          startOnLoad: false,
          theme: 'dark',
          themeVariables: {
            primaryColor: '#289448',
            primaryTextColor: '#F9FAFB',
            primaryBorderColor: '#34A856',
            lineColor: '#1FACC0',
            secondaryColor: '#178A9A',
            tertiaryColor: '#1F7038',
            background: '#2d2d2d',
            mainBkg: '#289448',
            nodeBorder: '#34A856',
            clusterBkg: '#383838',
            clusterBorder: '#1FACC0',
            titleColor: '#F9FAFB',
            edgeLabelBackground: '#2d2d2d',
          },
          fontFamily: "'Inter', system-ui, sans-serif",
        })

        const { svg } = await mermaid.render(idRef.current, code)

        if (!cancelled && containerRef.current) {
          containerRef.current.innerHTML = svg
          setLoading(false)
        }
      } catch (err) {
        if (!cancelled) {
          setError(err instanceof Error ? err.message : 'Error rendering diagram')
          setLoading(false)
        }
      }
    }

    renderDiagram()

    return () => {
      cancelled = true
    }
  }, [code])

  if (error) {
    return (
      <div className="my-4 rounded-xl border border-red-300 dark:border-red-800 bg-red-50 dark:bg-red-900/20 p-4">
        <p className="text-sm text-red-600 dark:text-red-400 mb-2">Error en diagrama Mermaid</p>
        <pre className="text-sm overflow-x-auto text-gray-800 dark:text-gray-300">
          <code>{code}</code>
        </pre>
      </div>
    )
  }

  return (
    <div className="mermaid-diagram my-4 not-prose">
      {loading && (
        <div className="flex items-center justify-center h-32 rounded-xl bg-gray-100 dark:bg-gray-800 animate-pulse">
          <span className="text-sm text-gray-500 dark:text-gray-400">Cargando diagrama...</span>
        </div>
      )}
      <div
        ref={containerRef}
        className={`flex justify-center ${loading ? 'hidden' : ''}`}
      />
    </div>
  )
}
