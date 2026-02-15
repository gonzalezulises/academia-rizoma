import { createServerClient } from '@supabase/ssr'
import { type NextRequest, NextResponse } from 'next/server'

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url)
  const code = searchParams.get('code')
  const token_hash = searchParams.get('token_hash')
  const type = searchParams.get('type')
  const nextParam = searchParams.get('next') ?? '/courses'
  // Only allow relative paths (prevent open redirect)
  const next = (nextParam.startsWith('/') && !nextParam.startsWith('//')) ? nextParam : '/courses'

  const cookiesToForward: { name: string; value: string; options: Record<string, unknown> }[] = []

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll: () => request.cookies.getAll(),
        setAll: (cookiesToSet) => {
          cookiesToForward.push(...cookiesToSet)
        },
      },
    }
  )

  let success = false

  // PKCE flow: Supabase redirects with ?code=
  if (code) {
    const { error } = await supabase.auth.exchangeCodeForSession(code)
    success = !error
  }
  // Token hash flow: Supabase redirects with ?token_hash=&type=
  else if (token_hash && type) {
    const { error } = await supabase.auth.verifyOtp({
      token_hash,
      type: type as 'magiclink' | 'email',
    })
    success = !error
  }

  // Use nextUrl which handles basePath automatically — avoids double /academia
  // Also override host for Vercel rewrites so cookies land on the user-facing domain
  const redirectUrl = request.nextUrl.clone()
  redirectUrl.pathname = success ? next : '/login'
  redirectUrl.search = success ? '' : '?error=auth_failed'

  const forwardedHost = request.headers.get('x-forwarded-host')
  if (forwardedHost) {
    redirectUrl.host = forwardedHost
    redirectUrl.protocol = request.headers.get('x-forwarded-proto') ?? 'https'
  }

  const response = NextResponse.redirect(redirectUrl)

  for (const { name, value, options } of cookiesToForward) {
    response.cookies.set(name, value, options as Parameters<typeof response.cookies.set>[2])
  }

  return response
}
