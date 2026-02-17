'use client'

import { useState, useMemo } from 'react'
import { useSearchParams } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import Link from 'next/link'

type Step = 'email' | 'register' | 'sent'

export default function UnifiedAuthForm() {
  const [step, setStep] = useState<Step>('email')
  const [email, setEmail] = useState('')
  const [name, setName] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)
  const supabase = useMemo(() => createClient(), [])
  const searchParams = useSearchParams()
  const next = searchParams.get('next')

  const basePath = process.env.NEXT_PUBLIC_BASE_PATH ?? ''

  const buildRedirectTo = () => {
    const callbackUrl = new URL(`${window.location.origin}${basePath}/auth/callback`)
    if (next) callbackUrl.searchParams.set('next', next)
    return callbackUrl.toString()
  }

  const handleEmailSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setError(null)

    const { error } = await supabase.auth.signInWithOtp({
      email,
      options: {
        shouldCreateUser: false,
        emailRedirectTo: buildRedirectTo(),
      },
    })

    if (error) {
      // User doesn't exist — show registration step
      setStep('register')
      setLoading(false)
      return
    }

    // User exists — magic link sent
    setStep('sent')
    setLoading(false)
  }

  const handleRegisterSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setError(null)

    const { error } = await supabase.auth.signInWithOtp({
      email,
      options: {
        shouldCreateUser: true,
        emailRedirectTo: buildRedirectTo(),
        data: { full_name: name },
      },
    })

    if (error) {
      setError(error.message)
      setLoading(false)
      return
    }

    setStep('sent')
    setLoading(false)
  }

  const handleResend = async () => {
    setLoading(true)
    setError(null)

    const isNewUser = name.length > 0
    const { error } = await supabase.auth.signInWithOtp({
      email,
      options: {
        shouldCreateUser: isNewUser,
        emailRedirectTo: buildRedirectTo(),
        ...(isNewUser ? { data: { full_name: name } } : {}),
      },
    })

    if (error) {
      setError(error.message)
    }
    setLoading(false)
  }

  const handleReset = () => {
    setStep('email')
    setEmail('')
    setName('')
    setError(null)
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-cloud-dancer dark:bg-gray-900 px-4">
      <div className="max-w-md w-full space-y-8">
        <div className="text-center">
          <Link href="/" className="inline-block mb-6">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src={`${basePath}/images/brand/logo-plenos-color-optimized.png`}
              alt="Rizoma Academia"
              className="h-12 w-auto dark:hidden"
            />
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src={`${basePath}/images/brand/logo-plenos-blanco-optimized.png`}
              alt="Rizoma Academia"
              className="h-12 w-auto hidden dark:block"
            />
          </Link>
          <h2 className="text-3xl font-bold text-gray-900 dark:text-white">
            Acceder a Academia Rizoma
          </h2>
          <p className="mt-2 text-sm text-gray-600 dark:text-gray-400">
            {step === 'email' && 'Ingresa tu email para continuar'}
            {step === 'register' && 'Completa tu registro para crear una cuenta'}
            {step === 'sent' && 'Te enviamos un enlace de acceso'}
          </p>
        </div>

        {error && (
          <div className="bg-rizoma-red/10 border border-rizoma-red/20 text-rizoma-red px-4 py-3 rounded-lg">
            {error}
          </div>
        )}

        {step === 'email' && (
          <form className="mt-8 space-y-6" onSubmit={handleEmailSubmit}>
            <div>
              <label htmlFor="email" className="block text-sm font-medium text-gray-700 dark:text-gray-300">
                Email
              </label>
              <input
                id="email"
                name="email"
                type="email"
                autoComplete="email"
                autoFocus
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="mt-1 block w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-rizoma-green focus:border-rizoma-green dark:bg-gray-800 dark:text-white"
                placeholder="tu@email.com"
              />
            </div>
            <button
              type="submit"
              disabled={loading}
              className="w-full flex justify-center py-2 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-rizoma-green hover:bg-rizoma-green-dark focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-rizoma-green disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
            >
              {loading ? 'Verificando...' : 'Continuar'}
            </button>
          </form>
        )}

        {step === 'register' && (
          <form className="mt-8 space-y-6" onSubmit={handleRegisterSubmit}>
            <div className="space-y-4">
              <div className="bg-gray-100 dark:bg-gray-800 px-3 py-2 rounded-lg text-sm text-gray-600 dark:text-gray-400">
                {email}
                <button
                  type="button"
                  onClick={handleReset}
                  className="ml-2 text-rizoma-green hover:text-rizoma-green-dark text-xs"
                >
                  Cambiar
                </button>
              </div>
              <div>
                <label htmlFor="name" className="block text-sm font-medium text-gray-700 dark:text-gray-300">
                  Nombre completo
                </label>
                <input
                  id="name"
                  name="name"
                  type="text"
                  autoFocus
                  required
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  className="mt-1 block w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-rizoma-green focus:border-rizoma-green dark:bg-gray-800 dark:text-white"
                  placeholder="Juan Pérez"
                />
              </div>
            </div>
            <button
              type="submit"
              disabled={loading}
              className="w-full flex justify-center py-2 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-rizoma-green hover:bg-rizoma-green-dark focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-rizoma-green disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
            >
              {loading ? 'Creando cuenta...' : 'Crear cuenta'}
            </button>
          </form>
        )}

        {step === 'sent' && (
          <div className="mt-8 text-center space-y-4">
            <div className="bg-rizoma-green/10 border border-rizoma-green/20 text-rizoma-green px-4 py-4 rounded-lg">
              <p className="font-medium">Revisa tu email</p>
              <p className="text-sm mt-1">
                Te enviamos un enlace de acceso a <strong>{email}</strong>.
                Haz clic en el enlace para continuar.
              </p>
            </div>
            <div className="flex flex-col gap-2">
              <button
                onClick={handleResend}
                disabled={loading}
                className="text-sm text-rizoma-green hover:text-rizoma-green-dark transition-colors disabled:opacity-50"
              >
                {loading ? 'Reenviando...' : 'Reenviar enlace'}
              </button>
              <button
                onClick={handleReset}
                className="text-sm text-gray-600 dark:text-gray-400 hover:text-rizoma-green transition-colors"
              >
                Usar otro email
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
