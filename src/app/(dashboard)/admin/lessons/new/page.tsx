'use client'

import { useSearchParams } from 'next/navigation'
import { Suspense } from 'react'
import Navbar from '@/components/Navbar'
import LessonWizard from '@/components/admin/lesson-wizard/LessonWizard'
import Link from 'next/link'

function WizardContent() {
  const searchParams = useSearchParams()
  const courseId = searchParams.get('courseId')

  if (!courseId) {
    return (
      <div className="text-center py-12">
        <p className="text-gray-500 dark:text-gray-400 mb-4">
          Se requiere un curso para crear una leccion.
        </p>
        <Link
          href="/admin/courses"
          className="text-rizoma-green hover:underline"
        >
          Ir a mis cursos
        </Link>
      </div>
    )
  }

  return <LessonWizard courseId={courseId} />
}

export default function NewLessonWizardPage() {
  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <Navbar />
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-6">
          <Link
            href="/admin/courses"
            className="text-sm text-rizoma-green dark:text-rizoma-green-light hover:underline mb-2 inline-block"
          >
            &larr; Volver a cursos
          </Link>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
            Crear leccion (Wizard 4C)
          </h1>
          <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
            Modelo pedagogico: Connection, Concepts, Concrete Practice, Conclusions
          </p>
        </div>
        <Suspense fallback={<div className="text-gray-500">Cargando wizard...</div>}>
          <WizardContent />
        </Suspense>
      </div>
    </div>
  )
}
