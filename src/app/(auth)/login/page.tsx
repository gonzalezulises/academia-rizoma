'use client'

import { useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import Link from 'next/link'

export default function LoginPage() {
  const [email, setEmail] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)
  const [success, setSuccess] = useState(false)
  const supabase = createClient()

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setError(null)

    const { error } = await supabase.auth.signInWithOtp({
      email,
      options: {
        emailRedirectTo: `${window.location.origin}/auth/callback`,
      },
    })

    if (error) {
      setError(error.message)
      setLoading(false)
      return
    }

    setSuccess(true)
    setLoading(false)
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-cloud-dancer dark:bg-gray-900 px-4">
      <div className="max-w-md w-full space-y-8">
        <div className="text-center">
          <Link href="/" className="inline-block mb-6">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src="/images/brand/logo-plenos-color-optimized.png"
              alt="Rizoma Academia"
              className="h-12 w-auto dark:hidden"
            />
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src="/images/brand/logo-plenos-blanco-optimized.png"
              alt="Rizoma Academia"
              className="h-12 w-auto hidden dark:block"
            />
          </Link>
          <h2 className="text-3xl font-bold text-gray-900 dark:text-white">
            Iniciar sesión
          </h2>
          <p className="mt-2 text-sm text-gray-600 dark:text-gray-400">
            Accede a tu cuenta para continuar aprendiendo
          </p>
        </div>

        {success ? (
          <div className="mt-8 text-center space-y-4">
            <div className="bg-rizoma-green/10 border border-rizoma-green/20 text-rizoma-green px-4 py-4 rounded-lg">
              <p className="font-medium">Revisa tu email</p>
              <p className="text-sm mt-1">
                Te enviamos un enlace de acceso a <strong>{email}</strong>.
                Haz clic en el enlace para iniciar sesión.
              </p>
            </div>
            <button
              onClick={() => {
                setSuccess(false)
                setEmail('')
              }}
              className="text-sm text-gray-600 dark:text-gray-400 hover:text-rizoma-green transition-colors"
            >
              Usar otro email
            </button>
          </div>
        ) : (
          <form className="mt-8 space-y-6" onSubmit={handleLogin}>
            {error && (
              <div className="bg-rizoma-red/10 border border-rizoma-red/20 text-rizoma-red px-4 py-3 rounded-lg">
                {error}
              </div>
            )}
            <div className="space-y-4">
              <div>
                <label htmlFor="email" className="block text-sm font-medium text-gray-700 dark:text-gray-300">
                  Email
                </label>
                <input
                  id="email"
                  name="email"
                  type="email"
                  autoComplete="email"
                  required
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="mt-1 block w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-rizoma-green focus:border-rizoma-green dark:bg-gray-800 dark:text-white"
                  placeholder="tu@email.com"
                />
              </div>
            </div>

            <button
              type="submit"
              disabled={loading}
              className="w-full flex justify-center py-2 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-rizoma-green hover:bg-rizoma-green-dark focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-rizoma-green disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
            >
              {loading ? 'Enviando enlace...' : 'Enviar enlace de acceso'}
            </button>

            <p className="text-center text-sm text-gray-600 dark:text-gray-400">
              ¿No tienes cuenta?{' '}
              <Link href="/register" className="text-rizoma-green hover:text-rizoma-green-dark font-medium">
                Regístrate aquí
              </Link>
            </p>
          </form>
        )}
      </div>
    </div>
  )
}
