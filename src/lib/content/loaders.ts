import { promises as fs } from 'fs'
import path from 'path'
import yaml from 'js-yaml'
import type {
  Exercise,
  LoadedExercise,
  DatasetReference
} from '@/types/exercises'

// Base paths
const CONTENT_PATH = path.join(process.cwd(), 'content')
const COURSES_PATH = path.join(CONTENT_PATH, 'courses')
const SHARED_PATH = path.join(CONTENT_PATH, 'shared')

// Exercise loader
export async function loadExercise(
  courseSlug: string,
  moduleId: string,
  exerciseId: string
): Promise<Exercise> {
  const exercisePath = path.join(
    COURSES_PATH,
    courseSlug,
    moduleId,
    'exercises',
    `${exerciseId}.yaml`
  )
  const content = await fs.readFile(exercisePath, 'utf-8')
  return yaml.load(content, { schema: yaml.JSON_SCHEMA }) as Exercise
}

// Dataset loader
async function loadDataset(datasetPath: string): Promise<string> {
  const fullPath = path.join(SHARED_PATH, 'datasets', datasetPath)
  return fs.readFile(fullPath, 'utf-8')
}

// Load dataset by reference
async function loadDatasetByRef(ref: DatasetReference): Promise<string> {
  return loadDataset(ref.path)
}

// SQL schema loader
async function loadSQLSchema(schemaId: string): Promise<string> {
  const schemaPath = path.join(SHARED_PATH, 'schemas', `${schemaId}.sql`)
  return fs.readFile(schemaPath, 'utf-8')
}

// Full exercise resolver - loads exercise with all dependencies
export async function resolveExercise(
  courseSlug: string,
  moduleId: string,
  exerciseId: string
): Promise<LoadedExercise> {
  const exercise = await loadExercise(courseSlug, moduleId, exerciseId)

  const datasets = new Map<string, string>()

  // Load datasets if present
  if ('datasets' in exercise && exercise.datasets) {
    for (const datasetRef of exercise.datasets) {
      const content = await loadDatasetByRef(datasetRef)
      datasets.set(datasetRef.id, content)
    }
  }

  // Load SQL schema if present
  let schema: string | undefined
  if (exercise.type === 'sql' && 'schema_id' in exercise) {
    schema = await loadSQLSchema(exercise.schema_id)
  }

  return { exercise, datasets, schema }
}
