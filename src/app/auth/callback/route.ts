import { createServerClient } from '@supabase/ssr'
import { type NextRequest, NextResponse } from 'next/server'

const basePath = process.env.NEXT_PUBLIC_BASE_PATH ?? ''

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url)
  const code = searchParams.get('code')
  const token_hash = searchParams.get('token_hash')
  const type = searchParams.get('type')
  const next = searchParams.get('next') ?? '/courses'

  // Behind a Vercel rewrite (www.rizo.ma/academia/* → academia-rizoma.vercel.app/*),
  // request.url.origin is the internal deployment URL. We must redirect back to the
  // user-facing domain so cookies land on the correct origin.
  const forwardedHost = request.headers.get('x-forwarded-host')
  const forwardedProto = request.headers.get('x-forwarded-proto') ?? 'https'
  const origin = forwardedHost
    ? `${forwardedProto}://${forwardedHost}`
    : new URL(request.url).origin
  const baseRedirect = `${origin}${basePath}`

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

  const redirectUrl = success
    ? `${baseRedirect}${next}`
    : `${baseRedirect}/login?error=auth_failed`

  const response = NextResponse.redirect(redirectUrl)

  for (const { name, value, options } of cookiesToForward) {
    response.cookies.set(name, value, options as Parameters<typeof response.cookies.set>[2])
  }

  return response
}
