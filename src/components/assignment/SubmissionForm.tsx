'use client'

import { useState, useRef } from 'react'
import { createClient } from '@/lib/supabase/client'
import type { Assignment, Submission } from '@/types'

interface SubmissionFormProps {
  assignment: Assignment
  userId: string
  existingSubmission?: Submission | null
  onSubmit?: (submission: Submission) => void
}

export default function SubmissionForm({
  assignment,
  userId,
  existingSubmission,
  onSubmit
}: SubmissionFormProps) {
  const [file, setFile] = useState<File | null>(null)
  const [comments, setComments] = useState(existingSubmission?.comments || '')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [dragActive, setDragActive] = useState(false)
  const fileInputRef = useRef<HTMLInputElement>(null)
  const supabase = createClient()

  const isLate = assignment.due_date && new Date(assignment.due_date) < new Date()
  const canSubmit = !existingSubmission || existingSubmission.status === 'pending' || existingSubmission.status === 'rejected'

  const validateFile = (file: File): string | null => {
    // Check file type
    const extension = file.name.split('.').pop()?.toLowerCase()
    if (assignment.allowed_file_types.length > 0 && extension && !assignment.allowed_file_types.includes(extension)) {
      return `Tipo de archivo no permitido. Tipos aceptados: ${assignment.allowed_file_types.join(', ')}`
    }

    // Check file size (max_file_size is in bytes)
    if (file.size > assignment.max_file_size) {
      const maxSizeMB = Math.round(assignment.max_file_size / (1024 * 1024))
      return `El archivo excede el tamaño máximo de ${maxSizeMB}MB`
    }

    return null
  }

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const selectedFile = e.target.files?.[0]
    if (selectedFile) {
      const validationError = validateFile(selectedFile)
      if (validationError) {
        setError(validationError)
        setFile(null)
      } else {
        setError(null)
        setFile(selectedFile)
      }
    }
  }

  const handleDrag = (e: React.DragEvent) => {
    e.preventDefault()
    e.stopPropagation()
    if (e.type === 'dragenter' || e.type === 'dragover') {
      setDragActive(true)
    } else if (e.type === 'dragleave') {
      setDragActive(false)
    }
  }

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault()
    e.stopPropagation()
    setDragActive(false)

    const droppedFile = e.dataTransfer.files?.[0]
    if (droppedFile) {
      const validationError = validateFile(droppedFile)
      if (validationError) {
        setError(validationError)
        setFile(null)
      } else {
        setError(null)
        setFile(droppedFile)
      }
    }
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()

    if (!file && !existingSubmission?.file_url) {
      setError('Debes seleccionar un archivo')
      return
    }

    setLoading(true)
    setError(null)

    let fileUrl = existingSubmission?.file_url || ''
    let fileName = existingSubmission?.file_name || ''
    let fileSize = existingSubmission?.file_size || 0

    // Upload file if new one selected
    if (file) {
      const fileExt = file.name.split('.').pop()
      const filePath = `submissions/${userId}/${assignment.id}/${Date.now()}.${fileExt}`

      const { error: uploadError } = await supabase.storage
        .from('assignments')
        .upload(filePath, file)

      if (uploadError) {
        setError('Error al subir el archivo')
        setLoading(false)
        return
      }

      const { data: { publicUrl } } = supabase.storage
        .from('assignments')
        .getPublicUrl(filePath)

      fileUrl = publicUrl
      fileName = file.name
      fileSize = file.size
    }

    // Create or update submission
    const submissionData = {
      assignment_id: assignment.id,
      user_id: userId,
      file_url: fileUrl,
      file_name: fileName,
      file_size: fileSize,
      comments: comments.trim() || null,
      status: isLate ? 'late' : 'pending',
      submitted_at: new Date().toISOString()
    }

    let result
    if (existingSubmission) {
      result = await supabase
        .from('submissions')
        .update(submissionData)
        .eq('id', existingSubmission.id)
        .select()
        .single()
    } else {
      result = await supabase
        .from('submissions')
        .insert(submissionData)
        .select()
        .single()
    }

    if (result.error) {
      setError('Error al guardar la entrega')
      setLoading(false)
      return
    }

    onSubmit?.(result.data as Submission)
    setLoading(false)
  }

  const formatFileSize = (bytes: number) => {
    if (bytes < 1024) return `${bytes} B`
    if (bytes < 1024 * 1024) return `${Math.round(bytes / 1024)} KB`
    return `${Math.round(bytes / (1024 * 1024))} MB`
  }

  if (!canSubmit && existingSubmission) {
    return (
      <div className="bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800 rounded-xl p-6">
        <div className="flex items-center gap-3 mb-4">
          <span className="text-3xl">✅</span>
          <div>
            <h3 className="text-lg font-semibold text-green-800 dark:text-green-200">
              Entrega recibida
            </h3>
            <p className="text-sm text-green-600 dark:text-green-400">
              Estado: {existingSubmission.status === 'approved' ? 'Aprobada' : 'En revision'}
            </p>
          </div>
        </div>
        {existingSubmission.file_name && (
          <p className="text-sm text-gray-600 dark:text-gray-400">
            Archivo: {existingSubmission.file_name}
          </p>
        )}
        {existingSubmission.score !== null && (
          <p className="text-lg font-bold text-green-700 dark:text-green-300 mt-2">
            Calificacion: {existingSubmission.score}/{assignment.max_score}
          </p>
        )}
        {existingSubmission.feedback && (
          <div className="mt-4 p-4 bg-white dark:bg-gray-800 rounded-lg">
            <p className="text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Retroalimentacion:
            </p>
            <p className="text-gray-600 dark:text-gray-400">
              {existingSubmission.feedback}
            </p>
          </div>
        )}
      </div>
    )
  }

  return (
    <form onSubmit={handleSubmit} className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm">
      <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
        {existingSubmission ? 'Actualizar entrega' : 'Subir entrega'}
      </h3>

      {isLate && (
        <div className="mb-4 p-3 bg-yellow-50 dark:bg-yellow-900/20 border border-yellow-200 dark:border-yellow-800 rounded-lg">
          <p className="text-sm text-yellow-800 dark:text-yellow-200">
            La fecha limite ha pasado. Tu entrega sera marcada como tardia.
          </p>
        </div>
      )}

      {error && (
        <div className="mb-4 p-3 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg">
          <p className="text-sm text-red-600 dark:text-red-400">{error}</p>
        </div>
      )}

      {/* File upload area */}
      <div
        className={`border-2 border-dashed rounded-xl p-8 text-center transition-colors ${
          dragActive
            ? 'border-rizoma-green bg-rizoma-green/5 dark:bg-rizoma-green-dark/20'
            : 'border-gray-300 dark:border-gray-600 hover:border-gray-400 dark:hover:border-gray-500'
        }`}
        onDragEnter={handleDrag}
        onDragLeave={handleDrag}
        onDragOver={handleDrag}
        onDrop={handleDrop}
        onClick={() => fileInputRef.current?.click()}
      >
        <input
          ref={fileInputRef}
          type="file"
          onChange={handleFileChange}
          accept={assignment.allowed_file_types.map(t => `.${t}`).join(',')}
          className="hidden"
        />

        {file ? (
          <div>
            <span className="text-4xl block mb-2">📄</span>
            <p className="text-gray-900 dark:text-white font-medium">{file.name}</p>
            <p className="text-sm text-gray-500">{formatFileSize(file.size)}</p>
            <button
              type="button"
              onClick={(e) => {
                e.stopPropagation()
                setFile(null)
              }}
              className="mt-2 text-sm text-red-600 hover:underline"
            >
              Cambiar archivo
            </button>
          </div>
        ) : (
          <div>
            <span className="text-4xl block mb-2">📁</span>
            <p className="text-gray-600 dark:text-gray-400 mb-2">
              Arrastra tu archivo aqui o haz clic para seleccionar
            </p>
            <p className="text-sm text-gray-500">
              Formatos: {assignment.allowed_file_types.join(', ').toUpperCase()}
            </p>
            <p className="text-sm text-gray-500">
              Tamaño maximo: {formatFileSize(assignment.max_file_size)}
            </p>
          </div>
        )}
      </div>

      {/* Comments */}
      <div className="mt-4">
        <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
          Comentarios (opcional)
        </label>
        <textarea
          value={comments}
          onChange={(e) => setComments(e.target.value)}
          rows={3}
          placeholder="Agrega notas o comentarios sobre tu entrega..."
          className="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white placeholder-gray-500 focus:ring-2 focus:ring-rizoma-green focus:border-transparent resize-none"
        />
      </div>

      {/* Submit button */}
      <button
        type="submit"
        disabled={loading || (!file && !existingSubmission?.file_url)}
        className="mt-4 w-full py-3 bg-purple-600 text-white rounded-lg font-medium hover:bg-purple-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
      >
        {loading ? 'Subiendo...' : existingSubmission ? 'Actualizar entrega' : 'Entregar'}
      </button>
    </form>
  )
}
