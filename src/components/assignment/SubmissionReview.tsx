'use client'

import { useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import type { SubmissionWithDetails, SubmissionStatus } from '@/types'

interface SubmissionReviewProps {
  submission: SubmissionWithDetails
  maxScore: number
  onUpdate?: (submission: SubmissionWithDetails) => void
}

export default function SubmissionReview({
  submission: initialSubmission,
  maxScore,
  onUpdate
}: SubmissionReviewProps) {
  const [submission, setSubmission] = useState(initialSubmission)
  const [score, setScore] = useState(submission.score?.toString() || '')
  const [feedback, setFeedback] = useState(submission.feedback || '')
  const [status, setStatus] = useState<SubmissionStatus>(submission.status)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [success, setSuccess] = useState(false)
  const supabase = createClient()

  const formatDate = (date: string) => {
    return new Date(date).toLocaleDateString('es-ES', {
      day: 'numeric',
      month: 'long',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    })
  }

  const formatFileSize = (bytes: number | null) => {
    if (!bytes) return 'N/A'
    if (bytes < 1024) return `${bytes} B`
    if (bytes < 1024 * 1024) return `${Math.round(bytes / 1024)} KB`
    return `${Math.round(bytes / (1024 * 1024))} MB`
  }

  const getStatusBadge = (status: SubmissionStatus) => {
    const styles = {
      pending: 'bg-yellow-100 dark:bg-yellow-900/30 text-yellow-700 dark:text-yellow-400',
      reviewed: 'bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-400',
      approved: 'bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-400',
      rejected: 'bg-red-100 dark:bg-red-900/30 text-red-700 dark:text-red-400',
      late: 'bg-orange-100 dark:bg-orange-900/30 text-orange-700 dark:text-orange-400'
    }
    const labels = {
      pending: 'Pendiente',
      reviewed: 'Revisada',
      approved: 'Aprobada',
      rejected: 'Rechazada',
      late: 'Tardia'
    }
    return (
      <span className={`px-2 py-1 rounded-full text-xs font-medium ${styles[status]}`}>
        {labels[status]}
      </span>
    )
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()

    const scoreNum = parseFloat(score)
    if (score && (isNaN(scoreNum) || scoreNum < 0 || scoreNum > maxScore)) {
      setError(`La calificacion debe estar entre 0 y ${maxScore}`)
      return
    }

    setLoading(true)
    setError(null)
    setSuccess(false)

    const { data: { user } } = await supabase.auth.getUser()

    const updateData = {
      score: score ? scoreNum : null,
      feedback: feedback.trim() || null,
      status,
      reviewed_at: new Date().toISOString(),
      reviewed_by: user?.id
    }

    const { data, error: updateError } = await supabase
      .from('submissions')
      .update(updateData)
      .eq('id', submission.id)
      .select()
      .single()

    if (updateError) {
      setError('Error al guardar la revision')
      setLoading(false)
      return
    }

    const updatedSubmission = { ...submission, ...data }
    setSubmission(updatedSubmission)
    onUpdate?.(updatedSubmission)
    setSuccess(true)
    setLoading(false)

    setTimeout(() => setSuccess(false), 3000)
  }

  return (
    <div className="bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden">
      {/* Header */}
      <div className="p-4 border-b border-gray-200 dark:border-gray-700">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            {submission.user?.avatar_url ? (
              <img
                src={submission.user.avatar_url}
                alt={submission.user.full_name || 'Usuario'}
                className="w-10 h-10 rounded-full object-cover"
              />
            ) : (
              <div className="w-10 h-10 rounded-full bg-purple-100 dark:bg-purple-900/30 flex items-center justify-center">
                <span className="text-purple-600 dark:text-purple-400 font-medium">
                  {(submission.user?.full_name || 'U')[0].toUpperCase()}
                </span>
              </div>
            )}
            <div>
              <p className="font-medium text-gray-900 dark:text-white">
                {submission.user?.full_name || 'Usuario'}
              </p>
              <p className="text-sm text-gray-500 dark:text-gray-400">
                Entregado: {formatDate(submission.submitted_at)}
              </p>
            </div>
          </div>
          {getStatusBadge(submission.status)}
        </div>
      </div>

      {/* File info */}
      <div className="p-4 bg-gray-50 dark:bg-gray-800/50 border-b border-gray-200 dark:border-gray-700">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <span className="text-2xl">📄</span>
            <div>
              <p className="font-medium text-gray-900 dark:text-white">
                {submission.file_name || 'Sin archivo'}
              </p>
              <p className="text-sm text-gray-500">
                {formatFileSize(submission.file_size)}
              </p>
            </div>
          </div>
          {submission.file_url && (
            <a
              href={submission.file_url}
              target="_blank"
              rel="noopener noreferrer"
              className="px-4 py-2 bg-blue-600 text-white rounded-lg text-sm font-medium hover:bg-blue-700 transition-colors"
            >
              Descargar
            </a>
          )}
        </div>

        {submission.comments && (
          <div className="mt-3 pt-3 border-t border-gray-200 dark:border-gray-700">
            <p className="text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Comentarios del estudiante:
            </p>
            <p className="text-gray-600 dark:text-gray-400 text-sm">
              {submission.comments}
            </p>
          </div>
        )}
      </div>

      {/* Review form */}
      <form onSubmit={handleSubmit} className="p-4">
        <h4 className="font-medium text-gray-900 dark:text-white mb-4">
          Revision
        </h4>

        {error && (
          <div className="mb-4 p-3 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg">
            <p className="text-sm text-red-600 dark:text-red-400">{error}</p>
          </div>
        )}

        {success && (
          <div className="mb-4 p-3 bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800 rounded-lg">
            <p className="text-sm text-green-600 dark:text-green-400">Revision guardada exitosamente</p>
          </div>
        )}

        <div className="grid grid-cols-2 gap-4 mb-4">
          {/* Score */}
          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Calificacion (0-{maxScore})
            </label>
            <input
              type="number"
              min="0"
              max={maxScore}
              step="0.5"
              value={score}
              onChange={(e) => setScore(e.target.value)}
              placeholder="Ej: 85"
              className="w-full px-4 py-2 border border-gray-200 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          {/* Status */}
          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Estado
            </label>
            <select
              value={status}
              onChange={(e) => setStatus(e.target.value as SubmissionStatus)}
              className="w-full px-4 py-2 border border-gray-200 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              <option value="pending">Pendiente</option>
              <option value="reviewed">Revisada</option>
              <option value="approved">Aprobada</option>
              <option value="rejected">Rechazada</option>
            </select>
          </div>
        </div>

        {/* Feedback */}
        <div className="mb-4">
          <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Retroalimentacion
          </label>
          <textarea
            value={feedback}
            onChange={(e) => setFeedback(e.target.value)}
            rows={4}
            placeholder="Escribe comentarios para el estudiante..."
            className="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white placeholder-gray-500 focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
          />
        </div>

        <button
          type="submit"
          disabled={loading}
          className="w-full py-2 bg-green-600 text-white rounded-lg font-medium hover:bg-green-700 disabled:opacity-50 transition-colors"
        >
          {loading ? 'Guardando...' : 'Guardar revision'}
        </button>
      </form>
    </div>
  )
}
