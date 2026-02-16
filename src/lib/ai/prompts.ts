// AI Prompt Templates for 4C pedagogical model lesson generation

interface PromptContext {
  title: string
  objectives: string[]
  bloomLevel: string
  courseName?: string
  moduleName?: string
  language?: string
  hookType?: string
  existingContent?: string
}

interface PromptPair {
  system: string
  user: string
}

const BASE_SYSTEM = `Eres un disenador instruccional experto que sigue el modelo 4C (Connection, Concepts, Concrete Practice, Conclusions).
Reglas:
- Responde SOLO en JSON valido, sin texto adicional.
- Todo el contenido debe estar en espanol.
- Usa Markdown para el contenido textual.
- Incluye un campo "estimatedMinutes" con la duracion estimada en minutos.
- El contenido debe ser conciso, directo y sin relleno.`

export const AI_PROMPTS = {
  connection(ctx: PromptContext): PromptPair {
    return {
      system: `${BASE_SYSTEM}
Genera el hook/conexion inicial de una leccion. El hook debe captar atencion y conectar con conocimiento previo.
Formato JSON requerido:
{
  "hookContent": "string (markdown, 2-3 parrafos max)",
  "hookType": "string (analogy|question|real_world|challenge)",
  "estimatedMinutes": number
}`,
      user: `Leccion: "${ctx.title}"
Objetivos: ${ctx.objectives.join(', ')}
Nivel Bloom: ${ctx.bloomLevel}
Tipo de hook preferido: ${ctx.hookType || 'auto'}
${ctx.courseName ? `Curso: ${ctx.courseName}` : ''}
${ctx.moduleName ? `Modulo: ${ctx.moduleName}` : ''}

Genera un hook que conecte al estudiante con el tema.`,
    }
  },

  concepts(ctx: PromptContext): PromptPair {
    return {
      system: `${BASE_SYSTEM}
Genera los bloques conceptuales de una leccion. Cada bloque explica un concepto clave.
Formato JSON requerido:
{
  "blocks": [
    {
      "id": "string",
      "title": "string",
      "type": "explanation|example|diagram|video",
      "content": "string (markdown)",
      "order": number
    }
  ],
  "estimatedMinutes": number
}`,
      user: `Leccion: "${ctx.title}"
Objetivos: ${ctx.objectives.join(', ')}
Nivel Bloom: ${ctx.bloomLevel}
${ctx.courseName ? `Curso: ${ctx.courseName}` : ''}

Genera 3-5 bloques conceptuales que cubran los objetivos de aprendizaje. Usa ejemplos de codigo cuando sea relevante.`,
    }
  },

  practice(ctx: PromptContext): PromptPair {
    return {
      system: `${BASE_SYSTEM}
Genera ejercicios practicos interactivos para una leccion. Los ejercicios deben ser progresivos en dificultad.
Formato JSON requerido:
{
  "exercises": [
    {
      "id": "string (kebab-case, ej: ex-01-nombre)",
      "title": "string",
      "type": "code-python|sql|quiz",
      "difficulty": "beginner|intermediate|advanced",
      "description": "string",
      "instructions": "string (markdown)",
      "starterCode": "string (codigo inicial)",
      "solutionCode": "string (solucion completa)",
      "testCode": "string (tests de validacion)",
      "hints": ["string", "string", "string"],
      "estimatedMinutes": number
    }
  ],
  "estimatedMinutes": number
}`,
      user: `Leccion: "${ctx.title}"
Objetivos: ${ctx.objectives.join(', ')}
Nivel Bloom: ${ctx.bloomLevel}
${ctx.courseName ? `Curso: ${ctx.courseName}` : ''}

Genera 2-4 ejercicios practicos progresivos. Cada ejercicio debe:
1. Tener 3 hints (que funcion usar, sintaxis basica, solucion casi completa)
2. Incluir codigo inicial y solucion
3. Tener tests de validacion con asserts`,
    }
  },

  quiz(ctx: PromptContext): PromptPair {
    return {
      system: `${BASE_SYSTEM}
Genera preguntas de quiz para la seccion de conclusiones de una leccion.
Formato JSON requerido:
{
  "questions": [
    {
      "id": "string",
      "question": "string",
      "type": "mcq|true_false|multiple_select",
      "options": [
        { "id": "string", "text": "string" }
      ],
      "correctAnswer": "string|string[] (id de la opcion correcta)",
      "explanation": "string (feedback para respuesta incorrecta)",
      "points": number
    }
  ],
  "connectForward": "string (markdown, 1-2 parrafos conectando con siguiente tema)",
  "estimatedMinutes": number
}`,
      user: `Leccion: "${ctx.title}"
Objetivos: ${ctx.objectives.join(', ')}
Nivel Bloom: ${ctx.bloomLevel}
${ctx.courseName ? `Curso: ${ctx.courseName}` : ''}
${ctx.existingContent ? `Contenido de la leccion:\n${ctx.existingContent.slice(0, 2000)}` : ''}

Genera 5-7 preguntas de quiz que evaluen la comprension de los objetivos. Incluye un parrafo de conexion hacia el siguiente tema.`,
    }
  },
}
