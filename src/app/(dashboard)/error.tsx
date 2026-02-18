'use client'

import { useEffect } from 'react'
import Link from 'next/link'

export default function DashboardError({
  error,
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  useEffect(() => {
    console.error('Dashboard error:', error)
  }, [error])

  return (
    <div className="min-h-[60vh] flex items-center justify-center">
      <div className="text-center max-w-md px-4">
        <div className="text-5xl mb-4">⚠️</div>
        <h2 className="text-xl font-semibold text-gray-900 dark:text-white mb-2">
          Algo salio mal
        </h2>
        <p className="text-gray-600 dark:text-gray-400 mb-6">
          Ocurrio un error al cargar esta pagina. Intenta de nuevo o regresa al inicio.
        </p>
        <div className="flex gap-3 justify-center">
          <button
            onClick={reset}
            className="px-4 py-2 bg-rizoma-green text-white rounded-lg hover:bg-rizoma-green-dark transition-colors"
          >
            Reintentar
          </button>
          <Link
            href="/courses"
            className="px-4 py-2 border border-gray-300 dark:border-gray-600 text-gray-700 dark:text-gray-300 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors"
          >
            Ir a cursos
          </Link>
        </div>
      </div>
    </div>
  )
}
