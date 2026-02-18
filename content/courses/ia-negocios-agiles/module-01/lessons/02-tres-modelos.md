## Los tres modelos que debes conocer

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
