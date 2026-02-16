'use client'

import { useState } from 'react'
import dynamic from 'next/dynamic'

const MonacoEditor = dynamic(() => import('@monaco-editor/react'), { ssr: false })

interface MarkdownEditorProps {
  value: string
  onChange: (value: string) => void
  placeholder?: string
  minHeight?: string
}

export default function MarkdownEditor({
  value,
  onChange,
  placeholder,
  minHeight = '200px',
}: MarkdownEditorProps) {
  const [mode, setMode] = useState<'edit' | 'preview'>('edit')

  return (
    <div className="border border-gray-300 dark:border-gray-700 rounded-lg overflow-hidden">
      <div className="flex border-b border-gray-300 dark:border-gray-700 bg-gray-50 dark:bg-gray-800">
        <button
          type="button"
          onClick={() => setMode('edit')}
          className={`px-4 py-1.5 text-sm font-medium ${
            mode === 'edit'
              ? 'text-rizoma-green border-b-2 border-rizoma-green'
              : 'text-gray-500 dark:text-gray-400'
          }`}
        >
          Editar
        </button>
        <button
          type="button"
          onClick={() => setMode('preview')}
          className={`px-4 py-1.5 text-sm font-medium ${
            mode === 'preview'
              ? 'text-rizoma-green border-b-2 border-rizoma-green'
              : 'text-gray-500 dark:text-gray-400'
          }`}
        >
          Vista previa
        </button>
      </div>

      {mode === 'edit' ? (
        <div style={{ minHeight }}>
          <MonacoEditor
            height={minHeight}
            language="markdown"
            value={value}
            onChange={(v) => onChange(v || '')}
            theme="vs-dark"
            options={{
              minimap: { enabled: false },
              wordWrap: 'on',
              lineNumbers: 'off',
              scrollBeyondLastLine: false,
              placeholder,
              fontSize: 14,
              padding: { top: 12 },
            }}
          />
        </div>
      ) : (
        <div
          className="prose dark:prose-invert max-w-none p-4"
          style={{ minHeight }}
          dangerouslySetInnerHTML={{ __html: simpleMarkdownToHtml(value) }}
        />
      )}
    </div>
  )
}

// Minimal markdown preview (avoids importing react-markdown in admin)
function simpleMarkdownToHtml(md: string): string {
  if (!md) return '<p class="text-gray-400">Sin contenido</p>'
  return md
    .replace(/### (.+)/g, '<h3>$1</h3>')
    .replace(/## (.+)/g, '<h2>$1</h2>')
    .replace(/# (.+)/g, '<h1>$1</h1>')
    .replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
    .replace(/\*(.+?)\*/g, '<em>$1</em>')
    .replace(/`(.+?)`/g, '<code>$1</code>')
    .replace(/```(\w*)\n([\s\S]*?)```/g, '<pre><code>$2</code></pre>')
    .replace(/\n\n/g, '</p><p>')
    .replace(/\n/g, '<br/>')
    .replace(/^/, '<p>')
    .replace(/$/, '</p>')
}
