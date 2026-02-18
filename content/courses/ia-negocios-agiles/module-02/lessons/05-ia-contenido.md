## IA para contenido y comunicación

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
- Google (2025). *Gemini for Google Workspace: Enterprise Features*.
