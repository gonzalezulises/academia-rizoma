'use client'

import { useState, useMemo } from 'react'
import { createClient } from '@/lib/supabase/client'
import { ResourceList, ResourceUpload } from '@/components/resources'
import type { Resource } from '@/types'

interface LessonResourcesProps {
  lessonId: string
  userId: string
  isInstructor: boolean
  initialResources: Resource[]
}

export default function LessonResources({
  lessonId,
  userId,
  isInstructor,
  initialResources
}: LessonResourcesProps) {
  const [resources, setResources] = useState(initialResources)
  const [showUpload, setShowUpload] = useState(false)
  const supabase = useMemo(() => createClient(), [])

  const handleUploaded = (newResource: Resource) => {
    setResources((prev) => [...prev, newResource])
    setShowUpload(false)
  }

  const handleDelete = async (resourceId: string) => {
    if (!confirm('¿Estas seguro de eliminar este recurso?')) return

    const { error } = await supabase
      .from('resources')
      .delete()
      .eq('id', resourceId)

    if (!error) {
      setResources((prev) => prev.filter((r) => r.id !== resourceId))
    }
  }

  if (resources.length === 0 && !isInstructor) {
    return null
  }

  return (
    <div className="mt-8 pt-8 border-t border-gray-200 dark:border-gray-700">
      <div className="flex items-center justify-between mb-4">
        <h2 className="text-lg font-semibold text-gray-900 dark:text-white">
          Recursos descargables
        </h2>
        {isInstructor && !showUpload && (
          <button
            onClick={() => setShowUpload(true)}
            className="text-sm text-rizoma-green dark:text-rizoma-green-light hover:underline"
          >
            + Agregar recurso
          </button>
        )}
      </div>

      {showUpload && (
        <div className="mb-6">
          <ResourceUpload
            lessonId={lessonId}
            userId={userId}
            onUploaded={handleUploaded}
            onCancel={() => setShowUpload(false)}
          />
        </div>
      )}

      <ResourceList
        resources={resources}
        isInstructor={isInstructor}
        onDelete={handleDelete}
      />
    </div>
  )
}
