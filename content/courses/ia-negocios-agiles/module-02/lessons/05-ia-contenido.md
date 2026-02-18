## IA para contenido y comunicacion

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
