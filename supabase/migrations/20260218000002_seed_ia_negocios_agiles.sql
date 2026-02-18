-- =====================================================
-- Seed: Curso "Inteligencia Artificial para Negocios Ágiles"
-- 3 módulos, 9 lecciones, 9 ejercicios (quizzes)
-- content_source = 'database' (contenido directo en DB)
-- =====================================================

-- 1. Insertar el curso
INSERT INTO courses (id, title, description, slug, thumbnail_url, is_published, content_source, content_status)
VALUES (
  '1a000000-0000-0000-0000-000000000001',
  'Inteligencia Artificial para Negocios Ágiles',
  'Aprende a usar Claude, Gemini y DeepSeek como herramientas prácticas para tu trabajo diario. Este curso desmitifica la IA generativa, te enseña a escribir prompts efectivos, y te muestra cómo aplicar estos modelos a análisis, comunicación y decisiones estratégicas. No requiere programación ni conocimientos técnicos previos.',
  'ia-negocios-agiles',
  '/images/courses/ia-negocios-agiles-hero.webp',
  true,
  'database',
  'published'
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  slug = EXCLUDED.slug,
  thumbnail_url = EXCLUDED.thumbnail_url,
  is_published = EXCLUDED.is_published,
  content_source = EXCLUDED.content_source,
  content_status = EXCLUDED.content_status;

-- 2. Insertar los módulos
INSERT INTO modules (id, course_id, title, description, order_index, is_locked)
VALUES
  (
    '1a010000-0000-0000-0000-000000000001',
    '1a000000-0000-0000-0000-000000000001',
    'Entendiendo la IA Generativa',
    'Desmitifica la inteligencia artificial generativa: qué es, qué no es y por qué importa. Conoce Claude, Gemini y DeepSeek y aprende a escribir prompts efectivos.',
    1,
    false
  ),
  (
    '1a020000-0000-0000-0000-000000000001',
    '1a000000-0000-0000-0000-000000000001',
    'IA Aplicada a Decisiones de Negocio',
    'Pasa de la teoría a la práctica: usa IA para analizar información, crear contenido profesional y pensar estratégicamente.',
    2,
    false
  ),
  (
    '1a030000-0000-0000-0000-000000000001',
    '1a000000-0000-0000-0000-000000000001',
    'Implementación Responsable',
    'Aplica todo lo aprendido a un caso real de PyME, gestiona riesgos éticos y diseña tu roadmap de adopción de 90 días.',
    3,
    false
  )
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  order_index = EXCLUDED.order_index;

-- 3. Insertar las lecciones con contenido completo en markdown
-- IMPORTANTE: order_index es GLOBAL para toda la navegación del curso

INSERT INTO lessons (id, course_id, module_id, title, content, lesson_type, order_index, duration_minutes, is_required)
VALUES
(
  '1a010100-0000-0000-0000-000000000001',
  '1a000000-0000-0000-0000-000000000001',
  '1a010000-0000-0000-0000-000000000001',
  'Qué es la IA generativa (y qué no es)',
  '## Qué es la IA generativa (y qué no es)

### La calculadora del pensamiento

Imagina que alguien te dice: "Tengo una herramienta que puede escribir un correo profesional, resumir un documento de 50 páginas y generar ideas para tu próxima campaña de marketing, todo en menos de un minuto." Suena a ciencia ficción, pero es exactamente lo que hace la IA generativa hoy.

Ahora imagina que esa misma persona agrega: "Ah, pero a veces inventa datos, no sabe sumar bien y puede darte información desactualizada con total confianza." Eso también es la IA generativa.

Entender ambas caras es fundamental antes de integrar estas herramientas en tu negocio. Piensa en la IA generativa como una **calculadora del pensamiento**: así como la calculadora amplificó nuestra capacidad de hacer operaciones numéricas pero no reemplazó la necesidad de entender matemáticas, los modelos de lenguaje amplifican nuestra capacidad de procesar y generar texto, pero no reemplazan el criterio profesional.

---

### Cómo funcionan los modelos de lenguaje (sin jerga técnica)

Los modelos de lenguaje grande (LLMs, por sus siglas en inglés) funcionan con un principio sorprendentemente simple: **predicen la siguiente palabra más probable en una secuencia**.

El proceso, simplificado:

1. **Entrenamiento**: El modelo lee cantidades masivas de texto — libros, artículos, código, conversaciones — y aprende patrones estadísticos sobre cómo se relacionan las palabras entre sí.
2. **Predicción**: Cuando le das un texto de entrada (un "prompt"), el modelo calcula la probabilidad de cada palabra posible que podría seguir y elige la más probable.
3. **Generación**: Repite este proceso palabra por palabra hasta completar una respuesta coherente.

> *Es como el autocompletado del celular, pero entrenado con casi todo el texto disponible en internet y con una capacidad de contexto de miles de palabras.*

Lo que es notable es que de este proceso mecánico de predicción estadística emergen capacidades que parecen "inteligentes": resumir, traducir, razonar, escribir código. Pero es crucial recordar que el modelo **no entiende** lo que dice — genera texto estadísticamente plausible.

---

### La evolución: de GPT a DeepSeek en cuatro años

La IA generativa evolucionó a una velocidad sin precedentes:

| Año | Hito | Importancia |
|---|---|---|
| 2017 | Google publica "Attention Is All You Need" | Nace la arquitectura Transformer, base de todos los LLMs actuales |
| 2020 | OpenAI lanza GPT-3 | Primer modelo que demuestra capacidades emergentes a gran escala |
| 2022 | OpenAI lanza ChatGPT | La IA generativa llega al público masivo (100M usuarios en 2 meses) |
| 2023 | Anthropic lanza Claude | Enfoque en seguridad y razonamiento extendido |
| 2023 | Google lanza Gemini | Capacidades multimodales (texto, imagen, video) desde el inicio |
| 2024 | DeepSeek publica modelos open source | China demuestra que se puede competir con modelos de código abierto a menor costo |

Para un profesional de negocios en Latinoamérica, esta evolución importa porque significa que **las opciones se multiplican y los costos bajan**. Ya no dependes de un solo proveedor estadounidense.

---

### Lo que la IA generativa puede hacer

Las capacidades reales y probadas incluyen:

- **Resumir**: Condensar un reporte trimestral de 30 páginas en un resumen ejecutivo de una página
- **Redactar**: Generar borradores de correos, propuestas, comunicados internos
- **Analizar texto**: Extraer temas principales de encuestas de satisfacción abiertas
- **Traducir**: No solo idiomas, sino registros (técnico a ejecutivo, formal a conversacional)
- **Lluvia de ideas**: Generar alternativas que no se te habrían ocurrido
- **Estructurar información**: Convertir notas desordenadas en tablas, agendas o planes

### Lo que la IA generativa NO puede hacer

Aquí es donde muchas empresas cometen errores costosos:

| Limitación | Explicación | Ejemplo de riesgo |
|---|---|---|
| **No accede a internet en tiempo real** | Su conocimiento tiene una fecha de corte | Preguntar por el tipo de cambio de hoy y recibir el de hace meses |
| **No hace matemáticas de forma confiable** | Predice texto, no calcula | Pedirle que sume una columna de 50 números y obtener un resultado aproximado |
| **No reemplaza experiencia de dominio** | No conoce tu industria específica ni tu contexto | Generar una estrategia fiscal sin conocer la legislación local de Panamá o Colombia |
| **No garantiza veracidad** | Genera texto plausible, no necesariamente verdadero | Citar una ley que suena real pero no existe |
| **No tiene memoria entre conversaciones** | Cada sesión empieza de cero (salvo configuraciones específicas) | Esperar que recuerde un proyecto discutido la semana pasada |

---

### El concepto clave: alucinaciones

Las **alucinaciones** son respuestas que el modelo genera con total confianza pero que son parcial o completamente falsas. No es un "error" en el sentido tradicional — es una consecuencia directa de cómo funciona: el modelo siempre produce la secuencia de texto más probable, incluso cuando no tiene información suficiente.

> *Un modelo de lenguaje nunca dice "no sé". Genera la respuesta más plausible, sea correcta o no. Tu trabajo es verificar.*

Esto tiene implicaciones directas para los negocios: cualquier dato, cifra, referencia legal o técnica generada por IA **debe verificarse** antes de usarse en decisiones reales. La IA generativa es excelente como punto de partida, pero peligrosa como punto final.

---

### Tu turno

<!-- exercise:ia-ex-01 -->

---

**Referencias:**

- Vaswani, A. et al. (2017). "Attention Is All You Need." *Advances in Neural Information Processing Systems*.
- OpenAI (2023). "GPT-4 Technical Report."
- Anthropic (2024). "The Claude Model Family."
- Bubeck, S. et al. (2023). "Sparks of Artificial General Intelligence: Early experiments with GPT-4." *arXiv:2303.12712*.
- Ji, Z. et al. (2023). "Survey of Hallucination in Natural Language Generation." *ACM Computing Surveys*.
',
  'text',
  1,
  20,
  true
),

-- ─────────────────────────────────────────────────────────────────────
-- MÓDULO 1, LECCIÓN 2: Los tres modelos que debes conocer
-- ─────────────────────────────────────────────────────────────────────
(
  '1a010200-0000-0000-0000-000000000001',
  '1a000000-0000-0000-0000-000000000001',
  '1a010000-0000-0000-0000-000000000001',
  'Los tres modelos que debes conocer',
  '## Los tres modelos que debes conocer

### No existe el "mejor modelo"

Si alguien te dice "este es el mejor modelo de IA", desconfía. Es como preguntar cuál es la mejor herramienta: depende completamente de lo que necesitas hacer. Un martillo es perfecto para clavar, inútil para cortar.

En el ecosistema actual de IA generativa hay decenas de modelos, pero tres destacan por su relevancia para profesionales de negocios en Latinoamérica: **Claude** (Anthropic), **Gemini** (Google) y **DeepSeek** (DeepSeek-AI, China). Cada uno tiene fortalezas distintas, y saber cuándo usar cuál te dará una ventaja competitiva real.

---

### Claude (Anthropic)

Anthropic fue fundada en 2021 por ex investigadores de OpenAI con un enfoque explícito en seguridad y alineación. Su modelo Claude se ha posicionado como la opción preferida para tareas que requieren **razonamiento profundo y análisis de documentos extensos**.

**Fortalezas clave:**

- **Ventana de contexto de 200K tokens**: Puede procesar documentos de más de 500 páginas en una sola conversación. Ideal para analizar contratos, reportes anuales o manuales completos.
- **Razonamiento extendido**: Sobresale en tareas que requieren pensar paso a paso — análisis financiero, evaluación de riesgos, comparación de opciones.
- **Escritura matizada**: Produce texto con tono natural, distingue registros (formal, conversacional, técnico) y sigue instrucciones complejas de formato.
- **Directrices éticas**: Diseñado para ser honesto sobre sus limitaciones y evitar generar contenido dañino.

**Ejemplo de uso en LATAM:** Una consultora en Bogotá necesita analizar un contrato de concesión de 180 páginas y generar un resumen ejecutivo con los 10 riesgos principales. Claude puede procesar el documento completo y producir un análisis estructurado en minutos.

---

### Gemini (Google)

Gemini es el modelo insignia de Google, diseñado desde cero para ser **multimodal** — es decir, trabaja nativamente con texto, imágenes, audio y video, no solo texto.

**Fortalezas clave:**

- **Capacidades multimodales**: Puede analizar gráficos, fotos de productos, capturas de pantalla y videos directamente. No necesitas describir la imagen — la "ve".
- **Integración con Google Workspace**: Funciona dentro de Gmail, Docs, Sheets y Slides, lo que reduce la fricción de adopción para equipos que ya usan estas herramientas.
- **Acceso a información actualizada**: A través de Google Search, puede complementar sus respuestas con datos recientes.
- **Buena relación costo-rendimiento**: Los modelos Gemini Flash ofrecen velocidad y bajo costo para tareas rutinarias.

**Ejemplo de uso en LATAM:** Un equipo de marketing en Ciudad de México quiere analizar las publicaciones de Instagram de tres competidores. Gemini puede recibir capturas de pantalla de los posts, identificar patrones visuales, analizar el tono del copy y generar un reporte comparativo con recomendaciones.

---

### DeepSeek (China, open source)

DeepSeek irrumpió en 2024 demostrando que modelos de código abierto pueden competir en calidad con los modelos propietarios, a una fracción del costo.

**Fortalezas clave:**

- **Código abierto y auto-hospedable**: Puedes correr el modelo en tus propios servidores. Los datos nunca salen de tu infraestructura.
- **Privacidad de datos**: Para industrias reguladas (salud, finanzas, legal) donde enviar datos a servidores externos es un problema de cumplimiento normativo.
- **Costo significativamente menor**: Al ser open source, el costo de uso es principalmente infraestructura propia, sin tarifas por token.
- **Calidad competitiva**: Los benchmarks muestran rendimiento comparable a modelos propietarios en muchas tareas.

**Ejemplo de uso en LATAM:** Un banco en Panamá necesita automatizar el análisis de solicitudes de crédito, pero regulaciones locales prohíben enviar datos financieros de clientes a servidores en Estados Unidos. DeepSeek puede desplegarse en la infraestructura del banco, cumpliendo con las normativas de protección de datos.

---

### Tabla comparativa detallada

| Criterio | Claude (Anthropic) | Gemini (Google) | DeepSeek (open source) |
|---|---|---|---|
| **Mejor para** | Análisis de documentos largos, razonamiento complejo, redacción ejecutiva | Tareas visuales, integración con Workspace, búsqueda actualizada | Datos sensibles, auto-hospedaje, costos bajos |
| **Contexto máximo** | 200K tokens (~500 páginas) | 1M tokens (Gemini 1.5 Pro) | 128K tokens (~320 páginas) |
| **Multimodal** | Texto e imágenes | Texto, imágenes, audio, video | Texto e imágenes |
| **Privacidad** | Datos en servidores de Anthropic (EE.UU.) | Datos en servidores de Google (EE.UU.) | Auto-hospedable, datos en tu infraestructura |
| **Costo aproximado** | ~$15 USD / 1M tokens (salida, modelo premium) | ~$7 USD / 1M tokens (Pro); Flash mucho menor | Gratis (open source) + costo de infraestructura |
| **Debilidad principal** | No tiene acceso a internet en tiempo real | Calidad variable en razonamiento largo | Requiere infraestructura técnica para desplegar |
| **Ideal para** | Consultores, abogados, analistas | Equipos de marketing, operaciones, ventas | Banca, salud, gobierno, empresas con datos regulados |

---

### La regla de oro: combinar modelos

Los profesionales más efectivos no eligen un solo modelo — usan el correcto para cada tarea:

> *Usa Claude para pensar, Gemini para ver y DeepSeek para lo que no puede salir de tu oficina.*

Un flujo de trabajo práctico podría ser:

1. **Gemini** para hacer investigación rápida con datos actualizados y analizar contenido visual
2. **Claude** para sintetizar toda esa información en un análisis profundo con recomendaciones
3. **DeepSeek** para procesar datos internos sensibles que no pueden enviarse a servidores externos

No se trata de lealtad a una marca. Se trata de usar la herramienta correcta para el problema correcto. A lo largo de este curso, trabajarás con diferentes modelos para que desarrolles criterio propio sobre cuándo usar cada uno.

---

### Tu turno

<!-- exercise:ia-ex-02 -->

---

**Referencias:**

- Anthropic (2024). "The Claude Model Family: Claude 3 Opus, Sonnet, and Haiku."
- Google DeepMind (2024). "Gemini 1.5: Unlocking multimodal understanding across millions of tokens of context."
- DeepSeek-AI (2024). "DeepSeek-V2: A Strong, Economical, and Efficient Mixture-of-Experts Language Model."
- Artificial Analysis (2025). "LLM Leaderboard & Pricing Comparison." artificialanalysis.ai.
- Chiang, W. et al. (2024). "Chatbot Arena: An Open Platform for Evaluating LLMs by Human Preference." *arXiv:2403.04132*.
',
  'text',
  2,
  20,
  true
),

-- ─────────────────────────────────────────────────────────────────────
-- MÓDULO 1, LECCIÓN 3: Anatomía de un buen prompt
-- ─────────────────────────────────────────────────────────────────────
(
  '1a010300-0000-0000-0000-000000000001',
  '1a000000-0000-0000-0000-000000000001',
  '1a010000-0000-0000-0000-000000000001',
  'Anatomía de un buen prompt',
  '## Anatomía de un buen prompt

### Por qué el prompt importa más que el modelo

Aquí va una verdad incómoda: la mayoría de las personas que dicen "la IA no me sirvió" simplemente escribieron un mal prompt. Es como quejarse de que Google no funciona porque buscaste "esa cosa que vi ayer".

La calidad de la respuesta de un modelo de lenguaje depende directamente de la calidad de la instrucción que le das. Un prompt mediocre con el mejor modelo del mundo produce resultados mediocres. Un prompt bien estructurado con un modelo básico puede sorprenderte.

La buena noticia: escribir buenos prompts no es arte ni magia. Es una habilidad con estructura, y la puedes aprender hoy.

---

### La fórmula: Rol + Contexto + Tarea + Formato

Todo prompt efectivo tiene cuatro componentes. No siempre necesitas los cuatro, pero mientras más incluyas, mejor será la respuesta.

| Componente | Qué hace | Ejemplo |
|---|---|---|
| **Rol** | Define desde qué perspectiva debe responder el modelo | "Eres un consultor financiero con experiencia en PYMES latinoamericanas" |
| **Contexto** | Proporciona la información de fondo necesaria | "Nuestra empresa tiene 45 empleados, opera en 3 países y factura $2M anuales" |
| **Tarea** | Especifica exactamente qué quieres que haga | "Analiza estos datos de ventas e identifica los 3 productos con mayor margen" |
| **Formato** | Indica cómo quieres la respuesta | "Presenta los resultados en una tabla con columnas: producto, margen, recomendación" |

> *Sin Rol, el modelo responde como un asistente genérico. Sin Contexto, adivina tu situación. Sin Tarea clara, divaga. Sin Formato, elige uno que probablemente no es el que necesitas.*

---

### Zero-shot vs. few-shot: dos estrategias fundamentales

**Zero-shot** significa pedirle algo al modelo sin darle ejemplos. Simplemente describes lo que quieres:

```
Clasifica el siguiente comentario de cliente como positivo, negativo o neutro:
"El producto llegó rápido pero el empaque estaba dañado"
```

**Few-shot** significa incluir ejemplos de lo que esperas antes de la tarea real:

```
Clasifica los siguientes comentarios de clientes:

Comentario: "Excelente servicio, todo perfecto"
Clasificación: Positivo

Comentario: "No vuelvo a comprar aquí"
Clasificación: Negativo

Comentario: "El producto llegó rápido pero el empaque estaba dañado"
Clasificación:
```

El enfoque few-shot casi siempre produce mejores resultados porque el modelo entiende exactamente el formato y criterio que esperas. Úsalo cuando la precisión importa.

---

### Tres prompts de negocio: antes y después

**Ejemplo 1: Resumir un reporte trimestral**

| | Prompt |
|---|---|
| **Malo** | "Resume este reporte" |
| **Bueno** | "Eres el CFO preparando una presentación para el directorio. Resume este reporte trimestral en máximo 5 bullets, enfocándote en: ingresos vs. meta, principales desviaciones y una recomendación accionable. Usa lenguaje ejecutivo, sin jerga contable." |

**Ejemplo 2: Redactar un correo a un cliente difícil**

| | Prompt |
|---|---|
| **Malo** | "Escribe un correo para un cliente enojado" |
| **Bueno** | "Eres el gerente de atención al cliente de una empresa de logística en Lima. Un cliente corporativo (representa el 8% de nuestra facturación) está molesto porque el último envío llegó 5 días tarde. Redacta un correo que: (1) reconozca el problema sin excusas, (2) explique la causa raíz (retraso aduanero), (3) ofrezca una compensación concreta y (4) proponga una medida preventiva. Tono: profesional, empático, no servil. Máximo 200 palabras." |

**Ejemplo 3: Analizar competencia**

| | Prompt |
|---|---|
| **Malo** | "Analiza a mi competencia" |
| **Bueno** | "Eres un estratega de negocios especializado en retail de moda en Centroamérica. Basándote en la siguiente información sobre 3 competidores [pegar datos], crea una tabla comparativa con: propuesta de valor, rango de precios, canales de venta, presencia digital y debilidad principal. Al final, identifica un espacio de mercado desatendido que nuestra marca podría aprovechar." |

---

### Los 5 errores más comunes

| Error | Por qué falla | Cómo corregirlo |
|---|---|---|
| **Demasiado vago** | "Ayúdame con marketing" no le dice nada útil al modelo | Especifica industria, audiencia, canal, objetivo y restricciones |
| **Demasiado largo sin estructura** | Un párrafo de 500 palabras sin organización confunde al modelo | Usa listas numeradas, separa rol/contexto/tarea/formato |
| **No especificar formato** | El modelo elige un formato que probablemente no necesitas | Pide explícitamente: tabla, bullets, párrafo corto, JSON, etc. |
| **Tratar la IA como buscador** | "¿Cuál es el PIB de Colombia?" es mejor en Google | Usa la IA para analizar, sintetizar y crear — no para buscar datos puntuales |
| **Abandonar al primer resultado malo** | Un mal output no significa que la herramienta no sirve | Refina el prompt: agrega contexto, cambia el rol, da ejemplos |

---

### El arte de iterar

Si la primera respuesta no es lo que esperabas, **no empieces de cero**. Itera sobre el prompt:

1. **Demasiado genérico** --> Agrega contexto específico de tu industria o situación
2. **Formato incorrecto** --> Especifica exactamente cómo quieres la salida
3. **Tono inadecuado** --> Define el tono: "ejecutivo", "técnico", "conversacional", "persuasivo"
4. **Falta profundidad** --> Pide que "explique su razonamiento paso a paso" (esto se llama Chain-of-Thought)
5. **Demasiado largo** --> Establece límites: "máximo 3 párrafos" o "responde en 100 palabras"

> *Un buen prompt rara vez sale perfecto a la primera. Los profesionales más efectivos con IA no escriben mejores prompts iniciales — iteran más rápido.*

La próxima vez que obtengas una respuesta insatisfactoria, antes de culpar al modelo, revisa tu prompt con esta lista. En la mayoría de los casos, el problema está en la instrucción, no en la herramienta.

---

### Tu turno

<!-- exercise:ia-ex-03 -->

---

**Referencias:**

- OpenAI (2023). "Prompt Engineering Guide." platform.openai.com/docs/guides/prompt-engineering.
- White, J. et al. (2023). "A Prompt Pattern Catalog to Enhance Prompt Engineering with ChatGPT." *arXiv:2302.11382*.
- Wei, J. et al. (2022). "Chain-of-Thought Prompting Elicits Reasoning in Large Language Models." *arXiv:2201.11903*.
- Anthropic (2024). "Prompt Engineering Guide." docs.anthropic.com.
- Zamfirescu-Pereira, J.D. et al. (2023). "Why Johnny Can''t Prompt." *Proceedings of CHI 2023*.
',
  'text',
  3,
  15,
  true
),

-- ─────────────────────────────────────────────────────────────────────
-- MÓDULO 2, LECCIÓN 4: IA para análisis y síntesis
-- ─────────────────────────────────────────────────────────────────────
(
  '1a020100-0000-0000-0000-000000000001',
  '1a000000-0000-0000-0000-000000000001',
  '1a020000-0000-0000-0000-000000000001',
  'IA para análisis y síntesis',
  '## IA para analisis y sintesis

### De 500 encuestas a 5 insights en 20 minutos

Imagina este escenario: tu empresa acaba de recibir los resultados de su encuesta anual de satisfaccion del cliente. Son 500 respuestas abiertas. Alguien tiene que leerlas, categorizarlas, identificar patrones y producir un resumen ejecutivo. Con un analista dedicado, eso toma entre 2 y 4 semanas. Con IA generativa, toma una tarde.

No estamos hablando de magia. Estamos hablando de lo que los modelos de lenguaje hacen mejor que cualquier otra tarea: **procesar, clasificar y sintetizar grandes volumenes de texto no estructurado**. Brynjolfsson y McAfee (2017) anticiparon este cambio en *Machine, Platform, Crowd*: las tareas que combinan lectura intensiva con clasificacion son exactamente donde la IA complementa mejor al ser humano.

La clave esta en saber que tipo de analisis necesitas y cual modelo usar.

---

### Tipos de analisis cualitativo con IA

No todo analisis es igual. Cada tipo requiere un enfoque distinto y algunos modelos lo manejan mejor que otros.

| Tipo de analisis | Descripcion | Modelo recomendado | Por que |
|---|---|---|---|
| **Categorizacion tematica** | Agrupar textos por tema (quejas, sugerencias, elogios) | Claude | Matices en lenguaje ambiguo, mejor comprension de contexto |
| **Extraccion de sentimiento** | Determinar si un texto es positivo, negativo o neutro | Claude / Gemini | Ambos competentes; Claude maneja mejor sarcasmo e ironia |
| **Resumen de documentos largos** | Condensar reportes de 50+ paginas en puntos clave | Claude | Ventana de contexto amplia, fidelidad al texto original |
| **Analisis de encuestas con imagenes** | Procesar formularios escaneados o escritos a mano | Gemini | Capacidad multimodal nativa para interpretar imagenes |
| **Identificacion de patrones** | Encontrar temas recurrentes en cientos de textos | Claude | Consistencia en categorizacion a lo largo de multiples pasadas |
| **Extraccion de datos estructurados** | Convertir texto libre en tablas o JSON | DeepSeek / Claude | DeepSeek competitivo a menor costo para tareas repetitivas |

---

### Caso detallado: 500 encuestas de satisfaccion

**Contexto:** Una distribuidora de productos de consumo en Colombia recibe 500 respuestas abiertas de su encuesta trimestral de satisfaccion. El equipo de experiencia del cliente necesita un informe para la junta directiva en 5 dias.

**Paso 1: Preparar los datos.** Exporta las respuestas a un archivo de texto plano o CSV. Si son mas de lo que cabe en una sola ventana de contexto, dividelas en lotes de 50-100.

**Paso 2: Categorizacion tematica.** Usa este prompt con Claude:

> *"Analiza las siguientes 100 respuestas de una encuesta de satisfaccion del cliente de una distribuidora de productos de consumo en Colombia. Para cada respuesta, asigna: (1) una categoria tematica (maximo 8 categorias), (2) un sentimiento (positivo, negativo, neutro, mixto), y (3) extrae la queja o elogio especifico si existe. Devuelve el resultado en formato de tabla."*

**Paso 3: Consolidacion.** Despues de procesar los 5 lotes, pide al modelo que consolide:

> *"Aqui estan los resultados de categorizacion de 5 lotes de encuestas (500 respuestas totales). Consolida los resultados: identifica las 5 categorias mas frecuentes, el sentimiento general por categoria, y los 3 problemas mas urgentes con ejemplos textuales directos de los encuestados."*

**Resultado tipico:** El modelo identifica que el 34% de las quejas se concentran en tiempos de entrega, el 22% en errores de facturacion, y el 18% en falta de comunicacion proactiva cuando hay retrasos. Tres insights accionables que habrian tomado semanas en emerger de un analisis manual.

---

### Claude vs. Gemini: diferencias practicas en analisis

No todos los modelos analizan texto de la misma manera. En pruebas comparativas (MIT Sloan, 2024), las diferencias se manifiestan en matices:

**Claude** tiende a ser mas conservador en sus categorizaciones. Si una respuesta es ambigua ("el servicio esta bien, pero podria mejorar"), Claude la clasificara como "mixta" y explicara la ambiguedad. Esto es valioso cuando necesitas precision.

**Gemini** es mas agresivo clasificando y tiene la ventaja de procesar imagenes. Si tus encuestas incluyen formularios escaneados, fotos de comentarios escritos a mano, o capturas de pantalla de chats de WhatsApp, Gemini puede interpretarlos directamente. Claude necesita que primero transcribas el texto.

**Recomendacion practica:** Si tus datos son texto puro, usa Claude. Si incluyen imagenes o documentos escaneados, usa Gemini para la extraccion inicial y luego Claude para el analisis profundo.

---

### Buenas practicas para analisis con IA

1. **Fragmenta documentos largos.** Los modelos procesan mejor textos en segmentos de 2,000-5,000 palabras que un documento completo de 50 paginas. La calidad del analisis se degrada con inputs muy extensos.

2. **Verifica contra la fuente.** Nunca presentes un resumen de IA sin cruzarlo con el documento original. Los modelos pueden omitir matices importantes o dar peso desproporcionado a ciertos temas.

3. **Usa prompts de extraccion especificos.** "Resume este documento" produce resultados genericos. "Extrae las 5 conclusiones principales, los 3 riesgos mencionados y cualquier dato cuantitativo citado" produce resultados utiles.

4. **Pide formato estructurado.** Solicitar tablas, listas numeradas o JSON facilita la verificacion y reduce la probabilidad de que el modelo "invente" conexiones narrativas.

5. **Haz multiples pasadas.** Pasa el mismo texto dos veces con angulos diferentes: primero para temas, luego para sentimiento, luego para datos cuantitativos. Cada pasada enfocada supera a una pasada generica.

> *"La IA no reemplaza el analisis critico — acelera la parte mecanica para que el humano pueda dedicar su tiempo a la interpretacion y la decision."* — MIT Sloan Management Review, 2024

---

### Tu turno

<!-- exercise:ia-ex-04 -->

---

**Referencias:**

- Brynjolfsson, E. & McAfee, A. (2017). *Machine, Platform, Crowd: Harnessing Our Digital Future*. W.W. Norton.
- MIT Sloan Management Review (2024). "AI in Business Analytics: From Automation to Augmentation."
- Anthropic (2025). *Claude Model Card and Evaluations*.
- Google DeepMind (2025). *Gemini Technical Report*.
',
  'text',
  4,
  20,
  true
),

-- ─────────────────────────────────────────────────────────────────────
-- MÓDULO 2, LECCIÓN 5: IA para contenido y comunicación
-- ─────────────────────────────────────────────────────────────────────
(
  '1a020200-0000-0000-0000-000000000001',
  '1a000000-0000-0000-0000-000000000001',
  '1a020000-0000-0000-0000-000000000001',
  'IA para contenido y comunicación',
  '## IA para contenido y comunicacion

### El profesional que escribe el doble en la mitad del tiempo

Toda organizacion produce contenido constantemente: correos, propuestas comerciales, presentaciones, comunicados internos, publicaciones en redes sociales, minutas de reuniones. Huang y Rust (2021) estiman que los profesionales dedican entre el 25% y el 40% de su jornada laboral a tareas de comunicacion escrita.

La IA generativa no te convierte en mejor escritor. Te convierte en un escritor mas rapido que puede dedicar mas tiempo a la revision y la estrategia. La diferencia entre contenido profesional y contenido mediocre generado por IA esta en como lo supervisas, no en como lo generas.

---

### Tipos de contenido profesional y modelo recomendado

| Tipo de contenido | Complejidad | Modelo sugerido | Razon |
|---|---|---|---|
| **Correos profesionales** | Baja | Cualquiera | Tarea estandar; la diferencia es minima entre modelos |
| **Propuestas comerciales** | Alta | Gemini + Google Workspace | Integracion nativa con Slides y Docs para formato final |
| **Comunicaciones de crisis** | Muy alta | Claude | Manejo de tono, empatia y sensibilidad legal |
| **Posts de redes sociales** | Media | Claude / Gemini | Depende de si necesitas imagenes (Gemini) o solo texto (Claude) |
| **Reportes ejecutivos** | Alta | Claude | Sintesis precisa, estructura clara, fidelidad a datos |
| **Comunicados internos** | Media | Cualquiera | Verificar tono institucional y consistencia con comunicaciones previas |

---

### Caso 1: Propuesta comercial con Gemini + Google Workspace

**Contexto:** Una consultora de recursos humanos en Peru necesita preparar una propuesta comercial para un cliente potencial del sector minero. Tiene 48 horas.

**Paso 1: Estructura con Gemini.** Usa Gemini en Google Docs para generar la estructura base:

> *"Crea la estructura de una propuesta comercial de consultoria en recursos humanos para una empresa minera en Peru. El proyecto es un diagnostico de clima laboral para 1,200 empleados en 3 sedes. Incluye: resumen ejecutivo, contexto del sector, metodologia propuesta, cronograma, equipo consultor e inversion estimada."*

**Paso 2: Desarrollo en Google Docs.** Gemini dentro de Docs permite expandir cada seccion manteniendo formato, generar tablas de cronograma y ajustar el tono al sector minero (formal, tecnico, orientado a resultados de seguridad y productividad).

**Paso 3: Presentacion en Google Slides.** Exporta los puntos clave a Slides. Gemini genera diapositivas con la estructura visual, que luego ajustas con la marca de tu empresa.

**Ventaja de Gemini aqui:** La integracion con el ecosistema Google elimina el paso de copiar-pegar entre herramientas. El contenido fluye de Docs a Slides a Sheets sin perder formato.

---

### Caso 2: Comunicacion de crisis con Claude

**Contexto:** Una fintech en Mexico descubre una vulnerabilidad de seguridad que expuso datos parciales de 2,000 usuarios. No hubo robo confirmado, pero deben comunicar el incidente a clientes, reguladores y prensa en las proximas 12 horas.

Este tipo de comunicacion requiere un equilibrio delicado: transparencia sin alarmismo, empatia sin admision de culpa legal, tecnicismo sin ser incomprensible.

**Prompt para Claude:**

> *"Redacta un comunicado para los clientes afectados por una vulnerabilidad de seguridad en una fintech mexicana. Datos clave: se detecto una vulnerabilidad que expuso nombres y correos electronicos (no datos financieros) de 2,000 usuarios durante 72 horas. La vulnerabilidad ya fue corregida. No hay evidencia de acceso malicioso. El tono debe ser: transparente, empatico, profesional, sin admitir negligencia legal. Incluye: que paso, que datos se expusieron, que hicimos, que estamos haciendo, que debe hacer el usuario."*

**Por que Claude para crisis:** Los modelos de Anthropic tienden a ser mas cuidadosos con el lenguaje legalmente sensible. Claude evita frases que podrian interpretarse como admision de culpa ("cometimos un error") y las reemplaza con formulaciones mas precisas ("identificamos y corregimos una vulnerabilidad"). Esto no reemplaza la revision legal, pero produce un primer borrador mas seguro.

---

### Tecnica de revision cruzada entre modelos

Una de las practicas mas efectivas para contenido de alta calidad es la **revision cruzada**: generar con un modelo y revisar con otro.

**Flujo recomendado:**

1. **Genera** el borrador con el modelo mas adecuado para el tipo de contenido
2. **Revisa** con un segundo modelo usando este prompt:

> *"Revisa el siguiente texto como si fueras un editor profesional. Identifica: (1) afirmaciones que podrian ser inexactas, (2) tono inconsistente, (3) secciones que suenan genericas o "escritas por IA", (4) oportunidades de mejorar claridad. No reescribas — solo senala los problemas."*

3. **Ajusta** manualmente basandote en las observaciones
4. **Revision humana final** — siempre

Esta tecnica funciona porque cada modelo tiene sesgos distintos. Lo que un modelo pasa por alto, el otro lo detecta.

---

### Errores comunes en contenido generado por IA

| Error | Ejemplo | Como evitarlo |
|---|---|---|
| **Tono generico** | "En el competitivo mundo empresarial de hoy..." | Incluir en el prompt: contexto especifico, audiencia, tono deseado |
| **Datos inventados** | "Segun un estudio de Harvard de 2023..." (que no existe) | Nunca usar datos citados por IA sin verificar la fuente original |
| **Voz inconsistente** | Un parrafo formal seguido de uno coloquial | Pedir al modelo que mantenga un tono especifico y revisar coherencia |
| **Exceso de adjetivos** | "Esta innovadora y revolucionaria solucion disruptiva..." | Pedir "tono directo, sin adjetivos innecesarios" en el prompt |
| **Falta de especificidad** | "Esto beneficiara a su organizacion de multiples maneras" | Exigir datos concretos, ejemplos y beneficios cuantificables |

---

### Checklist de calidad para contenido generado con IA

Antes de enviar cualquier contenido generado o asistido por IA, verifica:

- [ ] **Hechos verificados:** Toda estadistica, cita o referencia fue confirmada en la fuente original
- [ ] **Tono consistente:** El texto suena como tu organizacion, no como "un robot"
- [ ] **Sin relleno:** Cada parrafo agrega informacion nueva; no hay repeticion disfrazada
- [ ] **Audiencia correcta:** El nivel de tecnicismo es apropiado para quien lo leera
- [ ] **Llamado a la accion claro:** El lector sabe que hacer despues de leer
- [ ] **Revision humana completa:** Alguien con conocimiento del tema lo leyo de principio a fin

> *"La IA es un excelente primer borrador. El error es tratarla como borrador final."* — Harvard Business Review, 2024

---

### Tu turno

<!-- exercise:ia-ex-05 -->

---

**Referencias:**

- Huang, M.H. & Rust, R.T. (2021). "A strategic framework for artificial intelligence in marketing." *Journal of the Academy of Marketing Science*, 49(1).
- Harvard Business Review (2024). "AI for Business Communication: Promises and Pitfalls."
- Anthropic (2025). *Claude Model Card and Evaluations*.
- Google (2025). *Gemini for Google Workspace: Enterprise Features*.
',
  'text',
  5,
  20,
  true
),

-- ─────────────────────────────────────────────────────────────────────
-- MÓDULO 2, LECCIÓN 6: IA como sparring estratégico
-- ─────────────────────────────────────────────────────────────────────
(
  '1a020300-0000-0000-0000-000000000001',
  '1a000000-0000-0000-0000-000000000001',
  '1a020000-0000-0000-0000-000000000001',
  'IA como sparring estratégico',
  '## IA como sparring estrategico

### Tu mejor adversario no tiene ego

Los mejores estrategas no buscan validacion — buscan que alguien desmonte sus ideas. En los equipos ejecutivos de alto rendimiento, esa funcion la cumple el "abogado del diablo": alguien que deliberadamente argumenta en contra de la propuesta para encontrar debilidades. El problema es que en la mayoria de las organizaciones, ese rol no existe o nadie quiere asumirlo.

La IA generativa no reemplaza al equipo estrategico, pero ofrece algo que pocos colegas pueden dar: **critica sin politica interna, disponibilidad inmediata y la capacidad de adoptar cualquier perspectiva que le pidas**. Davenport y Ronanki (2018) identificaron en Harvard Business Review que una de las aplicaciones mas subvaloradas de la IA es precisamente esta: no como generadora de respuestas, sino como generadora de preguntas.

---

### Tecnicas de sparring estrategico con IA

#### 1. Analisis FODA/SWOT asistido

El analisis FODA clasico funciona bien como framework, pero suele producir listas genericas cuando lo hace un solo equipo con sus propios sesgos. La IA puede enriquecer cada cuadrante desde perspectivas que el equipo no considero.

**Prompt efectivo:**

> *"Actua como consultor estrategico para una empresa de logistica de ultima milla en Argentina con 200 empleados. A partir de esta informacion [pegar contexto], genera un analisis FODA. Para cada punto, explica por que lo clasificas ahi y que evidencia lo soporta. Incluye al menos 2 amenazas que el equipo directivo probablemente no ha considerado."*

La instruccion final — "amenazas que probablemente no han considerado" — es la que genera valor real. Obliga al modelo a ir mas alla de lo obvio.

#### 2. Planificacion de escenarios

Pedir a la IA que construya 3 escenarios (optimista, base, pesimista) para una decision estrategica, con supuestos explicitos para cada uno.

#### 3. Red teaming (argumentar en contra)

Pedir al modelo que actue como un inversor esceptico, un competidor, o un regulador y argumente por que tu plan va a fracasar.

#### 4. Pre-mortem

La tecnica mas poderosa. Desarrollada por Gary Klein (2007) y publicada en Harvard Business Review, consiste en imaginar que el proyecto ya fracaso y trabajar hacia atras para identificar las causas.

---

### Caso: Pre-mortem de un lanzamiento de producto con Claude

**Contexto:** Una startup de foodtech en Chile va a lanzar un servicio de suscripcion de comidas saludables para oficinas corporativas. El equipo esta entusiasmado. Nadie ha cuestionado seriamente el plan.

**Prompt:**

> *"Imagina que es diciembre de 2026 y el servicio de suscripcion de comidas saludables para oficinas corporativas que lanzamos en Chile fracaso completamente. La empresa perdio el 60% de su inversion inicial. Trabaja hacia atras: genera 7 razones plausibles y especificas por las que fracaso. Para cada una, indica: (1) la causa raiz, (2) la senal de alerta temprana que ignoramos, y (3) que podriamos haber hecho para prevenirlo. Se brutal — necesito las criticas que mi equipo no se atreve a hacer."*

**Resultado tipico de Claude:**

| Causa de fracaso | Senal ignorada | Prevencion |
|---|---|---|
| Tasa de rotacion de oficinas: las empresas cancelan cuando reducen personal | Tendencia de layoffs en sector tech Chile H2 2026 | Contratos minimos de 6 meses con penalizacion |
| Logistica de "ultima milla fria" subestimada: la cadena de frio para 50+ entregas diarias es 3x mas costosa que la proyeccion | No se hizo piloto real de logistica antes del lanzamiento | Piloto de 4 semanas con 10 oficinas antes de escalar |
| Competencia de apps de delivery con opcion "saludable" a menor precio y sin suscripcion | iFood y Rappi ya ofrecen filtros de comida saludable | Diferenciacion clara: nutricionista dedicada, menu semanal personalizado |
| Desperdicio de alimentos superior al 20% por variabilidad de asistencia a oficinas | Datos de asistencia post-pandemia muestran 60-70%, no 90% | Modelo flexible basado en asistencia real, no en headcount |

Este tipo de analisis no reemplaza la investigacion de mercado real. Pero en 10 minutos produce preguntas que le habrian tomado al equipo semanas descubrir — o que nunca habrian formulado por optimismo grupal.

---

### Caso: Analisis competitivo con DeepSeek

**Contexto:** Una cadena de farmacias en Centroamerica necesita analizar 15 competidores antes de definir su estrategia de expansion. El analisis requiere multiples iteraciones.

**Por que DeepSeek aqui:** El analisis competitivo iterativo implica muchas consultas sucesivas — refinar, pedir mas detalle, explorar hipotesis. DeepSeek ofrece capacidad analitica competente a un costo significativamente menor que Claude o Gemini, lo que lo hace ideal para las fases exploratorias donde el volumen de interaccion es alto y no necesitas maxima precision en cada respuesta.

**Flujo recomendado:** Usa DeepSeek para las 10-15 iteraciones exploratorias. Cuando tengas las hipotesis consolidadas, pasa a Claude para el analisis final con mayor profundidad y matiz.

---

### Limitaciones criticas: lo que la IA NO puede hacer en estrategia

Esta es la seccion mas importante de esta leccion. La IA como sparring estrategico tiene limites reales y peligrosos si no los reconoces.

**1. Alucinaciones en datos de mercado.** Los modelos pueden inventar estadisticas, participaciones de mercado, o datos de competidores con total confianza. Si Claude dice "el mercado de foodtech en Chile crecio un 34% en 2025", verifica esa cifra. Puede ser real o completamente fabricada.

**2. Datos de entrenamiento desactualizados.** Los modelos tienen una fecha de corte en sus datos. No conocen tu mercado local en tiempo real, ni la ultima regulacion de tu pais, ni el movimiento reciente de tu competidor. Kaplan y Haenlein (2019) advierten que la IA es tan buena como los datos que la alimentan.

**3. Ausencia de contexto local.** Un modelo sabe que existe Peru, pero no conoce las dinamicas especificas de negociar con distribuidores en Arequipa vs. Lima. El contexto hiperlocal — relaciones, cultura organizacional, regulaciones municipales — es algo que solo tu equipo tiene.

**4. Sobreconfianza en las respuestas.** Los modelos generan texto con el mismo nivel de certeza independientemente de si estan seguros o adivinando. No dicen "no se" con la frecuencia que deberian. Esto es peligroso en contextos estrategicos donde la falsa precision mata.

---

### Como mitigar las limitaciones

| Limitacion | Mitigacion practica |
|---|---|
| Alucinaciones de datos | Usa IA para **estructura y preguntas**, no para datos facticos. Toda cifra se verifica |
| Datos desactualizados | Alimenta al modelo con datos recientes: reportes, noticias, estados financieros publicos |
| Falta de contexto local | Incluye contexto relevante en cada prompt. La IA no adivina — necesita que le cuentes |
| Sobreconfianza | Pide explicitamente: "indica tu nivel de confianza en cada afirmacion y senala donde estas especulando" |

---

### La ventaja humano + IA

La combinacion optima no es "IA decide" ni "humano decide solo". Es un ciclo:

1. **Humano** define la pregunta estrategica y aporta contexto real
2. **IA** genera estructura, escenarios, criticas y preguntas no consideradas
3. **Humano** evalua, descarta lo irrelevante, verifica datos y aplica juicio
4. **IA** refina basandose en la retroalimentacion humana
5. **Humano** toma la decision final con mayor informacion y menos puntos ciegos

Davenport y Ronanki (2018) lo resumen asi: la IA no toma mejores decisiones que los humanos — permite que los humanos tomen mejores decisiones al ampliar la superficie de lo que consideran.

---

### Tu turno

<!-- exercise:ia-ex-06 -->

---

**Referencias:**

- Kaplan, A. & Haenlein, M. (2019). "Siri, Siri, in my hand: Who''s the fairest in the land?" *Business Horizons*, 62(1).
- Davenport, T.H. & Ronanki, R. (2018). "Artificial Intelligence for the Real World." *Harvard Business Review*, 96(1).
- Klein, G. (2007). "Performing a Project Premortem." *Harvard Business Review*, 85(9).
- Tetlock, P. & Gardner, D. (2015). *Superforecasting: The Art and Science of Prediction*. Crown.
',
  'text',
  6,
  15,
  true
),

-- ─────────────────────────────────────────────────────────────────────
-- MÓDULO 3, LECCIÓN 7: Caso: Transformación de una PyME
-- ─────────────────────────────────────────────────────────────────────
(
  '1a030100-0000-0000-0000-000000000001',
  '1a000000-0000-0000-0000-000000000001',
  '1a030000-0000-0000-0000-000000000001',
  'Caso: Transformación de una PyME',
  '## Caso: Transformación de una PyME

### El punto de partida

Distribuidora Centroamericana es una empresa familiar con 12 años de operación, 45 empleados y facturación anual de $3.5 millones. Opera desde Guatemala con rutas de distribución hacia Honduras y El Salvador, moviendo productos de consumo masivo a más de 400 puntos de venta.

La empresa funciona. Pero funciona con dolor. El gerente general, Andrés, lo resume así: "Hacemos todo a mano. Nuestras vendedoras llevan cuadernos. Nuestros clientes esperan días por una respuesta. Y yo tomo decisiones con el estómago porque no tengo datos organizados."

Este es un caso ficticio, pero los problemas son reales. Son los mismos que enfrentan miles de PyMEs en Centroamérica y el resto de Latinoamérica. Lo que lo hace interesante es cómo se resolvieron: no con un proyecto millonario de transformación digital, sino con tres implementaciones de IA en 90 días.

---

### El diagnóstico: tres dolores concretos

Antes de hablar de soluciones, Andrés identificó los tres problemas que más le costaban dinero y oportunidades:

| Problema | Síntoma | Impacto estimado |
|---|---|---|
| **Atención al cliente lenta** | Tiempo promedio de respuesta: 48 horas | Pérdida de pedidos urgentes, clientes frustrados |
| **Seguimiento de ventas manual** | Hojas de Excel desactualizadas, sin visibilidad en tiempo real | Decisiones comerciales a ciegas, vendedoras sin prioridades claras |
| **Procesos internos sin documentar** | El conocimiento está en la cabeza de 3 personas clave | Capacitación de nuevos empleados toma 3 meses, riesgo si alguien se va |

> *Ninguno de estos problemas requería inteligencia artificial para resolverse. Pero la IA permitió resolverlos más rápido, más barato y con menos personas dedicadas que las alternativas tradicionales.*

---

### Fase 1 (Mes 1): Chatbot de atención al cliente con Claude

**El problema:** Los clientes enviaban consultas por WhatsApp (precios, disponibilidad, estado de pedidos) y un equipo de 2 personas respondía manualmente. El 60% de las consultas eran repetitivas.

**La solución:** Implementaron un asistente con la API de Claude conectado a su catálogo de productos y sistema de pedidos. El chatbot responde preguntas frecuentes, consulta precios y disponibilidad, y escala a un humano cuando la consulta es compleja.

**Resultados:**

| Métrica | Antes | Después |
|---|---|---|
| Tiempo promedio de respuesta | 48 horas | 2 horas (automáticas) / 4 horas (escaladas) |
| Consultas resueltas sin intervención humana | 0% | 60% |
| Satisfacción del cliente (encuesta mensual) | 5.2/10 | 7.8/10 |
| Pedidos perdidos por demora | ~15/mes | ~3/mes |

**Costo:** $200/mes en API de Claude + $800 de integración inicial (un freelancer local).

**Lección aprendida:** No intentaron automatizar todo. El 40% de consultas complejas sigue con humanos. La clave fue identificar las consultas repetitivas y automatizar solo esas.

---

### Fase 2 (Mes 2): Análisis de ventas con Gemini + Google Sheets

**El problema:** Los datos de ventas existían en 6 hojas de cálculo diferentes, cada vendedora con su formato. No había visión consolidada. Los reportes semanales tomaban 8 horas de trabajo administrativo.

**La solución:** Consolidaron las hojas en un Google Sheet estandarizado y conectaron Gemini (a través de Google Workspace) para generar análisis automáticos. Cada lunes, Gemini produce un reporte con tendencias, alertas y recomendaciones.

**Resultados:**

| Métrica | Antes | Después |
|---|---|---|
| Tiempo de elaboración de reporte semanal | 8 horas | 15 minutos (revisión humana) |
| Visibilidad de datos de ventas | Parcial, desactualizada | Completa, en tiempo real |
| Insight clave descubierto | Ninguno sistemático | El 20% de clientes genera el 80% de ingresos, pero recibía el mismo nivel de atención que el resto |

**Costo:** $30/usuario/mes de Google Workspace (ya lo tenían parcialmente) para 5 usuarios clave.

**Acción derivada:** Con el análisis de Pareto que Gemini reveló, reasignaron a la mejor vendedora para dedicarse exclusivamente a los 80 clientes top. En el primer mes, el valor promedio de pedido de esos clientes subió 18%.

**Lección aprendida:** La IA no generó datos nuevos. Organizó y analizó los que ya tenían. A veces la transformación no requiere datos sofisticados, sino dejar de ignorar los que ya existen.

---

### Fase 3 (Mes 3): Documentación interna con DeepSeek (self-hosted)

**El problema:** Tres personas concentraban el conocimiento de operaciones, logística y relaciones con proveedores. Si alguna se iba, la empresa perdía meses de productividad. No había manuales ni procedimientos escritos.

**La solución:** Instalaron DeepSeek (modelo de código abierto) en un servidor local. El proceso fue simple pero poderoso: entrevistaron a cada persona clave durante 2 horas grabadas, transcribieron las entrevistas y usaron DeepSeek para generar procedimientos operativos estándar (SOPs), manuales de capacitación y documentos de referencia.

**Resultados:**

| Métrica | Antes | Después |
|---|---|---|
| Procedimientos documentados | 0 | 23 SOPs completos |
| Tiempo de onboarding de nuevos empleados | 3 meses | 6 semanas |
| Dependencia de personas clave | Crítica (riesgo alto) | Moderada (conocimiento distribuido) |

**Costo:** $0 por el software (código abierto) + $500 de configuración del servidor (hardware existente, solo configuración).

**Lección aprendida:** Eligieron DeepSeek self-hosted porque la documentación incluía información sensible: proveedores, márgenes, procesos propietarios. Al correr localmente, ningún dato salió de la empresa.

---

### El balance: ROI en 90 días

| Concepto | Inversión mensual | Retorno mensual |
|---|---|---|
| Chatbot Claude (Fase 1) | $200 | $1,800 (pedidos recuperados) + $1,000 (menos horas de soporte) |
| Análisis Gemini (Fase 2) | $150 | $5,000 (ingresos adicionales por mejor targeting) |
| DeepSeek (Fase 3) | $0 (ya pagado) | Difícil de cuantificar, pero redujo riesgo operativo crítico |
| **Total** | **$350/mes** | **~$7,800/mes** |

Inversión inicial total: $1,300. Retorno mensual neto: ~$7,450. **Payback: menos de una semana.**

---

### Las 5 lecciones de Distribuidora Centroamericana

1. **Empezar por el dolor, no por la tecnología.** No buscaron "implementar IA". Buscaron resolver problemas concretos que les costaban dinero.

2. **Tres herramientas diferentes para tres problemas diferentes.** No existe un modelo de IA que lo haga todo mejor. Claude para conversación, Gemini para análisis integrado con Google, DeepSeek para datos sensibles.

3. **Implementación por fases, no big bang.** Cada fase fue un proyecto de 30 días con resultados medibles. Si la Fase 1 hubiera fallado, habrían perdido $1,000, no $100,000.

4. **El ROI más grande fue inesperado.** Esperaban ahorrar tiempo. Lo que realmente transformó el negocio fue el insight del análisis de Pareto que llevó a reasignar recursos comerciales.

5. **La IA no reemplazó a nadie.** Las 2 personas de atención al cliente ahora dedican su tiempo a resolver problemas complejos y fidelizar clientes, en lugar de responder "¿cuál es el precio de X?" por centésima vez.

> *La pregunta no es si tu PyME puede darse el lujo de implementar IA. Con costos de $350/mes, la pregunta es si puede darse el lujo de no hacerlo.*

---

### Tu turno

<!-- exercise:ia-ex-07 -->

---

**Referencias:**

- McKinsey & Company (2024). "The state of AI in early 2024: Gen AI adoption spikes and starts to generate value."
- BID / IDB (2023). "Adopción de inteligencia artificial en pequeñas y medianas empresas de América Latina."
- Brynjolfsson, E. & McAfee, A. (2017). *Machine, Platform, Crowd: Harnessing Our Digital Future*. W.W. Norton.
- Koch, R. (1998). *The 80/20 Principle*. Currency/Doubleday.
',
  'text',
  7,
  20,
  true
),

-- ─────────────────────────────────────────────────────────────────────
-- MÓDULO 3, LECCIÓN 8: Riesgos, ética y gobernanza
-- ─────────────────────────────────────────────────────────────────────
(
  '1a030200-0000-0000-0000-000000000001',
  '1a000000-0000-0000-0000-000000000001',
  '1a030000-0000-0000-0000-000000000001',
  'Riesgos, ética y gobernanza',
  '## Riesgos, ética y gobernanza

### Lo que nadie te dice en la demo

Todas las demostraciones de IA muestran el mejor escenario: el prompt perfecto, la respuesta impecable, el resultado transformador. Pero usar IA en un negocio real implica gestionar riesgos reales. Esta lección cubre los cinco riesgos críticos que cualquier profesional debe entender antes de integrar IA generativa en su organización.

No se trata de generar miedo. Se trata de usar estas herramientas con criterio profesional, de la misma manera que un contador usa una hoja de cálculo sabiendo que un error de fórmula puede costar millones.

---

### 1. Alucinaciones: cuando la IA miente con confianza

Como vimos en la Lección 1.1, los modelos de lenguaje generan texto estadísticamente plausible, no necesariamente verdadero. En un contexto empresarial, esto tiene consecuencias concretas:

| Escenario | Qué puede pasar | Consecuencia |
|---|---|---|
| Propuesta comercial | La IA cita una regulación que no existe | Pierdes credibilidad con el cliente |
| Asesoría legal interna | El modelo inventa un artículo del código tributario | Decisiones fiscales basadas en información falsa |
| Reporte financiero | Genera proyecciones con números inventados | Decisiones de inversión erróneas |
| Atención al cliente | Promete una política de devolución que no es la tuya | Obligación legal con el cliente |

**Cómo mitigar:**
- Toda información fáctica generada por IA debe verificarse contra fuentes primarias
- Nunca publiques datos, cifras o referencias legales sin confirmarlas
- Implementa un flujo de revisión humana antes de que cualquier contenido generado por IA llegue a un cliente o se use en una decisión

> *Regla de oro: usa la IA como borrador, nunca como fuente final. Si no puedes verificar algo que generó la IA, no lo uses.*

---

### 2. Datos confidenciales: lo que NUNCA debes enviar a un modelo de IA

Este es el riesgo más subestimado. Cada vez que escribes algo en un chatbot de IA, esa información viaja a servidores externos. Esto significa que debes tratar el prompt como si fuera un correo electrónico que podría ser leído por terceros.

**Nunca envíes a un modelo de IA:**
- Datos personales de clientes (nombres, cédulas, direcciones, números de cuenta)
- Contraseñas, tokens de acceso o credenciales de cualquier tipo
- Información financiera confidencial (estados financieros no publicados, márgenes reales)
- Fórmulas propietarias, recetas, algoritmos de negocio
- Documentos legales en proceso (contratos en negociación, demandas pendientes)
- Información de empleados (evaluaciones, salarios, datos médicos)

### Comparativa de privacidad entre modelos

| Aspecto | Claude (Anthropic) | Gemini (Google) | DeepSeek (self-hosted) |
|---|---|---|---|
| **¿Usa tus datos para entrenar?** | No (política explícita) | No en tier Enterprise; sí en versión gratuita | No aplica (corre en tu servidor) |
| **Certificaciones** | SOC 2 Type II | SOC 2, ISO 27001 | Depende de tu infraestructura |
| **Dónde se procesan los datos** | Servidores de Anthropic (EE.UU.) | Servidores de Google (global) | Tu servidor local |
| **Retención de datos** | No retiene conversaciones de API | Varía por plan y región | Tú controlas la retención |
| **Mejor para datos sensibles** | API con acuerdo empresarial | Workspace Enterprise | Máximo control, pero tú gestionas la seguridad |

> *Si tu empresa maneja datos sensibles de clientes (salud, finanzas, legales), considera seriamente modelos self-hosted como DeepSeek o acuerdos empresariales con cláusulas explícitas de no-entrenamiento.*

---

### 3. Sesgo en los outputs: la IA refleja (y amplifica) prejuicios

Los modelos de lenguaje aprenden de texto existente, y el texto existente contiene sesgos. Esto se manifiesta en situaciones de negocio de formas sutiles pero peligrosas:

- **Reclutamiento:** Si le pides a la IA que redacte un perfil de puesto para "ingeniero de software", puede usar pronombres masculinos por defecto o describir características asociadas culturalmente con hombres.
- **Análisis de mercado:** Puede subestimar el poder adquisitivo de ciertos segmentos demográficos o regiones porque sus datos de entrenamiento tienen sesgo hacia mercados desarrollados.
- **Generación de contenido:** Puede perpetuar estereotipos culturales en textos de marketing dirigidos a audiencias latinoamericanas.

**Cómo mitigar:**
- Revisa críticamente cualquier output que involucre personas, demografía o decisiones que afecten a grupos específicos
- Especifica en tus prompts que quieres lenguaje inclusivo y perspectivas diversas
- No uses IA como única fuente para decisiones que afecten a personas (contratación, promociones, evaluaciones)

---

### 4. Sobre-dependencia: el peligro de dejar de pensar

Quizás el riesgo más insidioso no es técnico sino cognitivo. Cuando una herramienta te da respuestas rápidas y articuladas, es tentador dejar de cuestionar esas respuestas.

Señales de alerta de sobre-dependencia:
- Aceptas la primera respuesta de la IA sin cuestionarla
- Dejaste de investigar por cuenta propia porque "la IA ya lo hizo"
- Tus documentos son esencialmente copy-paste de outputs de IA sin edición sustancial
- No puedes explicar el razonamiento detrás de una recomendación que presentaste (porque la generó la IA)

**La regla del 70/30:** Usa la IA para el 70% del trabajo mecánico (borradores, estructura, investigación inicial). Pero el 30% de criterio profesional, verificación y decisión final debe ser humano. Ese 30% es lo que justifica tu salario.

---

### 5. Panorama regulatorio en América Latina

La regulación de IA en la región está en construcción. No existe aún una ley comprehensiva equivalente al EU AI Act en ningún país latinoamericano, pero hay avances importantes:

| País | Estado actual | Implicaciones para tu empresa |
|---|---|---|
| **Colombia** | Marco ético de IA (MinTIC, 2024). Lineamientos voluntarios para sector público y privado | Referencia útil para diseñar políticas internas |
| **Brasil** | LGPD (Ley General de Protección de Datos) aplica a datos procesados por IA. Proyecto de ley de IA en trámite | Si operas en Brasil, los datos personales enviados a IA están sujetos a LGPD |
| **Panamá** | Ley 81 de Protección de Datos Personales (2019). Sin regulación específica de IA | Protección de datos personales aplica independientemente de si los procesa un humano o una IA |
| **México** | NOM-151 para mensajes de datos. Discusión activa sobre regulación de IA | Atención a evolución regulatoria; los datos personales ya están protegidos por la Ley Federal |
| **Chile** | Política Nacional de IA (2021). Proyecto de ley de IA avanzado | Uno de los marcos más avanzados de la región |

**Regla práctica:** Aunque no exista ley específica de IA en tu país, las leyes de protección de datos personales ya aplican a cualquier dato que envíes a un modelo de IA. Si es dato personal, necesitas base legal para procesarlo.

---

### Marco de gobernanza para tu organización

No necesitas un comité de ética de 20 personas. Necesitas respuestas claras a estas preguntas:

| Pregunta de gobernanza | Ejemplo de respuesta |
|---|---|
| **¿Quién autoriza nuevos casos de uso de IA?** | El líder de área + una revisión de TI/legal |
| **¿Qué tipos de datos se pueden enviar a IA externa?** | Solo datos públicos o anonimizados. Datos sensibles solo en modelos self-hosted |
| **¿Quién revisa los outputs antes de uso externo?** | El autor + un revisor que no usó IA para el mismo documento |
| **¿Cómo documentamos el uso de IA?** | Registro simple: qué herramienta, para qué tarea, quién revisó |
| **¿Cada cuánto revisamos las políticas?** | Cada 6 meses (el campo evoluciona rápido) |

> *La gobernanza de IA no debe frenar la innovación. Debe canalizarla. Una empresa sin políticas de uso de IA no es más ágil — es más vulnerable.*

---

### Tu turno

<!-- exercise:ia-ex-08 -->

---

**Referencias:**

- European Parliament (2024). "EU Artificial Intelligence Act." Regulation (EU) 2024/1689.
- Floridi, L. et al. (2018). "AI4People — An Ethical Framework for a Good AI Society." *Minds and Machines*, 28, 689-707.
- OECD (2019). "Recommendation of the Council on Artificial Intelligence." OECD Legal Instruments.
- UNESCO (2021). "Recommendation on the Ethics of Artificial Intelligence."
- MinTIC Colombia (2024). "Marco Ético para la Inteligencia Artificial en Colombia."
- Brasil, Lei Geral de Proteção de Dados (LGPD), Lei n. 13.709/2018.
',
  'text',
  8,
  20,
  true
),

-- ─────────────────────────────────────────────────────────────────────
-- MÓDULO 3, LECCIÓN 9: Tu roadmap de adopción
-- ─────────────────────────────────────────────────────────────────────
(
  '1a030300-0000-0000-0000-000000000001',
  '1a000000-0000-0000-0000-000000000001',
  '1a030000-0000-0000-0000-000000000001',
  'Tu roadmap de adopción',
  '## Tu roadmap de adopción

### De la teoría a los 90 días que importan

Has llegado a la última lección del curso. Sabes qué es la IA generativa, conoces sus capacidades y limitaciones, has visto cómo aplicarla a decisiones de negocio y entiendes los riesgos. Ahora la pregunta es: ¿cómo llevas todo esto a la práctica en tu organización?

La respuesta no es "contratar un equipo de IA" ni "comprar una plataforma enterprise". La respuesta es un proceso gradual de 90 días dividido en cuatro fases que cualquier equipo puede ejecutar, sin importar el tamaño de la empresa ni el presupuesto disponible.

---

### Fase 1: Explorar (Semanas 1-2)

**Objetivo:** Identificar oportunidades y romper la barrera del primer uso.

En esta fase, no hay compromisos formales. El objetivo es que 3-5 personas clave de tu equipo experimenten con herramientas de IA en su trabajo real.

**Acciones concretas:**
1. Identifica **3 casos de uso de alto impacto y bajo riesgo** (revisa la tabla al final de esta lección)
2. Crea cuentas gratuitas en Claude, Gemini y DeepSeek
3. Cada persona elige un caso de uso y experimenta durante 2 semanas
4. Al final de la semana 2, cada persona comparte: ¿qué funcionó? ¿Qué no? ¿Cuánto tiempo ahorró?

**Métricas de éxito:**
- Al menos 3 personas completaron experimentos individuales
- Se identificó al menos 1 caso de uso con ahorro de tiempo demostrable
- El equipo tiene una opinión informada (no basada en titulares de prensa) sobre qué puede hacer la IA

> *El error más común en esta fase es sobre-planificar. No necesitas un documento de 20 páginas para empezar a usar Claude. Necesitas un prompt y 10 minutos.*

---

### Fase 2: Piloto (Semanas 3-6)

**Objetivo:** Validar un caso de uso con métricas reales.

De los casos explorados en la Fase 1, selecciona el que mostró mayor potencial y diseña un piloto estructurado.

**Acciones concretas:**
1. Selecciona **1 caso de uso ganador** (el que demostró mayor ahorro o impacto)
2. Define métricas de éxito antes de empezar (tiempo ahorrado, calidad del output, satisfacción del usuario)
3. Asigna un equipo pequeño (3-5 personas) para ejecutar el piloto durante 4 semanas
4. Documenta resultados semanalmente: qué funciona, qué ajustes se necesitan, qué problemas aparecen
5. Al final de la semana 6, presenta resultados al equipo de liderazgo con datos concretos

**Métricas de éxito:**
- Reducción medible de tiempo en la tarea pilotada (mínimo 30%)
- Al menos 80% de los participantes del piloto quieren seguir usando la herramienta
- Se identificaron y documentaron limitaciones y riesgos específicos
- Existe un caso de negocio con números reales (no proyecciones teóricas)

**Ejemplo de piloto bien definido:**

| Elemento | Definición |
|---|---|
| Caso de uso | Generar borradores de propuestas comerciales con Claude |
| Equipo | 3 ejecutivos de ventas |
| Duración | 4 semanas |
| Métrica principal | Tiempo promedio de elaboración de propuesta (antes vs. después) |
| Métrica secundaria | Tasa de aprobación de propuestas por clientes |
| Criterio de éxito | Reducción de 50% en tiempo de elaboración sin reducción en tasa de aprobación |

---

### Fase 3: Escalar (Semanas 7-10)

**Objetivo:** Expandir lo que funciona a más equipos y crear estructura.

Si el piloto fue exitoso, es momento de pasar de un experimento a un proceso. Esto requiere crear las condiciones para que más personas adopten la herramienta.

**Acciones concretas:**
1. Expande el caso de uso validado a **2-3 departamentos adicionales**
2. Crea **templates de prompts** estandarizados para las tareas más comunes
3. Documenta las **mejores prácticas** que surgieron del piloto (qué funciona, qué no, errores comunes)
4. Identifica y entrena **power users** (1-2 por departamento) que sirvan como referencia para sus compañeros
5. Establece las **reglas básicas**: qué datos se pueden compartir, qué flujo de revisión seguir, cómo reportar problemas

**Métricas de éxito:**
- Al menos 3 departamentos usando IA de forma regular
- Existen templates documentados para las 5 tareas más comunes
- Los power users pueden resolver dudas de sus compañeros sin escalar a TI
- Se redujo el tiempo total dedicado a tareas rutinarias en un 20% a nivel organizacional

---

### Fase 4: Institucionalizar (Semanas 11-12)

**Objetivo:** Convertir la adopción en política y cultura organizacional.

Esta fase convierte lo informal en formal. No se trata de burocracia sino de sostenibilidad.

**Acciones concretas:**
1. Redacta una **política de uso de IA** (basada en el marco de gobernanza de la Lección 3.2)
2. Asigna **presupuesto mensual** para herramientas de IA (basado en ROI demostrado del piloto)
3. Integra la IA con **herramientas existentes** (CRM, email, documentación interna)
4. Establece un ciclo de **capacitación continua** (la IA evoluciona cada trimestre; tu equipo debe evolucionar con ella)
5. Define un proceso de **evaluación de nuevos casos de uso** (quién propone, quién aprueba, cómo se mide)

**Métricas de éxito:**
- Existe una política de uso de IA aprobada por la dirección
- Hay presupuesto asignado y aprobado
- Al menos 5 procesos organizacionales integran IA de forma regular
- Hay un proceso claro para evaluar y aprobar nuevos casos de uso

---

### Gestión del cambio: los patrones de resistencia

La tecnología es la parte fácil. Las personas son el verdadero desafío. Estos son los patrones de resistencia más comunes y cómo abordarlos:

| Patrón de resistencia | Lo que dicen | Lo que realmente sienten | Cómo abordarlo |
|---|---|---|---|
| **Miedo al reemplazo** | "La IA nos va a quitar el trabajo" | Inseguridad sobre su valor profesional | Demostrar que la IA amplifica, no reemplaza. Mostrar casos donde las personas hacen trabajo más valioso |
| **Escepticismo técnico** | "Esto es una moda, ya pasará" | Fatiga de cambio por iniciativas anteriores que fracasaron | Mostrar resultados concretos del piloto. No prometer transformación, prometer ahorro de 2 horas por semana |
| **Perfeccionismo** | "Los outputs no son perfectos" | Necesidad de control total sobre el resultado | Explicar el modelo 70/30: la IA hace el borrador, tú haces la versión final |
| **Inercia** | "Siempre lo hemos hecho así y funciona" | Costo cognitivo de aprender algo nuevo | Empezar con la tarea que más detestan. Si la IA elimina el trabajo tedioso, la adopción se da sola |

> *No intentes convencer al 100% del equipo en el día 1. Enfócate en el 15-20% de early adopters. Cuando sus resultados sean visibles, la mayoría seguirá. Los últimos escépticos se convencerán cuando se queden solos.*

---

### Quick wins vs. transformación profunda

No todo tiene que ser un proyecto estratégico. Los quick wins generan credibilidad; la transformación genera ventaja competitiva. Necesitas ambos.

| Quick wins (Semanas 1-4) | Transformación profunda (Meses 3-12) |
|---|---|
| Resumir documentos largos | Rediseñar el proceso de atención al cliente |
| Generar borradores de correos | Automatizar el análisis de datos comerciales |
| Traducir materiales | Crear un sistema de inteligencia competitiva |
| Lluvia de ideas para campañas | Documentar y estandarizar procesos operativos |
| Preparar agendas de reuniones | Integrar IA en el flujo de toma de decisiones |

Los quick wins demuestran valor en días. La transformación profunda genera impacto en meses. La clave es **empezar por los quick wins para ganar credibilidad y presupuesto, y luego invertir en transformación**.

---

### Casos de uso por departamento

| Departamento | Caso de uso | Herramienta sugerida | Dificultad |
|---|---|---|---|
| **Ventas** | Borradores de propuestas comerciales personalizadas | Claude | Baja |
| **Ventas** | Análisis de pipeline y priorización de prospectos | Gemini + Sheets | Media |
| **Marketing** | Generación de contenido para redes sociales | Claude o Gemini | Baja |
| **Marketing** | Análisis de encuestas de satisfacción (texto abierto) | Claude | Media |
| **RRHH** | Borradores de descripciones de puesto y ofertas laborales | Claude | Baja |
| **RRHH** | Resumen de entrevistas y comparación de candidatos | Claude | Media |
| **Operaciones** | Documentación de procesos y SOPs | DeepSeek (self-hosted) | Media |
| **Operaciones** | Análisis de incidencias y patrones de problemas | Gemini | Alta |
| **Finanzas** | Resumen de reportes financieros para audiencias no técnicas | Claude | Baja |
| **Finanzas** | Análisis de variaciones presupuestarias | Gemini + Sheets | Media |

---

### Un cierre honesto

La IA generativa no es magia ni es una moda. Es una herramienta poderosa que amplifica las capacidades de los profesionales que saben usarla. Como toda herramienta, su valor depende de quién la usa, para qué la usa y con qué criterio la usa.

El objetivo nunca fue reemplazar personas. El objetivo es que las personas dediquen su tiempo a lo que realmente importa: pensar, decidir, crear relaciones, resolver problemas complejos. Y que deleguen a la IA lo que la IA hace mejor: procesar volumen, generar borradores, organizar información y proponer alternativas.

Tienes el conocimiento. Tienes las herramientas. Tienes un plan de 90 días. Lo que falta es empezar.

> *"La mejor manera de predecir el futuro es crearlo." — Peter Drucker*

---

### Tu turno

<!-- exercise:ia-ex-09 -->

---

**Referencias:**

- Rogers, E.M. (2003). *Diffusion of Innovations* (5th ed.). Free Press.
- Kotter, J.P. (2012). *Leading Change*. Harvard Business Review Press.
- World Economic Forum (2024). "The Future of Jobs Report 2024."
- Drucker, P.F. (1999). *Management Challenges for the 21st Century*. HarperBusiness.
- Moore, G.A. (2014). *Crossing the Chasm* (3rd ed.). Harper Business.
',
  'text',
  9,
  20,
  true
)

ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  lesson_type = EXCLUDED.lesson_type,
  order_index = EXCLUDED.order_index,
  duration_minutes = EXCLUDED.duration_minutes;

-- 4. Insertar ejercicios (quizzes) en course_exercises

-- Quiz 1: Mitos vs. realidades de la IA generativa (Lección 1)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  '1a000000-0000-0000-0000-000000000001',
  '1a010000-0000-0000-0000-000000000001',
  '1a010100-0000-0000-0000-000000000001',
  'ia-ex-01',
  'quiz',
  '{
  "id": "ia-ex-01",
  "title": "Mitos vs. realidades de la IA generativa",
  "description": "Separa los mitos de las capacidades reales de la IA generativa.",
  "questions": [
    {
      "question": "Una empresa quiere usar IA para calcular automáticamente sus impuestos mensuales sumando facturas. ¿Es un buen caso de uso?",
      "options": [
        "Sí — la IA puede hacer cálculos complejos",
        "No — los LLMs predicen texto, no calculan de forma confiable",
        "Solo si usa Claude",
        "Depende del volumen de facturas"
      ],
      "correct": 1,
      "explanation": "Los modelos de lenguaje predicen la siguiente palabra, no hacen matemáticas confiables. Para cálculos exactos, usa una hoja de cálculo o software contable."
    },
    {
      "question": "Un colega dice: ''Le pregunté a ChatGPT el tipo de cambio de hoy y me respondió.'' ¿Cuál es el problema?",
      "options": [
        "Ninguno — los LLMs acceden a internet",
        "El dato puede ser inventado o desactualizado — los LLMs no acceden a internet en tiempo real",
        "Solo Gemini tiene acceso a datos actualizados",
        "El problema es que debió usar Claude"
      ],
      "correct": 1,
      "explanation": "Los LLMs tienen una fecha de corte en sus datos de entrenamiento. Sin acceso a internet en tiempo real, pueden generar datos desactualizados con total confianza."
    },
    {
      "question": "¿Qué son las ''alucinaciones'' en el contexto de IA generativa?",
      "options": [
        "Errores de programación en el modelo",
        "Respuestas incorrectas que el modelo genera con total confianza",
        "Problemas de conexión a internet",
        "Sesgo en los datos de entrenamiento"
      ],
      "correct": 1,
      "explanation": "Las alucinaciones son respuestas que suenan completamente plausibles pero son parcial o totalmente falsas. El modelo nunca dice ''no sé'' — siempre genera la secuencia más probable."
    },
    {
      "question": "¿Cuál de estas tareas es un buen caso de uso para IA generativa?",
      "options": [
        "Calcular el balance general de la empresa",
        "Resumir un reporte trimestral de 30 páginas en 5 puntos clave",
        "Predecir el precio exacto de las acciones mañana",
        "Reemplazar al equipo legal para revisar contratos"
      ],
      "correct": 1,
      "explanation": "Resumir documentos largos es una de las fortalezas principales de los LLMs. Calcular, predecir valores exactos o reemplazar expertise legal no son usos apropiados."
    },
    {
      "question": "La analogía de la ''calculadora del pensamiento'' significa que la IA generativa:",
      "options": [
        "Piensa como un humano",
        "Amplifica capacidades pero no reemplaza el criterio profesional",
        "Solo sirve para cálculos",
        "Es más inteligente que los humanos"
      ],
      "correct": 1,
      "explanation": "Así como la calculadora amplificó nuestra capacidad de hacer operaciones sin reemplazar la necesidad de entender matemáticas, los LLMs amplifican el procesamiento de texto sin reemplazar el juicio humano."
    }
  ],
  "passing_score": 50,
  "exercise_type": "quiz",
  "difficulty": "beginner",
  "estimated_duration_minutes": 5
}'::jsonb,
  1
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- Quiz 2: Elige el modelo correcto (Lección 2)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  '1a000000-0000-0000-0000-000000000001',
  '1a010000-0000-0000-0000-000000000001',
  '1a010200-0000-0000-0000-000000000001',
  'ia-ex-02',
  'quiz',
  '{
  "id": "ia-ex-02",
  "title": "Elige el modelo correcto",
  "description": "Determina cuál modelo de IA es más adecuado para cada escenario de negocio.",
  "questions": [
    {
      "question": "Una consultora en Bogotá necesita analizar un contrato de concesión de 180 páginas y generar un resumen ejecutivo con los 10 riesgos principales. ¿Qué modelo?",
      "options": [
        "Claude — ventana de contexto de 200K tokens, excelente en análisis de documentos largos",
        "Gemini — mejor para tareas multimodales",
        "DeepSeek — más barato",
        "Cualquiera funciona igual"
      ],
      "correct": 0,
      "explanation": "Claude sobresale en análisis de documentos extensos gracias a su ventana de contexto de 200K tokens y su capacidad de razonamiento profundo."
    },
    {
      "question": "Un equipo de marketing quiere analizar publicaciones de Instagram de competidores (capturas de pantalla). ¿Qué modelo?",
      "options": [
        "Claude — mejor razonamiento",
        "Gemini — capacidad multimodal nativa para analizar imágenes directamente",
        "DeepSeek — código abierto",
        "Ninguno puede analizar imágenes"
      ],
      "correct": 1,
      "explanation": "Gemini fue diseñado desde cero como multimodal. Puede ''ver'' y analizar imágenes, capturas de pantalla y videos directamente, sin necesidad de transcribirlos."
    },
    {
      "question": "Un banco en Panamá necesita automatizar análisis de solicitudes de crédito, pero regulaciones prohíben enviar datos a servidores externos. ¿Qué modelo?",
      "options": [
        "Claude con acuerdo empresarial",
        "Gemini Enterprise",
        "DeepSeek self-hosted — corre en infraestructura propia, datos nunca salen",
        "No pueden usar IA"
      ],
      "correct": 2,
      "explanation": "DeepSeek es código abierto y puede desplegarse en los servidores del banco. Los datos nunca salen de su infraestructura, cumpliendo las regulaciones de protección de datos."
    },
    {
      "question": "Un equipo necesita generar reportes semanales de ventas integrando datos de Google Sheets automáticamente. ¿Qué modelo?",
      "options": [
        "Claude",
        "Gemini — integración nativa con Google Workspace",
        "DeepSeek",
        "Todos funcionan igual con Sheets"
      ],
      "correct": 1,
      "explanation": "Gemini se integra nativamente con Google Workspace (Sheets, Docs, Slides), eliminando la fricción de copiar-pegar entre herramientas."
    },
    {
      "question": "La regla de oro para elegir modelos es:",
      "options": [
        "Siempre usar el más caro",
        "Usar Claude para pensar, Gemini para ver, DeepSeek para lo que no puede salir de tu oficina",
        "Usar un solo modelo para todo por consistencia",
        "El modelo más reciente es siempre mejor"
      ],
      "correct": 1,
      "explanation": "No existe el ''mejor modelo''. Los profesionales más efectivos combinan: Claude para análisis y razonamiento, Gemini para tareas visuales e integración, DeepSeek para datos sensibles."
    }
  ],
  "passing_score": 50,
  "exercise_type": "quiz",
  "difficulty": "beginner",
  "estimated_duration_minutes": 5
}'::jsonb,
  2
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- Quiz 3: Evalúa y mejora prompts (Lección 3)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  '1a000000-0000-0000-0000-000000000001',
  '1a010000-0000-0000-0000-000000000001',
  '1a010300-0000-0000-0000-000000000001',
  'ia-ex-03',
  'quiz',
  '{
  "id": "ia-ex-03",
  "title": "Evalúa y mejora prompts",
  "description": "Identifica problemas en prompts y aplica la estructura Rol + Contexto + Tarea + Formato.",
  "questions": [
    {
      "question": "''Resume este reporte.'' ¿Qué le falta a este prompt?",
      "options": [
        "Nada — es claro y directo",
        "Le falta Rol, Contexto y Formato — no sabe para quién, sobre qué ni cómo presentar",
        "Es demasiado corto",
        "Le falta el nombre del archivo"
      ],
      "correct": 1,
      "explanation": "Sin Rol (¿quién resume?), Contexto (¿para qué audiencia?) ni Formato (¿bullets, párrafo, tabla?), el modelo genera un resumen genérico que probablemente no es útil."
    },
    {
      "question": "¿Cuál es la diferencia entre prompting zero-shot y few-shot?",
      "options": [
        "Zero-shot es gratis, few-shot es de pago",
        "Zero-shot pide sin ejemplos, few-shot incluye ejemplos de lo que esperas",
        "Zero-shot es más preciso",
        "Few-shot solo funciona con Claude"
      ],
      "correct": 1,
      "explanation": "Zero-shot: solo describes la tarea. Few-shot: incluyes 2-3 ejemplos del resultado esperado. Few-shot casi siempre produce mejores resultados porque el modelo entiende exactamente el formato y criterio."
    },
    {
      "question": "''Ayúdame con marketing.'' ¿Por qué este prompt producirá resultados mediocres?",
      "options": [
        "Marketing es un tema muy amplio",
        "Es demasiado vago — no especifica industria, audiencia, canal, objetivo ni restricciones",
        "Debería usar Gemini para marketing",
        "Le falta decir ''por favor''"
      ],
      "correct": 1,
      "explanation": "Sin especificar industria, audiencia, canal, objetivo ni restricciones, el modelo tiene que adivinar todo. El resultado será genérico e inútil para tu contexto específico."
    },
    {
      "question": "Si la primera respuesta de la IA no es buena, deberías:",
      "options": [
        "Cambiar de modelo",
        "Empezar la conversación de cero",
        "Refinar el prompt: agregar contexto, cambiar el rol, dar ejemplos",
        "Aceptar que la IA no sirve para esa tarea"
      ],
      "correct": 2,
      "explanation": "Un buen prompt rara vez sale perfecto a la primera. Los profesionales más efectivos no escriben mejores prompts iniciales — iteran más rápido. Refina en lugar de reiniciar."
    },
    {
      "question": "¿Cuál es el prompt más efectivo para analizar competencia?",
      "options": [
        "''Analiza a mi competencia''",
        "''Eres un estratega de negocios especializado en retail LATAM. Con estos datos de 3 competidores, crea tabla comparativa con: propuesta de valor, precios, canales, debilidad. Identifica espacio desatendido.''",
        "''Dime todo sobre mis competidores en el mercado''",
        "''Necesito información de competidores para una presentación''"
      ],
      "correct": 1,
      "explanation": "Incluye Rol (estratega especializado), Contexto (retail LATAM, datos específicos), Tarea (tabla comparativa con criterios) y Formato (tabla + espacio desatendido). Los otros son vagos."
    }
  ],
  "passing_score": 50,
  "exercise_type": "quiz",
  "difficulty": "beginner",
  "estimated_duration_minutes": 5
}'::jsonb,
  3
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- Quiz 4: IA para análisis: elige el enfoque correcto (Lección 4)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  '1a000000-0000-0000-0000-000000000001',
  '1a020000-0000-0000-0000-000000000001',
  '1a020100-0000-0000-0000-000000000001',
  'ia-ex-04',
  'quiz',
  '{
  "id": "ia-ex-04",
  "title": "IA para análisis: elige el enfoque correcto",
  "description": "Identifica el mejor uso de IA para diferentes tipos de análisis de datos.",
  "questions": [
    {
      "question": "Tienes 500 respuestas abiertas de una encuesta de satisfacción. ¿Cuál es el primer paso antes de enviarlas a la IA?",
      "options": [
        "Enviar todo en un solo prompt",
        "Preparar y fragmentar los datos en lotes de 50-100 respuestas",
        "Pedirle a la IA que genere las encuestas",
        "Resumir manualmente primero"
      ],
      "correct": 1,
      "explanation": "Los modelos procesan mejor textos en segmentos. Fragmentar en lotes de 50-100 mantiene la calidad del análisis y permite verificar resultados por lote."
    },
    {
      "question": "Necesitas analizar formularios escritos a mano escaneados como imágenes. ¿Qué modelo es más apropiado?",
      "options": [
        "Claude — mejor razonamiento",
        "Gemini — capacidad multimodal nativa para interpretar imágenes",
        "DeepSeek — más barato",
        "Ninguno puede leer escritura a mano"
      ],
      "correct": 1,
      "explanation": "Gemini puede procesar imágenes directamente, incluyendo formularios escaneados y escritura a mano. Claude necesitaría que primero transcribieras el texto."
    },
    {
      "question": "''Resume este documento'' vs. ''Extrae las 5 conclusiones principales, los 3 riesgos mencionados y cualquier dato cuantitativo citado.'' ¿Cuál producirá mejor resultado?",
      "options": [
        "El primero — es más simple",
        "El segundo — los prompts de extracción específicos producen resultados más útiles",
        "Son equivalentes",
        "Depende del modelo"
      ],
      "correct": 1,
      "explanation": "Los prompts de extracción específicos guían al modelo sobre exactamente qué buscar, reduciendo la probabilidad de omisiones y generando resultados verificables."
    },
    {
      "question": "Después de que la IA generó un resumen de un reporte financiero, deberías:",
      "options": [
        "Publicarlo directamente — la IA es precisa",
        "Verificar el resumen contra el documento original antes de usar los datos",
        "Pedir a otro modelo que confirme",
        "Agregarlo al dashboard sin revisión"
      ],
      "correct": 1,
      "explanation": "Nunca presentes un resumen de IA sin cruzarlo con el documento original. Los modelos pueden omitir matices importantes o dar peso desproporcionado a ciertos temas."
    },
    {
      "question": "¿Por qué es recomendable hacer múltiples pasadas sobre el mismo texto en lugar de un solo análisis?",
      "options": [
        "Para gastar más tokens",
        "Cada pasada enfocada (temas, sentimiento, datos) supera a una pasada genérica",
        "Los modelos necesitan calentamiento",
        "Para comparar versiones"
      ],
      "correct": 1,
      "explanation": "Una pasada para temas, otra para sentimiento, otra para datos cuantitativos. Cada pasada enfocada produce resultados más profundos que intentar extraer todo en una sola consulta."
    }
  ],
  "passing_score": 60,
  "exercise_type": "quiz",
  "difficulty": "intermediate",
  "estimated_duration_minutes": 5
}'::jsonb,
  4
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- Quiz 5: Evalúa contenido generado por IA (Lección 5)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  '1a000000-0000-0000-0000-000000000001',
  '1a020000-0000-0000-0000-000000000001',
  '1a020200-0000-0000-0000-000000000001',
  'ia-ex-05',
  'quiz',
  '{
  "id": "ia-ex-05",
  "title": "Evalúa contenido generado por IA",
  "description": "Identifica problemas comunes en contenido generado por IA y aplica técnicas de revisión.",
  "questions": [
    {
      "question": "Un comunicado de crisis generado por IA dice: ''Cometimos un error grave y pedimos disculpas.'' ¿Por qué es problemático?",
      "options": [
        "Es demasiado corto",
        "Admite culpa legal — debería decir ''identificamos y corregimos una vulnerabilidad''",
        "Le falta un llamado a la acción",
        "Está bien, es transparente"
      ],
      "correct": 1,
      "explanation": "En comunicación de crisis, admitir ''error grave'' puede tener implicaciones legales. Claude tiende a generar formulaciones más cuidadosas, pero siempre requiere revisión legal."
    },
    {
      "question": "¿Qué es la técnica de ''revisión cruzada entre modelos''?",
      "options": [
        "Usar el mismo modelo dos veces",
        "Generar con un modelo y revisar con otro para detectar problemas que uno solo no vería",
        "Comparar precios entre modelos",
        "Traducir entre idiomas con diferentes modelos"
      ],
      "correct": 1,
      "explanation": "Cada modelo tiene sesgos distintos. Generar con uno y revisar con otro aprovecha las diferentes perspectivas. Lo que un modelo pasa por alto, el otro lo detecta."
    },
    {
      "question": "Un texto generado por IA dice: ''Según un estudio de Harvard de 2023, el 78% de las empresas...'' ¿Qué debes hacer?",
      "options": [
        "Usarlo — Harvard es fuente confiable",
        "Verificar que ese estudio existe antes de usar la cita — la IA puede haberlo inventado",
        "Cambiar Harvard por McKinsey",
        "Eliminar el porcentaje"
      ],
      "correct": 1,
      "explanation": "Los modelos frecuentemente inventan citas y estudios que suenan completamente reales. Toda referencia generada por IA debe verificarse contra la fuente original antes de usarse."
    },
    {
      "question": "''En el competitivo mundo empresarial de hoy, la innovación disruptiva es clave para el éxito...'' ¿Qué problema tiene este texto?",
      "options": [
        "Es perfecto",
        "Tono genérico y exceso de adjetivos — suena a ''escrito por IA'' sin contexto específico",
        "Es demasiado formal",
        "Le faltan datos"
      ],
      "correct": 1,
      "explanation": "Frases genéricas con adjetivos vacíos (''competitivo'', ''disruptiva'', ''clave'') son señales de contenido sin especificidad. El prompt debería incluir contexto específico y pedir tono directo."
    },
    {
      "question": "Antes de enviar cualquier contenido generado por IA a un cliente, el paso más importante es:",
      "options": [
        "Pedirle a la IA que lo revise",
        "Que alguien con conocimiento del tema lo lea completamente y verifique hechos",
        "Pasarlo por un detector de IA",
        "Agregar un disclaimer de que fue generado por IA"
      ],
      "correct": 1,
      "explanation": "La revisión humana completa por alguien que conoce el tema es indispensable. Verifica hechos, tono, consistencia con la marca y que no haya información inventada."
    }
  ],
  "passing_score": 60,
  "exercise_type": "quiz",
  "difficulty": "intermediate",
  "estimated_duration_minutes": 5
}'::jsonb,
  5
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- Quiz 6: IA para decisiones estratégicas (Lección 6)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  '1a000000-0000-0000-0000-000000000001',
  '1a020000-0000-0000-0000-000000000001',
  '1a020300-0000-0000-0000-000000000001',
  'ia-ex-06',
  'quiz',
  '{
  "id": "ia-ex-06",
  "title": "IA para decisiones estratégicas",
  "description": "Aplica técnicas de sparring estratégico con IA y reconoce sus limitaciones.",
  "questions": [
    {
      "question": "¿Qué es un ''pre-mortem'' y cómo se aplica con IA?",
      "options": [
        "Análisis de datos pasados",
        "Imaginar que el proyecto fracasó y pedirle a la IA que identifique causas plausibles trabajando hacia atrás",
        "Predecir el éxito del proyecto",
        "Analizar la competencia post-lanzamiento"
      ],
      "correct": 1,
      "explanation": "La técnica de Gary Klein (2007): imaginas que el proyecto ya fracasó y trabajas hacia atrás para identificar causas. La IA genera críticas que tu equipo probablemente no se atrevería a hacer."
    },
    {
      "question": "Claude dice: ''El mercado de foodtech en Chile creció un 34% en 2025.'' ¿Qué debes hacer?",
      "options": [
        "Usarlo en tu presentación — Claude es confiable",
        "Verificar esa cifra en fuentes reales — puede ser una alucinación",
        "Redondear a 35% para que suene mejor",
        "Citar a Claude como fuente"
      ],
      "correct": 1,
      "explanation": "Los modelos pueden inventar estadísticas con total confianza. Toda cifra de mercado generada por IA debe verificarse contra fuentes primarias (reportes de industria, datos oficiales)."
    },
    {
      "question": "¿Por qué DeepSeek es ideal para las fases exploratorias de análisis competitivo?",
      "options": [
        "Es más preciso que Claude",
        "Permite muchas iteraciones a menor costo — ideal cuando necesitas 10-15 consultas sucesivas",
        "Tiene mejores datos de mercado",
        "Es más rápido"
      ],
      "correct": 1,
      "explanation": "El análisis competitivo iterativo requiere muchas consultas para refinar hipótesis. DeepSeek ofrece calidad competente a menor costo, ideal para exploración de alto volumen."
    },
    {
      "question": "La mayor limitación de usar IA como sparring estratégico es:",
      "options": [
        "Es muy lenta",
        "Carece de contexto local real — no conoce las dinámicas específicas de tu mercado",
        "Es demasiado cara",
        "Solo funciona en inglés"
      ],
      "correct": 1,
      "explanation": "Un modelo sabe que existe Perú, pero no conoce las dinámicas de negociar con distribuidores en Arequipa vs. Lima. El contexto hiperlocal solo lo tiene tu equipo."
    },
    {
      "question": "El ciclo óptimo humano + IA para estrategia es:",
      "options": [
        "IA decide, humano ejecuta",
        "Humano define pregunta → IA genera escenarios y críticas → humano verifica y decide → IA refina",
        "Humano y IA deciden por separado y comparan",
        "IA primero, humano revisa al final"
      ],
      "correct": 1,
      "explanation": "El humano aporta contexto real y juicio. La IA amplía la superficie de lo que se considera. El humano verifica y toma la decisión final. Es un ciclo iterativo, no lineal."
    }
  ],
  "passing_score": 60,
  "exercise_type": "quiz",
  "difficulty": "intermediate",
  "estimated_duration_minutes": 5
}'::jsonb,
  6
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- Quiz 7: Analiza la viabilidad de implementación (Lección 7)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  '1a000000-0000-0000-0000-000000000001',
  '1a030000-0000-0000-0000-000000000001',
  '1a030100-0000-0000-0000-000000000001',
  'ia-ex-07',
  'quiz',
  '{
  "id": "ia-ex-07",
  "title": "Analiza la viabilidad de implementación",
  "description": "Evalúa el caso de Distribuidora Centroamericana y analiza decisiones de implementación de IA.",
  "questions": [
    {
      "question": "Distribuidora Centroamericana empezó por automatizar atención al cliente (60% consultas repetitivas). ¿Por qué fue buena primera fase?",
      "options": [
        "Era lo más caro",
        "Alto impacto (48h→2h respuesta), bajo riesgo (solo consultas repetitivas), ROI rápido",
        "Porque Claude es el mejor modelo",
        "Porque era lo más fácil técnicamente"
      ],
      "correct": 1,
      "explanation": "La Fase 1 ideal combina alto impacto visible (mejora de 48h a 2h), bajo riesgo (solo automatiza lo repetitivo, escala lo complejo a humanos) y ROI demostrable en semanas."
    },
    {
      "question": "Eligieron DeepSeek self-hosted para documentación interna en lugar de Claude o Gemini. ¿La razón principal?",
      "options": [
        "Es más barato",
        "La documentación incluía información sensible (proveedores, márgenes, procesos propietarios) que no debía salir de la empresa",
        "Es más rápido",
        "DeepSeek escribe mejor documentación"
      ],
      "correct": 1,
      "explanation": "La documentación interna contenía información propietaria sensible. Al correr DeepSeek localmente, ningún dato sale de la infraestructura de la empresa."
    },
    {
      "question": "El insight más valioso del caso fue el análisis de Pareto (20% de clientes genera 80% de ingresos). ¿Qué herramienta lo reveló?",
      "options": [
        "Claude chatbot",
        "Gemini + Google Sheets — al consolidar y analizar datos de ventas que ya tenían",
        "DeepSeek",
        "Un consultor externo"
      ],
      "correct": 1,
      "explanation": "Gemini no generó datos nuevos — organizó y analizó los que ya existían en las hojas de cálculo dispersas. A veces la transformación no requiere datos sofisticados, sino dejar de ignorar los existentes."
    },
    {
      "question": "El ROI fue ~$7,800/mes con inversión de $350/mes. ¿Qué lección clave aporta este dato?",
      "options": [
        "Siempre hay que calcular ROI",
        "Para PyMEs, la barrera no es el costo de la IA ($350/mes) sino la percepción de que es inaccesible",
        "El ROI siempre será alto",
        "Solo funciona para distribuidoras"
      ],
      "correct": 1,
      "explanation": "Con costos de $350/mes, la pregunta no es si una PyME puede darse el lujo de implementar IA, sino si puede darse el lujo de no hacerlo. La barrera es percepción, no presupuesto."
    },
    {
      "question": "¿Cuál fue la lección más importante sobre el personal?",
      "options": [
        "Despidieron a los de atención al cliente",
        "La IA no reemplazó a nadie — liberó tiempo para que hicieran trabajo más valioso",
        "Contrataron especialistas en IA",
        "Redujeron el equipo en 50%"
      ],
      "correct": 1,
      "explanation": "Las 2 personas de atención al cliente ahora resuelven problemas complejos y fidelizan clientes, en lugar de responder preguntas repetitivas. La IA automatizó lo tedioso, no a las personas."
    }
  ],
  "passing_score": 60,
  "exercise_type": "quiz",
  "difficulty": "intermediate",
  "estimated_duration_minutes": 5
}'::jsonb,
  7
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- Quiz 8: Identifica riesgos y mitigaciones (Lección 8)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  '1a000000-0000-0000-0000-000000000001',
  '1a030000-0000-0000-0000-000000000001',
  '1a030200-0000-0000-0000-000000000001',
  'ia-ex-08',
  'quiz',
  '{
  "id": "ia-ex-08",
  "title": "Identifica riesgos y mitigaciones",
  "description": "Evalúa riesgos reales del uso de IA en negocios y propón mitigaciones adecuadas.",
  "questions": [
    {
      "question": "Un empleado pega el estado financiero completo de la empresa (no publicado) en ChatGPT para pedir un análisis. ¿Cuál es el riesgo principal?",
      "options": [
        "Que el análisis sea incorrecto",
        "Que información financiera confidencial esté ahora en servidores externos sin control",
        "Que ChatGPT no entienda contabilidad",
        "No hay riesgo si es la versión de pago"
      ],
      "correct": 1,
      "explanation": "Información financiera no publicada en servidores externos viola confidencialidad. Incluso si el proveedor no entrena con tus datos, los datos viajaron fuera de tu control."
    },
    {
      "question": "¿Cuál modelo ofrece máximo control sobre datos sensibles?",
      "options": [
        "Claude con acuerdo empresarial",
        "Gemini Enterprise",
        "DeepSeek self-hosted — los datos nunca salen de tu infraestructura",
        "Todos ofrecen el mismo nivel de privacidad"
      ],
      "correct": 2,
      "explanation": "Solo con modelos self-hosted (como DeepSeek) tienes control total. Los datos nunca salen de tu infraestructura. Claude y Gemini Enterprise ofrecen garantías contractuales, pero los datos viajan a sus servidores."
    },
    {
      "question": "Le pides a la IA que redacte un perfil de puesto para ''ingeniero de software'' y usa pronombres masculinos por defecto. ¿Qué tipo de riesgo es?",
      "options": [
        "Alucinación",
        "Sesgo en los outputs — la IA refleja prejuicios de sus datos de entrenamiento",
        "Error técnico",
        "Problema de formato"
      ],
      "correct": 1,
      "explanation": "Los modelos aprenden de texto existente que contiene sesgos. En reclutamiento, esto puede perpetuar discriminación de género. Siempre especifica lenguaje inclusivo en tus prompts."
    },
    {
      "question": "La ''regla del 70/30'' para uso de IA significa:",
      "options": [
        "70% de empresas usan IA",
        "Usa IA para 70% del trabajo mecánico, pero el 30% de criterio, verificación y decisión debe ser humano",
        "70% de los outputs son correctos",
        "30% del presupuesto para IA"
      ],
      "correct": 1,
      "explanation": "La IA maneja el trabajo mecánico (borradores, estructura, investigación). Pero el criterio profesional, la verificación de hechos y la decisión final son responsabilidad humana. Ese 30% es lo que justifica tu salario."
    },
    {
      "question": "En Panamá, aunque no hay ley específica de IA, ¿qué regulación ya aplica al enviar datos de clientes a un modelo de IA?",
      "options": [
        "Ninguna — no hay regulación de IA",
        "Ley 81 de Protección de Datos Personales (2019) — aplica independientemente de si procesa un humano o una IA",
        "Solo regulaciones de EE.UU.",
        "Solo aplica si usas DeepSeek"
      ],
      "correct": 1,
      "explanation": "La Ley 81 protege datos personales independientemente de cómo se procesen. Si envías datos personales de clientes a un modelo de IA, necesitas base legal para ese procesamiento."
    }
  ],
  "passing_score": 60,
  "exercise_type": "quiz",
  "difficulty": "intermediate",
  "estimated_duration_minutes": 5
}'::jsonb,
  8
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- Quiz 9: Quiz final: Tu plan de adopción de IA (Lección 9)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  '1a000000-0000-0000-0000-000000000001',
  '1a030000-0000-0000-0000-000000000001',
  '1a030300-0000-0000-0000-000000000001',
  'ia-ex-09',
  'quiz',
  '{
  "id": "ia-ex-09",
  "title": "Quiz final: Tu plan de adopción de IA",
  "description": "Integra todos los conceptos del curso para diseñar una estrategia de adopción de IA.",
  "questions": [
    {
      "question": "En la Fase 1 (Explorar), el error más común es:",
      "options": [
        "No usar suficientes modelos",
        "Sobre-planificar — crear documentos de 20 páginas en lugar de experimentar con un prompt y 10 minutos",
        "No tener presupuesto",
        "Elegir el modelo incorrecto"
      ],
      "correct": 1,
      "explanation": "La Fase 1 es exploración, no planificación. No necesitas un plan de 20 páginas para abrir Claude y probar un prompt. La parálisis por planificación mata más iniciativas de IA que los errores técnicos."
    },
    {
      "question": "Un empleado dice: ''La IA nos va a quitar el trabajo.'' ¿Cuál es la mejor forma de abordar esta resistencia?",
      "options": [
        "Ignorarlo — es inevitable",
        "Demostrar con casos concretos que la IA amplifica, no reemplaza. Mostrar cómo libera tiempo para trabajo más valioso",
        "Prometerle que nunca se usará IA en su área",
        "Mandarlo a un curso de programación"
      ],
      "correct": 1,
      "explanation": "El miedo al reemplazo se combate con evidencia, no con promesas. Muestra casos donde las personas hacen trabajo más valioso gracias a la IA (como en Distribuidora Centroamericana)."
    },
    {
      "question": "¿Cuál es la secuencia correcta del roadmap de 90 días?",
      "options": [
        "Explorar → Piloto → Escalar → Institucionalizar",
        "Planificar → Comprar → Implementar → Evaluar",
        "Capacitar → Implementar → Escalar → Evaluar",
        "Institucionalizar → Escalar → Piloto → Explorar"
      ],
      "correct": 0,
      "explanation": "Explorar (semanas 1-2) → Piloto (semanas 3-6) → Escalar (semanas 7-10) → Institucionalizar (semanas 11-12). De lo informal a lo formal, de lo individual a lo organizacional."
    },
    {
      "question": "¿Por qué los ''quick wins'' son importantes antes de la transformación profunda?",
      "options": [
        "Son más baratos",
        "Generan credibilidad y presupuesto para proyectos más ambiciosos",
        "Son más fáciles de medir",
        "Los directivos solo entienden quick wins"
      ],
      "correct": 1,
      "explanation": "Los quick wins (resumir documentos, generar borradores) demuestran valor en días y generan la credibilidad necesaria para obtener presupuesto y apoyo para la transformación profunda."
    },
    {
      "question": "Al final del curso, ¿cuál es el principio fundamental sobre IA en los negocios?",
      "options": [
        "La IA va a reemplazar a todos los profesionales",
        "La IA es una herramienta que amplifica capacidades humanas — su valor depende del criterio de quien la usa",
        "Hay que adoptar IA lo más rápido posible sin planificación",
        "Solo las empresas grandes pueden beneficiarse de la IA"
      ],
      "correct": 1,
      "explanation": "La IA generativa amplifica capacidades. Como toda herramienta, su valor depende de quién la usa, para qué y con qué criterio. El objetivo es augmentación, no reemplazo."
    },
    {
      "question": "Eres gerente de una PyME con 30 empleados. Quieres empezar con IA. ¿Cuál sería tu primer paso concreto mañana?",
      "options": [
        "Contratar un consultor de IA",
        "Elegir una tarea repetitiva que te quite tiempo, abrir Claude/Gemini gratis, y probar un prompt bien estructurado",
        "Crear un comité de IA con 5 personas",
        "Esperar a que la regulación esté clara"
      ],
      "correct": 1,
      "explanation": "No necesitas consultor, comité ni esperar regulación. Identifica una tarea repetitiva, abre una herramienta gratuita y experimenta. El primer paso es un prompt, no un plan."
    }
  ],
  "passing_score": 60,
  "exercise_type": "quiz",
  "difficulty": "advanced",
  "estimated_duration_minutes": 8
}'::jsonb,
  9
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- 5. Verificación
SELECT
    'Curso IA para Negocios Ágiles creado' as status,
    (SELECT COUNT(*) FROM courses WHERE slug = 'ia-negocios-agiles') as cursos,
    (SELECT COUNT(*) FROM modules WHERE course_id = '1a000000-0000-0000-0000-000000000001') as modulos,
    (SELECT COUNT(*) FROM lessons WHERE course_id = '1a000000-0000-0000-0000-000000000001') as lecciones,
    (SELECT COUNT(*) FROM course_exercises WHERE course_id = '1a000000-0000-0000-0000-000000000001') as ejercicios;
