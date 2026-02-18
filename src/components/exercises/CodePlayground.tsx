'use client'

import { useState, useCallback, useEffect, useRef } from 'react'
import dynamic from 'next/dynamic'
import { usePyodide } from '@/hooks/usePyodide'
import { ExerciseShell } from './ExerciseShell'
import type { CodeExercise, TestResult, ExerciseProgress, ComprehensionQuestion } from '@/types/exercises'

// Dynamically import Monaco Editor (client-side only)
const Editor = dynamic(
  () => import('@monaco-editor/react').then(mod => mod.default),
  { ssr: false, loading: () => <EditorSkeleton /> }
)

function EditorSkeleton() {
  return (
    <div className="h-64 bg-gray-100 dark:bg-gray-800 animate-pulse flex items-center justify-center">
      <span className="text-gray-500">Cargando editor...</span>
    </div>
  )
}

// Componente para preguntas de comprensión (mostradas después de la visualización)
interface ComprehensionState {
  selectedOption: string | null
  isSubmitted: boolean
  isCorrect: boolean | null
}

function ComprehensionSection({
  questions,
  states,
  onSelect,
  onSubmit,
  hasVisualization
}: {
  questions: ComprehensionQuestion[]
  states: Record<string, ComprehensionState>
  onSelect: (questionId: string, optionId: string) => void
  onSubmit: (questionId: string) => void
  hasVisualization: boolean
}) {
  if (!hasVisualization) return null

  return (
    <div className="mt-6 border-t border-gray-200 dark:border-gray-700 pt-6">
      <h4 className="text-sm font-semibold text-gray-900 dark:text-white mb-4 flex items-center gap-2">
        <svg className="w-5 h-5 text-rizoma-green" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        Preguntas de comprensión
      </h4>

      <div className="space-y-4">
        {questions.map((question, qIndex) => {
          const state = states[question.id] || { selectedOption: null, isSubmitted: false, isCorrect: null }

          return (
            <div key={question.id} className="bg-gray-50 dark:bg-gray-800/50 rounded-lg p-4">
              <p className="text-sm font-medium text-gray-900 dark:text-white mb-3">
                {qIndex + 1}. {question.question}
              </p>

              <div className="space-y-2">
                {question.options.map((option) => {
                  const isSelected = state.selectedOption === option.id
                  const isCorrectOption = option.id === question.correct
                  const showResult = state.isSubmitted

                  let optionClasses = 'w-full text-left p-2.5 rounded-md border text-sm transition-all '

                  if (showResult) {
                    if (isCorrectOption) {
                      optionClasses += 'border-green-500 bg-green-50 dark:bg-green-900/30 text-green-800 dark:text-green-200'
                    } else if (isSelected && !isCorrectOption) {
                      optionClasses += 'border-red-500 bg-red-50 dark:bg-red-900/30 text-red-800 dark:text-red-200'
                    } else {
                      optionClasses += 'border-gray-200 dark:border-gray-700 text-gray-500 dark:text-gray-500'
                    }
                  } else if (isSelected) {
                    optionClasses += 'border-rizoma-green bg-rizoma-green/10 text-rizoma-green-dark dark:text-rizoma-green-light'
                  } else {
                    optionClasses += 'border-gray-200 dark:border-gray-700 hover:border-gray-300 dark:hover:border-gray-600 text-gray-700 dark:text-gray-300'
                  }

                  return (
                    <button
                      key={option.id}
                      onClick={() => !state.isSubmitted && onSelect(question.id, option.id)}
                      disabled={state.isSubmitted}
                      className={optionClasses}
                    >
                      <div className="flex items-center gap-2">
                        <span className={`flex-shrink-0 w-5 h-5 rounded-full border flex items-center justify-center text-xs ${
                          isSelected ? 'border-current bg-current' : 'border-gray-400'
                        }`}>
                          {showResult && isCorrectOption ? (
                            <svg className="w-3 h-3 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" />
                            </svg>
                          ) : showResult && isSelected && !isCorrectOption ? (
                            <svg className="w-3 h-3 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M6 18L18 6M6 6l12 12" />
                            </svg>
                          ) : (
                            <span className={isSelected ? 'text-white text-xs' : 'text-gray-500 text-xs'}>
                              {option.id.toUpperCase()}
                            </span>
                          )}
                        </span>
                        <span>{option.text}</span>
                      </div>
                    </button>
                  )
                })}
              </div>

              {!state.isSubmitted && (
                <button
                  onClick={() => onSubmit(question.id)}
                  disabled={!state.selectedOption}
                  className={`mt-3 px-4 py-1.5 text-sm rounded-md font-medium transition-colors ${
                    state.selectedOption
                      ? 'bg-rizoma-green hover:bg-rizoma-green-dark text-white'
                      : 'bg-gray-200 dark:bg-gray-700 text-gray-400 cursor-not-allowed'
                  }`}
                >
                  Verificar
                </button>
              )}

              {state.isSubmitted && (
                <div className={`mt-3 p-2.5 rounded-md text-sm ${
                  state.isCorrect
                    ? 'bg-green-50 dark:bg-green-900/20 text-green-700 dark:text-green-300'
                    : 'bg-red-50 dark:bg-red-900/20 text-red-700 dark:text-red-300'
                }`}>
                  {state.isCorrect
                    ? (question.feedback_correct || '¡Correcto!')
                    : (question.feedback_incorrect || 'Incorrecto. Revisa la visualización.')}
                </div>
              )}
            </div>
          )
        })}
      </div>
    </div>
  )
}

