import { NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'

export type AuthResult = {
  user: { id: string }
  supabase: Awaited<ReturnType<typeof createClient>>
}

export type AdminResult = AuthResult & {
  profile: { role: string }
}

function apiError(message: string, status: number) {
  return NextResponse.json({ error: message }, { status })
}

/**
 * Require authenticated user for API routes.
 * Returns the user and supabase client, or a NextResponse error.
 */
export async function requireAuth(): Promise<AuthResult | NextResponse> {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) {
    return apiError('Unauthorized', 401)
  }

  return { user, supabase }
}

/**
 * Require admin or instructor role for API routes.
 * Returns the user, profile and supabase client, or a NextResponse error.
 */
export async function requireAdmin(): Promise<AdminResult | NextResponse> {
  const result = await requireAuth()
  if (result instanceof NextResponse) return result

  const { user, supabase } = result

  const { data: profile } = await supabase
    .from('profiles')
    .select('role')
    .eq('id', user.id)
    .single()

  if (!profile || (profile.role !== 'admin' && profile.role !== 'instructor')) {
    return apiError('Forbidden', 403)
  }

  return { user, supabase, profile }
}

/** Type guard: checks if the result is an error response */
export function isAuthError(result: AuthResult | AdminResult | NextResponse): result is NextResponse {
  return result instanceof NextResponse
}
