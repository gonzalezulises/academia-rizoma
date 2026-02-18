-- =====================================================
-- Fix: Spanish orthography across all courses
-- Adds missing accent marks (tildes), ¿ opening question marks,
-- ñ characters, and ¡ opening exclamation marks
-- =====================================================
BEGIN;

-- =====================================================
-- 1. PYTHON COURSE
-- =====================================================

-- Course title and description
UPDATE courses SET
  title = 'Introducción a Python',
  description = 'Aprende Python desde cero con ejercicios prácticos interactivos. Ideal para principiantes que quieren dar sus primeros pasos en programación.'
WHERE id = 'ba910d93-bf66-4038-8d60-b70df4f6843e';

-- Lesson 2 description
UPDATE lessons SET content = 'Operadores aritméticos, de comparación y lógicos'
WHERE id = '22222222-2222-2222-2222-222222222222';

-- =====================================================
-- 2. SQL COURSE
-- =====================================================

-- Course description
UPDATE courses SET
  description = 'Aprende a consultar bases de datos desde cero. Sin prerrequisitos de programación. Al terminar, podrás extraer y resumir datos de cualquier base de datos relacional.'
WHERE id = 'c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f';

-- Lesson 1 title
UPDATE lessons SET
  title = '¿Qué es SQL y por qué lo necesitas?'
WHERE id = 'e3f4a5b6-c7d8-4e9f-0a1b-2c3d4e5f6a7b';

-- =====================================================
-- 3. DATA ANALYTICS COURSE
-- =====================================================

-- Course description
UPDATE courses SET
  description = 'Curso completo de Data Analytics que cubre Análisis Descriptivo, Predictivo y Prescriptivo. Aprende a extraer valor comercial de los datos usando Python, Pandas, Scikit-Learn y herramientas de visualización.'
WHERE id = 'da000000-0000-0000-0000-000000000001';

-- Module titles and descriptions
UPDATE modules SET title = 'Introducción a Python', description = 'Fundamentos de Python: variables, tipos de datos, estructuras de control y funciones.' WHERE id = 'da010000-0000-0000-0000-000000000001';
UPDATE modules SET title = 'Obtención de Datos con Pandas', description = 'Cargar, explorar y manipular datos con Pandas. CSV, Excel y DataFrames.' WHERE id = 'da020000-0000-0000-0000-000000000001';
UPDATE modules SET title = 'Análisis Exploratorio de Datos', description = 'Estadísticas descriptivas, agrupación, datos faltantes y combinación de DataFrames.' WHERE id = 'da030000-0000-0000-0000-000000000001';
UPDATE modules SET title = 'Visualización de Datos', description = 'Matplotlib, Seaborn y Plotly para comunicar insights visualmente.' WHERE id = 'da040000-0000-0000-0000-000000000001';
UPDATE modules SET title = 'Modelos de Pronóstico y Regresión', description = 'Regresión lineal, evaluación de modelos y predicción de demanda.' WHERE id = 'da050000-0000-0000-0000-000000000001';
UPDATE modules SET title = 'Clasificación', description = 'Regresión logística, árboles de decisión y métricas de clasificación.' WHERE id = 'da060000-0000-0000-0000-000000000001';
UPDATE modules SET title = 'Clustering y Segmentación', description = 'K-Means, DBSCAN y segmentación de clientes.' WHERE id = 'da070000-0000-0000-0000-000000000001';

