-- =====================================================
-- Seed: Curso Data Analytics con Python
-- 8 modulos, 33 lecciones, ejercicios interactivos Python
-- =====================================================

-- 1. Insertar el curso
INSERT INTO courses (id, title, description, slug, thumbnail_url, is_published)
VALUES (
  'da000000-0000-0000-0000-000000000001',
  'Data Analytics con Python',
  'Curso completo de Data Analytics que cubre Analisis Descriptivo, Predictivo y Prescriptivo. Aprende a extraer valor comercial de los datos usando Python, Pandas, Scikit-Learn y herramientas de visualizacion.',
  'data-analytics',
  '/images/courses/data-analytics-thumbnail.png',
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
  ('da010000-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'Introduccion a Python', 'Fundamentos de Python: variables, tipos de datos, estructuras de control y funciones.', 1, false),
  ('da020000-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'Obtencion de Datos con Pandas', 'Cargar, explorar y manipular datos con Pandas. CSV, Excel y DataFrames.', 2, false),
  ('da030000-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'Analisis Exploratorio de Datos', 'Estadisticas descriptivas, agrupacion, datos faltantes y combinacion de DataFrames.', 3, false),
  ('da040000-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'Visualizacion de Datos', 'Matplotlib, Seaborn y Plotly para comunicar insights visualmente.', 4, false),
  ('da050000-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'Modelos de Pronostico y Regresion', 'Regresion lineal, evaluacion de modelos y prediccion de demanda.', 5, false),
  ('da060000-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'Clasificacion', 'Regresion logistica, arboles de decision y metricas de clasificacion.', 6, false),
  ('da070000-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'Clustering y Segmentacion', 'K-Means, DBSCAN y segmentacion de clientes.', 7, false),
  ('da080000-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'Dashboards Interactivos', 'Plotly avanzado y Streamlit para dashboards interactivos.', 8, false)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description;

-- 3. Insertar las lecciones
INSERT INTO lessons (id, course_id, module_id, title, content, lesson_type, order_index, duration_minutes, is_required, video_url)
VALUES
  -- Modulo 1: Introduccion a Python
  ('da010100-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da010000-0000-0000-0000-000000000001', 'Primeros pasos con Python', 'Ver archivo: content/courses/data-analytics/module-01/lessons/01-primeros-pasos.md', 'text', 1, 15, true, null),
  ('da010200-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da010000-0000-0000-0000-000000000001', 'Tipos de datos y operaciones', 'Ver archivo: content/courses/data-analytics/module-01/lessons/02-tipos-datos.md', 'text', 2, 20, true, null),
  ('da010300-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da010000-0000-0000-0000-000000000001', 'Listas y diccionarios', 'Ver archivo: content/courses/data-analytics/module-01/lessons/03-colecciones.md', 'text', 3, 25, true, null),
  ('da010400-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da010000-0000-0000-0000-000000000001', 'Control de flujo', 'Ver archivo: content/courses/data-analytics/module-01/lessons/04-control-flujo.md', 'text', 4, 25, true, null),
  ('da010500-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da010000-0000-0000-0000-000000000001', 'Funciones basicas', 'Ver archivo: content/courses/data-analytics/module-01/lessons/05-funciones.md', 'text', 5, 20, true, null),

  -- Modulo 2: Pandas
  ('da020100-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da020000-0000-0000-0000-000000000001', 'Introduccion a Pandas', 'Ver archivo: content/courses/data-analytics/module-02/lessons/01-intro-pandas.md', 'text', 1, 20, true, null),
  ('da020200-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da020000-0000-0000-0000-000000000001', 'DataFrames y Series', 'Ver archivo: content/courses/data-analytics/module-02/lessons/02-dataframes.md', 'text', 2, 25, true, null),
  ('da020300-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da020000-0000-0000-0000-000000000001', 'Seleccion de datos', 'Ver archivo: content/courses/data-analytics/module-02/lessons/03-seleccion.md', 'text', 3, 25, true, null),
  ('da020400-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da020000-0000-0000-0000-000000000001', 'Otras fuentes de datos', 'Ver archivo: content/courses/data-analytics/module-02/lessons/04-fuentes-datos.md', 'text', 4, 20, true, null),

  -- Modulo 3: EDA
  ('da030100-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da030000-0000-0000-0000-000000000001', 'Estadisticas descriptivas', 'Ver archivo: content/courses/data-analytics/module-03/lessons/01-estadisticas-basicas.md', 'text', 1, 20, true, null),
  ('da030200-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da030000-0000-0000-0000-000000000001', 'Agrupacion y agregacion', 'Ver archivo: content/courses/data-analytics/module-03/lessons/02-groupby.md', 'text', 2, 25, true, null),
  ('da030300-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da030000-0000-0000-0000-000000000001', 'Manejo de datos faltantes', 'Ver archivo: content/courses/data-analytics/module-03/lessons/03-valores-faltantes.md', 'text', 3, 20, true, null),
  ('da030400-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da030000-0000-0000-0000-000000000001', 'Combinar DataFrames', 'Ver archivo: content/courses/data-analytics/module-03/lessons/04-merge-concat.md', 'text', 4, 25, true, null),

  -- Modulo 4: Visualizacion
  ('da040100-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da040000-0000-0000-0000-000000000001', 'Matplotlib basico', 'Ver archivo: content/courses/data-analytics/module-04/lessons/01-intro-matplotlib.md', 'text', 1, 25, true, null),
  ('da040200-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da040000-0000-0000-0000-000000000001', 'Visualizacion con Seaborn', 'Ver archivo: content/courses/data-analytics/module-04/lessons/02-seaborn.md', 'text', 2, 20, true, null),
  ('da040300-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da040000-0000-0000-0000-000000000001', 'Graficos con Plotly', 'Ver archivo: content/courses/data-analytics/module-04/lessons/03-plotly.md', 'text', 3, 25, true, null),
  ('da040400-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da040000-0000-0000-0000-000000000001', 'Mejores practicas', 'Ver archivo: content/courses/data-analytics/module-04/lessons/04-mejores-practicas.md', 'text', 4, 25, true, null),

  -- Modulo 5: Regresion
  ('da050100-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da050000-0000-0000-0000-000000000001', 'Introduccion al Machine Learning', 'Ver archivo: content/courses/data-analytics/module-05/lessons/01-intro-ml.md', 'text', 1, 20, true, null),
  ('da050200-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da050000-0000-0000-0000-000000000001', 'Regresion Lineal', 'Ver archivo: content/courses/data-analytics/module-05/lessons/02-regresion-lineal.md', 'text', 2, 30, true, null),
  ('da050300-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da050000-0000-0000-0000-000000000001', 'Metricas de regresion', 'Ver archivo: content/courses/data-analytics/module-05/lessons/03-metricas-regresion.md', 'text', 3, 25, true, null),
  ('da050400-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da050000-0000-0000-0000-000000000001', 'Caso: Bikeshare', 'Ver archivo: content/courses/data-analytics/module-05/lessons/04-caso-bikeshare.md', 'text', 4, 45, true, null),

  -- Modulo 6: Clasificacion
  ('da060100-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da060000-0000-0000-0000-000000000001', 'Introduccion a Clasificacion', 'Ver archivo: content/courses/data-analytics/module-06/lessons/01-intro-clasificacion.md', 'text', 1, 30, true, null),
  ('da060200-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da060000-0000-0000-0000-000000000001', 'Regresion Logistica', 'Ver archivo: content/courses/data-analytics/module-06/lessons/02-regresion-logistica.md', 'text', 2, 25, true, null),
  ('da060300-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da060000-0000-0000-0000-000000000001', 'Metricas de clasificacion', 'Ver archivo: content/courses/data-analytics/module-06/lessons/03-metricas-clasificacion.md', 'text', 3, 30, true, null),
  ('da060400-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da060000-0000-0000-0000-000000000001', 'Caso: Titanic', 'Ver archivo: content/courses/data-analytics/module-06/lessons/04-caso-titanic.md', 'text', 4, 60, true, null),

  -- Modulo 7: Clustering
  ('da070100-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da070000-0000-0000-0000-000000000001', 'Introduccion al Clustering', 'Ver archivo: content/courses/data-analytics/module-07/lessons/01-intro-clustering.md', 'text', 1, 20, true, null),
  ('da070200-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da070000-0000-0000-0000-000000000001', 'K-Means en detalle', 'Ver archivo: content/courses/data-analytics/module-07/lessons/02-kmeans.md', 'text', 2, 30, true, null),
  ('da070300-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da070000-0000-0000-0000-000000000001', 'DBSCAN', 'Ver archivo: content/courses/data-analytics/module-07/lessons/03-dbscan.md', 'text', 3, 25, true, null),
  ('da070400-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da070000-0000-0000-0000-000000000001', 'Caso: Segmentacion de clientes', 'Ver archivo: content/courses/data-analytics/module-07/lessons/04-caso-segmentacion.md', 'text', 4, 60, true, null),

  -- Modulo 8: Dashboards
  ('da080100-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da080000-0000-0000-0000-000000000001', 'Plotly Graph Objects', 'Ver archivo: content/courses/data-analytics/module-08/lessons/01-intro-dashboards.md', 'text', 1, 30, true, null),
  ('da080200-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da080000-0000-0000-0000-000000000001', 'Plotly avanzado', 'Ver archivo: content/courses/data-analytics/module-08/lessons/02-plotly-avanzado.md', 'text', 2, 25, true, null),
  ('da080300-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da080000-0000-0000-0000-000000000001', 'Introduccion a Streamlit', 'Ver archivo: content/courses/data-analytics/module-08/lessons/03-streamlit-basico.md', 'text', 3, 30, true, null),
  ('da080400-0000-0000-0000-000000000001', 'da000000-0000-0000-0000-000000000001', 'da080000-0000-0000-0000-000000000001', 'Construyendo un dashboard', 'Ver archivo: content/courses/data-analytics/module-08/lessons/04-dashboard-completo.md', 'text', 4, 40, true, null)

ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  content = EXCLUDED.content;

-- Verificacion
SELECT
    'Curso Data Analytics creado' as status,
    (SELECT COUNT(*) FROM courses WHERE slug = 'data-analytics') as cursos,
    (SELECT COUNT(*) FROM modules WHERE course_id = 'da000000-0000-0000-0000-000000000001') as modulos,
    (SELECT COUNT(*) FROM lessons WHERE course_id = 'da000000-0000-0000-0000-000000000001') as lecciones;
