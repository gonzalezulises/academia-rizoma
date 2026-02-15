import { createClient } from '@/lib/supabase/server'
import { NextResponse } from 'next/server'

const basePath = process.env.NEXT_PUBLIC_BASE_PATH ?? ''

export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url)
  const code = searchParams.get('code')
  const next = searchParams.get('next') ?? '/courses'

  if (code) {
    const supabase = await createClient()
    const { error } = await supabase.auth.exchangeCodeForSession(code)
    if (!error) {
      return NextResponse.redirect(`${origin}${basePath}${next}`)
    }
  }

  return NextResponse.redirect(`${origin}${basePath}/login?error=invalid`)
}
