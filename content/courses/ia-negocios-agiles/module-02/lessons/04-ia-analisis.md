## IA para análisis y síntesis

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
- Google DeepMind (2025). *Gemini Technical Report*.
