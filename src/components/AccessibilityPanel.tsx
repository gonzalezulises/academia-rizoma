'use client'

import { useEffect, useState, useCallback, useRef } from 'react'

const STORAGE_KEY = 'rizo_a11y_settings'

interface A11ySettings {
  darkMode: boolean
  textSize: 'small' | 'normal' | 'large' | 'xlarge'
  highContrast: boolean
  reducedMotion: boolean
}

const defaultSettings: A11ySettings = {
  darkMode: false,
  textSize: 'normal',
  highContrast: false,
  reducedMotion: false,
}

const textSizePx: Record<string, string> = {
  small: '14px',
  normal: '16px',
  large: '18px',
  xlarge: '20px',
}

function getInitialSettings(): A11ySettings {
  try {
    const saved = localStorage.getItem(STORAGE_KEY)
    const s = saved ? { ...defaultSettings, ...JSON.parse(saved) } : { ...defaultSettings }
    if (!saved) {
      if (window.matchMedia('(prefers-color-scheme: dark)').matches) s.darkMode = true
      if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) s.reducedMotion = true
      if (window.matchMedia('(prefers-contrast: high)').matches) s.highContrast = true
    }
    return s
  } catch {
    return defaultSettings
  }
}

function persistSettings(settings: A11ySettings) {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(settings))
  } catch {
    // localStorage not available
  }
}

function applyToDOM(settings: A11ySettings) {
  const html = document.documentElement
  html.classList.toggle('dark', settings.darkMode)
  html.classList.toggle('high-contrast', settings.highContrast)
  html.classList.toggle('reduce-motion', settings.reducedMotion)
  html.style.fontSize = textSizePx[settings.textSize] || '16px'
}

function ToggleSwitch({ checked, onToggle, label }: { checked: boolean; onToggle: () => void; label: string }) {
  return (
    <button
      type="button"
      role="switch"
      aria-checked={checked}
      aria-label={label}
      onClick={onToggle}
      className={`relative w-11 h-6 rounded-full transition-colors focus:outline-none focus-visible:ring-2 focus-visible:ring-rizoma-green focus-visible:ring-offset-2 ${checked ? 'bg-rizoma-green' : 'bg-gray-300'}`}
    >
      <span className={`absolute left-1 top-1 w-4 h-4 bg-white rounded-full shadow transition-transform ${checked ? 'translate-x-5' : ''}`} />
    </button>
  )
}