-- Lesson titles (only the ones with accent issues)
UPDATE lessons SET title = 'Funciones básicas' WHERE id = 'da010500-0000-0000-0000-000000000001';
UPDATE lessons SET title = 'Introducción a Pandas' WHERE id = 'da020100-0000-0000-0000-000000000001';
UPDATE lessons SET title = 'Selección de datos' WHERE id = 'da020300-0000-0000-0000-000000000001';
UPDATE lessons SET title = 'Estadísticas descriptivas' WHERE id = 'da030100-0000-0000-0000-000000000001';
UPDATE lessons SET title = 'Agrupación y agregación' WHERE id = 'da030200-0000-0000-0000-000000000001';
UPDATE lessons SET title = 'Matplotlib básico' WHERE id = 'da040100-0000-0000-0000-000000000001';
UPDATE lessons SET title = 'Visualización con Seaborn' WHERE id = 'da040200-0000-0000-0000-000000000001';
UPDATE lessons SET title = 'Gráficos con Plotly' WHERE id = 'da040300-0000-0000-0000-000000000001';
UPDATE lessons SET title = 'Mejores prácticas' WHERE id = 'da040400-0000-0000-0000-000000000001';
UPDATE lessons SET title = 'Introducción al Machine Learning' WHERE id = 'da050100-0000-0000-0000-000000000001';
UPDATE lessons SET title = 'Regresión Lineal' WHERE id = 'da050200-0000-0000-0000-000000000001';
UPDATE lessons SET title = 'Métricas de regresión' WHERE id = 'da050300-0000-0000-0000-000000000001';
UPDATE lessons SET title = 'Introducción a Clasificación' WHERE id = 'da060100-0000-0000-0000-000000000001';
UPDATE lessons SET title = 'Regresión Logística' WHERE id = 'da060200-0000-0000-0000-000000000001';
UPDATE lessons SET title = 'Métricas de clasificación' WHERE id = 'da060300-0000-0000-0000-000000000001';
UPDATE lessons SET title = 'Introducción al Clustering' WHERE id = 'da070100-0000-0000-0000-000000000001';
UPDATE lessons SET title = 'Caso: Segmentación de clientes' WHERE id = 'da070400-0000-0000-0000-000000000001';
UPDATE lessons SET title = 'Introducción a Streamlit' WHERE id = 'da080300-0000-0000-0000-000000000001';

-- =====================================================
-- 4. ONA FUNDAMENTALS COURSE
-- =====================================================

-- Course title and description
UPDATE courses SET
  title = 'Introducción al Análisis de Redes Organizacionales (ONA)',
  description = 'Aprende a revelar la estructura informal de tu organización. Diagnostica silos, cuellos de botella y dependencias usando análisis de redes. Curso práctico con casos reales de LATAM, sin necesidad de programar.'
WHERE id = 'f0a00000-0000-0000-0000-000000000001';

-- Module descriptions
UPDATE modules SET description = 'Descubre la diferencia entre organigrama y red informal, aprende las métricas clave y diseña encuestas ONA efectivas.' WHERE id = 'f0a10000-0000-0000-0000-000000000001';
UPDATE modules SET description = 'Identifica patrones problemáticos (silos, cuellos de botella, dependencias) y aprende a formular recomendaciones accionables.' WHERE id = 'f0a20000-0000-0000-0000-000000000001';

-- Lesson titles
UPDATE lessons SET title = 'Métricas de Centralidad' WHERE id = 'f0a10200-0000-0000-0000-000000000001';
UPDATE lessons SET title = 'Diseñando Encuestas ONA' WHERE id = 'f0a10300-0000-0000-0000-000000000001';
UPDATE lessons SET title = 'Patrones Problemáticos' WHERE id = 'f0a20100-0000-0000-0000-000000000001';
UPDATE lessons SET title = 'Caso Integrador: Aseguradora del Pacífico' WHERE id = 'f0a20200-0000-0000-0000-000000000001';

-- =====================================================
-- 5. SKLEARN COURSE
-- =====================================================

-- Course title and description
UPDATE courses SET
  title = 'Introducción a Scikit-Learn',
  description = 'De cero a entrenar y evaluar tu primer modelo de machine learning. Aprende el ecosistema sklearn, el patrón fit/predict, preprocesamiento de datos y evaluación de modelos con métricas de negocio.'
WHERE id = '7483519d-cc1d-4cba-bf52-6dde74ce8933';

