'use client'

import { useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import Link from 'next/link'

export default function RegisterPage() {
  const [fullName, setFullName] = useState('')
  const [email, setEmail] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)
  const [success, setSuccess] = useState(false)
  const supabase = createClient()

  const handleRegister = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setError(null)

    // Store name for post-callback profile update
    localStorage.setItem('pending_full_name', fullName)

    const { error } = await supabase.auth.signInWithOtp({
      email,
      options: {
        emailRedirectTo: `${window.location.origin}${process.env.NEXT_PUBLIC_BASE_PATH ?? ''}/auth/callback`,
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
            Crear cuenta
          </h2>
          <p className="mt-2 text-sm text-gray-600 dark:text-gray-400">
            Únete a la plataforma de aprendizaje de Rizoma
          </p>
        </div>

        {success ? (
          <div className="mt-8 text-center space-y-4">
            <div className="bg-rizoma-green/10 border border-rizoma-green/20 text-rizoma-green px-4 py-4 rounded-lg">
              <p className="font-medium">Revisa tu email</p>
              <p className="text-sm mt-1">
                Te enviamos un enlace de acceso a <strong>{email}</strong>.
                Haz clic en el enlace para completar tu registro.
              </p>
            </div>
            <button
              onClick={() => {
                setSuccess(false)
                setEmail('')
                setFullName('')
              }}
              className="text-sm text-gray-600 dark:text-gray-400 hover:text-rizoma-green transition-colors"
            >
              Usar otro email
            </button>
          </div>
        ) : (
          <form className="mt-8 space-y-6" onSubmit={handleRegister}>
            {error && (
              <div className="bg-rizoma-red/10 border border-rizoma-red/20 text-rizoma-red px-4 py-3 rounded-lg">
                {error}
              </div>
            )}
            <div className="space-y-4">
              <div>
                <label htmlFor="fullName" className="block text-sm font-medium text-gray-700 dark:text-gray-300">
                  Nombre completo
                </label>
                <input
                  id="fullName"
                  name="fullName"
                  type="text"
                  required
                  value={fullName}
                  onChange={(e) => setFullName(e.target.value)}
                  className="mt-1 block w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-rizoma-green focus:border-rizoma-green dark:bg-gray-800 dark:text-white"
                  placeholder="Juan Pérez"
                />
              </div>
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
              {loading ? 'Enviando enlace...' : 'Crear cuenta'}
            </button>

            <p className="text-center text-sm text-gray-600 dark:text-gray-400">
              ¿Ya tienes cuenta?{' '}
              <Link href="/login" className="text-rizoma-green hover:text-rizoma-green-dark font-medium">
                Inicia sesión
              </Link>
            </p>
          </form>
        )}
      </div>
    </div>
  )
}
