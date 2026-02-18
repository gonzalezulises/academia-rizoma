-- =====================================================
-- Seed: Curso "Métricas Ágiles — De la Medición a la Acción"
-- 2 módulos, 6 lecciones, 4 ejercicios
-- content_source = 'database' (contenido directo en DB)
-- Fuentes: rizo.ma/blog, rizo.ma/recursos, rizo.ma/impacto
-- =====================================================

-- 1. Insertar el curso
INSERT INTO courses (id, title, description, slug, thumbnail_url, is_published, content_source, content_status)
VALUES (
  'ae000000-0000-0000-0000-000000000001',
  'Métricas Ágiles — De la Medición a la Acción',
  'Aprende a diseñar métricas que realmente impulsen decisiones. Domina flujo de valor, Kanban, OKRs y las 4 métricas clave de equipos ágiles con casos reales de transformación en América Latina.',
  'metricas-agiles',
  '/images/courses/metricas-agiles-hero.webp',
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
    'ae010000-0000-0000-0000-000000000001',
    'ae000000-0000-0000-0000-000000000001',
    'Diseñando Métricas que Importan',
    'Aprende a distinguir métricas accionables de decorativas, mapea tu flujo de valor para encontrar cuellos de botella y domina las 4 métricas fundamentales de equipos ágiles.',
    1,
    false
  ),
  (
    'ae020000-0000-0000-0000-000000000001',
    'ae000000-0000-0000-0000-000000000001',
    'De la Medición a la Acción',
    'Aplica Kanban para gestionar el flujo visual, conecta OKRs con métricas operativas y analiza un caso real de transformación ágil en América Latina.',
    2,
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

-- ─────────────────────────────────────────────────────────────────────
-- MÓDULO 1, LECCIÓN 1: Métricas Accionables vs. Decorativas
-- ─────────────────────────────────────────────────────────────────────
(
  'ae010100-0000-0000-0000-000000000001',
  'ae000000-0000-0000-0000-000000000001',
  'ae010000-0000-0000-0000-000000000001',
  'Métricas Accionables vs. Decorativas',
  '## Métricas Accionables vs. Decorativas

### El problema que nadie quiere admitir

Abre el dashboard de tu organización. Cuenta los indicadores. Ahora hazte una pregunta incómoda: **¿cuántos de ellos cambiaron alguna decisión en los últimos 90 días?**

Bernard Marr, autor de *Key Performance Indicators* (2015), propone un test brutal: muestra cada indicador a los tomadores de decisiones y observa si **hacen algo diferente en los próximos 30 minutos**. Si asienten con la cabeza y pasan a la siguiente diapositiva, la métrica es decorativa.

Cuando este test se aplica a los 40 indicadores típicos de una revisión ejecutiva, rara vez sobreviven más de 12 — frecuentemente menos de 8.

### Teatro de dashboards

Existe un fenómeno que podemos llamar **teatro de dashboards**: revisiones ejecutivas que funcionan como ritual performativo en lugar de herramientas de decisión. Se crea la apariencia de control sin impulsar acción alguna.

Pfeffer y Sutton documentaron esto en *The Knowing-Doing Gap* (2000): las organizaciones sustituyen la acción real con la presentación de información sobre la acción necesaria. El dashboard se convierte en el fin, no en el medio.

> *"Las organizaciones que producen la mayor cantidad de indicadores frecuentemente son las que peor deciden — el volumen crea una ilusión de decisiones basadas en datos mientras el sesgo de confirmación opera con mayor eficacia cuando hay datos abundantes."*

### Las 3 características de una métrica accionable

Kaplan y Norton establecieron en *The Balanced Scorecard* (1996) que los indicadores deben conectarse causalmente con los resultados estratégicos. Pero ¿cómo saber si tu métrica realmente cumple ese requisito? Toda métrica accionable posee tres características:

#### 1. Umbral explícito

Un valor definido que dispara respuestas específicas. No basta con "monitorear" — debe existir un número que active un protocolo.

**Ejemplo:** Tasa de rotación de personal > 15% trimestral → revisión obligatoria de managers con entrevistas de salida en 48 horas.

Sin umbral, la métrica es solo un número en una pantalla. Con umbral, es un gatillo de acción.

#### 2. Dueño identificado

Una persona responsable de actuar, no solo de reportar. La diferencia es crítica: el analista que genera el reporte no es el dueño de la métrica — lo es quien tiene autoridad y responsabilidad para intervenir cuando el umbral se cruza.

#### 3. Frecuencia adecuada

Alineada con los ciclos de decisión. Una métrica diaria para una decisión trimestral genera ruido. Una métrica trimestral para una decisión diaria llega tarde. La frecuencia debe coincidir con la velocidad a la que puedes actuar.

### Goodhart''s Law: cuando la métrica se convierte en objetivo

Charles Goodhart formuló en 1975 una ley que toda organización debería tener enmarcada:

> *"Cuando una medida se convierte en objetivo, deja de ser una buena medida."*

Esto genera lo que llamamos **incentivos perversos**:

| Métrica como objetivo | Comportamiento perverso |
|---|---|
| Utilización (horas asignadas / disponibles) | Mantener personas ocupadas en lugar de producir resultados |
| Cantidad de proyectos completados | Fragmentar proyectos grandes en muchos pequeños |
| Velocidad del sprint (story points) | Inflar estimaciones para parecer más productivo |

### El proceso correcto: empezar por las decisiones

Peter Drucker advirtió: "Lo que se mide se gestiona" — pero omitimos la segunda parte de su reflexión: **medir lo incorrecto puede ser peor que no medir nada**.

El proceso recomendado:

1. **Inventariar** las decisiones ejecutivas recurrentes
2. **Identificar** qué información mejoraría la calidad o velocidad de esas decisiones
3. **Convertir** solo esa información en indicadores activos
4. **Mover** todo lo demás a reportes de referencia, disponibles bajo demanda

Un banco puede producir 200 indicadores regulatorios pero necesitar solo 20 para gestión real. Los 180 restantes pertenecen a reportes de cumplimiento, no al dashboard ejecutivo.

### Costo oculto de la medición

Las organizaciones rara vez calculan el costo total de su sistema de medición más allá de las licencias de software (Power BI, Tableau, Looker). El costo real incluye:

- **Horas-persona** para producir, validar y formatear cada indicador
- **Horas ejecutivas** para revisar indicadores que no generan acción
- **Costo de oportunidad** del tiempo que podría dedicarse a decisiones reales
- **Costo cognitivo** de procesar información irrelevante

### Reflexión

Antes de continuar con la siguiente lección, considera: ¿cuántos indicadores en tu organización pasarían el test de los 30 minutos de Marr? La respuesta honesta a esa pregunta es el primer paso hacia un sistema de métricas que realmente funcione.

---

**Referencias:**

- Kaplan, R. S. & Norton, D. P. (1996). *The Balanced Scorecard*
- Marr, B. (2015). *Key Performance Indicators: The 75 Measures Every Manager Needs to Know*
- Pfeffer, J. & Sutton, R. I. (2000). *The Knowing-Doing Gap*
- Goodhart, C. A. E. (1975). *Papers in Monetary Economics*
- Few, S. (2009). *Now You See It*',
  'text',
  1,
  20,
  true
),

-- ─────────────────────────────────────────────────────────────────────
-- MÓDULO 1, LECCIÓN 2: Flujo de Valor y Cuellos de Botella
-- ─────────────────────────────────────────────────────────────────────
(
  'ae010200-0000-0000-0000-000000000001',
  'ae000000-0000-0000-0000-000000000001',
  'ae010000-0000-0000-0000-000000000001',
  'Flujo de Valor y Cuellos de Botella',
  '## Flujo de Valor y Cuellos de Botella

### ¿Dónde se atora tu operación?

Eliyahu Goldratt lo estableció en *The Goal* (1984): **el rendimiento de un sistema está determinado por su restricción**. No por su mejor parte, no por el promedio — por su punto más débil.

La implicación práctica es contraintuitiva: mejorar cualquier punto que **no** sea la restricción crea acumulación de inventario aguas arriba o capacidad ociosa aguas abajo. Sin embargo, la mayoría de las iniciativas de mejora se enfocan exactamente ahí — en los puntos donde ya somos buenos.

### El flujo de valor: más que un diagrama

Un **flujo de valor** (value stream) es la secuencia completa de actividades que entrega un resultado al cliente. No es el proceso diseñado en el manual de calidad — es lo que **realmente sucede**, incluyendo:

- Tiempos de procesamiento (cuando alguien trabaja activamente)
- Tiempos de espera (cuando el trabajo está en cola)
- Transferencias entre departamentos (handoffs)
- Puntos de decisión y aprobación

El **Value Stream Mapping (VSM)** documenta este flujo tal como ocurre realmente, no como fue diseñado.

### La revelación incómoda: el tiempo de espera

Aquí viene el dato que cambia perspectivas. En organizaciones de servicio:

| Componente | Proporción del tiempo total |
|---|---|
| **Tiempo de espera** (colas, aprobaciones, transferencias) | **70-90%** |
| **Tiempo de procesamiento** (trabajo activo) | **10-30%** |

Lee eso de nuevo. Entre el 70% y el 90% del tiempo que toma completar un requerimiento, **nadie está trabajando en él**. Está en una bandeja de entrada, esperando aprobación, o en tránsito entre equipos.

La consecuencia matemática es devastadora:

| Intervención | Esfuerzo | Impacto en tiempo total |
|---|---|---|
| Acelerar procesamiento 50% | Alto | Solo **~10%** de reducción |
| Reducir esperas 25% | Medio | **~20%** de reducción |

Womack y Jones lo formalizaron en *Lean Thinking* (1996): **la optimización local degrada el rendimiento global**. Hacer que un departamento trabaje más rápido puede empeorar el sistema si crea colas más largas en el siguiente punto.

### Colas invisibles: el enemigo oculto

Donald Reinertsen, en *The Principles of Product Development Flow* (2009), identificó un problema fundamental del trabajo del conocimiento: **las colas son invisibles**.

En una fábrica, ves el inventario acumulándose físicamente. En una oficina, las colas se esconden en:

- Bandejas de correo electrónico
- Backlogs de tickets
- Solicitudes de aprobación pendientes
- Documentos "en revisión"

No puedes gestionar lo que no puedes ver.

### Los 3 cuellos de botella más comunes

En organizaciones de servicio, los cuellos de botella recurren en tres patrones:

#### 1. Colas de aprobación jerárquica

Gerentes con más solicitudes de aprobación que capacidad de atención. Cada aprobación individual toma minutos, pero la cola de espera puede durar días.

#### 2. Transferencias entre departamentos (handoffs)

Cada transferencia crea: una cola de entrada en el receptor, pérdida de contexto, y ciclos de clarificación. Un proceso que cruza 5 departamentos tiene al menos 5 colas invisibles.

#### 3. Recursos especializados compartidos

Un actuario, un abogado corporativo, un arquitecto de soluciones — expertos que participan en múltiples flujos simultáneamente. Mientras trabajan en un flujo, los demás esperan.

### Ley de Little: la matemática del flujo

John D.C. Little demostró en 1961 una relación elegante:

> **Cycle Time = WIP / Throughput**

Donde:
- **Cycle Time** = tiempo promedio que toma completar un ítem
- **WIP** (Work in Process) = cantidad de trabajo simultáneo en el sistema
- **Throughput** = ítems completados por unidad de tiempo

La implicación es poderosa: **reducir el trabajo simultáneo reduce el tiempo de ciclo sin necesidad de trabajar más rápido**. Si tienes 30 proyectos simultáneos pero capacidad para 10, cada proyecto tarda 3 veces más de lo necesario.

### Intervenciones que funcionan (y las que no)

David Anderson formalizó esto en *Kanban: Successful Evolutionary Change* (2010). Las intervenciones más efectivas son contraintuitivas:

**Más efectivas:**
- Reducir la demanda sobre la restricción (eliminar aprobaciones innecesarias)
- Eliminar pasos que no agregan valor
- Reducir el trabajo simultáneo (limitar WIP)
- Rediseñar para limitar los puntos donde la restricción interviene

**Menos efectivas:**
- Agregar más capacidad a la restricción (contratar más personas)
- Acelerar actividades que no son la restricción
- Mejorar velocidad de procesamiento en áreas de baja espera

En el sector regulado, **30-50% de los pasos del proceso no agregan valor** — existen por inercia histórica o por interpretaciones excesivas de normativa.

### Ejercicio de reflexión

Piensa en un requerimiento frecuente en tu equipo (un ticket, una solicitud, un entregable). Ahora estima:

- ¿Cuánto tiempo pasa **siendo procesado activamente**?
- ¿Cuánto tiempo pasa **esperando en alguna cola**?

Si la espera supera el 50% del tiempo total, tienes colas invisibles que gestionar.

<!-- exercise:ma-ex-02 -->

---

**Referencias:**

- Goldratt, E. M. (1984). *The Goal*
- Womack, J. P. & Jones, D. T. (1996). *Lean Thinking*
- Little, J. D. C. (1961). *A Proof for the Queuing Formula: L = λW*
- Reinertsen, D. G. (2009). *The Principles of Product Development Flow*
- Anderson, D. J. (2010). *Kanban: Successful Evolutionary Change*',
  'text',
  2,
  25,
  true
),

-- ─────────────────────────────────────────────────────────────────────
-- MÓDULO 1, LECCIÓN 3: Las 4 Métricas Clave de Equipos Ágiles
-- ─────────────────────────────────────────────────────────────────────
(
  'ae010300-0000-0000-0000-000000000001',
  'ae000000-0000-0000-0000-000000000001',
  'ae010000-0000-0000-0000-000000000001',
  'Las 4 Métricas Clave de Equipos Ágiles',
  '## Las 4 Métricas Clave de Equipos Ágiles

### De la teoría a la medición práctica

En las lecciones anteriores aprendiste a distinguir métricas accionables de decorativas y a identificar dónde se atora el flujo de valor. Ahora necesitas las métricas específicas que te permiten gestionar ese flujo.

Existen cuatro métricas fundamentales que todo equipo ágil debe dominar. No son las únicas, pero son las que proporcionan la base para todas las demás decisiones de gestión del trabajo.

### 1. Lead Time

**Definición:** Tiempo total desde que un cliente hace una solicitud hasta que recibe el resultado.

El lead time incluye **todo**: la espera en el backlog, la priorización, el procesamiento, las revisiones, las aprobaciones y la entrega. Es la métrica que el cliente experimenta — no le importa cuánto tiempo trabajaste; le importa cuánto tiempo esperó.

**¿Por qué importa?**

- Es la promesa implícita que haces a tu cliente
- La variabilidad del lead time destruye la confianza más que un lead time alto pero predecible
- Un mismo tipo de solicitud puede tomar entre 3 y 30 días dependiendo de circunstancias — esa variabilidad es síntoma de un sistema no gestionado

**Umbral accionable (ejemplo):** Lead time promedio de solicitudes tipo A > 10 días → revisar colas de aprobación y WIP.

### 2. Cycle Time

**Definición:** Tiempo desde que alguien empieza a trabajar activamente en un ítem hasta que lo completa.

La diferencia con lead time es crucial: **cycle time excluye el tiempo de espera**. Si el lead time de un ticket es 15 días pero el cycle time es 2 días, el trabajo real toma 2 días — los otros 13 son colas.

**¿Por qué importa?**

- Mide la eficiencia real de tu proceso de trabajo
- Si el cycle time es estable pero el lead time crece, el problema no es productividad — es congestión
- Es la base para hacer predicciones probabilísticas de entrega

**Relación con lead time:**

```
Lead Time = Cycle Time + Tiempo de Espera
```

Si Lead Time >> Cycle Time, tu problema son las colas, no la velocidad de trabajo.

### 3. Throughput

**Definición:** Cantidad de ítems completados por unidad de tiempo (semana, sprint, mes).

Throughput no mide esfuerzo ni horas trabajadas — mide **resultados entregados**. Un equipo que completa 8 historias por sprint de manera consistente tiene un throughput predecible, independientemente de las horas invertidas.

**¿Por qué importa?**

- Es la base para planificación y forecasting
- Un throughput decreciente señala problemas sistémicos (dependencias, deuda técnica, rotación)
- Combinado con WIP y cycle time via la Ley de Little, permite diagnosticar el sistema completo

### 4. WIP (Work in Process)

**Definición:** Cantidad de ítems que están siendo procesados simultáneamente en un momento dado.

Recuerda la Ley de Little de la lección anterior:

> **Cycle Time = WIP / Throughput**

Si tu throughput es 10 ítems por semana y tienes 30 ítems en proceso, cada ítem tardará en promedio 3 semanas. Reduce WIP a 15 y el cycle time baja a 1.5 semanas — **sin trabajar más rápido**.

**¿Por qué importa?**

- Es la palanca más directa para reducir cycle time
- WIP alto genera context switching, que degrada la calidad y la velocidad
- Limitar WIP hace visible la congestión del sistema — y eso genera conversaciones incómodas pero necesarias

### Cómo se relacionan entre sí

Las 4 métricas forman un sistema interconectado:

```
                    ┌─────────────┐
                    │  Lead Time  │
                    │  (cliente)  │
                    └──────┬──────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
     ┌────────▼───┐  ┌─────▼─────┐  ┌──▼──────────┐
     │ Cycle Time │  │  Espera   │  │ Variabilidad│
     │ (equipo)   │  │  (colas)  │  │ (confianza) │
     └────────┬───┘  └───────────┘  └─────────────┘
              │
     ┌────────▼────────────────┐
     │   WIP ↔ Throughput      │
     │   (Ley de Little)       │
     └─────────────────────────┘
```

- **Reducir WIP** → reduce **Cycle Time** → reduce **Lead Time**
- **Throughput estable** + **WIP controlado** = **Lead Time predecible**
- **Lead Time predecible** = **confianza del cliente**

### Anti-patrón: métricas de actividad vs. métricas de flujo

| Métrica de actividad (decorativa) | Métrica de flujo (accionable) |
|---|---|
| Horas trabajadas | Throughput |
| Story points completados | Cycle time |
| % de utilización | WIP |
| Reuniones realizadas | Lead time |
| Tickets creados | Tickets completados |

Las métricas de actividad miden esfuerzo. Las métricas de flujo miden resultado. Un equipo puede estar 100% utilizado y entregar cero valor si todo su trabajo está en proceso y nada se completa.

### Quiz: ¿Accionable o decorativa?

Pon a prueba tu comprensión identificando qué métricas cumplen con las 3 características de una métrica accionable (umbral, dueño, frecuencia) y cuáles son teatro de dashboards.

<!-- exercise:ma-ex-01 -->

---

**Referencias:**

- Anderson, D. J. (2010). *Kanban: Successful Evolutionary Change*
- Reinertsen, D. G. (2009). *The Principles of Product Development Flow*
- Little, J. D. C. (1961). *A Proof for the Queuing Formula: L = λW*',
  'text',
  3,
  20,
  true
),

-- ─────────────────────────────────────────────────────────────────────
-- MÓDULO 2, LECCIÓN 4: Kanban: Gestión Visual del Flujo
-- ─────────────────────────────────────────────────────────────────────
(
  'ae020100-0000-0000-0000-000000000001',
  'ae000000-0000-0000-0000-000000000001',
  'ae020000-0000-0000-0000-000000000001',
  'Kanban: Gestión Visual del Flujo',
  '## Kanban: Gestión Visual del Flujo

### De las colas invisibles al tablero visible

En el módulo anterior establecimos que las colas invisibles dominan el tiempo de proceso en organizaciones de servicio (70-90% del tiempo total). Kanban ataca exactamente ese problema: **hace visible lo invisible**.

David Anderson formalizó Kanban para el trabajo del conocimiento en *Kanban: Successful Evolutionary Change* (2010), adaptando los principios del sistema de producción de Toyota al contexto de servicios, tecnología y trabajo creativo.

### Los 3 pilares de un sistema Kanban

#### 1. Visualización del trabajo

Un tablero Kanban no es una lista de tareas bonita — es una **radiografía del sistema de trabajo**. Cada columna representa un estado real del proceso:

```
┌──────────┬───────────┬──────────┬──────────┬──────────┐
│ Backlog  │ Análisis  │ En Curso │ Revisión │  Hecho   │
│          │           │          │          │          │
│ ┌──────┐ │ ┌──────┐  │ ┌──────┐ │ ┌──────┐ │ ┌──────┐ │
│ │ T-12 │ │ │ T-08 │  │ │ T-05 │ │ │ T-03 │ │ │ T-01 │ │
│ └──────┘ │ └──────┘  │ │ T-06 │ │ └──────┘ │ │ T-02 │ │
│ ┌──────┐ │           │ │ T-07 │ │          │ └──────┘ │
│ │ T-13 │ │           │ └──────┘ │          │          │
│ └──────┘ │           │          │          │          │
│          │  WIP: 1   │  WIP: 3  │  WIP: 1  │          │
└──────────┴───────────┴──────────┴──────────┴──────────┘
```

Lo que revela el tablero:
- **Acumulaciones** — ¿dónde se amontonan las tarjetas?
- **Cuellos de botella** — ¿qué columna está siempre llena?
- **Trabajo bloqueado** — ¿qué ítems no avanzan?
- **WIP real** — ¿cuántas cosas tenemos en vuelo?

#### 2. Límites de WIP (Work in Process)

Aquí es donde Kanban se diferencia de un simple tablero de tareas. **Limitar el WIP** significa establecer un número máximo de ítems que pueden estar en cada columna simultáneamente.

Recuerda la Ley de Little: Cycle Time = WIP / Throughput. Si fijas el throughput (determinado por la capacidad del equipo) y reduces WIP, el cycle time **baja automáticamente**.

**¿Qué pasa cuando una columna alcanza su límite WIP?**

El equipo no puede empezar trabajo nuevo — debe terminar algo primero. Esto genera una presión saludable que:

- Fuerza a resolver bloqueos en lugar de ignorarlos
- Reduce context switching
- Hace que los cuellos de botella sean imposibles de ignorar
- Promueve la colaboración (si "mi" columna está llena, ayudo en otra)

#### 3. Políticas explícitas

Las políticas explícitas son las reglas del juego documentadas y visibles. No asumen que "todos saben cómo funciona":

- **Definición de "Listo":** ¿Cuándo puede un ítem moverse de una columna a la siguiente?
- **Priorización:** ¿Cómo se decide qué entra al sistema?
- **Escalamiento:** ¿Qué hacer cuando un ítem lleva más de X días bloqueado?
- **Clases de servicio:** ¿Cómo se manejan urgencias vs. trabajo normal?

Sin políticas explícitas, cada persona interpreta el proceso a su manera — y las inconsistencias se acumulan silenciosamente.

### Kanban no es Scrum

Una confusión frecuente. Las diferencias clave:

| Aspecto | Scrum | Kanban |
|---|---|---|
| Cadencia | Sprints fijos (1-4 semanas) | Flujo continuo |
| Roles | Product Owner, Scrum Master, Dev Team | No prescribe roles |
| Planificación | Sprint Planning cada iteración | Bajo demanda (pull) |
| Cambios | Protegidos durante el sprint | Bienvenidos en cualquier momento |
| Métrica principal | Velocidad (story points) | Cycle time, throughput |
| Mejor para | Desarrollo de producto | Operaciones, soporte, flujo variable |

No son mutuamente excluyentes — muchos equipos usan **Scrumban** (sprints de Scrum + límites WIP de Kanban).

### Checklist de prácticas de flujo

Para evaluar la madurez de las prácticas Kanban de tu equipo, puedes usar el [Checklist de Flujo Kanban](https://rizo.ma/recursos/checklist-flujo-kanban) — una herramienta gratuita con 36 puntos de evaluación organizados en 5 dimensiones:

1. **Visualización** — ¿El tablero refleja la realidad?
2. **Límites WIP** — ¿Existen y se respetan?
3. **Gestión del flujo** — ¿Se miden cycle time y throughput?
4. **Políticas explícitas** — ¿Están documentadas y visibles?
5. **Mejora continua** — ¿Se revisan y ajustan las prácticas?

El checklist genera un reporte inmediato sin necesidad de registro.

### Las señales de alerta

Estas situaciones indican que tu sistema Kanban necesita ajuste:

- **Tarjetas que no se mueven** durante días (bloqueos no gestionados)
- **Límites WIP que "siempre" se exceden** (límites decorativos, no reales)
- **Columna "En Revisión" permanentemente llena** (cuello de botella en aprobaciones)
- **Todo es "urgente"** (falta de políticas de clases de servicio)
- **El tablero no se actualiza** (la herramienta no refleja la realidad)

### Ejercicio de reflexión

Piensa en el proceso de trabajo de tu equipo actual:

1. ¿Podrías dibujar las columnas de un tablero Kanban que represente **cómo realmente fluye** el trabajo (no cómo debería)?
2. ¿En qué columna se acumula más trabajo?
3. Si tuvieras que poner un límite WIP en cada columna, ¿cuál sería?

No hay respuestas correctas — el ejercicio es hacer visible lo que hoy es invisible.

---

**Referencias:**

- Anderson, D. J. (2010). *Kanban: Successful Evolutionary Change*
- Herramienta: [Checklist de Flujo Kanban — rizo.ma](https://rizo.ma/recursos/checklist-flujo-kanban)',
  'text',
  4,
  25,
  true
),

-- ─────────────────────────────────────────────────────────────────────
-- MÓDULO 2, LECCIÓN 5: OKRs como Mecanismo de Gobernanza
-- ─────────────────────────────────────────────────────────────────────
(
  'ae020200-0000-0000-0000-000000000001',
  'ae000000-0000-0000-0000-000000000001',
  'ae020000-0000-0000-0000-000000000001',
  'OKRs como Mecanismo de Gobernanza',
  '## OKRs como Mecanismo de Gobernanza

### El puente entre estrategia y operación

Las métricas que aprendiste en el Módulo 1 (lead time, cycle time, throughput, WIP) son operativas — te dicen cómo está funcionando el equipo hoy. Pero ¿cómo conectas esas métricas con los objetivos estratégicos de la organización?

Ahí es donde entran los **OKRs (Objectives and Key Results)** — no como otra herramienta de moda, sino como el mecanismo que conecta la dirección estratégica con la realidad operativa medible.

### Qué son los OKRs (y qué no son)

Un OKR tiene dos componentes:

- **Objective (O):** Una dirección cualitativa, inspiradora y ambiciosa. Responde a "¿hacia dónde vamos?"
- **Key Results (KR):** Resultados cuantitativos y medibles que demuestran progreso hacia el objetivo. Responden a "¿cómo sabemos que estamos avanzando?"

**Ejemplo bien formulado:**

```
Objective: Entregar valor predecible a nuestros clientes internos

KR1: Reducir lead time promedio de solicitudes tipo A de 15 a 8 días
KR2: Reducir variabilidad del lead time (desviación estándar) de 7 a 3 días
KR3: Mantener throughput semanal ≥ 12 ítems completados
```

Observa cómo los Key Results se conectan directamente con las métricas de flujo del Módulo 1. No son métricas inventadas — son las mismas métricas operativas elevadas a nivel estratégico.

### Cadencia de revisión: el ritmo de la gobernanza

Los OKRs sin cadencia de revisión son decorativos. La cadencia recomendada:

| Cadencia | Actividad | Participantes |
|---|---|---|
| **Semanal** | Check-in de métricas operativas (cycle time, WIP, throughput) | Equipo |
| **Mensual** | Revisión de progreso de Key Results | Equipo + Líder |
| **Trimestral** | Evaluación de Objectives y definición de nuevos OKRs | Líderes + Stakeholders |

La clave es que cada nivel de cadencia **alimenta al siguiente**. Las métricas semanales informan el progreso mensual de Key Results, que a su vez valida o invalida los Objectives trimestrales.

### OKRs conectados a métricas operativas

El error más común es definir OKRs desconectados de la operación real. Compara:

| OKR desconectado | OKR conectado |
|---|---|
| KR: "Completar proyecto X para marzo" | KR: "Reducir cycle time de features de 12 a 6 días" |
| KR: "Lanzar 3 nuevos productos" | KR: "Throughput de releases ≥ 2 por semana" |
| KR: "Mejorar satisfacción del cliente a 4.5" | KR: "Lead time de soporte < 24 horas en el 90% de tickets" |

Los OKRs de la columna izquierda miden **entregables** (outputs). Los de la derecha miden **capacidades del sistema** (outcomes). La diferencia es que las capacidades persisten: un equipo que logra cycle time de 6 días mantiene esa capacidad para cualquier proyecto futuro.

### Anti-patrones de OKRs

#### 1. OKRs como lista de tareas disfrazada

```
❌ Objective: Modernizar la plataforma
   KR1: Migrar base de datos a PostgreSQL
   KR2: Implementar API REST
   KR3: Rediseñar el frontend

✅ Objective: Acelerar la entrega de nuevas funcionalidades
   KR1: Reducir tiempo de deploy de 4 horas a 15 minutos
   KR2: Cycle time de bug fixes < 48 horas
   KR3: Zero downtime en deployments (99.9% uptime)
```

#### 2. Demasiados OKRs

Si tienes más de 3 Objectives con 3-5 Key Results cada uno, tienes demasiados. Los OKRs son sobre **foco** — decidir qué es lo más importante **ahora**, no listar todo lo que podrías hacer.

#### 3. Key Results sin dueño

Cada Key Result necesita una persona que responda por él — no que lo "monitoree", sino que tenga autoridad y responsabilidad para intervenir cuando la métrica se desvía. Exactamente como las métricas accionables de la Lección 1.

#### 4. OKRs que nunca cambian

Si tus OKRs trimestrales siempre se logran al 100%, no son ambiciosos. Si nunca se logran, no son realistas. El rango saludable es 60-70% de logro — suficientemente ambicioso para estirar, suficientemente realista para mantener la motivación.

### OKRs y Toyota Kata

En el caso del Canal de Panamá, los equipos usaron **Toyota Kata** junto con OKRs para crear un ciclo de mejora continua:

1. **Dirección** (Objective): ¿Hacia dónde queremos ir?
2. **Condición actual** (métricas actuales): ¿Dónde estamos hoy?
3. **Siguiente condición objetivo** (Key Result): ¿Cuál es el próximo paso medible?
4. **Experimento** (PDCA): ¿Qué acción tomamos para cerrar la brecha?

Este ciclo se repite semanalmente, creando un ritmo de mejora continua basado en evidencia, no en intuición.

### Quiz: Diseñando OKRs conectados

Pon a prueba tu capacidad para diseñar OKRs que se conecten con métricas operativas reales.

<!-- exercise:ma-ex-03 -->

---

**Referencias:**

- Doerr, J. (2018). *Measure What Matters*
- Rother, M. (2009). *Toyota Kata*
- Caso de referencia: Canal de Panamá — Coaching Ágil (2021-2023)',
  'text',
  5,
  20,
  true
),

-- ─────────────────────────────────────────────────────────────────────
-- MÓDULO 2, LECCIÓN 6: Caso Integrador — Transformación Ágil en LATAM
-- ─────────────────────────────────────────────────────────────────────
(
  'ae020300-0000-0000-0000-000000000001',
  'ae000000-0000-0000-0000-000000000001',
  'ae020000-0000-0000-0000-000000000001',
  'Caso Integrador: Transformación Ágil en LATAM',
  '## Caso Integrador: Transformación Ágil en LATAM

### Introducción

A lo largo de este curso has aprendido a distinguir métricas accionables de decorativas, a identificar cuellos de botella en el flujo de valor, a usar las 4 métricas clave de equipos ágiles, a gestionar el flujo con Kanban y a conectar OKRs con métricas operativas.

Ahora es momento de integrar todo en un caso real. Este caso combina elementos de dos transformaciones ágiles en América Latina: una institución gubernamental de infraestructura crítica y una aseguradora regional.

---

### Caso: Operaciones Ágiles en el Sector Público y Financiero

#### Contexto A: Institución de Infraestructura Crítica

Una organización gubernamental responsable de una de las infraestructuras más complejas de América Latina enfrentaba un desafío: sus equipos de operaciones y mantenimiento utilizaban procesos diseñados décadas atrás. La gestión era reactiva, los tiempos de respuesta eran impredecibles y no existían métricas de flujo.

**Situación inicial:**

- Solicitudes de mantenimiento con lead time de 5 a 45 días (variabilidad extrema)
- Sin visibilidad del WIP real — cada equipo tenía su propia lista informal
- Aprobaciones jerárquicas de 3 niveles para cualquier intervención
- Reportes mensuales de 200+ indicadores que nadie leía
- Cultura de "todo es urgente" — sin priorización sistemática

**Intervención (2021-2023):**

Se implementó un programa de coaching ágil basado en tres ejes:

1. **Value Stream Mapping** — Se mapearon los flujos reales de solicitudes de mantenimiento. El hallazgo clave: el 78% del lead time era tiempo de espera en colas de aprobación. El trabajo activo representaba solo el 22%.

2. **Toyota Kata** — Se establecieron ciclos PDCA semanales con equipos piloto. Cada equipo definió su "condición actual" con métricas de flujo (lead time, cycle time, WIP) y una "condición objetivo" a 4 semanas.

3. **OKRs operativos** — Se reemplazaron los 200 indicadores con 3 OKRs trimestrales:

```
Objective: Respuesta predecible a solicitudes de mantenimiento

KR1: Lead time promedio ≤ 10 días (desde 25 días)
KR2: Variabilidad (desviación estándar) ≤ 5 días (desde 15 días)
KR3: 0 solicitudes con más de 30 días sin resolución
```

**Resultados a 18 meses:**

| Métrica | Antes | Después |
|---|---|---|
| Lead time promedio | 25 días | 11 días |
| Variabilidad (σ) | 15 días | 6 días |
| Solicitudes > 30 días | 23% | 4% |
| Indicadores activos | 200+ | 18 |
| Nivel de aprobación | 3 niveles | 1 nivel (< $5K) |

---

#### Contexto B: Aseguradora Regional

Una aseguradora con operaciones en Centroamérica enfrentaba tiempos de entrega excesivos en su área de tecnología. Los equipos de desarrollo usaban un proceso "waterfall disfrazado de ágil" — tenían sprints, pero sin métricas de flujo ni límites de WIP.

**Situación inicial:**

- Cycle time de features: 35 días promedio
- Releases: 1 cada 6-8 semanas
- 40+ proyectos simultáneos para un equipo de 25 personas
- Sprint velocity como única métrica (decorativa — sin umbral ni dueño)
- Dependencias entre equipos no gestionadas

**Intervención (2018-2020):**

Se diseñó un framework ágil para la entrega de tecnología basado en Scrum + Kanban:

1. **Visualización del flujo** — Se implementaron tableros Kanban por equipo y un tablero de programa que mostraba dependencias. Por primera vez, todos podían ver dónde se acumulaba el trabajo.

2. **Límites WIP agresivos** — Se redujo de 40 a 15 proyectos simultáneos. Los 25 proyectos restantes se movieron a un backlog priorizado. La reacción inicial fue resistencia ("no podemos pausar esos proyectos"), pero la Ley de Little demostró que 40 proyectos simultáneos significaban que cada uno tardaba 2.7 veces más de lo necesario.

3. **Métricas accionables** — Se reemplazó sprint velocity con:

| Métrica | Umbral | Dueño | Frecuencia |
|---|---|---|---|
| Cycle time de features | > 20 días → investigar bloqueos | Tech Lead | Semanal |
| Throughput semanal | < 5 ítems → revisar WIP y bloqueos | Scrum Master | Semanal |
| Lead time de bugs críticos | > 48 horas → escalamiento automático | Engineering Manager | Diario |

**Resultados a 24 meses:**

| Métrica | Antes | Después |
|---|---|---|
| Cycle time de features | 35 días | 12 días |
| Releases | 1/6-8 semanas | 1/semana |
| Proyectos simultáneos (WIP) | 40+ | 12-15 |
| Throughput semanal | 3-4 ítems | 8-10 ítems |
| Predictabilidad | ±20 días | ±4 días |

La paradoja: **haciendo menos cosas a la vez, completaban más cosas por semana.**

---

### Patrones comunes entre ambos casos

A pesar de ser contextos completamente diferentes (gobierno vs. sector financiero, mantenimiento vs. tecnología), los patrones son notablemente similares:

| Patrón | Institución pública | Aseguradora |
|---|---|---|
| Problema central | Colas invisibles de aprobación | WIP excesivo sin límites |
| Intervención clave | Reducir niveles de aprobación | Reducir proyectos simultáneos |
| Métrica ignorada | Tiempo de espera | Cycle time (usaban velocity) |
| Resistencia principal | "Necesitamos control" | "No podemos pausar proyectos" |
| Resultado contraintuitivo | Menos control → más predecibilidad | Menos proyectos → más entregas |

### Lecciones transversales

1. **Empezar por hacer visible el flujo actual** — No diseñar el proceso ideal, sino mapear lo que realmente ocurre.

2. **Reducir antes que agregar** — La primera intervención siempre es quitar (aprobaciones innecesarias, WIP excesivo, indicadores decorativos), no agregar (más personas, más herramientas, más reportes).

3. **Pocas métricas, bien elegidas** — 18 indicadores accionables generan más impacto que 200 decorativos.

4. **La resistencia es información** — Las objeciones revelan los supuestos del sistema actual. "Necesitamos 3 niveles de aprobación" revela una cultura de desconfianza. "No podemos pausar proyectos" revela compromisos no priorizados.

5. **Resultados contraintuitivos son la norma** — Menos control genera más predecibilidad. Menos proyectos generan más entregas. Menos métricas generan mejores decisiones.

---

### Evaluación para madurez ágil

Si quieres evaluar la madurez ágil de tu organización, puedes usar el [Assessment de Madurez Ágil](https://rizo.ma/recursos/assessment-madurez-agil) — una herramienta gratuita con 25 preguntas organizadas en 5 dimensiones clave, con resultados inmediatos.

---

### Caso de estudio: Tu turno

Ahora es tu turno de aplicar lo aprendido. En el siguiente ejercicio, analizarás un escenario basado en los patrones de estos casos y propondrás intervenciones usando las herramientas del curso.

<!-- exercise:ma-ex-04 -->

---

**Referencias:**

- Caso de referencia: Canal de Panamá — Coaching Ágil y Data Analytics (2021-2024)
- Caso de referencia: Seguros SURA — Framework Ágil de Entrega (2018-2020)
- Herramienta: [Assessment de Madurez Ágil — rizo.ma](https://rizo.ma/recursos/assessment-madurez-agil)
- Rother, M. (2009). *Toyota Kata*
- Anderson, D. J. (2010). *Kanban: Successful Evolutionary Change*',
  'text',
  6,
  30,
  true
)

ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  lesson_type = EXCLUDED.lesson_type,
  order_index = EXCLUDED.order_index,
  duration_minutes = EXCLUDED.duration_minutes;

-- 4. Insertar ejercicios embebidos en course_exercises

-- Quiz: Métricas accionables vs decorativas (Lección 1.3)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  'ae000000-0000-0000-0000-000000000001',
  'ae010000-0000-0000-0000-000000000001',
  'ae010300-0000-0000-0000-000000000001',
  'ma-ex-01',
  'quiz',
  '{
    "id": "ma-ex-01",
    "title": "¿Accionable o Decorativa?",
    "description": "Identifica cuáles de las siguientes métricas cumplen con las 3 características de una métrica accionable (umbral explícito, dueño identificado, frecuencia adecuada).",
    "questions": [
      {
        "question": "\"Tasa de rotación de personal\": se muestra en el dashboard mensual del CEO. No tiene umbral definido ni persona asignada para actuar.",
        "options": ["Accionable", "Decorativa"],
        "correct": 1,
        "explanation": "Sin umbral ni dueño, es decorativa. El CEO la ve pero nadie tiene la responsabilidad específica de actuar cuando cruza cierto valor."
      },
      {
        "question": "\"Cycle time de tickets de soporte > 48h\": dispara alerta automática al Team Lead, quien debe investigar bloqueos dentro de 24h. Se revisa diariamente.",
        "options": ["Accionable", "Decorativa"],
        "correct": 0,
        "explanation": "Cumple las 3 características: umbral (> 48h), dueño (Team Lead), frecuencia (diaria). Es una métrica accionable."
      },
      {
        "question": "\"NPS (Net Promoter Score) trimestral\": se presenta en la junta directiva. Se analiza la tendencia histórica.",
        "options": ["Accionable", "Decorativa"],
        "correct": 1,
        "explanation": "Aunque es una métrica valiosa, tal como se describe no tiene umbral de acción ni dueño que intervenga. Se observa pero no dispara acciones específicas."
      },
      {
        "question": "\"WIP > 15 ítems en la columna En Curso\": el Scrum Master pausa nuevas entradas y convoca revisión de bloqueos. Se verifica en el standup diario.",
        "options": ["Accionable", "Decorativa"],
        "correct": 0,
        "explanation": "Umbral (> 15), dueño (Scrum Master), frecuencia (diaria), y acción definida (pausar entradas + revisar bloqueos). Perfectamente accionable."
      },
      {
        "question": "\"Cantidad de story points completados por sprint\": se reporta al final de cada sprint. Se compara con sprints anteriores.",
        "options": ["Accionable", "Decorativa"],
        "correct": 1,
        "explanation": "Los story points sin umbral, dueño ni acción definida son una métrica de actividad, no de flujo. Comparar con sprints anteriores es informativo pero no dispara intervención."
      }
    ],
    "passing_score": 60,
    "exercise_type": "quiz",
    "difficulty": "intermediate",
    "estimated_duration_minutes": 10
  }'::jsonb,
  1
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- Reflection: Colas invisibles (Lección 2.1)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  'ae000000-0000-0000-0000-000000000001',
  'ae010000-0000-0000-0000-000000000001',
  'ae010200-0000-0000-0000-000000000001',
  'ma-ex-02',
  'reflection',
  '{
    "id": "ma-ex-02",
    "title": "¿Dónde están las colas invisibles en tu equipo?",
    "description": "Reflexiona sobre el flujo de trabajo de tu equipo e identifica las colas invisibles que consumen tiempo sin agregar valor.",
    "prompts": [
      {
        "question": "Piensa en un tipo de solicitud frecuente en tu equipo (ticket, feature, reporte). Describe brevemente el flujo desde que se solicita hasta que se entrega.",
        "min_words": 30,
        "placeholder": "Ejemplo: Un ticket de soporte llega por email, se registra en Jira, se asigna en el standup, se trabaja, se revisa por QA, se despliega..."
      },
      {
        "question": "Estima qué porcentaje del lead time total es tiempo de espera (colas, aprobaciones, transferencias) vs. tiempo de trabajo activo.",
        "min_words": 15,
        "placeholder": "Ejemplo: Creo que el 70% es espera — sobre todo entre la asignación y que alguien realmente empieza a trabajar en él..."
      },
      {
        "question": "Identifica la cola más grande (donde más tiempo se acumula). ¿Qué la causa? ¿Qué acción concreta podrías tomar para reducirla?",
        "min_words": 30,
        "placeholder": "Ejemplo: La cola más grande es la espera de code review. La causa es que solo 2 personas hacen reviews para un equipo de 8. Podríamos..."
      }
    ],
    "exercise_type": "reflection",
    "difficulty": "intermediate",
    "estimated_duration_minutes": 15
  }'::jsonb,
  1
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- Quiz: Diseñar OKRs conectados a métricas (Lección 2.2)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  'ae000000-0000-0000-0000-000000000001',
  'ae020000-0000-0000-0000-000000000001',
  'ae020200-0000-0000-0000-000000000001',
  'ma-ex-03',
  'quiz',
  '{
    "id": "ma-ex-03",
    "title": "Diseñando OKRs Conectados",
    "description": "Evalúa tu comprensión de cómo conectar OKRs con métricas operativas reales. Identifica los OKRs bien formulados y los anti-patrones.",
    "questions": [
      {
        "question": "¿Cuál de estos Key Results está mejor conectado con métricas operativas?",
        "options": [
          "Completar la migración a microservicios para Q2",
          "Reducir cycle time de features de 20 a 8 días",
          "Implementar 3 nuevos pipelines de CI/CD",
          "Capacitar al 100% del equipo en Kubernetes"
        ],
        "correct": 1,
        "explanation": "Reducir cycle time mide una capacidad del sistema (outcome), no un entregable específico (output). Los otros son tareas disfrazadas de Key Results."
      },
      {
        "question": "Un equipo tiene este OKR: ''Objetivo: Ser el equipo más rápido de la empresa. KR1: Completar 200 story points por sprint''. ¿Qué anti-patrón representa?",
        "options": [
          "OKR sin cadencia de revisión",
          "Goodhart''s Law — la métrica se convierte en objetivo y se infla",
          "OKR demasiado ambicioso",
          "Key Result sin dueño"
        ],
        "correct": 1,
        "explanation": "Story points como objetivo incentivan inflar estimaciones (Goodhart''s Law). Además, ''más rápido'' medido en puntos no refleja valor entregado al cliente."
      },
      {
        "question": "¿Con qué frecuencia deben revisarse las métricas operativas que alimentan los OKRs?",
        "options": [
          "Trimestralmente, junto con los OKRs",
          "Mensualmente, en la revisión de progreso",
          "Semanalmente, para detectar desviaciones a tiempo",
          "Diariamente, en cada standup"
        ],
        "correct": 2,
        "explanation": "Las métricas operativas (cycle time, WIP, throughput) se revisan semanalmente. Las revisiones de Key Results son mensuales. Los OKRs se evalúan trimestralmente. Cada nivel alimenta al siguiente."
      },
      {
        "question": "Un OKR tiene 5 Objectives con 5 Key Results cada uno (25 KR en total). ¿Cuál es el problema principal?",
        "options": [
          "Los Key Results no son medibles",
          "Falta de foco — demasiados OKRs diluyen la atención y el esfuerzo",
          "No hay suficientes dueños para cada KR",
          "La cadencia trimestral es insuficiente para tantos KR"
        ],
        "correct": 1,
        "explanation": "La recomendación es máximo 3 Objectives con 3-5 Key Results cada uno. 25 KR significa que nada es realmente prioritario — los OKRs son sobre foco, no sobre exhaustividad."
      }
    ],
    "passing_score": 50,
    "exercise_type": "quiz",
    "difficulty": "intermediate",
    "estimated_duration_minutes": 10
  }'::jsonb,
  1
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- Case Study: Transformación ágil (Lección 2.3)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  'ae000000-0000-0000-0000-000000000001',
  'ae020000-0000-0000-0000-000000000001',
  'ae020300-0000-0000-0000-000000000001',
  'ma-ex-04',
  'case-study',
  '{
    "id": "ma-ex-04",
    "title": "Caso: Diagnóstico de Métricas en FinServ LATAM",
    "description": "Una fintech centroamericana con 60 desarrolladores te contrata como consultor ágil. Analiza la situación y propón intervenciones usando las herramientas del curso.",
    "scenario": "FinServ LATAM es una fintech con 60 desarrolladores organizados en 8 equipos. Cada equipo maneja entre 5 y 12 proyectos simultáneamente (WIP total estimado: 70+ ítems). El CTO reporta al board con un dashboard de 150 indicadores incluyendo velocidad por equipo, utilización, bugs reportados, cobertura de código y NPS. El lead time promedio para nuevas features es de 45 días, con un rango de 10 a 90 días. Los equipos tienen sprints de 2 semanas pero el 60% de los sprints terminan con carry-over (trabajo no completado que pasa al siguiente sprint). Las aprobaciones de arquitectura requieren firma del CTO y del CISO para cualquier cambio que toque la base de datos. El equipo de QA (3 personas) es compartido entre los 8 equipos de desarrollo.",
    "questions": [
      {
        "question": "De los 150 indicadores del CTO, ¿cuáles 4-5 métricas accionables recomendarías mantener como indicadores activos? Justifica cada una con umbral, dueño y frecuencia.",
        "min_words": 50,
        "placeholder": "Ejemplo: 1. Lead time de features con umbral de > 30 días, dueño: Engineering Manager, frecuencia semanal..."
      },
      {
        "question": "Usando la Ley de Little (Cycle Time = WIP / Throughput), si el throughput promedio es de 10 features/semana entre todos los equipos, ¿cuál es el cycle time actual con 70 ítems de WIP? ¿A cuánto bajaría si reducen WIP a 25?",
        "min_words": 30,
        "placeholder": "CT actual = 70/10 = ..."
      },
      {
        "question": "Identifica los 3 cuellos de botella principales en el escenario. Para cada uno, clasifícalo (aprobación jerárquica, recurso compartido, o handoff) y propón una intervención concreta.",
        "min_words": 60,
        "placeholder": "1. Aprobación CTO + CISO para cambios de DB → Tipo: aprobación jerárquica → Intervención: ..."
      },
      {
        "question": "Formula 1 OKR trimestral (1 Objective + 3 Key Results) que conecte la estrategia con las métricas operativas que recomendaste. Los Key Results deben usar las métricas de flujo del curso.",
        "min_words": 40,
        "placeholder": "Objective: ... KR1: ... KR2: ... KR3: ..."
      }
    ],
    "rubric": {
      "excellent": "Identifica correctamente los 3 cuellos de botella, aplica Ley de Little, selecciona métricas con las 3 características de accionabilidad, y formula OKRs conectados a métricas operativas.",
      "good": "Identifica 2 de 3 cuellos de botella, aplica Ley de Little correctamente, selecciona métricas razonables pero sin las 3 características completas.",
      "needs_improvement": "Lista problemas genéricos sin conectar con los frameworks del curso. No aplica Ley de Little ni las 3 características de métricas accionables."
    },
    "exercise_type": "case-study",
    "difficulty": "advanced",
    "estimated_duration_minutes": 25
  }'::jsonb,
  1
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- 5. Verificación
SELECT
    'Curso Métricas Ágiles creado' as status,
    (SELECT COUNT(*) FROM courses WHERE slug = 'metricas-agiles') as cursos,
    (SELECT COUNT(*) FROM modules WHERE course_id = 'ae000000-0000-0000-0000-000000000001') as modulos,
    (SELECT COUNT(*) FROM lessons WHERE course_id = 'ae000000-0000-0000-0000-000000000001') as lecciones,
    (SELECT COUNT(*) FROM course_exercises WHERE course_id = 'ae000000-0000-0000-0000-000000000001') as ejercicios;