-- Module titles and descriptions (match by course_id + order_index)
UPDATE modules SET
  description = 'Entender qué es sklearn, su API consistente, y cuándo usarlo vs alternativas'
WHERE course_id = '7483519d-cc1d-4cba-bf52-6dde74ce8933' AND order_index = 1;

UPDATE modules SET
  title = 'El patrón fit/predict'
WHERE course_id = '7483519d-cc1d-4cba-bf52-6dde74ce8933' AND order_index = 2;

UPDATE modules SET
  title = 'Evaluación de modelos',
  description = 'Métricas de clasificación y cómo elegir la correcta según el problema'
WHERE course_id = '7483519d-cc1d-4cba-bf52-6dde74ce8933' AND order_index = 4;

-- =====================================================
-- 6. IA NEGOCIOS AGILES - FULL LESSON CONTENT UPDATES
-- =====================================================

-- Lesson 4: IA para análisis y síntesis
UPDATE lessons SET content = $CONTENT$## IA para análisis y síntesis

### De 500 encuestas a 5 insights en 20 minutos

Imagina este escenario: tu empresa acaba de recibir los resultados de su encuesta anual de satisfacción del cliente. Son 500 respuestas abiertas. Alguien tiene que leerlas, categorizarlas, identificar patrones y producir un resumen ejecutivo. Con un analista dedicado, eso toma entre 2 y 4 semanas. Con IA generativa, toma una tarde.

No estamos hablando de magia. Estamos hablando de lo que los modelos de lenguaje hacen mejor que cualquier otra tarea: **procesar, clasificar y sintetizar grandes volúmenes de texto no estructurado**. Brynjolfsson y McAfee (2017) anticiparon este cambio en *Machine, Platform, Crowd*: las tareas que combinan lectura intensiva con clasificación son exactamente donde la IA complementa mejor al ser humano.

La clave está en saber qué tipo de análisis necesitas y cuál modelo usar.

---

### Tipos de análisis cualitativo con IA

No todo análisis es igual. Cada tipo requiere un enfoque distinto y algunos modelos lo manejan mejor que otros.

| Tipo de análisis | Descripción | Modelo recomendado | Por qué |
|---|---|---|---|
| **Categorización temática** | Agrupar textos por tema (quejas, sugerencias, elogios) | Claude | Matices en lenguaje ambiguo, mejor comprensión de contexto |
| **Extracción de sentimiento** | Determinar si un texto es positivo, negativo o neutro | Claude / Gemini | Ambos competentes; Claude maneja mejor sarcasmo e ironía |
| **Resumen de documentos largos** | Condensar reportes de 50+ páginas en puntos clave | Claude | Ventana de contexto amplia, fidelidad al texto original |
| **Análisis de encuestas con imágenes** | Procesar formularios escaneados o escritos a mano | Gemini | Capacidad multimodal nativa para interpretar imágenes |
| **Identificación de patrones** | Encontrar temas recurrentes en cientos de textos | Claude | Consistencia en categorización a lo largo de múltiples pasadas |
| **Extracción de datos estructurados** | Convertir texto libre en tablas o JSON | DeepSeek / Claude | DeepSeek competitivo a menor costo para tareas repetitivas |

---

### Caso detallado: 500 encuestas de satisfacción

**Contexto:** Una distribuidora de productos de consumo en Colombia recibe 500 respuestas abiertas de su encuesta trimestral de satisfacción. El equipo de experiencia del cliente necesita un informe para la junta directiva en 5 días.

**Paso 1: Preparar los datos.** Exporta las respuestas a un archivo de texto plano o CSV. Si son más de lo que cabe en una sola ventana de contexto, divídelas en lotes de 50-100.

**Paso 2: Categorización temática.** Usa este prompt con Claude:

> *"Analiza las siguientes 100 respuestas de una encuesta de satisfacción del cliente de una distribuidora de productos de consumo en Colombia. Para cada respuesta, asigna: (1) una categoría temática (máximo 8 categorías), (2) un sentimiento (positivo, negativo, neutro, mixto), y (3) extrae la queja o elogio específico si existe. Devuelve el resultado en formato de tabla."*

