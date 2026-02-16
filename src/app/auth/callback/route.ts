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

  // Build redirect WITHOUT basePath — Next.js automatically prepends basePath
  // to redirect Location headers in route handlers. Including it manually
  // causes /academia/academia/... duplication.
  const forwardedHost = request.headers.get('x-forwarded-host')
  const forwardedProto = (request.headers.get('x-forwarded-proto') ?? 'https').split(',')[0].trim()
  const origin = forwardedHost
    ? `${forwardedProto}://${forwardedHost.split(',')[0].trim()}`
    : new URL(request.url).origin

  const redirectPath = success ? next : '/login?error=auth_failed'
  const response = NextResponse.redirect(`${origin}${redirectPath}`)

  for (const { name, value, options } of cookiesToForward) {
    response.cookies.set(name, value, options as Parameters<typeof response.cookies.set>[2])
  }

  return response
}
