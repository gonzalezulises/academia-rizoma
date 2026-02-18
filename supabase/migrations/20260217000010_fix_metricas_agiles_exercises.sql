-- =====================================================
-- Fix exercise_data JSONB to match TypeScript types
-- Fields: type (not exercise_type), correct option format,
-- reflection_prompt, scenario_text, analysis_questions
-- =====================================================

-- Fix ma-ex-01: Quiz — Métricas accionables vs decorativas
UPDATE course_exercises
SET exercise_data = '{
  "id": "ma-ex-01",
  "type": "quiz",
  "title": "¿Accionable o Decorativa?",
  "description": "Identifica cuáles de las siguientes métricas cumplen con las 3 características de una métrica accionable (umbral explícito, dueño identificado, frecuencia adecuada).",
  "instructions": "Lee cada escenario y determina si la métrica descrita es accionable o decorativa. Recuerda las 3 características: umbral explícito, dueño identificado y frecuencia adecuada.",
  "difficulty": "intermediate",
  "estimated_time_minutes": 10,
  "points": 50,
  "passing_score": 60,
  "show_explanation_on_wrong": true,
  "questions": [
    {
      "id": "q1",
      "question": "\"Tasa de rotación de personal\": se muestra en el dashboard mensual del CEO. No tiene umbral definido ni persona asignada para actuar.",
      "type": "mcq",
      "options": [
        { "id": "a", "text": "Accionable" },
        { "id": "b", "text": "Decorativa" }
      ],
      "correct": "b",
      "points": 10,
      "explanation": "Sin umbral ni dueño, es decorativa. El CEO la ve pero nadie tiene la responsabilidad específica de actuar cuando cruza cierto valor."
    },
    {
      "id": "q2",
      "question": "\"Cycle time de tickets de soporte > 48h\": dispara alerta automática al Team Lead, quien debe investigar bloqueos dentro de 24h. Se revisa diariamente.",
      "type": "mcq",
      "options": [
        { "id": "a", "text": "Accionable" },
        { "id": "b", "text": "Decorativa" }
      ],
      "correct": "a",
      "points": 10,
      "explanation": "Cumple las 3 características: umbral (> 48h), dueño (Team Lead), frecuencia (diaria). Es una métrica accionable."
    },
    {
      "id": "q3",
      "question": "\"NPS (Net Promoter Score) trimestral\": se presenta en la junta directiva. Se analiza la tendencia histórica.",
      "type": "mcq",
      "options": [
        { "id": "a", "text": "Accionable" },
        { "id": "b", "text": "Decorativa" }
      ],
      "correct": "b",
      "points": 10,
      "explanation": "Aunque es una métrica valiosa, tal como se describe no tiene umbral de acción ni dueño que intervenga. Se observa pero no dispara acciones específicas."
    },
    {
      "id": "q4",
      "question": "\"WIP > 15 ítems en la columna En Curso\": el Scrum Master pausa nuevas entradas y convoca revisión de bloqueos. Se verifica en el standup diario.",
      "type": "mcq",
      "options": [
        { "id": "a", "text": "Accionable" },
        { "id": "b", "text": "Decorativa" }
      ],
      "correct": "a",
      "points": 10,
      "explanation": "Umbral (> 15), dueño (Scrum Master), frecuencia (diaria), y acción definida (pausar entradas + revisar bloqueos). Perfectamente accionable."
    },
    {
      "id": "q5",
      "question": "\"Cantidad de story points completados por sprint\": se reporta al final de cada sprint. Se compara con sprints anteriores.",
      "type": "mcq",
      "options": [
        { "id": "a", "text": "Accionable" },
        { "id": "b", "text": "Decorativa" }
      ],
      "correct": "b",
      "points": 10,
      "explanation": "Los story points sin umbral, dueño ni acción definida son una métrica de actividad, no de flujo. Comparar con sprints anteriores es informativo pero no dispara intervención."
    }
  ]
}'::jsonb
WHERE exercise_id = 'ma-ex-01'
  AND course_id = 'ae000000-0000-0000-0000-000000000001';