**Paso 3: Consolidación.** Después de procesar los 5 lotes, pide al modelo que consolide:

> *"Aquí están los resultados de categorización de 5 lotes de encuestas (500 respuestas totales). Consolida los resultados: identifica las 5 categorías más frecuentes, el sentimiento general por categoría, y los 3 problemas más urgentes con ejemplos textuales directos de los encuestados."*

**Resultado típico:** El modelo identifica que el 34% de las quejas se concentran en tiempos de entrega, el 22% en errores de facturación, y el 18% en falta de comunicación proactiva cuando hay retrasos. Tres insights accionables que habrían tomado semanas en emerger de un análisis manual.

---

### Claude vs. Gemini: diferencias prácticas en análisis

No todos los modelos analizan texto de la misma manera. En pruebas comparativas (MIT Sloan, 2024), las diferencias se manifiestan en matices:

**Claude** tiende a ser más conservador en sus categorizaciones. Si una respuesta es ambigua ("el servicio está bien, pero podría mejorar"), Claude la clasificará como "mixta" y explicará la ambigüedad. Esto es valioso cuando necesitas precisión.

**Gemini** es más agresivo clasificando y tiene la ventaja de procesar imágenes. Si tus encuestas incluyen formularios escaneados, fotos de comentarios escritos a mano, o capturas de pantalla de chats de WhatsApp, Gemini puede interpretarlos directamente. Claude necesita que primero transcribas el texto.

**Recomendación práctica:** Si tus datos son texto puro, usa Claude. Si incluyen imágenes o documentos escaneados, usa Gemini para la extracción inicial y luego Claude para el análisis profundo.

---

### Buenas prácticas para análisis con IA

1. **Fragmenta documentos largos.** Los modelos procesan mejor textos en segmentos de 2,000-5,000 palabras que un documento completo de 50 páginas. La calidad del análisis se degrada con inputs muy extensos.

2. **Verifica contra la fuente.** Nunca presentes un resumen de IA sin cruzarlo con el documento original. Los modelos pueden omitir matices importantes o dar peso desproporcionado a ciertos temas.

3. **Usa prompts de extracción específicos.** "Resume este documento" produce resultados genéricos. "Extrae las 5 conclusiones principales, los 3 riesgos mencionados y cualquier dato cuantitativo citado" produce resultados útiles.

4. **Pide formato estructurado.** Solicitar tablas, listas numeradas o JSON facilita la verificación y reduce la probabilidad de que el modelo "invente" conexiones narrativas.

5. **Haz múltiples pasadas.** Pasa el mismo texto dos veces con ángulos diferentes: primero para temas, luego para sentimiento, luego para datos cuantitativos. Cada pasada enfocada supera a una pasada genérica.

> *"La IA no reemplaza el análisis crítico — acelera la parte mecánica para que el humano pueda dedicar su tiempo a la interpretación y la decisión."* — MIT Sloan Management Review, 2024

---

### Tu turno

<!-- exercise:ia-ex-04 -->

---

**Referencias:**

- Brynjolfsson, E. & McAfee, A. (2017). *Machine, Platform, Crowd: Harnessing Our Digital Future*. W.W. Norton.
- MIT Sloan Management Review (2024). "AI in Business Analytics: From Automation to Augmentation."
- Anthropic (2025). *Claude Model Card and Evaluations*.
- Google DeepMind (2025). *Gemini Technical Report*.$CONTENT$
WHERE id = '1a020100-0000-0000-0000-000000000001';

-- Lesson 5: IA para contenido y comunicación
UPDATE lessons SET content = $CONTENT$## IA para contenido y comunicación

### El profesional que escribe el doble en la mitad del tiempo

Toda organización produce contenido constantemente: correos, propuestas comerciales, presentaciones, comunicados internos, publicaciones en redes sociales, minutas de reuniones. Huang y Rust (2021) estiman que los profesionales dedican entre el 25% y el 40% de su jornada laboral a tareas de comunicación escrita.

