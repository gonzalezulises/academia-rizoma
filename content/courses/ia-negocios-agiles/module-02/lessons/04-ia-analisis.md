## IA para analisis y sintesis

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
