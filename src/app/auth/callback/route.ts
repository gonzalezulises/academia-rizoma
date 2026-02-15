import { createServerClient } from '@supabase/ssr'
import { type NextRequest, NextResponse } from 'next/server'

const basePath = process.env.NEXT_PUBLIC_BASE_PATH ?? ''

export async function GET(request: NextRequest) {
  const { searchParams, origin } = new URL(request.url)
  const code = searchParams.get('code')
  const token_hash = searchParams.get('token_hash')
  const type = searchParams.get('type')
  const next = searchParams.get('next') ?? '/courses'

  const redirectUrl = `${origin}${basePath}${next}`
  const response = NextResponse.redirect(redirectUrl)

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll: () => request.cookies.getAll(),
        setAll: (cookiesToSet) => {
          cookiesToSet.forEach(({ name, value, options }) =>
            response.cookies.set(name, value, options)
          )
        },
      },
    }
  )

  // PKCE flow: Supabase redirects with ?code=
  if (code) {
    const { error } = await supabase.auth.exchangeCodeForSession(code)
    if (!error) {
      console.log('[auth/callback] Code exchange succeeded')
      return response
    }
    console.error('[auth/callback] Code exchange failed:', error.message)
  }

  // Token hash flow: Supabase redirects with ?token_hash=&type=
  if (token_hash && type) {
    const { error } = await supabase.auth.verifyOtp({
      token_hash,
      type: type as 'magiclink' | 'email',
    })
    if (!error) {
      console.log('[auth/callback] Token hash verification succeeded')
      return response
    }
    console.error('[auth/callback] Token hash verification failed:', error.message)
  }

  // Debug: log what params were received
  console.error('[auth/callback] No valid auth params. Params:', Object.fromEntries(searchParams.entries()))

  return NextResponse.redirect(`${origin}${basePath}/login?error=invalid`)
}