La IA generativa no te convierte en mejor escritor. Te convierte en un escritor más rápido que puede dedicar más tiempo a la revisión y la estrategia. La diferencia entre contenido profesional y contenido mediocre generado por IA está en cómo lo supervisas, no en cómo lo generas.

---

### Tipos de contenido profesional y modelo recomendado

| Tipo de contenido | Complejidad | Modelo sugerido | Razón |
|---|---|---|---|
| **Correos profesionales** | Baja | Cualquiera | Tarea estándar; la diferencia es mínima entre modelos |
| **Propuestas comerciales** | Alta | Gemini + Google Workspace | Integración nativa con Slides y Docs para formato final |
| **Comunicaciones de crisis** | Muy alta | Claude | Manejo de tono, empatía y sensibilidad legal |
| **Posts de redes sociales** | Media | Claude / Gemini | Depende de si necesitas imágenes (Gemini) o solo texto (Claude) |
| **Reportes ejecutivos** | Alta | Claude | Síntesis precisa, estructura clara, fidelidad a datos |
| **Comunicados internos** | Media | Cualquiera | Verificar tono institucional y consistencia con comunicaciones previas |

---

### Caso 1: Propuesta comercial con Gemini + Google Workspace

**Contexto:** Una consultora de recursos humanos en Perú necesita preparar una propuesta comercial para un cliente potencial del sector minero. Tiene 48 horas.

**Paso 1: Estructura con Gemini.** Usa Gemini en Google Docs para generar la estructura base:

> *"Crea la estructura de una propuesta comercial de consultoría en recursos humanos para una empresa minera en Perú. El proyecto es un diagnóstico de clima laboral para 1,200 empleados en 3 sedes. Incluye: resumen ejecutivo, contexto del sector, metodología propuesta, cronograma, equipo consultor e inversión estimada."*

**Paso 2: Desarrollo en Google Docs.** Gemini dentro de Docs permite expandir cada sección manteniendo formato, generar tablas de cronograma y ajustar el tono al sector minero (formal, técnico, orientado a resultados de seguridad y productividad).

**Paso 3: Presentación en Google Slides.** Exporta los puntos clave a Slides. Gemini genera diapositivas con la estructura visual, que luego ajustas con la marca de tu empresa.

**Ventaja de Gemini aquí:** La integración con el ecosistema Google elimina el paso de copiar-pegar entre herramientas. El contenido fluye de Docs a Slides a Sheets sin perder formato.

---

### Caso 2: Comunicación de crisis con Claude

**Contexto:** Una fintech en México descubre una vulnerabilidad de seguridad que expuso datos parciales de 2,000 usuarios. No hubo robo confirmado, pero deben comunicar el incidente a clientes, reguladores y prensa en las próximas 12 horas.

Este tipo de comunicación requiere un equilibrio delicado: transparencia sin alarmismo, empatía sin admisión de culpa legal, tecnicismo sin ser incomprensible.

**Prompt para Claude:**

> *"Redacta un comunicado para los clientes afectados por una vulnerabilidad de seguridad en una fintech mexicana. Datos clave: se detectó una vulnerabilidad que expuso nombres y correos electrónicos (no datos financieros) de 2,000 usuarios durante 72 horas. La vulnerabilidad ya fue corregida. No hay evidencia de acceso malicioso. El tono debe ser: transparente, empático, profesional, sin admitir negligencia legal. Incluye: qué pasó, qué datos se expusieron, qué hicimos, qué estamos haciendo, qué debe hacer el usuario."*

**Por qué Claude para crisis:** Los modelos de Anthropic tienden a ser más cuidadosos con el lenguaje legalmente sensible. Claude evita frases que podrían interpretarse como admisión de culpa ("cometimos un error") y las reemplaza con formulaciones más precisas ("identificamos y corregimos una vulnerabilidad"). Esto no reemplaza la revisión legal, pero produce un primer borrador más seguro.