export default function AccessibilityPanel() {
  const [open, setOpen] = useState(false)
  const [settings, setSettings] = useState<A11ySettings>(defaultSettings)
  const panelRef = useRef<HTMLDivElement>(null)
  const btnRef = useRef<HTMLButtonElement>(null)
  const initialized = useRef(false)

  // Load on mount — apply to DOM only, defer state update
  useEffect(() => {
    if (initialized.current) return
    initialized.current = true
    const s = getInitialSettings()
    applyToDOM(s)
    // Use timeout to avoid synchronous setState in effect
    setTimeout(() => setSettings(s), 0)
  }, [])

  const update = useCallback((patch: Partial<A11ySettings>) => {
    setSettings(prev => {
      const next = { ...prev, ...patch }
      persistSettings(next)
      applyToDOM(next)
      return next
    })
  }, [])

  const reset = useCallback(() => {
    const s = { ...defaultSettings }
    setSettings(s)
    persistSettings(s)
    applyToDOM(s)
  }, [])

  // Close on Escape / click outside
  useEffect(() => {
    if (!open) return
    const onKey = (e: KeyboardEvent) => { if (e.key === 'Escape') setOpen(false) }
    const onClick = (e: MouseEvent) => {
      if (panelRef.current && !panelRef.current.contains(e.target as Node) &&
          btnRef.current && !btnRef.current.contains(e.target as Node)) {
        setOpen(false)
      }
    }
    document.addEventListener('keydown', onKey)
    document.addEventListener('click', onClick)
    return () => { document.removeEventListener('keydown', onKey); document.removeEventListener('click', onClick) }
  }, [open])

  return (
    <>
      {/* Toggle Button */}
      <button
        ref={btnRef}
        type="button"
        onClick={() => setOpen(o => !o)}
        className="fixed bottom-4 left-4 z-50 w-12 h-12 bg-gray-800 dark:bg-white text-white dark:text-gray-800 rounded-full shadow-lg hover:scale-110 transition-all duration-300 flex items-center justify-center focus:outline-none focus-visible:ring-2 focus-visible:ring-rizoma-green focus-visible:ring-offset-2"
        aria-label="Accesibilidad"
        aria-expanded={open}
        aria-controls="a11y-panel"
      >
        <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4" />
        </svg>
      </button>

      {/* Panel */}
      {open && (
        <div
          ref={panelRef}
          id="a11y-panel"
          className="fixed bottom-20 left-4 z-50 w-80 max-w-[calc(100vw-2rem)] bg-white dark:bg-gray-900 rounded-xl shadow-2xl border border-gray-200 dark:border-gray-700 p-6"
          role="dialog"
          aria-label="Accesibilidad"
          aria-modal="true"
        >
          <div className="flex items-center justify-between mb-6">
            <h2 className="text-lg font-semibold text-gray-900 dark:text-white flex items-center gap-2">
              <svg className="w-5 h-5 text-rizoma-green" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 10V3L4 14h7v7l9-11h-7z" />
              </svg>
              Accesibilidad
            </h2>
            <button
              type="button"
              onClick={() => setOpen(false)}
              className="p-1 text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 rounded-lg focus:outline-none focus-visible:ring-2 focus-visible:ring-rizoma-green"
              aria-label="Cerrar"
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>

          <div className="space-y-5">
            {/* Dark Mode */}
            <div className="flex items-center justify-between">
              <span className="text-sm font-medium text-gray-700 dark:text-gray-300 flex items-center gap-2">
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z" />
                </svg>
                Modo oscuro
              </span>
              <ToggleSwitch checked={settings.darkMode} onToggle={() => update({ darkMode: !settings.darkMode })} label="Modo oscuro" />
            </div>

            {/* Text Size */}
            <div>
              <span className="text-sm font-medium text-gray-700 dark:text-gray-300 flex items-center gap-2 mb-2">
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h8m-8 6h16" />
                </svg>
                Tamano de texto
              </span>
              <div className="flex gap-2" role="radiogroup" aria-label="Tamano de texto">
                {(['small', 'normal', 'large', 'xlarge'] as const).map((size, i) => {
                  const selected = settings.textSize === size
                  return (
                    <button
                      key={size}
                      type="button"
                      role="radio"
                      aria-checked={selected}
                      onClick={() => update({ textSize: size })}
                      className={`flex-1 py-2 px-3 rounded-lg border transition-colors focus:outline-none focus-visible:ring-2 focus-visible:ring-rizoma-green ${
                        selected
                          ? 'bg-rizoma-green text-white border-rizoma-green'
                          : 'border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800'
                      }`}
                      style={{ fontSize: ['0.75rem', '0.875rem', '1rem', '1.125rem'][i] }}
                    >
                      A
                    </button>
                  )
                })}
              </div>
            </div>

            {/* High Contrast */}
            <div className="flex items-center justify-between">
              <span className="text-sm font-medium text-gray-700 dark:text-gray-300 flex items-center gap-2">
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z" />
                </svg>
                Alto contraste
              </span>
              <ToggleSwitch checked={settings.highContrast} onToggle={() => update({ highContrast: !settings.highContrast })} label="Alto contraste" />
            </div>

            {/* Reduced Motion */}
            <div className="flex items-center justify-between">
              <span className="text-sm font-medium text-gray-700 dark:text-gray-300 flex items-center gap-2">
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z" />
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                Reducir animaciones
              </span>
              <ToggleSwitch checked={settings.reducedMotion} onToggle={() => update({ reducedMotion: !settings.reducedMotion })} label="Reducir animaciones" />
            </div>

            {/* Reset */}
            <button
              type="button"
              onClick={reset}
              className="w-full py-2 px-4 text-sm font-medium text-gray-600 dark:text-gray-400 border border-gray-300 dark:border-gray-600 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800 focus:outline-none focus-visible:ring-2 focus-visible:ring-rizoma-green transition-colors"
            >
              Restablecer
            </button>
          </div>
        </div>
      )}
    </>
  )
}
