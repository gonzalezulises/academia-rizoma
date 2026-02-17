import { Suspense } from 'react'
import UnifiedAuthForm from '@/components/UnifiedAuthForm'

export const metadata = {
  title: 'Acceder — Academia Rizoma',
}

export default function AuthPage() {
  return (
    <Suspense>
      <UnifiedAuthForm />
    </Suspense>
  )
}