---

### Técnica de revisión cruzada entre modelos

Una de las prácticas más efectivas para contenido de alta calidad es la **revisión cruzada**: generar con un modelo y revisar con otro.

**Flujo recomendado:**

1. **Genera** el borrador con el modelo más adecuado para el tipo de contenido
2. **Revisa** con un segundo modelo usando este prompt:

> *"Revisa el siguiente texto como si fueras un editor profesional. Identifica: (1) afirmaciones que podrían ser inexactas, (2) tono inconsistente, (3) secciones que suenan genéricas o "escritas por IA", (4) oportunidades de mejorar claridad. No reescribas — solo señala los problemas."*

3. **Ajusta** manualmente basándote en las observaciones
4. **Revisión humana final** — siempre

Esta técnica funciona porque cada modelo tiene sesgos distintos. Lo que un modelo pasa por alto, el otro lo detecta.

---

### Errores comunes en contenido generado por IA

| Error | Ejemplo | Cómo evitarlo |
|---|---|---|
| **Tono genérico** | "En el competitivo mundo empresarial de hoy..." | Incluir en el prompt: contexto específico, audiencia, tono deseado |
| **Datos inventados** | "Según un estudio de Harvard de 2023..." (que no existe) | Nunca usar datos citados por IA sin verificar la fuente original |
| **Voz inconsistente** | Un párrafo formal seguido de uno coloquial | Pedir al modelo que mantenga un tono específico y revisar coherencia |
| **Exceso de adjetivos** | "Esta innovadora y revolucionaria solución disruptiva..." | Pedir "tono directo, sin adjetivos innecesarios" en el prompt |
| **Falta de especificidad** | "Esto beneficiará a su organización de múltiples maneras" | Exigir datos concretos, ejemplos y beneficios cuantificables |

---

### Checklist de calidad para contenido generado con IA

Antes de enviar cualquier contenido generado o asistido por IA, verifica:

- [ ] **Hechos verificados:** Toda estadística, cita o referencia fue confirmada en la fuente original
- [ ] **Tono consistente:** El texto suena como tu organización, no como "un robot"
- [ ] **Sin relleno:** Cada párrafo agrega información nueva; no hay repetición disfrazada
- [ ] **Audiencia correcta:** El nivel de tecnicismo es apropiado para quien lo leerá
- [ ] **Llamado a la acción claro:** El lector sabe qué hacer después de leer
- [ ] **Revisión humana completa:** Alguien con conocimiento del tema lo leyó de principio a fin

> *"La IA es un excelente primer borrador. El error es tratarla como borrador final."* — Harvard Business Review, 2024

---

### Tu turno

<!-- exercise:ia-ex-05 -->

---

**Referencias:**

- Huang, M.H. & Rust, R.T. (2021). "A strategic framework for artificial intelligence in marketing." *Journal of the Academy of Marketing Science*, 49(1).
- Harvard Business Review (2024). "AI for Business Communication: Promises and Pitfalls."
- Anthropic (2025). *Claude Model Card and Evaluations*.
- Google (2025). *Gemini for Google Workspace: Enterprise Features*.$CONTENT$
WHERE id = '1a020200-0000-0000-0000-000000000001';

-- Lesson 6: IA como sparring estratégico
UPDATE lessons SET content = $CONTENT$## IA como sparring estratégico

### Tu mejor adversario no tiene ego

Los mejores estrategas no buscan validación — buscan que alguien desmonte sus ideas. En los equipos ejecutivos de alto rendimiento, esa función la cumple el "abogado del diablo": alguien que deliberadamente argumenta en contra de la propuesta para encontrar debilidades. El problema es que en la mayoría de las organizaciones, ese rol no existe o nadie quiere asumirlo.

