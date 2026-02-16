'use client'

import { use, useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import Navbar from '@/components/Navbar'
import LessonWizard from '@/components/admin/lesson-wizard/LessonWizard'
import Link from 'next/link'

interface PageProps {
  params: Promise<{ id: string }>
}

export default function EditLessonWizardPage({ params }: PageProps) {
  const { id: lessonId } = use(params)
  const [courseId, setCourseId] = useState<string | null>(null)
  const [loading, setLoading] = useState(true)
  const supabase = createClient()

  useEffect(() => {
    const loadLesson = async () => {
      const { data } = await supabase
        .from('lessons')
        .select('course_id')
        .eq('id', lessonId)
        .single()

      if (data) setCourseId(data.course_id)
      setLoading(false)
    }

    loadLesson()
  }, [lessonId, supabase])

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <Navbar />
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-6">
          {courseId && (
            <Link
              href={`/admin/courses/${courseId}`}
              className="text-sm text-rizoma-green dark:text-rizoma-green-light hover:underline mb-2 inline-block"
            >
              &larr; Volver al curso
            </Link>
          )}
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
            Editar leccion (Wizard 4C)
          </h1>
        </div>
        {loading ? (
          <div className="text-gray-500">Cargando...</div>
        ) : courseId ? (
          <LessonWizard courseId={courseId} lessonId={lessonId} />
        ) : (
          <div className="text-center py-12">
            <p className="text-gray-500 dark:text-gray-400">
              Leccion no encontrada.
            </p>
          </div>
        )}
      </div>
    </div>
  )
}
