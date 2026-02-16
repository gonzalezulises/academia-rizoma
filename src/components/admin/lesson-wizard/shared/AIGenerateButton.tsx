'use client'

interface AIGenerateButtonProps {
  onClick: () => void
  isGenerating: boolean
  error: string | null
  provider: 'local' | 'cloud' | 'none' | null
  label?: string
  disabled?: boolean
}

export default function AIGenerateButton({
  onClick,
  isGenerating,
  error,
  provider,
  label = 'Generar con IA',
  disabled = false,
}: AIGenerateButtonProps) {
  const isDisabled = disabled || isGenerating || provider === 'none'

  return (
    <div className="inline-flex flex-col gap-1">
      <div className="inline-flex items-center gap-2">
        <button
          type="button"
          onClick={onClick}
          disabled={isDisabled}
          className="inline-flex items-center gap-2 px-4 py-2 text-sm font-medium rounded-lg
            bg-purple-600 text-white hover:bg-purple-700
            disabled:opacity-50 disabled:cursor-not-allowed
            transition-colors"
        >
          {isGenerating ? (
            <>
              <svg className="animate-spin h-4 w-4" viewBox="0 0 24 24" fill="none">
                <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
              </svg>
              Generando...
            </>
          ) : provider === 'none' ? (
            'IA no configurada'
          ) : (
            <>
              <svg className="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2}
                  d="M13 10V3L4 14h7v7l9-11h-7z" />
              </svg>
              {label}
            </>
          )}
        </button>
        {provider && provider !== 'none' && (
          <span className="text-xs px-2 py-0.5 rounded-full bg-gray-100 dark:bg-gray-700 text-gray-500 dark:text-gray-400">
            {provider === 'local' ? 'DGX' : 'Claude'}
          </span>
        )}
      </div>
      {error && (
        <p className="text-sm text-red-600 dark:text-red-400">{error}</p>
      )}
    </div>
  )
}