interface CodePlaygroundProps {
  exercise: CodeExercise
  progress?: ExerciseProgress
  onProgressUpdate?: (progress: Partial<ExerciseProgress>) => void
  showSolution?: boolean
}

export function CodePlayground({
  exercise,
  progress,
  onProgressUpdate,
  showSolution = false
}: CodePlaygroundProps) {
  // UI configuration from exercise YAML
  const hideCode = exercise.ui_config?.hide_code ?? false
  // showOutputOnly reserved for future use (hide tests tab, etc.)
  const _showOutputOnly = exercise.ui_config?.show_output_only ?? false
  void _showOutputOnly // Evita warning de unused
  const autoRun = exercise.ui_config?.auto_run ?? hideCode // Auto-run if code is hidden

  const [code, setCode] = useState(progress?.current_code || exercise.starter_code)
  const [output, setOutput] = useState('')
  const [figures, setFigures] = useState<string[]>([])
  const [testResults, setTestResults] = useState<TestResult[]>([])
  const [isRunning, setIsRunning] = useState(false)
  const [hasAutoRun, setHasAutoRun] = useState(false)
  const [activeTab, setActiveTab] = useState<'output' | 'tests'>('output')
  const [showSolutionCode, setShowSolutionCode] = useState(false)

  // State para preguntas de comprensión
  const [comprehensionStates, setComprehensionStates] = useState<Record<string, ComprehensionState>>({})
  const comprehensionStatesRef = useRef(comprehensionStates)
  useEffect(() => {
    comprehensionStatesRef.current = comprehensionStates
  }, [comprehensionStates])

  // Handlers para preguntas de comprensión
  const handleComprehensionSelect = useCallback((questionId: string, optionId: string) => {
    setComprehensionStates(prev => ({
      ...prev,
      [questionId]: { selectedOption: optionId, isSubmitted: false, isCorrect: null }
    }))
  }, [])

  const handleComprehensionSubmit = useCallback((questionId: string) => {
    const question = exercise.comprehension_questions?.find(q => q.id === questionId)
    if (!question) return

    const state = comprehensionStatesRef.current[questionId]
    if (!state?.selectedOption) return

    const isCorrect = state.selectedOption === question.correct
    setComprehensionStates(prev => ({
      ...prev,
      [questionId]: { ...prev[questionId], isSubmitted: true, isCorrect }
    }))
  }, [exercise.comprehension_questions])

  const {
    isLoading: pyodideLoading,
    isReady: pyodideReady,
    loadProgress,
    runCode,
    runTests,
    error: pyodideError
  } = usePyodide({
    packages: exercise.required_packages || ['numpy', 'pandas']
  })

  // Calculate score from test results
  const score = testResults.reduce((sum, r) => sum + r.points_earned, 0)
  const maxScore = exercise.test_cases.reduce((sum, t) => sum + t.points, 0)
  const allTestsPassed = testResults.length > 0 && testResults.every(r => r.passed)

  // Handle code execution (run only)
  const handleRun = useCallback(async () => {
    setIsRunning(true)
    setOutput('')
    setFigures([])
    setTestResults([])
    setActiveTab('output')

    const result = await runCode(code)

    if (result.success) {
      setOutput(result.stdout || (result.figures?.length ? '' : 'Ejecutado correctamente (sin output)'))
      if (result.figures) {
        setFigures(result.figures)
      }
    } else {
      setOutput(`Error: ${result.error}\n\n${result.stderr}`)
    }

    setIsRunning(false)
  }, [code, runCode])

  // Handle code submission (run + tests)
  const handleSubmit = useCallback(async () => {
    setIsRunning(true)
    setOutput('')
    setFigures([])
    setTestResults([])
    setActiveTab('tests')

    const result = await runTests(code, exercise.test_cases)

    if (result.stdout || result.stderr) {
      setOutput(result.stdout + (result.stderr ? `\n\nStderr: ${result.stderr}` : ''))
    }

    if (result.error) {
      setOutput(`Error: ${result.error}`)
    }

    if (result.test_results) {
      setTestResults(result.test_results)

      // Update progress
      const newScore = result.test_results.reduce((sum, r) => sum + r.points_earned, 0)
      onProgressUpdate?.({
        current_code: code,
        attempts: (progress?.attempts || 0) + 1,
        score: newScore,
        max_score: maxScore,
        test_results: result.test_results,
        status: result.success ? 'completed' : 'in_progress',
        completed_at: result.success ? new Date().toISOString() : undefined,
        last_attempt_at: new Date().toISOString()
      })
    }

    setIsRunning(false)
  }, [code, exercise.test_cases, runTests, onProgressUpdate, progress?.attempts, maxScore])

  // Reset code to starter
  const handleReset = useCallback(() => {
    setCode(exercise.starter_code)
    setOutput('')
    setFigures([])
    setTestResults([])
  }, [exercise.starter_code])

  // Keyboard shortcut for running
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if ((e.metaKey || e.ctrlKey) && e.key === 'Enter') {
        e.preventDefault()
        handleRun()
      }
      if ((e.metaKey || e.ctrlKey) && e.shiftKey && e.key === 'Enter') {
        e.preventDefault()
        handleSubmit()
      }
    }

    window.addEventListener('keydown', handleKeyDown)
    return () => window.removeEventListener('keydown', handleKeyDown)
  }, [handleRun, handleSubmit])

  // Auto-run code when hide_code is true and Pyodide is ready
  // Usamos setTimeout para evitar setState síncrono en el effect
  useEffect(() => {
    if (autoRun && pyodideReady && !hasAutoRun && !isRunning) {
      const timeoutId = setTimeout(() => {
        setHasAutoRun(true)
        handleRun()
      }, 0)
      return () => clearTimeout(timeoutId)
    }
  }, [autoRun, pyodideReady, hasAutoRun, isRunning, handleRun])

  return (
    <ExerciseShell
      exercise={exercise}
      score={score}
      maxScore={maxScore}
      attempts={progress?.attempts}
      isSubmitting={isRunning}
    >
      <div className="p-4 space-y-4">
        {/* Pyodide loading state */}
        {pyodideLoading && (
          <div className="bg-rizoma-green/5 dark:bg-rizoma-green-dark/20 rounded-md p-3 flex items-center gap-3">
            <div className="flex-shrink-0">
              <svg className="animate-spin h-5 w-5 text-rizoma-green" fill="none" viewBox="0 0 24 24">
                <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
              </svg>
            </div>
            <div className="flex-1">
              <p className="text-sm text-rizoma-green-dark dark:text-rizoma-green-light">
                Cargando Python... {loadProgress}%
              </p>
              <div className="mt-1 w-full bg-rizoma-green/20 dark:bg-rizoma-green-dark rounded-full h-1.5">
                <div
                  className="bg-rizoma-green h-1.5 rounded-full transition-all duration-300"
                  style={{ width: `${loadProgress}%` }}
                />
              </div>
            </div>
          </div>
        )}

        {pyodideError && (
          <div className="bg-red-50 dark:bg-red-900/20 rounded-md p-3 text-sm text-red-700 dark:text-red-300">
            Error cargando Python: {pyodideError.message}
          </div>
        )}

        {/* Code Editor - hidden when hide_code is true */}
        {!hideCode && (
          <div className="border border-gray-200 dark:border-gray-700 rounded-md overflow-hidden">
            <div className="bg-gray-100 dark:bg-gray-800 px-3 py-2 flex items-center justify-between border-b border-gray-200 dark:border-gray-700">
              <span className="text-sm font-medium text-gray-700 dark:text-gray-300">
                Python
              </span>
              <div className="flex items-center gap-2">
                <button
                  onClick={handleReset}
                  aria-label="Reiniciar codigo"
                  className="text-xs text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200"
                >
                  Reiniciar
                </button>
                {showSolution && (
                  <button
                    onClick={() => setShowSolutionCode(!showSolutionCode)}
                    className="text-xs text-rizoma-green hover:text-rizoma-green-dark dark:text-rizoma-green-light dark:hover:text-rizoma-green-light"
                  >
                    {showSolutionCode ? 'Ocultar solución' : 'Ver solución'}
                  </button>
                )}
              </div>
            </div>
            <Editor
              height="256px"
              language="python"
              theme="vs-dark"
              value={showSolutionCode ? exercise.solution_code : code}
              onChange={(value) => !showSolutionCode && setCode(value || '')}
              options={{
                minimap: { enabled: false },
                fontSize: 14,
                lineNumbers: 'on',
                scrollBeyondLastLine: false,
                automaticLayout: true,
                tabSize: 4,
                readOnly: showSolutionCode
              }}
            />
          </div>
        )}

        {/* Action buttons - show simplified version when hide_code is true */}
        {hideCode ? (
          <div className="flex items-center gap-3">
            {!hasAutoRun && (
              <button
                onClick={handleRun}
                disabled={!pyodideReady || isRunning}
                className="flex items-center gap-2 px-4 py-2 bg-rizoma-green text-white rounded-md hover:bg-rizoma-green-dark disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
              >
                <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z" />
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                Generar visualizacion
              </button>
            )}
            {hasAutoRun && figures.length > 0 && (
              <button
                onClick={handleRun}
                disabled={!pyodideReady || isRunning}
                className="flex items-center gap-2 px-3 py-1.5 text-sm text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200 transition-colors"
              >
                <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                </svg>
                Regenerar
              </button>
            )}
          </div>
        ) : (
          <div className="flex items-center gap-3">
            <button
              onClick={handleRun}
              disabled={!pyodideReady || isRunning}
              aria-label="Ejecutar codigo"
              className="flex items-center gap-2 px-4 py-2 bg-gray-600 text-white rounded-md hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
            >
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z" />
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              Ejecutar
              <kbd className="hidden sm:inline text-xs bg-gray-700 px-1.5 py-0.5 rounded">⌘↵</kbd>
            </button>
            <button
              onClick={handleSubmit}
              disabled={!pyodideReady || isRunning}
              aria-label="Enviar codigo para evaluacion"
              className="flex items-center gap-2 px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
            >
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              Enviar
              <kbd className="hidden sm:inline text-xs bg-green-700 px-1.5 py-0.5 rounded">⇧⌘↵</kbd>
            </button>
          </div>
        )}

        {/* Output / Tests tabs */}
        <div className="border border-gray-200 dark:border-gray-700 rounded-md overflow-hidden">
          <div className="flex border-b border-gray-200 dark:border-gray-700">
            <button
              onClick={() => setActiveTab('output')}
              aria-label="Ver output"
              className={`px-4 py-2 text-sm font-medium ${
                activeTab === 'output'
                  ? 'bg-white dark:bg-gray-800 text-gray-900 dark:text-white border-b-2 border-rizoma-green'
                  : 'bg-gray-50 dark:bg-gray-900 text-gray-500 dark:text-gray-400 hover:text-gray-700'
              }`}
            >
              Output
            </button>
            <button
              onClick={() => setActiveTab('tests')}
              aria-label="Ver resultados de tests"
              className={`px-4 py-2 text-sm font-medium flex items-center gap-2 ${
                activeTab === 'tests'
                  ? 'bg-white dark:bg-gray-800 text-gray-900 dark:text-white border-b-2 border-rizoma-green'
                  : 'bg-gray-50 dark:bg-gray-900 text-gray-500 dark:text-gray-400 hover:text-gray-700'
              }`}
            >
              Tests
              {testResults.length > 0 && (
                <span className={`text-xs px-1.5 py-0.5 rounded ${
                  allTestsPassed
                    ? 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200'
                    : 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200'
                }`}>
                  {testResults.filter(r => r.passed).length}/{testResults.length}
                </span>
              )}
            </button>
          </div>

          <div className="p-4 bg-gray-50 dark:bg-gray-900 min-h-[120px]">
            {activeTab === 'output' ? (
              <div className="space-y-4">
                {/* Matplotlib figures */}
                {figures.length > 0 && (
                  <div className="space-y-4">
                    {figures.map((fig, index) => (
                      <div key={index} className="bg-white rounded-lg p-2 shadow-sm">
                        {/* eslint-disable-next-line @next/next/no-img-element */}
                        <img
                          src={`data:image/png;base64,${fig}`}
                          alt={`Figura ${index + 1}`}
                          className="max-w-full h-auto mx-auto"
                        />
                      </div>
                    ))}
                  </div>
                )}
                {/* Text output */}
                {(output || figures.length === 0) && (
                  <pre className="text-sm text-gray-700 dark:text-gray-300 whitespace-pre-wrap font-mono">
                    {output || 'Ejecuta el código para ver el output...'}
                  </pre>
                )}
              </div>
            ) : (
              <div className="space-y-2">
                {testResults.length === 0 ? (
                  <p className="text-sm text-gray-500 dark:text-gray-400">
                    Envía tu código para ejecutar los tests...
                  </p>
                ) : (
                  testResults.map((result, index) => {
                    const testCase = exercise.test_cases.find(t => t.id === result.test_id)
                    return (
                      <div
                        key={result.test_id}
                        className={`flex items-center justify-between p-3 rounded-md ${
                          result.passed
                            ? 'bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800'
                            : 'bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800'
                        }`}
                      >
                        <div className="flex items-center gap-2">
                          {result.passed ? (
                            <svg className="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                            </svg>
                          ) : (
                            <svg className="w-5 h-5 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                            </svg>
                          )}
                          <span className={`text-sm font-medium ${
                            result.passed ? 'text-green-700 dark:text-green-300' : 'text-red-700 dark:text-red-300'
                          }`}>
                            {testCase?.name || `Test ${index + 1}`}
                          </span>
                        </div>
                        <div className="flex items-center gap-3">
                          {result.error_message && !testCase?.hidden && (
                            <span className="text-xs text-red-600 dark:text-red-400">
                              {result.error_message}
                            </span>
                          )}
                          <span className={`text-sm ${
                            result.passed ? 'text-green-600 dark:text-green-400' : 'text-gray-400'
                          }`}>
                            {result.points_earned}/{testCase?.points || 0} pts
                          </span>
                          {result.execution_time_ms && (
                            <span className="text-xs text-gray-400">
                              {result.execution_time_ms}ms
                            </span>
                          )}
                        </div>
                      </div>
                    )
                  })
                )}
              </div>
            )}
          </div>
        </div>

        {/* Comprehension questions - shown after visualization */}
        {exercise.comprehension_questions && exercise.comprehension_questions.length > 0 && (
          <ComprehensionSection
            questions={exercise.comprehension_questions}
            states={comprehensionStates}
            onSelect={handleComprehensionSelect}
            onSubmit={handleComprehensionSubmit}
            hasVisualization={figures.length > 0}
          />
        )}

        {/* Success message */}
        {allTestsPassed && (
          <div className="bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800 rounded-md p-4 flex items-center gap-3">
            <svg className="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <div>
              <p className="font-medium text-green-800 dark:text-green-200">
                Excelente! Todos los tests pasaron.
              </p>
              <p className="text-sm text-green-600 dark:text-green-400">
                Has obtenido {score} de {maxScore} puntos.
              </p>
            </div>
          </div>
        )}
      </div>
    </ExerciseShell>
  )
}
