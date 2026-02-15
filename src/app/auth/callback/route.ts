import { createServerClient } from '@supabase/ssr'
import { type NextRequest, NextResponse } from 'next/server'

const basePath = process.env.NEXT_PUBLIC_BASE_PATH ?? ''

export async function GET(request: NextRequest) {
  const { searchParams, origin } = new URL(request.url)
  const code = searchParams.get('code')
  const token_hash = searchParams.get('token_hash')
  const type = searchParams.get('type')
  const next = searchParams.get('next') ?? '/courses'

  // We'll build the final redirect URL after we know the outcome
  const baseRedirect = `${origin}${basePath}`

  // Track cookies set by Supabase for the final response
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

  let authResult = 'no_params'

  // PKCE flow: Supabase redirects with ?code=
  if (code) {
    const { error } = await supabase.auth.exchangeCodeForSession(code)
    authResult = error ? `code_fail:${error.message}` : 'code_ok'
  }
  // Token hash flow: Supabase redirects with ?token_hash=&type=
  else if (token_hash && type) {
    const { error } = await supabase.auth.verifyOtp({
      token_hash,
      type: type as 'magiclink' | 'email',
    })
    authResult = error ? `token_fail:${error.message}` : 'token_ok'
  }

  // Build redirect based on result
  const isSuccess = authResult === 'code_ok' || authResult === 'token_ok'
  const redirectUrl = isSuccess
    ? `${baseRedirect}${next}?_dbg=${encodeURIComponent(authResult)}&cookies=${cookiesToForward.length}`
    : `${baseRedirect}/login?error=${encodeURIComponent(authResult)}&params=${[...searchParams.keys()].join(',')}`

  const response = NextResponse.redirect(redirectUrl)

  // Apply all cookies Supabase wanted to set onto the final response
  for (const { name, value, options } of cookiesToForward) {
    response.cookies.set(name, value, options as Parameters<typeof response.cookies.set>[2])
  }

  return response
}
