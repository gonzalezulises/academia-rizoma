import { createServerClient } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'

// Routes that require authentication
const PROTECTED_PREFIXES = ['/dashboard', '/admin', '/courses/']
// Legacy auth routes → redirect to /auth
const LEGACY_AUTH_ROUTES = ['/login', '/register']
// All auth routes (for redirecting authenticated users away)
const AUTH_ROUTES = ['/login', '/register', '/auth']

export async function middleware(request: NextRequest) {
  let supabaseResponse = NextResponse.next({ request })

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll: () => request.cookies.getAll(),
        setAll: (cookiesToSet) => {
          cookiesToSet.forEach(({ name, value }) =>
            request.cookies.set(name, value)
          )
          supabaseResponse = NextResponse.next({ request })
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options)
          )
        },
      },
    }
  )

  // Refresh the session — required for Server Components to read updated cookies
  const { data: { user } } = await supabase.auth.getUser()

  const pathname = request.nextUrl.pathname

  // Redirect legacy /login and /register to /auth
  if (LEGACY_AUTH_ROUTES.some(route => pathname === route)) {
    const authUrl = request.nextUrl.clone()
    authUrl.pathname = '/auth'
    // Preserve any existing ?next= param
    const existingNext = request.nextUrl.searchParams.get('next')
    if (existingNext) authUrl.searchParams.set('next', existingNext)
    return NextResponse.redirect(authUrl)
  }

  // Redirect unauthenticated users away from protected routes
  const isProtected = PROTECTED_PREFIXES.some(prefix => pathname.startsWith(prefix))
  if (isProtected && !user) {
    const authUrl = request.nextUrl.clone()
    authUrl.pathname = '/auth'
    authUrl.searchParams.set('next', pathname)
    return NextResponse.redirect(authUrl)
  }

  // Redirect authenticated users away from auth routes
  const isAuthRoute = AUTH_ROUTES.some(route => pathname === route)
  if (isAuthRoute && user) {
    const coursesUrl = request.nextUrl.clone()
    coursesUrl.pathname = '/courses'
    return NextResponse.redirect(coursesUrl)
  }

  return supabaseResponse
}

export const config = {
  matcher: ['/((?!_next/static|_next/image|favicon.png|images/).*)'],
}