La IA generativa no reemplaza al equipo estratégico, pero ofrece algo que pocos colegas pueden dar: **crítica sin política interna, disponibilidad inmediata y la capacidad de adoptar cualquier perspectiva que le pidas**. Davenport y Ronanki (2018) identificaron en Harvard Business Review que una de las aplicaciones más subvaloradas de la IA es precisamente esta: no como generadora de respuestas, sino como generadora de preguntas.

---

### Técnicas de sparring estratégico con IA

#### 1. Análisis FODA/SWOT asistido

El análisis FODA clásico funciona bien como framework, pero suele producir listas genéricas cuando lo hace un solo equipo con sus propios sesgos. La IA puede enriquecer cada cuadrante desde perspectivas que el equipo no consideró.

**Prompt efectivo:**

> *"Actúa como consultor estratégico para una empresa de logística de última milla en Argentina con 200 empleados. A partir de esta información [pegar contexto], genera un análisis FODA. Para cada punto, explica por qué lo clasificas ahí y qué evidencia lo soporta. Incluye al menos 2 amenazas que el equipo directivo probablemente no ha considerado."*

La instrucción final — "amenazas que probablemente no han considerado" — es la que genera valor real. Obliga al modelo a ir más allá de lo obvio.

#### 2. Planificación de escenarios

Pedir a la IA que construya 3 escenarios (optimista, base, pesimista) para una decisión estratégica, con supuestos explícitos para cada uno.

#### 3. Red teaming (argumentar en contra)

Pedir al modelo que actúe como un inversor escéptico, un competidor, o un regulador y argumente por qué tu plan va a fracasar.

#### 4. Pre-mortem

La técnica más poderosa. Desarrollada por Gary Klein (2007) y publicada en Harvard Business Review, consiste en imaginar que el proyecto ya fracasó y trabajar hacia atrás para identificar las causas.

---

### Caso: Pre-mortem de un lanzamiento de producto con Claude

**Contexto:** Una startup de foodtech en Chile va a lanzar un servicio de suscripción de comidas saludables para oficinas corporativas. El equipo está entusiasmado. Nadie ha cuestionado seriamente el plan.

**Prompt:**

> *"Imagina que es diciembre de 2026 y el servicio de suscripción de comidas saludables para oficinas corporativas que lanzamos en Chile fracasó completamente. La empresa perdió el 60% de su inversión inicial. Trabaja hacia atrás: genera 7 razones plausibles y específicas por las que fracasó. Para cada una, indica: (1) la causa raíz, (2) la señal de alerta temprana que ignoramos, y (3) qué podríamos haber hecho para prevenirlo. Sé brutal — necesito las críticas que mi equipo no se atreve a hacer."*

**Resultado típico de Claude:**

| Causa de fracaso | Señal ignorada | Prevención |
|---|---|---|
| Tasa de rotación de oficinas: las empresas cancelan cuando reducen personal | Tendencia de layoffs en sector tech Chile H2 2026 | Contratos mínimos de 6 meses con penalización |
| Logística de "última milla fría" subestimada: la cadena de frío para 50+ entregas diarias es 3x más costosa que la proyección | No se hizo piloto real de logística antes del lanzamiento | Piloto de 4 semanas con 10 oficinas antes de escalar |
| Competencia de apps de delivery con opción "saludable" a menor precio y sin suscripción | iFood y Rappi ya ofrecen filtros de comida saludable | Diferenciación clara: nutricionista dedicada, menú semanal personalizado |
| Desperdicio de alimentos superior al 20% por variabilidad de asistencia a oficinas | Datos de asistencia post-pandemia muestran 60-70%, no 90% | Modelo flexible basado en asistencia real, no en headcount |

Este tipo de análisis no reemplaza la investigación de mercado real. Pero en 10 minutos produce preguntas que le habrían tomado al equipo semanas descubrir — o que nunca habrían formulado por optimismo grupal.

---

### Caso: Análisis competitivo con DeepSeek

**Contexto:** Una cadena de farmacias en Centroamérica necesita analizar 15 competidores antes de definir su estrategia de expansión. El análisis requiere múltiples iteraciones.

