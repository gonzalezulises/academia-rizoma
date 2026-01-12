'use client'

import { useState, useCallback } from 'react'
import { createClient } from '@/lib/supabase/client'
import type { Resource } from '@/types'

interface ResourceUploadProps {
  lessonId: string
  userId: string
  onUploaded?: (resource: Resource) => void
  onCancel?: () => void
}

const ALLOWED_TYPES = [
  'application/pdf',
  'application/msword',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'application/vnd.ms-excel',
  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  'application/vnd.ms-powerpoint',
  'application/vnd.openxmlformats-officedocument.presentationml.presentation',
  'text/plain',
  'text/csv',
  'image/jpeg',
  'image/png',
  'image/gif',
  'image/webp',
  'application/zip',
  'application/x-rar-compressed'
]

const MAX_FILE_SIZE = 50 * 1024 * 1024 // 50MB

export default function ResourceUpload({
  lessonId,
  userId,
  onUploaded,
  onCancel
}: ResourceUploadProps) {
  const [title, setTitle] = useState('')
  const [description, setDescription] = useState('')
  const [file, setFile] = useState<File | null>(null)
  const [uploading, setUploading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [dragActive, setDragActive] = useState(false)
  const supabase = createClient()

  const handleDrag = useCallback((e: React.DragEvent) => {
    e.preventDefault()
    e.stopPropagation()
    if (e.type === 'dragenter' || e.type === 'dragover') {
      setDragActive(true)
    } else if (e.type === 'dragleave') {
      setDragActive(false)
    }
  }, [])

  const handleDrop = useCallback((e: React.DragEvent) => {
    e.preventDefault()
    e.stopPropagation()
    setDragActive(false)

    if (e.dataTransfer.files && e.dataTransfer.files[0]) {
      validateAndSetFile(e.dataTransfer.files[0])
    }
  }, [])

  const validateAndSetFile = (selectedFile: File) => {
    setError(null)

    if (!ALLOWED_TYPES.includes(selectedFile.type)) {
      setError('Tipo de archivo no permitido')
      return
    }

    if (selectedFile.size > MAX_FILE_SIZE) {
      setError('El archivo excede el limite de 50MB')
      return
    }

    setFile(selectedFile)
    if (!title) {
      setTitle(selectedFile.name.replace(/\.[^/.]+$/, ''))
    }
  }

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      validateAndSetFile(e.target.files[0])
    }
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()

    if (!file) {
      setError('Selecciona un archivo')
      return
    }

    if (!title.trim()) {
      setError('El titulo es requerido')
      return
    }

    setUploading(true)
    setError(null)

    try {
      // Upload file to storage
      const fileExt = file.name.split('.').pop()
      const fileName = `${userId}/${lessonId}/${Date.now()}.${fileExt}`

      const { error: uploadError } = await supabase.storage
        .from('resources')
        .upload(fileName, file)

      if (uploadError) {
        throw new Error('Error al subir el archivo')
      }

      // Get public URL
      const { data: { publicUrl } } = supabase.storage
        .from('resources')
        .getPublicUrl(fileName)

      // Create resource record
      const { data, error: dbError } = await supabase
        .from('resources')
        .insert({
          lesson_id: lessonId,
          title: title.trim(),
          description: description.trim() || null,
          file_url: publicUrl,
          file_type: file.type,
          file_size: file.size,
          created_by: userId
        })
        .select()
        .single()

      if (dbError) {
        throw new Error('Error al guardar el recurso')
      }

      onUploaded?.(data as Resource)
      setTitle('')
      setDescription('')
      setFile(null)
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Error al subir el recurso')
    } finally {
      setUploading(false)
    }
  }

  return (
    <form onSubmit={handleSubmit} className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm">
      <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
        Subir recurso
      </h3>

      {error && (
        <div className="mb-4 p-3 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg">
          <p className="text-sm text-red-600 dark:text-red-400">{error}</p>
        </div>
      )}

      <div className="space-y-4">
        {/* File upload area */}
        <div
          onDragEnter={handleDrag}
          onDragLeave={handleDrag}
          onDragOver={handleDrag}
          onDrop={handleDrop}
          className={`
            relative border-2 border-dashed rounded-xl p-8 text-center transition-colors
            ${dragActive
              ? 'border-rizoma-green bg-rizoma-green/5 dark:bg-rizoma-green-dark/20'
              : file
                ? 'border-green-500 bg-green-50 dark:bg-green-900/20'
                : 'border-gray-300 dark:border-gray-600 hover:border-gray-400'
            }
          `}
        >
          <input
            type="file"
            onChange={handleFileChange}
            accept={ALLOWED_TYPES.join(',')}
            className="absolute inset-0 w-full h-full opacity-0 cursor-pointer"
          />

          {file ? (
            <div className="flex items-center justify-center gap-3">
              <svg className="w-8 h-8 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              <div className="text-left">
                <p className="font-medium text-gray-900 dark:text-white">{file.name}</p>
                <p className="text-sm text-gray-500">{(file.size / 1024 / 1024).toFixed(2)} MB</p>
              </div>
              <button
                type="button"
                onClick={(e) => { e.stopPropagation(); setFile(null) }}
                className="p-1 text-gray-500 hover:text-red-500"
              >
                <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>
          ) : (
            <>
              <svg className="mx-auto w-12 h-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
              </svg>
              <p className="mt-2 text-sm text-gray-600 dark:text-gray-400">
                <span className="font-medium text-rizoma-green dark:text-rizoma-green-light">Haz click para subir</span> o arrastra y suelta
              </p>
              <p className="mt-1 text-xs text-gray-500">
                PDF, Word, Excel, PowerPoint, imagenes (max. 50MB)
              </p>
            </>
          )}
        </div>

        {/* Title */}
        <div>
          <label htmlFor="title" className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Titulo
          </label>
          <input
            id="title"
            type="text"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            placeholder="Nombre del recurso"
            className="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white placeholder-gray-500 focus:ring-2 focus:ring-rizoma-green focus:border-transparent"
          />
        </div>

        {/* Description */}
        <div>
          <label htmlFor="description" className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Descripcion (opcional)
          </label>
          <textarea
            id="description"
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            rows={2}
            placeholder="Breve descripcion del recurso..."
            className="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white placeholder-gray-500 focus:ring-2 focus:ring-rizoma-green focus:border-transparent resize-none"
          />
        </div>
      </div>

      {/* Actions */}
      <div className="flex items-center justify-end gap-3 mt-6 pt-4 border-t border-gray-200 dark:border-gray-700">
        {onCancel && (
          <button
            type="button"
            onClick={onCancel}
            className="px-4 py-2 text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200"
          >
            Cancelar
          </button>
        )}
        <button
          type="submit"
          disabled={uploading || !file || !title.trim()}
          className="px-6 py-2 bg-rizoma-green text-white rounded-lg font-medium hover:bg-rizoma-green-dark disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
        >
          {uploading ? 'Subiendo...' : 'Subir recurso'}
        </button>
      </div>
    </form>
  )
}
