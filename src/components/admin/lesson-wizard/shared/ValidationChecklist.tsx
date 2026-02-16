'use client'

import type { ValidationResult } from '../types'

interface ValidationChecklistProps {
  validation: ValidationResult
}

const statusIcons = {
  pass: { icon: '\u2713', color: 'text-green-600 dark:text-green-400' },
  warning: { icon: '!', color: 'text-yellow-600 dark:text-yellow-400' },
  error: { icon: '\u2717', color: 'text-red-600 dark:text-red-400' },
}

export default function ValidationChecklist({ validation }: ValidationChecklistProps) {
  return (
    <div className="bg-white dark:bg-gray-800 rounded-xl p-4 shadow-sm">
      <h3 className="text-sm font-semibold text-gray-700 dark:text-gray-300 mb-3 uppercase tracking-wider">
        Checklist de calidad
      </h3>
      <ul className="space-y-2">
        {validation.rules.map(rule => {
          const { icon, color } = statusIcons[rule.status]
          return (
            <li key={rule.id} className="flex items-start gap-2">
              <span className={`font-bold text-sm mt-0.5 w-4 text-center flex-shrink-0 ${color}`}>
                {icon}
              </span>
              <div className="min-w-0">
                <p className="text-sm text-gray-800 dark:text-gray-200">{rule.label}</p>
                {rule.message && (
                  <p className="text-xs text-gray-500 dark:text-gray-400">{rule.message}</p>
                )}
              </div>
            </li>
          )
        })}
      </ul>
      <div className={`mt-4 pt-3 border-t border-gray-200 dark:border-gray-700 text-sm font-medium ${
        validation.isValid ? 'text-green-600 dark:text-green-400' : 'text-gray-500 dark:text-gray-400'
      }`}>
        {validation.isValid ? 'Leccion lista para guardar' : 'Completa los items en rojo para guardar'}
      </div>
    </div>
  )
}
