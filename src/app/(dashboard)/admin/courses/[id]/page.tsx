'use client'

import { useState, useEffect, useCallback, use, useRef } from 'react'
import { createClient } from '@/lib/supabase/client'
import { useRouter } from 'next/navigation'
import Link from 'next/link'
import Navbar from '@/components/Navbar'
import type { Course, Module, Lesson } from '@/types'

interface PageProps {
  params: Promise<{ id: string }>
}

export default function AdminCourseDetailPage({ params }: PageProps) {
  const { id: courseId } = use(params)
  const [course, setCourse] = useState<Course | null>(null)
  const [modules, setModules] = useState<(Module & { lessons: Lesson[] })[]>([])
  const [orphanLessons, setOrphanLessons] = useState<Lesson[]>([])
  const [loading, setLoading] = useState(true)

  // Module form
  const [showModuleForm, setShowModuleForm] = useState(false)
  const [moduleTitle, setModuleTitle] = useState('')
  const [moduleDescription, setModuleDescription] = useState('')
  const [editingModule, setEditingModule] = useState<Module | null>(null)

  // Lesson form
  const [showLessonForm, setShowLessonForm] = useState(false)
  const [lessonModuleId, setLessonModuleId] = useState<string | null>(null)
  const [lessonTitle, setLessonTitle] = useState('')
  const [lessonType, setLessonType] = useState<'video' | 'text' | 'quiz' | 'assignment'>('video')
  const [lessonVideoUrl, setLessonVideoUrl] = useState('')
  const [lessonContent, setLessonContent] = useState('')
  const [lessonDuration, setLessonDuration] = useState('')
  const [editingLesson, setEditingLesson] = useState<Lesson | null>(null)

  // Thumbnail editing
  const [editingThumbnail, setEditingThumbnail] = useState(false)
  const [thumbnailUrl, setThumbnailUrl] = useState('')

  const [saving, setSaving] = useState(false)
  const [saveError, setSaveError] = useState<string | null>(null)

  const supabase = createClient()
  const router = useRouter()
  const formRef = useRef<HTMLDivElement>(null)

  const loadModulesAndLessons = useCallback(async () => {
    // Get modules with lessons
    const { data: modulesData } = await supabase
      .from('modules')
      .select(`
        *,
        lessons(*)
      `)
      .eq('course_id', courseId)
      .order('order_index', { ascending: true })

    if (modulesData) {
      setModules(modulesData.map(m => ({
        ...m,
        lessons: (m.lessons || []).sort((a: Lesson, b: Lesson) => a.order_index - b.order_index)
      })))
    }

    // Get orphan lessons
    const { data: orphanData } = await supabase
      .from('lessons')
      .select('*')
      .eq('course_id', courseId)
      .is('module_id', null)
      .order('order_index', { ascending: true })

    setOrphanLessons(orphanData || [])
  }, [supabase, courseId])

  useEffect(() => {
    const init = async () => {
      const { data: { user: authUser } } = await supabase.auth.getUser()

      if (!authUser) {
        router.push('/login')
        return
      }

      const { data: profile } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', authUser.id)
        .single()

      if (!profile || (profile.role !== 'admin' && profile.role !== 'instructor')) {
        router.push('/courses')
        return
      }

      // Get course
      const { data: courseData, error: courseError } = await supabase
        .from('courses')
        .select('*')
        .eq('id', courseId)
        .single()

      if (courseError || !courseData) {
        router.push('/admin/courses')
        return
      }

      // Check ownership
      if (courseData.instructor_id !== authUser.id && profile.role !== 'admin') {
        router.push('/admin/courses')
        return
      }

      setCourse(courseData)
      setThumbnailUrl(courseData.thumbnail_url || '')
      await loadModulesAndLessons()
      setLoading(false)
    }

    init()
  }, [supabase, router, courseId, loadModulesAndLessons])

  // Thumbnail handler
  const handleSaveThumbnail = async () => {
    setSaving(true)
    const newUrl = thumbnailUrl.trim() || null
    const { error } = await supabase
      .from('courses')
      .update({ thumbnail_url: newUrl })
      .eq('id', courseId)

    if (!error && course) {
      setCourse({ ...course, thumbnail_url: newUrl })
    }
    setEditingThumbnail(false)
    setSaving(false)
  }

  // Module handlers
  const handleSaveModule = async (e: React.FormEvent) => {
    e.preventDefault()
    setSaving(true)

    if (editingModule) {
      const { error } = await supabase
        .from('modules')
        .update({
          title: moduleTitle,
          description: moduleDescription
        })
        .eq('id', editingModule.id)

      if (!error) {
        await loadModulesAndLessons()
        resetModuleForm()
      }
    } else {
      const { error } = await supabase
        .from('modules')
        .insert({
          course_id: courseId,
          title: moduleTitle,
          description: moduleDescription,
          order_index: modules.length
        })

      if (!error) {
        await loadModulesAndLessons()
        resetModuleForm()
      }
    }

    setSaving(false)
  }

  const handleDeleteModule = async (moduleId: string) => {
    if (!confirm('¿Eliminar este modulo? Las lecciones se moveran a sin modulo.')) return

    // First, move lessons to orphan
    const { error: moveError } = await supabase
      .from('lessons')
      .update({ module_id: null })
      .eq('module_id', moduleId)

    if (moveError) {
      setSaveError(`Error moviendo lecciones: ${moveError.message}`)
      return
    }

    const { error } = await supabase
      .from('modules')
      .delete()
      .eq('id', moduleId)

    if (error) {
      setSaveError(`Error eliminando modulo: ${error.message}`)
    } else {
      await loadModulesAndLessons()
    }
  }

  const editModule = (module: Module) => {
    setEditingModule(module)
    setModuleTitle(module.title)
    setModuleDescription(module.description || '')
    setShowModuleForm(true)
    setTimeout(() => formRef.current?.scrollIntoView({ behavior: 'smooth' }), 50)
  }

  const resetModuleForm = () => {
    setEditingModule(null)
    setModuleTitle('')
    setModuleDescription('')
    setShowModuleForm(false)
  }

  // Lesson handlers
  const handleSaveLesson = async (e: React.FormEvent) => {
    e.preventDefault()
    setSaving(true)
    setSaveError(null)

    const lessonData = {
      course_id: courseId,
      module_id: lessonModuleId,
      title: lessonTitle,
      lesson_type: lessonType,
      video_url: lessonVideoUrl || null,
      content: lessonContent || null,
      duration_minutes: lessonDuration ? parseInt(lessonDuration) : null,
      is_required: true
    }

    if (editingLesson) {
      const { error } = await supabase
        .from('lessons')
        .update(lessonData)
        .eq('id', editingLesson.id)

      if (error) {
        setSaveError(error.message)
      } else {
        await loadModulesAndLessons()
        resetLessonForm()
      }
    } else {
      const { error } = await supabase
        .from('lessons')
        .insert({
          ...lessonData,
          order_index: lessonModuleId
            ? modules.find(m => m.id === lessonModuleId)?.lessons.length || 0
            : orphanLessons.length
        })

      if (error) {
        setSaveError(error.message)
      } else {
        await loadModulesAndLessons()
        resetLessonForm()
      }
    }

    setSaving(false)
  }

  const handleDeleteLesson = async (lessonId: string) => {
    if (!confirm('¿Eliminar esta leccion?')) return

    const { error } = await supabase
      .from('lessons')
      .delete()
      .eq('id', lessonId)

    if (!error) {
      await loadModulesAndLessons()
    }
  }

  const handleMoveModule = async (index: number, direction: 'up' | 'down') => {
    const targetIndex = direction === 'up' ? index - 1 : index + 1
    if (targetIndex < 0 || targetIndex >= modules.length) return

    const reordered = [...modules]
    const [moved] = reordered.splice(index, 1)
    reordered.splice(targetIndex, 0, moved)

    const results = await Promise.all(
      reordered.map((m, i) =>
        supabase.from('modules').update({ order_index: i }).eq('id', m.id)
      )
    )
    const failed = results.find(r => r.error)
    if (failed?.error) setSaveError(`Error reordenando: ${failed.error.message}`)

    await loadModulesAndLessons()
  }

  const handleMoveLesson = async (lessons: Lesson[], index: number, direction: 'up' | 'down') => {
    const targetIndex = direction === 'up' ? index - 1 : index + 1
    if (targetIndex < 0 || targetIndex >= lessons.length) return

    const reordered = [...lessons]
    const [moved] = reordered.splice(index, 1)
    reordered.splice(targetIndex, 0, moved)

    const results = await Promise.all(
      reordered.map((lesson, i) =>
        supabase.from('lessons').update({ order_index: i }).eq('id', lesson.id)
      )
    )
    const failed = results.find(r => r.error)
    if (failed?.error) setSaveError(`Error reordenando: ${failed.error.message}`)

    await loadModulesAndLessons()
  }

  const editLesson = (lesson: Lesson) => {
    setEditingLesson(lesson)
    setLessonModuleId(lesson.module_id)
    setLessonTitle(lesson.title)
    setLessonType((lesson.lesson_type as typeof lessonType) || 'video')
    setLessonVideoUrl(lesson.video_url || '')
    setLessonContent(lesson.content || '')
    setLessonDuration(lesson.duration_minutes?.toString() || '')
    setShowLessonForm(true)
    setTimeout(() => formRef.current?.scrollIntoView({ behavior: 'smooth' }), 50)
  }

  const openLessonFormForModule = (moduleId: string | null) => {
    resetLessonForm()
    setLessonModuleId(moduleId)
    setShowLessonForm(true)
    setTimeout(() => formRef.current?.scrollIntoView({ behavior: 'smooth' }), 50)
  }

  const resetLessonForm = () => {
    setEditingLesson(null)
    setLessonModuleId(null)
    setLessonTitle('')
    setLessonType('video')
    setLessonVideoUrl('')
    setLessonContent('')
    setLessonDuration('')
    setShowLessonForm(false)
  }

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
        <Navbar />
        <div className="flex items-center justify-center h-64">
          <div className="text-gray-500">Cargando...</div>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <Navbar />
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Header */}
        <div className="mb-8">
          <Link
            href="/admin/courses"
            className="text-sm text-rizoma-green dark:text-rizoma-green-light hover:underline mb-4 inline-block"
          >
            &larr; Volver a mis cursos
          </Link>

          {/* Thumbnail */}
          <div className="mb-4">
            {editingThumbnail ? (
              <div className="space-y-3">
                {thumbnailUrl && (
                  <img
                    src={thumbnailUrl}
                    alt="Preview"
                    className="w-full max-w-md h-48 object-cover rounded-lg border border-gray-200 dark:border-gray-700"
                  />
                )}
                <div className="flex gap-2 items-center max-w-md">
                  <input
                    type="url"
                    value={thumbnailUrl}
                    onChange={(e) => setThumbnailUrl(e.target.value)}
                    placeholder="/images/courses/mi-curso.jpg o https://..."
                    className="flex-1 px-3 py-2 text-sm border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white"
                  />
                  <button
                    onClick={handleSaveThumbnail}
                    disabled={saving}
                    className="px-3 py-2 text-sm bg-rizoma-green text-white rounded-lg hover:bg-rizoma-green-dark disabled:opacity-50"
                  >
                    Guardar
                  </button>
                  <button
                    onClick={() => { setThumbnailUrl(course?.thumbnail_url || ''); setEditingThumbnail(false) }}
                    className="px-3 py-2 text-sm border border-gray-300 dark:border-gray-600 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
                  >
                    Cancelar
                  </button>
                </div>
              </div>
            ) : (
              <div
                onClick={() => setEditingThumbnail(true)}
                className="cursor-pointer group relative w-full max-w-md"
                title="Clic para editar imagen"
              >
                {course?.thumbnail_url ? (
                  <img
                    src={course.thumbnail_url}
                    alt={course.title}
                    className="w-full h-48 object-cover rounded-lg border border-gray-200 dark:border-gray-700"
                  />
                ) : (
                  <div className="w-full h-48 bg-gradient-to-br from-rizoma-green to-rizoma-cyan rounded-lg flex items-center justify-center">
                    <span className="text-white text-4xl font-bold">
                      {course?.title.charAt(0)}
                    </span>
                  </div>
                )}
                <div className="absolute inset-0 bg-black/0 group-hover:bg-black/40 rounded-lg transition-colors flex items-center justify-center">
                  <span className="text-white text-sm font-medium opacity-0 group-hover:opacity-100 transition-opacity">
                    Editar imagen
                  </span>
                </div>
              </div>
            )}
          </div>

          <div className="flex justify-between items-start">
            <div>
              <h1 className="text-3xl font-bold text-gray-900 dark:text-white">
                {course?.title}
              </h1>
              <p className="text-gray-600 dark:text-gray-400 mt-1">
                {course?.description || 'Sin descripcion'}
              </p>
              <span className={`inline-block mt-2 text-xs px-2 py-1 rounded-full ${
                course?.is_published
                  ? 'bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400'
                  : 'bg-yellow-100 text-yellow-700 dark:bg-yellow-900/30 dark:text-yellow-400'
              }`}>
                {course?.is_published ? 'Publicado' : 'Borrador'}
              </span>
            </div>
            <Link
              href={`/courses/${courseId}`}
              target="_blank"
              className="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
            >
              Ver curso
            </Link>
          </div>
        </div>

        {/* Module Form */}
        {showModuleForm && (
          <form ref={formRef as React.Ref<HTMLFormElement>} onSubmit={handleSaveModule} className="bg-white dark:bg-gray-800 rounded-xl p-6 mb-8 shadow-sm">
            <h2 className="text-xl font-semibold text-gray-900 dark:text-white mb-4">
              {editingModule ? 'Editar modulo' : 'Nuevo modulo'}
            </h2>
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  Titulo del modulo
                </label>
                <input
                  type="text"
                  value={moduleTitle}
                  onChange={(e) => setModuleTitle(e.target.value)}
                  required
                  className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white"
                  placeholder="Ej: Introduccion"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  Descripcion
                </label>
                <textarea
                  value={moduleDescription}
                  onChange={(e) => setModuleDescription(e.target.value)}
                  rows={2}
                  className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white"
                  placeholder="Descripcion opcional del modulo"
                />
              </div>
              <div className="flex gap-2">
                <button
                  type="submit"
                  disabled={saving}
                  className="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 disabled:opacity-50"
                >
                  {saving ? 'Guardando...' : editingModule ? 'Guardar cambios' : 'Crear modulo'}
                </button>
                <button
                  type="button"
                  onClick={resetModuleForm}
                  className="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
                >
                  Cancelar
                </button>
              </div>
            </div>
          </form>
        )}

        {/* Lesson Form */}
        {showLessonForm && (
          <form ref={formRef as React.Ref<HTMLFormElement>} onSubmit={handleSaveLesson} className="bg-white dark:bg-gray-800 rounded-xl p-6 mb-8 shadow-sm">
            <h2 className="text-xl font-semibold text-gray-900 dark:text-white mb-4">
              {editingLesson ? 'Editar leccion' : 'Nueva leccion'}
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  Titulo
                </label>
                <input
                  type="text"
                  value={lessonTitle}
                  onChange={(e) => setLessonTitle(e.target.value)}
                  required
                  className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white"
                  placeholder="Titulo de la leccion"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  Modulo
                </label>
                <select
                  value={lessonModuleId || ''}
                  onChange={(e) => setLessonModuleId(e.target.value || null)}
                  className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white"
                >
                  <option value="">Sin modulo</option>
                  {modules.map(m => (
                    <option key={m.id} value={m.id}>{m.title}</option>
                  ))}
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  Tipo
                </label>
                <select
                  value={lessonType}
                  onChange={(e) => setLessonType(e.target.value as typeof lessonType)}
                  className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white"
                >
                  <option value="video">Video</option>
                  <option value="text">Texto</option>
                  <option value="quiz">Quiz</option>
                  <option value="assignment">Tarea</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  Duracion (minutos)
                </label>
                <input
                  type="number"
                  value={lessonDuration}
                  onChange={(e) => setLessonDuration(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white"
                  placeholder="Ej: 15"
                />
              </div>
              {lessonType === 'video' && (
                <div className="md:col-span-2">
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                    URL del video (YouTube, Vimeo embed)
                  </label>
                  <input
                    type="url"
                    value={lessonVideoUrl}
                    onChange={(e) => setLessonVideoUrl(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white"
                    placeholder="https://www.youtube.com/embed/..."
                  />
                </div>
              )}
              <div className="md:col-span-2">
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  Contenido / Notas
                </label>
                <textarea
                  value={lessonContent}
                  onChange={(e) => setLessonContent(e.target.value)}
                  rows={4}
                  className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white"
                  placeholder="Contenido de la leccion (HTML permitido)"
                />
              </div>
            </div>
            {saveError && (
              <div className="mt-4 p-3 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg text-red-700 dark:text-red-400 text-sm">
                Error: {saveError}
              </div>
            )}
            <div className="flex gap-2 mt-4">
              <button
                type="submit"
                disabled={saving}
                className="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 disabled:opacity-50"
              >
                {saving ? 'Guardando...' : editingLesson ? 'Guardar cambios' : 'Crear leccion'}
              </button>
              <button
                type="button"
                onClick={resetLessonForm}
                className="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
              >
                Cancelar
              </button>
            </div>
          </form>
        )}

        {/* Actions */}
        {!showModuleForm && !showLessonForm && (
          <div className="flex gap-4 mb-8">
            <button
              onClick={() => setShowModuleForm(true)}
              className="px-4 py-2 bg-rizoma-green text-white rounded-lg hover:bg-rizoma-green-dark"
            >
              + Nuevo modulo
            </button>
            <button
              onClick={() => openLessonFormForModule(null)}
              className="px-4 py-2 border border-rizoma-green text-rizoma-green rounded-lg hover:bg-rizoma-green/5 dark:hover:bg-rizoma-green-dark/20"
            >
              + Creacion rapida
            </button>
            <Link
              href={`/admin/lessons/new?courseId=${courseId}`}
              className="px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700"
            >
              + Wizard 4C
            </Link>
          </div>
        )}

        {/* Modules List */}
        <div className="space-y-6">
          {modules.map((module, moduleIndex) => (
            <div key={module.id} className="bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden">
              <div className="p-4 bg-gray-50 dark:bg-gray-700/50 flex justify-between items-center">
                <div className="flex items-center gap-3">
                  <div className="flex flex-col gap-0.5">
                    <button
                      onClick={() => handleMoveModule(moduleIndex, 'up')}
                      disabled={moduleIndex === 0}
                      className="p-0.5 text-gray-400 hover:text-gray-700 dark:hover:text-gray-200 disabled:opacity-25 disabled:cursor-not-allowed"
                      title="Mover modulo arriba"
                    >
                      <svg className="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 15l7-7 7 7" /></svg>
                    </button>
                    <button
                      onClick={() => handleMoveModule(moduleIndex, 'down')}
                      disabled={moduleIndex === modules.length - 1}
                      className="p-0.5 text-gray-400 hover:text-gray-700 dark:hover:text-gray-200 disabled:opacity-25 disabled:cursor-not-allowed"
                      title="Mover modulo abajo"
                    >
                      <svg className="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" /></svg>
                    </button>
                  </div>
                  <div>
                    <span className="text-sm text-gray-500 dark:text-gray-400 mr-2">
                      Modulo {moduleIndex + 1}
                    </span>
                    <h3 className="text-lg font-semibold text-gray-900 dark:text-white inline">
                      {module.title}
                    </h3>
                  </div>
                </div>
                <div className="flex gap-2">
                  <button
                    onClick={() => openLessonFormForModule(module.id)}
                    className="px-3 py-1 text-sm bg-green-100 text-green-700 rounded-lg hover:bg-green-200"
                  >
                    + Leccion
                  </button>
                  <button
                    onClick={() => editModule(module)}
                    className="px-3 py-1 text-sm bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 dark:bg-gray-600 dark:text-gray-200"
                  >
                    Editar
                  </button>
                  <button
                    onClick={() => handleDeleteModule(module.id)}
                    className="px-3 py-1 text-sm bg-red-100 text-red-700 rounded-lg hover:bg-red-200"
                  >
                    Eliminar
                  </button>
                </div>
              </div>
              {module.lessons.length > 0 ? (
                <ul className="divide-y divide-gray-200 dark:divide-gray-700">
                  {module.lessons.map((lesson, lessonIndex) => (
                    <li key={lesson.id} className="p-4 flex justify-between items-center">
                      <div className="flex items-center gap-3">
                        {/* Reorder arrows */}
                        <div className="flex flex-col gap-0.5">
                          <button
                            onClick={() => handleMoveLesson(module.lessons, lessonIndex, 'up')}
                            disabled={lessonIndex === 0}
                            className="p-0.5 text-gray-400 hover:text-gray-700 dark:hover:text-gray-200 disabled:opacity-25 disabled:cursor-not-allowed"
                            title="Mover arriba"
                          >
                            <svg className="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 15l7-7 7 7" /></svg>
                          </button>
                          <button
                            onClick={() => handleMoveLesson(module.lessons, lessonIndex, 'down')}
                            disabled={lessonIndex === module.lessons.length - 1}
                            className="p-0.5 text-gray-400 hover:text-gray-700 dark:hover:text-gray-200 disabled:opacity-25 disabled:cursor-not-allowed"
                            title="Mover abajo"
                          >
                            <svg className="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" /></svg>
                          </button>
                        </div>
                        <span className="text-lg">
                          {lesson.lesson_type === 'video' && '🎬'}
                          {lesson.lesson_type === 'text' && '📄'}
                          {lesson.lesson_type === 'quiz' && '❓'}
                          {lesson.lesson_type === 'assignment' && '📝'}
                        </span>
                        <div>
                          <p className="font-medium text-gray-900 dark:text-white">
                            {lessonIndex + 1}. {lesson.title}
                          </p>
                          <p className="text-sm text-gray-500 dark:text-gray-400">
                            {lesson.lesson_type} {lesson.duration_minutes && `• ${lesson.duration_minutes} min`}
                          </p>
                        </div>
                      </div>
                      <div className="flex gap-2">
                        <button
                          onClick={() => editLesson(lesson)}
                          className="px-3 py-1 text-sm text-rizoma-green hover:bg-rizoma-green/5 dark:hover:bg-rizoma-green-dark/20 rounded-lg"
                        >
                          Editar
                        </button>
                        <Link
                          href={`/admin/lessons/${lesson.id}/edit`}
                          className="px-3 py-1 text-sm text-purple-600 hover:bg-purple-50 dark:hover:bg-purple-900/20 rounded-lg"
                        >
                          Wizard
                        </Link>
                        <button
                          onClick={() => handleDeleteLesson(lesson.id)}
                          className="px-3 py-1 text-sm text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg"
                        >
                          Eliminar
                        </button>
                      </div>
                    </li>
                  ))}
                </ul>
              ) : (
                <p className="p-4 text-gray-500 dark:text-gray-400 text-center">
                  No hay lecciones en este modulo
                </p>
              )}
            </div>
          ))}

          {/* Orphan lessons */}
          {orphanLessons.length > 0 && (
            <div className="bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden">
              <div className="p-4 bg-yellow-50 dark:bg-yellow-900/20 flex justify-between items-center">
                <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                  Lecciones sin modulo
                </h3>
              </div>
              <ul className="divide-y divide-gray-200 dark:divide-gray-700">
                {orphanLessons.map((lesson, index) => (
                  <li key={lesson.id} className="p-4 flex justify-between items-center">
                    <div className="flex items-center gap-3">
                      <span className="text-lg">
                        {lesson.lesson_type === 'video' && '🎬'}
                        {lesson.lesson_type === 'text' && '📄'}
                        {lesson.lesson_type === 'quiz' && '❓'}
                        {lesson.lesson_type === 'assignment' && '📝'}
                      </span>
                      <div>
                        <p className="font-medium text-gray-900 dark:text-white">
                          {index + 1}. {lesson.title}
                        </p>
                        <p className="text-sm text-gray-500 dark:text-gray-400">
                          {lesson.lesson_type || 'video'} {lesson.duration_minutes && `• ${lesson.duration_minutes} min`}
                        </p>
                      </div>
                    </div>
                    <div className="flex gap-2">
                      <button
                        onClick={() => editLesson(lesson)}
                        className="px-3 py-1 text-sm text-rizoma-green hover:bg-rizoma-green/5 dark:hover:bg-rizoma-green-dark/20 rounded-lg"
                      >
                        Editar
                      </button>
                      <button
                        onClick={() => handleDeleteLesson(lesson.id)}
                        className="px-3 py-1 text-sm text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg"
                      >
                        Eliminar
                      </button>
                    </div>
                  </li>
                ))}
              </ul>
            </div>
          )}

          {modules.length === 0 && orphanLessons.length === 0 && (
            <div className="text-center py-12 bg-white dark:bg-gray-800 rounded-xl">
              <div className="text-4xl mb-4">📚</div>
              <p className="text-gray-600 dark:text-gray-400">
                Este curso aun no tiene contenido. Crea tu primer modulo o leccion.
              </p>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