**Por qué DeepSeek aquí:** El análisis competitivo iterativo implica muchas consultas sucesivas — refinar, pedir más detalle, explorar hipótesis. DeepSeek ofrece capacidad analítica competente a un costo significativamente menor que Claude o Gemini, lo que lo hace ideal para las fases exploratorias donde el volumen de interacción es alto y no necesitas máxima precisión en cada respuesta.

**Flujo recomendado:** Usa DeepSeek para las 10-15 iteraciones exploratorias. Cuando tengas las hipótesis consolidadas, pasa a Claude para el análisis final con mayor profundidad y matiz.

---

### Limitaciones críticas: lo que la IA NO puede hacer en estrategia

Esta es la sección más importante de esta lección. La IA como sparring estratégico tiene límites reales y peligrosos si no los reconoces.

**1. Alucinaciones en datos de mercado.** Los modelos pueden inventar estadísticas, participaciones de mercado, o datos de competidores con total confianza. Si Claude dice "el mercado de foodtech en Chile creció un 34% en 2025", verifica esa cifra. Puede ser real o completamente fabricada.

**2. Datos de entrenamiento desactualizados.** Los modelos tienen una fecha de corte en sus datos. No conocen tu mercado local en tiempo real, ni la última regulación de tu país, ni el movimiento reciente de tu competidor. Kaplan y Haenlein (2019) advierten que la IA es tan buena como los datos que la alimentan.

**3. Ausencia de contexto local.** Un modelo sabe que existe Perú, pero no conoce las dinámicas específicas de negociar con distribuidores en Arequipa vs. Lima. El contexto hiperlocal — relaciones, cultura organizacional, regulaciones municipales — es algo que solo tu equipo tiene.

**4. Sobreconfianza en las respuestas.** Los modelos generan texto con el mismo nivel de certeza independientemente de si están seguros o adivinando. No dicen "no sé" con la frecuencia que deberían. Esto es peligroso en contextos estratégicos donde la falsa precisión mata.

---

### Cómo mitigar las limitaciones

| Limitación | Mitigación práctica |
|---|---|
| Alucinaciones de datos | Usa IA para **estructura y preguntas**, no para datos fácticos. Toda cifra se verifica |
| Datos desactualizados | Alimenta al modelo con datos recientes: reportes, noticias, estados financieros públicos |
| Falta de contexto local | Incluye contexto relevante en cada prompt. La IA no adivina — necesita que le cuentes |
| Sobreconfianza | Pide explícitamente: "indica tu nivel de confianza en cada afirmación y señala donde estás especulando" |

---

### La ventaja humano + IA

La combinación óptima no es "IA decide" ni "humano decide solo". Es un ciclo:

1. **Humano** define la pregunta estratégica y aporta contexto real
2. **IA** genera estructura, escenarios, críticas y preguntas no consideradas
3. **Humano** evalúa, descarta lo irrelevante, verifica datos y aplica juicio
4. **IA** refina basándose en la retroalimentación humana
5. **Humano** toma la decisión final con mayor información y menos puntos ciegos

Davenport y Ronanki (2018) lo resumen así: la IA no toma mejores decisiones que los humanos — permite que los humanos tomen mejores decisiones al ampliar la superficie de lo que consideran.

---

### Tu turno

<!-- exercise:ia-ex-06 -->

---

**Referencias:**

- Kaplan, A. & Haenlein, M. (2019). "Siri, Siri, in my hand: Who's the fairest in the land?" *Business Horizons*, 62(1).
- Davenport, T.H. & Ronanki, R. (2018). "Artificial Intelligence for the Real World." *Harvard Business Review*, 96(1).
- Klein, G. (2007). "Performing a Project Premortem." *Harvard Business Review*, 85(9).
- Tetlock, P. & Gardner, D. (2015). *Superforecasting: The Art and Science of Prediction*. Crown.$CONTENT$
WHERE id = '1a020300-0000-0000-0000-000000000001';

COMMIT;
