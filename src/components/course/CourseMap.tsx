'use client'

import ModuleCard from './ModuleCard'
import type { ModuleWithLessons } from '@/types'

interface CourseMapProps {
  modules: ModuleWithLessons[]
  courseId: string
  userProgress?: Map<string, boolean>
}

export default function CourseMap({ modules, courseId, userProgress }: CourseMapProps) {
  const sortedModules = [...modules].sort((a, b) => a.order_index - b.order_index)

  const getCompletedLessonsCount = (module: ModuleWithLessons) => {
    if (!userProgress) return 0
    return module.lessons?.filter(lesson =>
      userProgress.get(lesson.id)
    ).length || 0
  }

  const isModuleLocked = (module: ModuleWithLessons) => {
    if (!module.is_locked) return false
    if (!module.unlock_after_module) return false

    // Check if prerequisite module is completed
    const prereqModule = sortedModules.find(m => m.id === module.unlock_after_module)
    if (!prereqModule) return false

    const prereqLessons = prereqModule.lessons?.length || 0
    const completedPrereq = getCompletedLessonsCount(prereqModule)

    return completedPrereq < prereqLessons
  }

  if (modules.length === 0) {
    return (
      <div className="text-center py-12 bg-white dark:bg-gray-800 rounded-xl">
        <div className="text-4xl mb-4">📚</div>
        <p className="text-gray-600 dark:text-gray-400">
          Este curso aun no tiene modulos. Pronto habra contenido disponible.
        </p>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between mb-6">
        <h2 className="text-xl font-semibold text-gray-900 dark:text-white">
          Contenido del curso
        </h2>
        <span className="text-sm text-gray-500 dark:text-gray-400">
          {modules.length} modulo{modules.length !== 1 ? 's' : ''}
        </span>
      </div>

      <div className="space-y-4">
        {sortedModules.map((module, index) => (
          <div key={module.id} className="relative">
            {/* Connection line */}
            {index > 0 && (
              <div className="absolute left-8 -top-4 w-0.5 h-4 bg-gray-200 dark:bg-gray-700" />
            )}

            {/* Module number badge */}
            <div className="absolute -left-3 top-6 w-8 h-8 rounded-full bg-blue-500 text-white flex items-center justify-center text-sm font-bold shadow-lg z-10">
              {index + 1}
            </div>

            <div className="ml-8">
              <ModuleCard
                module={module}
                courseId={courseId}
                isLocked={isModuleLocked(module)}
                completedLessons={getCompletedLessonsCount(module)}
              />
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}
