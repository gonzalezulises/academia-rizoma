'use client'

import Link from 'next/link'
import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import { useRouter } from 'next/navigation'
import type { Profile } from '@/types'
import { NotificationBell } from '@/components/notifications'

export default function Navbar() {
  const [user, setUser] = useState<Profile | null>(null)
  const [loading, setLoading] = useState(true)
  const supabase = createClient()
  const router = useRouter()

  useEffect(() => {
    const getUser = async () => {
      const { data: { user: authUser } } = await supabase.auth.getUser()

      if (authUser) {
        const { data: profile } = await supabase
          .from('profiles')
          .select('*')
          .eq('id', authUser.id)
          .single()

        setUser(profile)
      }
      setLoading(false)
    }

    getUser()

    const { data: { subscription } } = supabase.auth.onAuthStateChange(() => {
      getUser()
    })

    return () => subscription.unsubscribe()
  }, [supabase])

  const handleLogout = async () => {
    await supabase.auth.signOut()
    setUser(null)
    router.push('/')
    router.refresh()
  }

  const isAdmin = user?.role === 'admin' || user?.role === 'instructor'

  return (
    <nav className="bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between h-16 items-center">
          <div className="flex items-center gap-8">
            <Link href="/" className="flex items-center">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img
                src="/images/brand/logo-plenos-color-optimized.png"
                alt="Rizoma Academia"
                className="h-8 w-auto dark:hidden"
              />
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img
                src="/images/brand/logo-plenos-blanco-optimized.png"
                alt="Rizoma Academia"
                className="h-8 w-auto hidden dark:block"
              />
            </Link>
            <div className="hidden md:flex gap-6">
              <Link
                href="/courses"
                className="text-gray-600 dark:text-gray-300 hover:text-rizoma-green dark:hover:text-rizoma-green-light transition-colors"
              >
                Cursos
              </Link>
              {user && (
                <Link
                  href="/dashboard"
                  className="text-gray-600 dark:text-gray-300 hover:text-rizoma-green dark:hover:text-rizoma-green-light transition-colors"
                >
                  Mi progreso
                </Link>
              )}
              {isAdmin && (
                <Link
                  href="/admin/courses"
                  className="text-rizoma-cyan dark:text-rizoma-cyan-light hover:text-rizoma-cyan-dark dark:hover:text-rizoma-cyan transition-colors"
                >
                  Admin
                </Link>
              )}
            </div>
          </div>

          <div className="flex items-center gap-4">
            {loading ? (
              <div className="w-8 h-8 rounded-full bg-gray-200 dark:bg-gray-700 animate-pulse" />
            ) : user ? (
              <div className="flex items-center gap-4">
                <NotificationBell userId={user.id} />
                <span className="text-sm text-gray-600 dark:text-gray-400">
                  {user.full_name || user.role}
                </span>
                <span className="text-xs px-2 py-1 rounded-full bg-rizoma-green/10 text-rizoma-green">
                  {user.role}
                </span>
                <button
                  onClick={handleLogout}
                  className="text-sm text-rizoma-red hover:text-rizoma-red-dark transition-colors"
                >
                  Salir
                </button>
              </div>
            ) : (
              <div className="flex gap-4">
                <Link
                  href="/login"
                  className="text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white transition-colors"
                >
                  Iniciar sesión
                </Link>
                <Link
                  href="/register"
                  className="px-4 py-2 bg-rizoma-green text-white rounded-lg hover:bg-rizoma-green-dark transition-colors"
                >
                  Registrarse
                </Link>
              </div>
            )}
          </div>
        </div>
      </div>
    </nav>
  )
}