-- Fix ma-ex-02: Reflection — Colas invisibles
UPDATE course_exercises
SET exercise_data = '{
  "id": "ma-ex-02",
  "type": "reflection",
  "title": "¿Dónde están las colas invisibles en tu equipo?",
  "description": "Reflexiona sobre el flujo de trabajo de tu equipo e identifica las colas invisibles que consumen tiempo sin agregar valor.",
  "instructions": "Piensa en un tipo de solicitud frecuente en tu equipo (ticket, feature, reporte). Describe el flujo completo, estima la proporción de tiempo de espera vs. trabajo activo, e identifica la cola más grande con una acción concreta para reducirla.",
  "difficulty": "intermediate",
  "estimated_time_minutes": 15,
  "points": 30,
  "reflection_prompt": "Piensa en un tipo de solicitud frecuente en tu equipo (ticket, feature, reporte).\n\n1. Describe brevemente el flujo desde que se solicita hasta que se entrega.\n\n2. Estima qué porcentaje del lead time total es tiempo de espera (colas, aprobaciones, transferencias) vs. tiempo de trabajo activo.\n\n3. Identifica la cola más grande (donde más tiempo se acumula). ¿Qué la causa? ¿Qué acción concreta podrías tomar para reducirla?"
}'::jsonb
WHERE exercise_id = 'ma-ex-02'
  AND course_id = 'ae000000-0000-0000-0000-000000000001';

-- Fix ma-ex-03: Quiz — Diseñar OKRs conectados
UPDATE course_exercises
SET exercise_data = '{
  "id": "ma-ex-03",
  "type": "quiz",
  "title": "Diseñando OKRs Conectados",
  "description": "Evalúa tu comprensión de cómo conectar OKRs con métricas operativas reales.",
  "instructions": "Identifica los OKRs bien formulados y los anti-patrones. Selecciona la mejor respuesta para cada pregunta.",
  "difficulty": "intermediate",
  "estimated_time_minutes": 10,
  "points": 40,
  "passing_score": 50,
  "show_explanation_on_wrong": true,
  "questions": [
    {
      "id": "q1",
      "question": "¿Cuál de estos Key Results está mejor conectado con métricas operativas?",
      "type": "mcq",
      "options": [
        { "id": "a", "text": "Completar la migración a microservicios para Q2" },
        { "id": "b", "text": "Reducir cycle time de features de 20 a 8 días" },
        { "id": "c", "text": "Implementar 3 nuevos pipelines de CI/CD" },
        { "id": "d", "text": "Capacitar al 100% del equipo en Kubernetes" }
      ],
      "correct": "b",
      "points": 10,
      "explanation": "Reducir cycle time mide una capacidad del sistema (outcome), no un entregable específico (output). Los otros son tareas disfrazadas de Key Results."
    },
    {
      "id": "q2",
      "question": "Un equipo tiene este OKR: \"Objetivo: Ser el equipo más rápido de la empresa. KR1: Completar 200 story points por sprint\". ¿Qué anti-patrón representa?",
      "type": "mcq",
      "options": [
        { "id": "a", "text": "OKR sin cadencia de revisión" },
        { "id": "b", "text": "Goodhart''s Law — la métrica se convierte en objetivo y se infla" },
        { "id": "c", "text": "OKR demasiado ambicioso" },
        { "id": "d", "text": "Key Result sin dueño" }
      ],
      "correct": "b",
      "points": 10,
      "explanation": "Story points como objetivo incentivan inflar estimaciones (Goodhart''s Law). Además, \"más rápido\" medido en puntos no refleja valor entregado al cliente."
    },
    {
      "id": "q3",
      "question": "¿Con qué frecuencia deben revisarse las métricas operativas que alimentan los OKRs?",
      "type": "mcq",
      "options": [
        { "id": "a", "text": "Trimestralmente, junto con los OKRs" },
        { "id": "b", "text": "Mensualmente, en la revisión de progreso" },
        { "id": "c", "text": "Semanalmente, para detectar desviaciones a tiempo" },
        { "id": "d", "text": "Diariamente, en cada standup" }
      ],
      "correct": "c",
      "points": 10,
      "explanation": "Las métricas operativas (cycle time, WIP, throughput) se revisan semanalmente. Las revisiones de Key Results son mensuales. Los OKRs se evalúan trimestralmente."
    },
    {
      "id": "q4",
      "question": "Un OKR tiene 5 Objectives con 5 Key Results cada uno (25 KR en total). ¿Cuál es el problema principal?",
      "type": "mcq",
      "options": [
        { "id": "a", "text": "Los Key Results no son medibles" },
        { "id": "b", "text": "Falta de foco — demasiados OKRs diluyen la atención y el esfuerzo" },
        { "id": "c", "text": "No hay suficientes dueños para cada KR" },
        { "id": "d", "text": "La cadencia trimestral es insuficiente para tantos KR" }
      ],
      "correct": "b",
      "points": 10,
      "explanation": "La recomendación es máximo 3 Objectives con 3-5 Key Results cada uno. 25 KR significa que nada es realmente prioritario."
    }
  ]
}'::jsonb
WHERE exercise_id = 'ma-ex-03'
  AND course_id = 'ae000000-0000-0000-0000-000000000001';

