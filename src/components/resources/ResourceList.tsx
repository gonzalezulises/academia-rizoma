'use client'

import { useState, useMemo } from 'react'
import { createClient } from '@/lib/supabase/client'
import type { Resource } from '@/types'

interface ResourceListProps {
  resources: Resource[]
  isInstructor?: boolean
  onDelete?: (resourceId: string) => void
}

const FILE_ICONS: Record<string, string> = {
  pdf: 'M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z',
  doc: 'M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z',
  image: 'M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z',
  video: 'M15 10l4.553-2.276A1 1 0 0121 8.618v6.764a1 1 0 01-1.447.894L15 14M5 18h8a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z',
  default: 'M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z'
}

function getFileIcon(fileType: string | null): string {
  if (!fileType) return FILE_ICONS.default
  if (fileType.includes('pdf')) return FILE_ICONS.pdf
  if (fileType.includes('doc') || fileType.includes('word')) return FILE_ICONS.doc
  if (fileType.includes('image')) return FILE_ICONS.image
  if (fileType.includes('video')) return FILE_ICONS.video
  return FILE_ICONS.default
}

function formatFileSize(bytes: number | null): string {
  if (!bytes) return ''
  if (bytes < 1024) return `${bytes} B`
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`
}

export default function ResourceList({ resources, isInstructor, onDelete }: ResourceListProps) {
  const [downloading, setDownloading] = useState<string | null>(null)
  const supabase = useMemo(() => createClient(), [])

  const handleDownload = async (resource: Resource) => {
    setDownloading(resource.id)

    try {
      // Increment download count
      await supabase.rpc('increment_download_count', { resource_id: resource.id })

      // Open download link
      window.open(resource.file_url, '_blank')
    } finally {
      setDownloading(null)
    }
  }

  if (resources.length === 0) {
    return (
      <div className="text-center py-8 text-gray-500 dark:text-gray-400">
        No hay recursos disponibles para esta leccion
      </div>
    )
  }

  return (
    <div className="space-y-3">
      {resources.map((resource) => (
        <div
          key={resource.id}
          className="flex items-center justify-between p-4 bg-gray-50 dark:bg-gray-800 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
        >
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-rizoma-green/10 dark:bg-rizoma-green-dark/30 rounded-lg flex items-center justify-center">
              <svg
                className="w-5 h-5 text-rizoma-green dark:text-rizoma-green-light"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d={getFileIcon(resource.file_type)}
                />
              </svg>
            </div>
            <div>
              <h4 className="font-medium text-gray-900 dark:text-white">
                {resource.title}
              </h4>
              <div className="flex items-center gap-2 text-sm text-gray-500 dark:text-gray-400">
                {resource.file_size && (
                  <span>{formatFileSize(resource.file_size)}</span>
                )}
                {resource.download_count > 0 && (
                  <>
                    <span>•</span>
                    <span>{resource.download_count} descargas</span>
                  </>
                )}
              </div>
              {resource.description && (
                <p className="text-sm text-gray-600 dark:text-gray-400 mt-1">
                  {resource.description}
                </p>
              )}
            </div>
          </div>

          <div className="flex items-center gap-2">
            <button
              onClick={() => handleDownload(resource)}
              disabled={downloading === resource.id}
              className="p-2 text-rizoma-green dark:text-rizoma-green-light hover:bg-rizoma-green/10 dark:hover:bg-rizoma-green-dark/30 rounded-lg transition-colors disabled:opacity-50"
              title="Descargar"
            >
              {downloading === resource.id ? (
                <svg className="w-5 h-5 animate-spin" fill="none" viewBox="0 0 24 24">
                  <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                  <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
                </svg>
              ) : (
                <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
                </svg>
              )}
            </button>

            {isInstructor && onDelete && (
              <button
                onClick={() => onDelete(resource.id)}
                className="p-2 text-red-600 dark:text-red-400 hover:bg-red-100 dark:hover:bg-red-900/30 rounded-lg transition-colors"
                title="Eliminar"
              >
                <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                </svg>
              </button>
            )}
          </div>
        </div>
      ))}
    </div>
  )
}
