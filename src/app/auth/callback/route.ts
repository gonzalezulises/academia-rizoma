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
    const validTypes = ['magiclink', 'email', 'signup', 'recovery'] as const
    type ValidType = (typeof validTypes)[number]
    if (validTypes.includes(type as ValidType)) {
      const { error } = await supabase.auth.verifyOtp({
        token_hash,
        type: type as ValidType,
      })
      success = !error
    }
  }

  // Use x-forwarded-host to redirect back to the user-facing domain (www.rizo.ma)
  // instead of the internal deployment (academia-rizoma.vercel.app) behind Vercel rewrites.
  // basePath must be included manually — Next.js does NOT auto-add it in route handlers.
  const forwardedHost = request.headers.get('x-forwarded-host')
  const forwardedProto = (request.headers.get('x-forwarded-proto') ?? 'https').split(',')[0].trim()
  const origin = forwardedHost
    ? `${forwardedProto}://${forwardedHost.split(',')[0].trim()}`
    : new URL(request.url).origin
  const basePath = process.env.NEXT_PUBLIC_BASE_PATH ?? ''

  const redirectPath = success ? next : '/auth?error=auth_failed'
  const response = NextResponse.redirect(`${origin}${basePath}${redirectPath}`)

  for (const { name, value, options } of cookiesToForward) {
    response.cookies.set(name, value, options as Parameters<typeof response.cookies.set>[2])
  }

  return response
}