-- Fix ma-ex-04: Case Study — Transformación ágil
UPDATE course_exercises
SET exercise_data = '{
  "id": "ma-ex-04",
  "type": "case-study",
  "title": "Caso: Diagnóstico de Métricas en FinServ LATAM",
  "description": "Una fintech centroamericana con 60 desarrolladores te contrata como consultor ágil. Analiza la situación y propón intervenciones.",
  "instructions": "Lee el escenario con atención. Usa los frameworks del curso (Ley de Little, 3 características de métricas accionables, clasificación de cuellos de botella, OKRs conectados) para responder las preguntas de análisis.",
  "difficulty": "advanced",
  "estimated_time_minutes": 25,
  "points": 100,
  "scenario_text": "FinServ LATAM es una fintech con 60 desarrolladores organizados en 8 equipos. Cada equipo maneja entre 5 y 12 proyectos simultáneamente (WIP total estimado: 70+ ítems). El CTO reporta al board con un dashboard de 150 indicadores incluyendo velocidad por equipo, utilización, bugs reportados, cobertura de código y NPS.\n\nEl lead time promedio para nuevas features es de 45 días, con un rango de 10 a 90 días. Los equipos tienen sprints de 2 semanas pero el 60% de los sprints terminan con carry-over (trabajo no completado que pasa al siguiente sprint).\n\nLas aprobaciones de arquitectura requieren firma del CTO y del CISO para cualquier cambio que toque la base de datos. El equipo de QA (3 personas) es compartido entre los 8 equipos de desarrollo.\n\nEl throughput promedio es de 10 features completadas por semana entre todos los equipos.",
  "analysis_questions": [
    "De los 150 indicadores del CTO, ¿cuáles 4-5 métricas accionables recomendarías mantener como indicadores activos? Justifica cada una con umbral, dueño y frecuencia.",
    "Usando la Ley de Little (Cycle Time = WIP / Throughput), si el throughput promedio es de 10 features/semana entre todos los equipos, ¿cuál es el cycle time actual con 70 ítems de WIP? ¿A cuánto bajaría si reducen WIP a 25?",
    "Identifica los 3 cuellos de botella principales en el escenario. Para cada uno, clasifícalo (aprobación jerárquica, recurso compartido, o handoff) y propón una intervención concreta.",
    "Formula 1 OKR trimestral (1 Objective + 3 Key Results) que conecte la estrategia con las métricas operativas que recomendaste. Los Key Results deben usar las métricas de flujo del curso."
  ]
}'::jsonb
WHERE exercise_id = 'ma-ex-04'
  AND course_id = 'ae000000-0000-0000-0000-000000000001';

-- Verify updates
SELECT exercise_id, exercise_type,
       exercise_data->>'type' as data_type,
       exercise_data->>'title' as title
FROM course_exercises
WHERE course_id = 'ae000000-0000-0000-0000-000000000001'
ORDER BY exercise_id;
