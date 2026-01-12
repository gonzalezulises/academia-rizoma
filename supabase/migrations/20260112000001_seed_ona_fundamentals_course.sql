-- =====================================================
-- Seed: Curso ONA Fundamentals
-- 2 modulos, 5 lecciones, 11 ejercicios (10 + quiz final)
-- Introduccion al Analisis de Redes Organizacionales
-- =====================================================

-- 1. Insertar el curso
INSERT INTO courses (id, title, description, slug, thumbnail_url, is_published)
VALUES (
  'ona00000-0000-0000-0000-000000000001',
  'Introduccion al Analisis de Redes Organizacionales (ONA)',
  'Aprende a revelar la estructura informal de tu organizacion. Diagnostica silos, cuellos de botella y dependencias usando analisis de redes. Curso practico con casos reales de LATAM, sin necesidad de programar.',
  'ona-fundamentals',
  '/images/courses/ona-fundamentals-thumbnail.png',
  true
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  slug = EXCLUDED.slug,
  is_published = EXCLUDED.is_published;

-- 2. Insertar los modulos
INSERT INTO modules (id, course_id, title, description, order_index, is_locked)
VALUES
  ('ona10000-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'Entendiendo las Redes Ocultas', 'Descubre la diferencia entre organigrama y red informal, aprende las metricas clave y diseña encuestas ONA efectivas.', 1, false),
  ('ona20000-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'De Datos a Decisiones', 'Identifica patrones problematicos (silos, cuellos de botella, dependencias) y aprende a formular recomendaciones accionables.', 2, false)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description;

-- 3. Insertar las lecciones
INSERT INTO lessons (id, course_id, module_id, title, content, lesson_type, order_index, duration_minutes, is_required, video_url)
VALUES
  -- Modulo 1: Entendiendo las Redes Ocultas
  ('ona10100-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona10000-0000-0000-0000-000000000001', 'Organigrama vs Red Informal', 'Ver archivo: content/courses/ona-fundamentals/module-01/lessons/01-organigrama-vs-red.md', 'text', 1, 20, true, null),
  ('ona10200-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona10000-0000-0000-0000-000000000001', 'Metricas de Centralidad', 'Ver archivo: content/courses/ona-fundamentals/module-01/lessons/02-metricas-centralidad.md', 'text', 2, 30, true, null),
  ('ona10300-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona10000-0000-0000-0000-000000000001', 'Disenando Encuestas ONA', 'Ver archivo: content/courses/ona-fundamentals/module-01/lessons/03-diseno-encuesta.md', 'text', 3, 25, true, null),

  -- Modulo 2: De Datos a Decisiones
  ('ona20100-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona20000-0000-0000-0000-000000000001', 'Patrones Problematicos', 'Ver archivo: content/courses/ona-fundamentals/module-02/lessons/04-patrones-problematicos.md', 'text', 1, 35, true, null),
  ('ona20200-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona20000-0000-0000-0000-000000000001', 'Caso Integrador: Aseguradora del Pacifico', 'Ver archivo: content/courses/ona-fundamentals/module-02/lessons/05-caso-integrador.md', 'text', 2, 30, true, null)

ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  content = EXCLUDED.content;

-- 4. Insertar los ejercicios
-- Nota: Los ejercicios usan el sistema de archivos YAML, esta tabla es para tracking de progreso

INSERT INTO exercises (id, course_id, module_id, lesson_id, title, description, exercise_type, difficulty, points, order_index)
VALUES
  -- Modulo 1 Ejercicios
  ('ona10101-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona10000-0000-0000-0000-000000000001', 'ona10100-0000-0000-0000-000000000001', 'Detectando la red oculta', 'Compara el organigrama formal con la red informal de consultas.', 'code-python', 'beginner', 20, 1),
  ('ona10102-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona10000-0000-0000-0000-000000000001', 'ona10100-0000-0000-0000-000000000001', 'Identificando al broker', 'Encuentra quien conecta departamentos que de otra forma estarian aislados.', 'code-python', 'beginner', 20, 2),
  ('ona10201-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona10000-0000-0000-0000-000000000001', 'ona10200-0000-0000-0000-000000000001', 'Calculadora de centralidad', 'Explora como cambian las metricas al modificar conexiones.', 'code-python', 'intermediate', 30, 3),
  ('ona10202-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona10000-0000-0000-0000-000000000001', 'ona10200-0000-0000-0000-000000000001', 'Caso Banco Regional', 'Interpreta las metricas de ONA para diagnosticar tiempos de aprobacion.', 'code-python', 'intermediate', 30, 4),
  ('ona10301-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona10000-0000-0000-0000-000000000001', 'ona10300-0000-0000-0000-000000000001', 'Constructor de preguntas ONA', 'Aprende a disenar preguntas de encuesta ONA efectivas.', 'quiz', 'beginner', 30, 5),
  ('ona10302-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona10000-0000-0000-0000-000000000001', 'ona10300-0000-0000-0000-000000000001', 'Auditor de encuestas ONA', 'Evalua la calidad de encuestas ONA reales.', 'quiz', 'intermediate', 40, 6),

  -- Modulo 2 Ejercicios
  ('ona20101-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona20000-0000-0000-0000-000000000001', 'ona20100-0000-0000-0000-000000000001', 'Diagnostico de silos', 'Identifica y cuantifica silos entre departamentos.', 'code-python', 'intermediate', 30, 7),
  ('ona20102-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona20000-0000-0000-0000-000000000001', 'ona20100-0000-0000-0000-000000000001', 'Riesgo de dependencia', 'Identifica personas clave cuya salida impactaria la red.', 'code-python', 'intermediate', 35, 8),
  ('ona20103-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona20000-0000-0000-0000-000000000001', 'ona20100-0000-0000-0000-000000000001', 'Simulador de impacto', 'Simula el impacto de remover o agregar conexiones.', 'code-python', 'intermediate', 35, 9),
  ('ona20201-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona20000-0000-0000-0000-000000000001', 'ona20200-0000-0000-0000-000000000001', 'Caso Aseguradora del Pacifico', 'Aplica todo lo aprendido en un caso integrador.', 'code-python', 'advanced', 50, 10),
  ('ona20202-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona20000-0000-0000-0000-000000000001', 'ona20200-0000-0000-0000-000000000001', 'Evaluacion Final ONA', 'Demuestra tu dominio de los conceptos de ONA.', 'quiz', 'intermediate', 100, 11)

ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description;

-- Verificacion
SELECT
    'Curso ONA Fundamentals creado' as status,
    (SELECT COUNT(*) FROM courses WHERE slug = 'ona-fundamentals') as cursos,
    (SELECT COUNT(*) FROM modules WHERE course_id = 'ona00000-0000-0000-0000-000000000001') as modulos,
    (SELECT COUNT(*) FROM lessons WHERE course_id = 'ona00000-0000-0000-0000-000000000001') as lecciones,
    (SELECT COUNT(*) FROM exercises WHERE course_id = 'ona00000-0000-0000-0000-000000000001') as ejercicios;
