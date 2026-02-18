-- =====================================================
-- Seed: Curso "Introducción al Análisis de Redes Organizacionales (ONA)"
-- 3 módulos, 9 lecciones, 9 ejercicios (quizzes)
-- content_source = 'database' (contenido directo en DB)
-- =====================================================

-- 1. Insertar el curso
INSERT INTO courses (id, title, description, slug, thumbnail_url, is_published, content_source, content_status)
VALUES (
  '0e000000-0000-0000-0000-000000000001',
  'Introducción al Análisis de Redes Organizacionales (ONA)',
  'Descubre por qué el organigrama no refleja cómo realmente funciona tu organización y cómo el Análisis de Redes Organizacionales (ONA) revela los patrones invisibles que impulsan o frenan la colaboración, la innovación y el talento. A través de casos reales de organizaciones en Latinoamérica, aprenderás a identificar roles ocultos, diagnosticar silos y dependencias críticas, y diseñar un plan de implementación de ONA. No requiere programación ni conocimientos técnicos previos.',
  'intro-ona',
  '/images/courses/intro-ona-hero.webp',
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
    '0e010000-0000-0000-0000-000000000001',
    '0e000000-0000-0000-0000-000000000001',
    'La Organización Invisible',
    'Del organigrama a la red real: roles ocultos y el caso de negocio para ONA.',
    1,
    false
  ),
  (
    '0e020000-0000-0000-0000-000000000001',
    '0e000000-0000-0000-0000-000000000001',
    'Los Patrones que Frenan (y Aceleran) tu Organización',
    'Silos, dependencias críticas y las señales de una red organizacional saludable.',
    2,
    false
  ),
  (
    '0e030000-0000-0000-0000-000000000001',
    '0e000000-0000-0000-0000-000000000001',
    'De la Teoría a tu Organización',
    'Métodos accesibles, ética del ONA y tu plan de implementación de 90 días.',
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
-- Lesson 1: El organigrama miente
(
  '0e010100-0000-0000-0000-000000000001',
  '0e000000-0000-0000-0000-000000000001',
  '0e010000-0000-0000-0000-000000000001',
  'El organigrama miente',
  '# El organigrama miente

### Si tu organización solo tiene la estructura que aparece en el organigrama, tienes un problema. Si tiene otra que no puedes ver, tienes uno peor.

Toda organización opera con **dos estructuras simultáneas**. La primera es la formal: el organigrama, las líneas de reporte, los comités. La segunda es invisible: las redes informales por donde realmente fluyen la información, la confianza y la influencia. La paradoja del control formal es que cuanto más rígido es el organigrama, más poder tiene la estructura informal — porque las personas buscan caminos alternativos para hacer su trabajo.

---

## Tres preguntas que el organigrama no puede responder

Antes de cualquier definición técnica, considera estas tres preguntas sobre tu propia organización:

| # | Pregunta | Lo que revela |
|---|----------|---------------|
| 1 | **¿A quién acuden realmente las personas cuando necesitan consejo?** | La red de conocimiento — quién tiene expertise percibido, independientemente de su título |
| 2 | **¿Quién conecta grupos que de otra forma no se comunicarían?** | Los puentes invisibles — personas que evitan que la organización se fragmente en silos |
| 3 | **¿Quién energiza al equipo y quién lo drena?** | La red de energía — el impacto emocional que ciertos individuos tienen sobre la motivación colectiva |

Si no puedes responder estas preguntas con datos, estás gestionando tu organización con un mapa incompleto.

---

## Qué es el Análisis de Redes Organizacionales (ONA)

**ONA** (*Organizational Network Analysis*) es el mapeo sistemático de las relaciones informales dentro de una organización — flujos de información, lazos de confianza, patrones de influencia — utilizando encuestas relacionales o huellas digitales de colaboración (correo, chat, calendarios).

No es una encuesta de clima. No mide satisfacción ni engagement. Mide **estructura**: quién se conecta con quién, con qué frecuencia, y para qué.

> *"Una organización no es un organigrama. Es una red de compromisos conversacionales."* — Fernando Flores

### Breve historia del análisis de redes

| Año | Autor | Contribución |
|-----|-------|-------------|
| 1934 | **Jacob Moreno** | Crea los *sociogramas* — primeros mapas visuales de relaciones sociales |
| 1973 | **Mark Granovetter** | Publica "The Strength of Weak Ties": los lazos débiles son los que conectan mundos distintos |
| 1992 | **Ron Burt** | Introduce los *agujeros estructurales*: las ventajas competitivas de quienes conectan grupos desconectados |
| 2004 | **Rob Cross & Andrew Parker** | Publican *The Hidden Power of Social Networks*, aplicando ONA a la gestión empresarial |

De la sociología académica al toolkit de Recursos Humanos: **80 años de evolución**.

---

## Por qué ONA es urgente ahora

El trabajo híbrido rompió la "máquina de café" — ese espacio informal donde se cruzaban personas de distintas áreas, se compartían ideas no planificadas y se construía confianza lateral. Microsoft Research (2021) analizó patrones de colaboración de 61,000 empleados y encontró que el trabajo remoto:

- **Redujo los lazos débiles** entre equipos en un 25%
- **Aumentó los silos** — los equipos se comunicaron más internamente pero menos con otras áreas
- **Disminuyó la sincronicidad** — menos reuniones espontáneas, más comunicación asíncrona sin contexto

Los líderes perdieron visibilidad sobre los patrones reales de colaboración. ONA restaura esa visibilidad con datos, no con suposiciones.

---

## Caso LATAM: TechCorp Colombia

Después de fusionar los departamentos de **TI y Producto**, TechCorp Colombia rediseñó el organigrama con nuevas líneas de reporte. Todo lucía limpio en el papel. Pero en la reestructuración, se despidió a una analista senior de QA que no parecía "estratégica" según los criterios formales.

Lo que el organigrama no mostraba: **esa analista era el único puente informal entre ambos equipos**. Sentada físicamente entre los dos pisos, había construido relaciones de confianza con desarrolladores y product managers. Cuando surgían problemas de integración, ambos lados acudían a ella — no al proceso formal de escalamiento.

**Resultado:** en los 3 meses siguientes, los incidentes cross-team se duplicaron. El tiempo de resolución de bugs de integración pasó de 2 días a 8. La organización había eliminado su conector invisible sin saberlo.

Un análisis ONA previo habría revelado su **alto índice de intermediación** (*betweenness centrality*) y su rol como broker entre grupos, permitiendo proteger esa conexión o crear alternativas antes de eliminarla.

---

### Tu turno

Reflexiona sobre tu propia organización: ¿puedes identificar quién cumple el rol de puente invisible entre áreas que no se comunicarían de otra forma?

<!-- exercise:ona-s-ex-01 -->

---

**Referencias:**

- Cross, R. & Parker, A. (2004). *The Hidden Power of Social Networks*. Harvard Business School Press.
- Moreno, J. L. (1934). *Who Shall Survive?* Nervous and Mental Disease Publishing.
- Granovetter, M. (1973). "The Strength of Weak Ties." *American Journal of Sociology*, 78(6), 1360-1380.
- Burt, R. S. (1992). *Structural Holes: The Social Structure of Competition*. Harvard University Press.
- Burt, R. S. (2004). "Structural Holes and Good Ideas." *American Journal of Sociology*, 110(2), 349-399.
- Yang, L. et al. (2021). "The Effects of Remote Work on Collaboration Among Information Workers." *Nature Human Behaviour*, 6, 43-54.',
  'text',
  1,
  20,
  true
)
,
-- Lesson 2: Los cinco roles que el organigrama no ve
(
  '0e010200-0000-0000-0000-000000000001',
  '0e000000-0000-0000-0000-000000000001',
  '0e010000-0000-0000-0000-000000000001',
  'Los cinco roles que el organigrama no ve',
  '# Los cinco roles que el organigrama no ve

### Tu mejor talento podría no ser quien tiene el mejor desempeño individual — sino quien hace que todos los demás funcionen mejor.

Las evaluaciones de desempeño tradicionales miden lo que una persona produce. ONA mide algo diferente: **el efecto que una persona tiene sobre la red**. Alguien puede tener resultados individuales promedio pero ser la razón por la que tres equipos colaboran sin fricciones. Eliminar a esa persona no aparece como riesgo en ningún dashboard de People Analytics — hasta que el daño ya está hecho.

---

## Los cinco roles informales de la red

Cada organización tiene personas que cumplen funciones críticas **sin que ningún título o descripción de cargo lo refleje**. ONA los hace visibles.

| Rol | Cómo se detecta | Riesgo si se pierde | Acción de gestión |
|-----|-----------------|--------------------|--------------------|
| **Hub (Conector central)** | Alto grado de centralidad — muchos acuden a esta persona | Cuello de botella, sobrecarga, single point of failure | Redistribuir carga, crear canales alternativos |
| **Broker (Puente)** | Conecta grupos que de otra forma no se comunicarían | Silos se profundizan, información no fluye entre áreas | Formalizar espacios de conexión, identificar brokers potenciales |
| **Energizante** | Las personas reportan sentirse motivadas después de interactuar con ellos | Moral y engagement caen, rotación aumenta | Reconocer, proteger de burnout, replicar comportamientos |
| **Periférico** | Pocos lazos, desconectado de la red principal | Talento invisible, fuga silenciosa, ideas perdidas | Investigar causa (¿nuevo? ¿remoto? ¿excluido?), crear puentes |
| **Influenciador oculto** | No tiene autoridad formal pero sus opiniones impactan decisiones de otros | Resistencia inexplicable al cambio, sabotaje pasivo | Incluir en procesos de cambio, consultar antes de anunciar |

> *"Los organigramas muestran quién reporta a quién. Las redes muestran quién importa para quién."* — Rob Cross, 2021

---

## Lo que las evaluaciones tradicionales no capturan

Considera la matriz de talento clásica, el **9-box** (desempeño vs. potencial). Un broker que conecta Operaciones con Innovación puede estar en el cuadrante de "desempeño sólido, potencial medio" — porque su contribución no se refleja en métricas individuales. Pero si se va, dos áreas dejan de comunicarse.

| Herramienta tradicional | Qué mide | Qué ignora |
|---|---|---|
| Evaluación de desempeño | Resultados individuales, competencias | Impacto en la red, rol informal |
| 9-box | Desempeño + potencial percibido | Conectividad, influencia real, función de puente |
| Encuesta de engagement | Satisfacción, intención de quedarse | Quién sostiene emocionalmente al equipo |

El resultado: **decisiones de talento basadas en mapas incompletos**. Se promueve al Hub sobrecargado (empeorando el cuello de botella), se deja ir al Broker invisible (fragmentando la red), y se ignora al Periférico que podría tener ideas transformadoras si alguien lo conectara.

---

## El impuesto oculto de la colaboración

Rob Cross y sus colegas documentaron en 2021 un fenómeno que denominaron **"collaborative overload"**: los Hubs y Brokers de la organización absorben una carga desproporcionada de trabajo relacional que no está en su descripción de cargo.

**Los datos son contundentes:**

- El 20-35% de las colaboraciones que agregan valor provienen de solo el **3-5%** de los empleados
- Estas personas dedican hasta un **50% más de tiempo** a ayudar a otros que el promedio
- Son las primeras en reportar **burnout** — pero las últimas en recibir ayuda, porque "siempre están bien"

El impuesto de la colaboración es invisible precisamente porque no está formalizado. Nadie les asignó ser el punto de contacto entre áreas. Simplemente lo son — y la organización depende de ello sin reconocerlo ni compensarlo.

---

## Caso LATAM: Banco Pichincha Ecuador

Durante su transformación digital, Banco Pichincha conformó un comité directivo (*steering committee*) con los líderes formales del cambio: VP de tecnología, directores de banca digital, jefes de operaciones. La resistencia al cambio en las sucursales, sin embargo, era alta.

Un análisis ONA reveló algo que el organigrama no mostraba: **3 gerentes de sucursal que no estaban en ningún comité eran los "energizantes" de la red**. Cuando los equipos de sucursal sentían ansiedad por la transformación, acudían a estos tres gerentes — no a sus jefes directos ni al comité formal.

**La acción:** Banco Pichincha incluyó a estos tres gerentes en la coalición de cambio. No como decoración, sino como **agentes de influencia legítimos**: participaron en el diseño del plan de adopción, comunicaron desde la empatía (no desde la directiva), y facilitaron la transición en sus redes.

**El resultado:** la adopción de la nueva plataforma digital, originalmente proyectada en 18 meses, se completó en 11 meses. La diferencia no fue tecnológica — fue de red.

> *"La resistencia al cambio rara vez es resistencia a la idea. Es resistencia a no haber sido consultado."* — Borgatti & Cross, 2003

---

### Tu turno

Identifica los cinco roles informales en un equipo que conozcas bien. ¿Quién es el Hub? ¿Quién el Broker? ¿Hay alguien en la periferia que podría estar siendo subutilizado?

<!-- exercise:ona-s-ex-02 -->

---

**Referencias:**

- Cross, R. & Parker, A. (2004). *The Hidden Power of Social Networks*. Harvard Business School Press.
- Borgatti, S. P. & Cross, R. (2003). "A Relational View of Information Seeking and Learning in Social Networks." *Management Science*, 49(4), 432-445.
- Cross, R., Rebele, R. & Grant, A. (2016). "Collaborative Overload." *Harvard Business Review*, 94(1), 74-79.
- Cross, R., Taylor, S. & Zehner, D. (2021). *Beyond Collaboration Overload*. Harvard Business Review Press.',
  'text',
  2,
  20,
  true
)
,
-- Lesson 3: El caso de negocio para ONA
(
  '0e010300-0000-0000-0000-000000000001',
  '0e000000-0000-0000-0000-000000000001',
  '0e010000-0000-0000-0000-000000000001',
  'El caso de negocio para ONA',
  '# El caso de negocio para ONA

### Las organizaciones gastan millones en encuestas de clima, 360 y people analytics. Ninguna de esas herramientas responde la pregunta más importante: ¿cómo fluye realmente el trabajo aquí?

Cada herramienta diagnóstica tiene un ángulo ciego. La encuesta de clima mide cómo se siente la gente, pero no quién colabora con quién. El 360 captura percepciones sobre competencias, pero no la estructura real de influencia. People analytics detecta patrones de rotación y productividad, pero no las relaciones informales que los explican. ONA no reemplaza estas herramientas — **llena el vacío que todas dejan**.

---

## ONA frente a otras herramientas diagnósticas

| Herramienta | Mide | No captura | Costo | Frecuencia ideal |
|---|---|---|---|---|
| Encuesta de clima | Satisfacción, engagement | Quién colabora con quién, flujo de información | Bajo | Anual |
| 360° feedback | Percepción de competencias | Estructura real de la red, silos | Medio | Anual |
| People analytics | Productividad, rotación, ausentismo | Relaciones informales, influencia | Alto | Continuo |
| **ONA** | **Flujo de información, influencia, dependencias, silos** | Calidad del trabajo, satisfacción individual | Medio | Cada 6-12 meses |

La clave es la **complementariedad**. Una encuesta de clima dice "el 60% del equipo de Operaciones está insatisfecho." ONA dice **por qué**: porque Operaciones está desconectado de Producto y toda la información les llega filtrada por un solo gerente que actúa como cuello de botella.

---

## Seis problemas que solo ONA resuelve

No todo problema organizacional requiere ONA. Pero hay seis escenarios donde ninguna otra herramienta proporciona la misma visibilidad:

| # | Problema | Lo que ONA revela |
|---|----------|-------------------|
| 1 | **Integración post-fusión** | Qué tan conectados (o aislados) están realmente los equipos fusionados — más allá del nuevo organigrama |
| 2 | **Dependencia de personas clave** | Quién es single point of failure — personas cuya salida fragmentaría la red |
| 3 | **Cuellos de botella en innovación** | Dónde están los silos que impiden que las ideas fluyan entre áreas |
| 4 | **Efectividad del onboarding** | Qué tan integrados están los nuevos empleados a los 90 días — ¿construyeron red o están aislados? |
| 5 | **Erosión colaborativa en trabajo híbrido** | Qué lazos se perdieron con la virtualidad y cuáles se mantuvieron |
| 6 | **Mapeo de resistencia al cambio** | Quiénes son los influenciadores ocultos que pueden acelerar o bloquear una transformación |

---

## El retorno de inversión de ONA

La pregunta inevitable del CFO: **¿cuánto vale esto?**

Cross y Parker (2004) documentaron que cuando ONA informa decisiones de reestructuración, el **tiempo de productividad post-cambio mejora entre 20% y 30%** — porque se protegen las conexiones críticas en lugar de destruirlas accidentalmente.

Deloitte (2020) estimó que romper silos organizacionales ahorra entre **15% y 25% del tiempo de los knowledge workers** — tiempo que se perdía buscando información que ya existía en otra área pero no fluía.

Alex "Sandy" Pentland (2014) demostró en *Social Physics* que los equipos con patrones de comunicación más distribuidos (no centralizados en un líder) superan a los centralizados en productividad por un factor de **3x** en tareas creativas.

> *"Los patrones de comunicación son el predictor más importante del éxito de un equipo — más que la inteligencia individual, la personalidad o el contenido de lo que se discute."* — Pentland, 2014

---

## Cuándo NO hacer ONA

ONA no es una herramienta universal. Hay cuatro situaciones donde implementarla puede ser contraproducente:

| Condición | Por qué no hacer ONA |
|-----------|---------------------|
| **Organización < 20 personas** | La red es lo suficientemente pequeña para mapearla conversando. Una encuesta formal es desproporcionada. |
| **Sin sponsor ejecutivo** | Los resultados de ONA requieren acción. Sin un líder comprometido a actuar, los datos se archivan y el ejercicio genera cinismo. |
| **Ciclo activo de despidos** | Las personas no responderán honestamente si temen que la información se use para decidir quién sobra. La confianza es prerrequisito. |
| **Sin plan de acción** | Medir por medir es peor que no medir. Si no hay claridad sobre qué se hará con los resultados, mejor esperar. |

La regla general: **ONA es una herramienta de acción, no de diagnóstico pasivo**. Si no estás dispuesto a cambiar algo con lo que descubras, no la uses.

---

## Caso LATAM: Grupo Bimbo México

Antes de la pandemia, los gerentes de planta de Grupo Bimbo en diferentes estados de México se encontraban trimestralmente en reuniones regionales. Esos encuentros presenciales generaban algo que no estaba en la agenda formal: **lazos débiles** (*weak ties*, en terminología de Granovetter). Un gerente en Monterrey compartía una mejora en el proceso de empaque; otro en Guadalajara la adaptaba para su línea de producción.

Después de dos años de reuniones virtuales, un análisis ONA reveló que esos lazos débiles entre plantas **habían colapsado casi por completo**. Las plantas se comunicaban intensamente hacia adentro (lazos fuertes intactos) pero casi nada entre sí. El intercambio de mejoras de proceso entre plantas cayó un **40%**.

**La acción:** Con datos de ONA en mano, Bimbo diseñó un programa de **rotaciones cruzadas entre plantas** — no basado en jerarquía ni antigüedad, sino en los huecos estructurales que el análisis de red reveló. Gerentes de plantas desconectadas fueron asignados a estancias de 2 semanas en plantas con las que no tenían vínculos.

**El resultado:** en 6 meses, el índice de transferencia de mejores prácticas entre plantas regresó a niveles pre-pandemia. La intervención no fue más reuniones virtuales — fue **reconstruir la red con intención**.

---

### Tu turno

Evalúa si tu organización está lista para implementar ONA. ¿Se cumplen las condiciones mínimas o hay banderas rojas que primero debes resolver?

<!-- exercise:ona-s-ex-03 -->

---

**Referencias:**

- Cross, R. & Parker, A. (2004). *The Hidden Power of Social Networks*. Harvard Business School Press.
- Pentland, A. (2014). *Social Physics: How Social Networks Can Make Us Smarter*. Penguin Books.
- Granovetter, M. (1973). "The Strength of Weak Ties." *American Journal of Sociology*, 78(6), 1360-1380.
- Deloitte (2020). *Human Capital Trends: The Social Enterprise at Work*. Deloitte Insights.
- Burt, R. S. (1992). *Structural Holes: The Social Structure of Competition*. Harvard University Press.',
  'text',
  3,
  20,
  true
)
,
-- Lesson 4: Silos, puentes rotos y la ilusión de la colaboración
(
  '0e020100-0000-0000-0000-000000000001',
  '0e000000-0000-0000-0000-000000000001',
  '0e020000-0000-0000-0000-000000000001',
  'Silos, puentes rotos y la ilusión de la colaboración',
  '# Silos, puentes rotos y la ilusión de la colaboración

### Tu organización tiene un organigrama que dice "colaboramos entre áreas". Pero, ¿cuántas veces una idea, un dato o una solución murió atrapada en un departamento porque nadie sabía que al otro lado del pasillo ya existía la respuesta?

Los silos organizacionales no aparecen en ningún documento oficial. Nadie los diseña. Pero emergen con la misma certeza que la gravedad: cada grupo desarrolla su propio lenguaje, sus propias prioridades y sus propias lealtades. El resultado es una **ilusión de colaboración** — reuniones interfuncionales donde cada área presenta sus slides, asienten cortésmente, y vuelven a operar como islas separadas.

---

## Los cuatro silos que dominan las organizaciones en LATAM

| Tipo de silo | Descripción | Señal típica | Ejemplo LATAM |
|---|---|---|---|
| **Geográfico** | Oficinas en distintas ciudades o países no se comunican | "No sabíamos que en la otra oficina ya resolvieron eso" | Multinacional con oficinas en CDMX, Bogotá y Lima que duplican el mismo análisis de mercado |
| **Funcional** | Departamentos operan como islas — ventas vs. operaciones, IT vs. marketing | Reuniones donde cada área habla su propio idioma técnico | IT y Marketing no se hablan en empresa de retail chilena |
| **Generacional** | Veteranos y nuevas generaciones no intercambian conocimiento | "Los jóvenes no entienden cómo funciona esto aquí" | Empresa familiar con 30 años donde la nueva generación digital no logra acceder al conocimiento tácito de los fundadores |
| **De adquisición** | Post-fusión, las empresas originales siguen operando como entidades separadas | "Nosotros" vs. "ellos" persiste años después de la integración | Grupo que adquiere competidor y las culturas nunca se integran — dos empresas con un solo nombre |

Estos silos rara vez existen de forma pura. Lo habitual es que se **superpongan**: un silo funcional + geográfico crea una doble barrera casi impenetrable.

---

## El costo oculto que nadie presupuesta

Según Deloitte, las organizaciones con silos pronunciados pierden entre el **15% y 25% de la productividad** de sus trabajadores de conocimiento. Ese costo se manifiesta en tres formas concretas:

| Forma de pérdida | Qué ocurre | Impacto |
|---|---|---|
| **Trabajo duplicado** | Dos equipos resuelven el mismo problema sin saberlo | Horas desperdiciadas, frustración al descubrir la duplicación |
| **Decisiones retrasadas** | Información crítica tarda semanas en cruzar fronteras departamentales | Oportunidades perdidas, ciclos de aprobación inflados |
| **Innovación atrapada** | Ideas valiosas quedan confinadas al grupo que las genera | La organización no capitaliza su propio conocimiento colectivo |

> *"The real competitive advantage comes not from what people know, but from what they share."* — Rob Cross

---

## Puentes rotos vs. redundancia: el equilibrio difícil

Cuando un **broker** (la persona que conecta dos grupos) se va, se quema o es reasignado, el puente se rompe y los silos vuelven a cerrarse. Pero crear **redundancia** — múltiples personas que conecten los mismos grupos — tiene un costo de coordinación. La clave no es maximizar ni minimizar puentes, sino **calibrar** la cantidad justa.

---

## Intervenciones: qué funciona y qué es teatro organizacional

| Intervención | Efectividad | Por qué |
|---|---|---|
| Reorganizar el organigrama | **Baja** | Cambia la estructura formal pero no las relaciones reales — los silos informales persisten |
| Crear comités interfuncionales forzados | **Media-baja** | Sin incentivos reales, se vuelven ceremoniales — reuniones donde se asiste pero no se colabora |
| Rotación de personal entre áreas | **Alta** | Crea lazos que persisten después de la rotación — la persona lleva consigo relaciones y contexto |
| Espacios físicos/virtuales de coincidencia | **Media-alta** | El "efecto cafetería" — el contacto casual genera lazos débiles que luego facilitan la colaboración |
| Proyectos conjuntos con entregables compartidos | **Alta** | La interdependencia real fuerza la colaboración genuina — no puedes entregar sin el otro |

La lección es clara: **las intervenciones que crean interdependencia real superan a las que solo crean proximidad formal**.

---

## Caso LATAM: CEMEX y la fragilidad de los super-brokers

Después de que CEMEX adquirió una cementera colombiana, un análisis de red reveló un dato alarmante: de los **800 empleados** distribuidos entre México y Colombia, solo **4 personas** mantenían relaciones de trabajo activas entre ambos países. Estos cuatro "super-brokers" canalizaban **toda** la coordinación transfronteriza.

Cuando uno de ellos fue promovido a un rol exclusivamente local, el **25% de los proyectos transfronterizos se estancó** en cuestión de semanas. No había redundancia — el puente simplemente dejó de existir.

La respuesta fue diseñar un **programa de "embajadores"** basado en datos de ONA: identificar roles estratégicos y crear deliberadamente **20+ nuevas conexiones transfronterizas** mediante rotaciones cortas, proyectos conjuntos y comunidades de práctica binacionales. En 12 meses, la dependencia de los super-brokers originales cayó de forma significativa.

**La lección:** un análisis ONA previo a la adquisición habría identificado esta fragilidad estructural antes de que se convirtiera en una crisis operativa.

---

### Tu turno

Piensa en tu organización: ¿puedes identificar qué tipo de silo es el más costoso y qué intervención tendría mayor impacto?

<!-- exercise:ona-s-ex-04 -->

---

**Referencias:**

- Cross, R., Rebele, R. & Grant, A. (2016). "Collaborative Overload." *Harvard Business Review*, 94(1), 74-79.
- Cross, R. & Parker, A. (2004). *The Hidden Power of Social Networks*. Harvard Business School Press.
- Burt, R. S. (2004). "Structural Holes and Good Ideas." *American Journal of Sociology*, 110(2), 349-399.
- Reagans, R. & Zuckerman, E. (2001). "Networks, Diversity, and Productivity." *Organization Science*, 12(4), 502-517.
- Hansen, M. T. (1999). "The Search-Transfer Problem." *Administrative Science Quarterly*, 44(1), 82-111.
- Deloitte (2017). *The Organization of the Future*. Deloitte University Press.',
  'text',
  4,
  20,
  true
)
,
-- Lesson 5: Dependencia crítica: cuando una sola persona sostiene la organización
(
  '0e020200-0000-0000-0000-000000000001',
  '0e000000-0000-0000-0000-000000000001',
  '0e020000-0000-0000-0000-000000000001',
  'Dependencia crítica: cuando una sola persona sostiene la organización',
  '# Dependencia crítica: cuando una sola persona sostiene la organización

### ¿Quién es esa persona en tu empresa que "sabe dónde está todo", que aparece en todas las reuniones importantes y sin la cual nada parece avanzar? Ahora pregúntate: ¿qué pasaría si mañana no estuviera?

Toda organización tiene héroes informales — personas que sostienen procesos, relaciones y decisiones mucho más allá de lo que dice su descripción de puesto. El problema no es que existan. El problema es que la organización **no sabe que depende de ellos** hasta que los pierde.

---

## Tres niveles de dependencia crítica

No toda dependencia es igual. Una persona puede ser irremplazable por lo que sabe, por con quién se conecta, o por cómo influye. Cada nivel tiene implicaciones distintas para la gestión de riesgo.

| Nivel | Descripción | Indicador cualitativo | Urgencia |
|---|---|---|---|
| **Operativo** | La persona posee conocimiento tácito sobre procesos diarios | "Solo María sabe cómo funciona el sistema de facturación" | Media — documentable con esfuerzo |
| **Relacional** | La persona es el puente de confianza entre grupos internos o con clientes | "Los clientes solo hablan con Juan" | Alta — difícil de transferir |
| **Estratégico** | La persona influye decisiones clave sin autoridad formal | "Nada se aprueba sin el visto bueno informal de Patricia" | Crítica — es sistémica, no individual |

La dependencia operativa es la más visible y la más fácil de resolver: documentación, cross-training, manuales. La relacional es más sutil — la confianza no se transfiere por decreto. Y la estratégica es la más peligrosa, porque frecuentemente **ni la propia persona sabe** que tiene ese poder informal.

---

## El heurístico del "mañana no viene"

Antes de cualquier herramienta sofisticada, HR puede aplicar un filtro simple. Para cada persona clave, pregunta: **"Si esta persona no viniera mañana, ¿qué se rompería?"**

| Categoría | Descripción | Ejemplo |
|---|---|---|
| **Recuperable en días** | El impacto es operativo y hay procesos documentados | Un analista de reportes con templates estandarizados |
| **Recuperable en semanas** | Se pierde conocimiento tácito pero hay personas que pueden reconstruirlo | Un gerente de proyecto con contexto de cliente pero equipo capaz |
| **No recuperable** | Se pierde la relación, la influencia o el conocimiento que no existe en ningún otro lugar | El director comercial cuya cartera de clientes se basa en confianza personal de 15 años |

> *"When a star leaves, the question is not whether you can replace their skills. It''s whether you can replace their network."* — Boris Groysberg

---

## El mito de la sucesión tradicional

La mayoría de los planes de sucesión en organizaciones latinoamericanas cometen el mismo error fundamental: planifican el reemplazo del **rol**, no de las **relaciones**.

Un plan de sucesión típico identifica competencias técnicas, experiencia funcional y potencial de liderazgo del sucesor. Pero cuando el valor real del ejecutivo saliente estaba en su **capital social** — la red de relaciones de confianza con clientes, la influencia lateral con pares de otras áreas, la credibilidad acumulada en 15 años de interacciones informales — el sucesor hereda el título pero **no hereda la red**.

Nahapiet y Ghoshal (1998) lo explican a través de las tres dimensiones del capital social:

| Dimensión | Qué se pierde con la salida | ¿Es transferible? |
|---|---|---|
| **Estructural** | Las conexiones — a quién conocía, con quién hablaba | Parcialmente — se puede presentar al sucesor |
| **Relacional** | La confianza acumulada, la reciprocidad, las normas compartidas | Difícilmente — la confianza se construye con tiempo |
| **Cognitiva** | El lenguaje compartido, los códigos implícitos con clientes y colegas | Muy difícilmente — es tácito por definición |

**La consecuencia práctica:** los planes de sucesión que no incluyen un período de **"networking en sombra"** — donde el sucesor construye relaciones propias junto al titular durante 6 a 12 meses — tienen una tasa de falla significativamente mayor.

---

## Caso LATAM: la aseguradora peruana que perdió lo que no sabía que tenía

Una aseguradora en Lima tenía un plan de sucesión ejemplar para su dirección comercial. Cuando el director titular — 15 años en el cargo — anunció su renuncia, el sucesor estaba identificado, evaluado y listo. Asumió el puesto en dos semanas.

Sin embargo, en los seis meses siguientes la cartera de clientes cayó un **20%**. El sucesor tenía las competencias técnicas, el conocimiento del mercado y la experiencia sectorial. Lo que no tenía era lo que los clientes más valoraban: **la relación personal** con el director anterior. La confianza estaba depositada en la persona, no en la empresa.

Un análisis ONA habría revelado esta dependencia relacional con meses de anticipación. La red habría mostrado que el director era el **único punto de contacto de alta confianza** con los 15 clientes más grandes — no había lazos redundantes entre esos clientes y otros ejecutivos de la empresa. La intervención habría sido un programa de **networking en sombra**: durante 6-12 meses antes de la transición, el sucesor habría acompañado al director en reuniones clave, construyendo su propia relación con cada cliente hasta que la confianza fuera transferida de forma natural.

**La moraleja:** el costo de esos 6 meses de transición gradual habría sido una fracción del 20% de cartera perdida.

---

### Tu turno

Identifica en tu organización una dependencia crítica que un plan de sucesión tradicional no captaría.

<!-- exercise:ona-s-ex-05 -->

---

**Referencias:**

- Cross, R. & Parker, A. (2004). *The Hidden Power of Social Networks*. Harvard Business School Press.
- Nahapiet, J. & Ghoshal, S. (1998). "Social Capital, Intellectual Capital, and the Organizational Advantage." *Academy of Management Review*, 23(2), 242-266.
- Groysberg, B. (2010). *Chasing Stars: The Myth of Talent and the Portability of Performance*. Princeton University Press.
- Cross, R., Rebele, R. & Grant, A. (2016). "Collaborative Overload." *Harvard Business Review*, 94(1), 74-79.',
  'text',
  5,
  20,
  true
)
,
-- Lesson 6: Patrones de redes saludables
(
  '0e020300-0000-0000-0000-000000000001',
  '0e000000-0000-0000-0000-000000000001',
  '0e020000-0000-0000-0000-000000000001',
  'Patrones de redes saludables',
  '# Patrones de redes saludables

### ¿Cómo se ve una organización que realmente colabora bien? No la que dice que colabora — la que lo hace. ¿Cuáles son las señales observables de una red organizacional que funciona?

Hemos dedicado las lecciones anteriores a diagnosticar patologías: silos, puentes rotos, dependencias críticas. Pero el diagnóstico sin referencia es inútil — necesitas saber **qué aspecto tiene una red sana** para reconocer cuándo la tuya no lo es. Esta lección define las cinco señales de una red organizacional saludable y te da herramientas cualitativas para evaluarlas sin necesidad de software.

---

## Cinco señales de una red organizacional saludable

| Señal | Qué significa | Red saludable | Red enferma |
|---|---|---|---|
| **Densidad adecuada** | Suficientes conexiones sin sobrecarga | Equipos internos bien conectados, sin exceso | Todos conectados con todos (reunionitis crónica) o nadie conectado con nadie |
| **Diversidad de lazos** | Conexiones entre distintas áreas, niveles y ubicaciones | Ingenieros hablan con marketing, juniors con seniors | Solo se conectan "con los suyos" — endogamia relacional |
| **Redundancia de puentes** | Múltiples personas conectan los mismos grupos | Si un broker se va, otros mantienen el flujo de información | Un solo broker sostiene toda la comunicación entre áreas |
| **Periferia conectada** | Personas nuevas o remotas tienen al menos 2-3 lazos fuertes | Nuevo empleado integrado en 3 meses | Empleado remoto invisible después de 6 meses |
| **Reciprocidad** | Las relaciones son bidireccionales, no extractivas | "Yo te ayudo, tú me ayudas" — flujo equilibrado | Unos pocos dan información y energía; muchos solo extraen |

Ninguna de estas señales es binaria. Cada una opera en un **espectro**, y el punto óptimo varía según el tamaño, la industria y la cultura de la organización.

---

## Capital social organizacional: la riqueza invisible

Nahapiet y Ghoshal (1998) propusieron que las organizaciones poseen un **capital social colectivo** — el valor agregado de todas las relaciones entre sus miembros. Este capital tiene tres dimensiones:

| Dimensión | Qué captura | Pregunta diagnóstica |
|---|---|---|
| **Estructural** | Quién está conectado con quién — la arquitectura de la red | ¿La información fluye entre áreas o se estanca dentro de cada grupo? |
| **Relacional** | La calidad de esos vínculos — confianza, reciprocidad, normas compartidas | ¿Las personas confían lo suficiente para compartir errores, no solo éxitos? |
| **Cognitiva** | Lenguaje compartido, narrativas comunes, visión alineada | ¿Equipos de distintas áreas usan los mismos conceptos para describir la estrategia? |

Una organización puede tener una estructura de red perfecta (todos conectados) y aún así fallar si la dimensión relacional es débil (las conexiones existen pero no hay confianza) o si la dimensión cognitiva está fragmentada (cada área interpreta la estrategia de manera distinta).

> *"Social capital is the goodwill that is engendered by the fabric of social relations."* — Nahapiet & Ghoshal

---

## Diagnóstico sin software: tres preguntas que revelan la salud de tu red

No necesitas un proyecto de ONA formal para hacer un diagnóstico inicial. Alex "Sandy" Pentland (2014) y Rob Cross (2021) han validado que ciertas preguntas cualitativas funcionan como proxies confiables de la salud de red:

**1. "¿Un empleado nuevo puede nombrar 3 personas fuera de su equipo a quienes llamaría para pedir ayuda?"**
- Si la respuesta es sí: la periferia está conectada — el onboarding genera lazos transversales
- Si la respuesta es no: la periferia está aislada — los nuevos empleados quedan atrapados en su equipo inmediato

**2. "Si tus 3 personas más conectadas tomaran vacaciones al mismo tiempo, ¿el trabajo continuaría?"**
- Si la respuesta es sí: hay redundancia de puentes — la red no depende de individuos
- Si la respuesta es no: tienes dependencias críticas no gestionadas

**3. "¿Los proyectos interfuncionales terminan a tiempo?"**
- Si la respuesta es sí: hay diversidad de lazos funcional — los equipos cruzan fronteras con fluidez
- Si la respuesta es no: los silos están frenando la ejecución, independientemente de lo que diga el organigrama

Estas tres preguntas no reemplazan un análisis cuantitativo, pero le dan a cualquier líder de HR una **línea base cualitativa** para decidir si un proyecto de ONA formal está justificado.

---

## Caso LATAM: Mercado Libre y la arquitectura deliberada de redes saludables

Mercado Libre, la empresa de tecnología más valiosa de América Latina, opera con una estructura dual que produce redes organizacionales saludables de forma deliberada:

- **Squads:** equipos pequeños y multifuncionales (producto, ingeniería, diseño, datos) con alta **densidad interna**. Dentro del squad, todos se conocen y colaboran diariamente. Esto genera velocidad de ejecución.

- **Guildas:** comunidades de práctica transversales (la guilda de backend, la guilda de UX, la guilda de datos) que crean **puentes entre squads**. Un ingeniero de backend pertenece a su squad para ejecutar y a la guilda de backend para aprender.

Esta estructura dual produce exactamente los patrones de red saludable: alta densidad dentro de squads, diversidad de lazos a través de guildas, redundancia de puentes (múltiples personas conectan los mismos grupos), periferia conectada (los nuevos se integran vía squad + guilda) y reciprocidad (las guildas operan como espacios de intercambio, no de extracción).

Cuando Mercado Libre analizó datos de colaboración interna, encontró que los ingenieros que participaban en al menos **una guilda** entregaban funcionalidades un **23% más rápido** que quienes solo operaban dentro de su squad. La razón: podían reutilizar soluciones de otros equipos en lugar de reinventarlas, gracias a los lazos débiles construidos en la guilda.

**La lección para cualquier organización:** no necesitas ser una empresa de tecnología para replicar este principio. Comunidades de práctica — Wenger (1998) las formalizó hace décadas — son una de las intervenciones más efectivas para crear redes saludables.

---

### Tu turno

Aplica las tres preguntas diagnósticas a tu propia organización y evalúa la salud de tu red.

<!-- exercise:ona-s-ex-06 -->

---

**Referencias:**

- Nahapiet, J. & Ghoshal, S. (1998). "Social Capital, Intellectual Capital, and the Organizational Advantage." *Academy of Management Review*, 23(2), 242-266.
- Pentland, A. (2014). *Social Physics: How Social Networks Can Make Us Smarter*. Penguin Press.
- Cross, R., Gardner, H. & Crocker, A. (2021). *Beyond Collaboration Overload*. Harvard Business Review Press.
- Wenger, E. (1998). *Communities of Practice: Learning, Meaning, and Identity*. Cambridge University Press.
- Cross, R. & Parker, A. (2004). *The Hidden Power of Social Networks*. Harvard Business School Press.',
  'text',
  6,
  20,
  true
)
,
-- Lesson 7: Cómo hacer ONA sin ser data scientist
(
  '0e030100-0000-0000-0000-000000000001',
  '0e000000-0000-0000-0000-000000000001',
  '0e030000-0000-0000-0000-000000000001',
  'Cómo hacer ONA sin ser data scientist',
  '# Cómo hacer ONA sin ser data scientist

### ¿Crees que necesitas un doctorado en ciencia de datos para mapear las redes de tu organización? No. Necesitas curiosidad, método y las preguntas correctas.

El mayor mito sobre ONA es que requiere software caro, analistas especializados y meses de trabajo. En realidad, las organizaciones más sofisticadas del mundo empezaron con lo mismo que tienes hoy: conversaciones, una hoja de cálculo y la voluntad de ver lo que el organigrama esconde. La diferencia entre un diagnóstico superficial y uno transformador no está en la herramienta — está en la calidad de las preguntas.

---

## El espectro de métodos ONA

No existe un único camino para hacer ONA. Existe un **espectro de profundidad** que debes elegir según tus recursos, tu contexto y tu objetivo.

| Nivel | Método | Costo | Tiempo | Precisión | Para quién |
|---|---|---|---|---|---|
| **Nivel 0: Observación** | Caminar la oficina, ver quién habla con quién, mapear en papel | Gratis | 1-2 semanas | Baja | Líder curioso en equipo pequeño |
| **Nivel 1: Entrevistas** | 15-20 entrevistas semi-estructuradas, mapear en post-its o Excel | Bajo | 2-4 semanas | Media | HR con 50-200 personas |
| **Nivel 2: Encuesta** | Survey online (Google Forms, Microsoft Forms, Typeform) + análisis en Excel/Sheets | Medio | 4-6 semanas | Alta | HR/consultor con 100-1000+ personas |
| **Nivel 3: Digital** | Análisis de metadata de email/Teams/Slack (sin leer contenido) | Alto | 2-4 semanas | Muy alta | Empresa con herramienta de people analytics |

La recomendación para la mayoría de los equipos de HR en LATAM: **empieza en Nivel 1 o 2**. Los niveles más altos agregan precisión, pero también agregan complejidad política y técnica que puede detener el proyecto antes de que genere valor.

---

## Las 4 preguntas universales de ONA

Cross y Parker (2004) identificaron cuatro preguntas que, aplicadas a cualquier organización, revelan las redes informales más críticas:

1. **"¿A quién acudes cuando necesitas información o consejo sobre tu trabajo?"** — Red de información
2. **"¿A quién acudes cuando necesitas tomar una decisión importante?"** — Red de decisión
3. **"¿Con quién interactúas regularmente para realizar tu trabajo?"** — Red de colaboración
4. **"¿Quién te energiza o motiva en el trabajo?"** — Red de energía

Cada pregunta revela una capa distinta de la organización informal. La red de información muestra dónde está el conocimiento real. La red de energía muestra quién sostiene la moral del equipo. **No son la misma red** — y las diferencias entre ellas son donde está el diagnóstico más valioso.

---

## Guía práctica para la encuesta ONA

Si eliges Nivel 2 (encuesta), estos son los parámetros clave para obtener datos válidos:

- **Método de respuesta**: Usa el *roster method* (lista de nombres donde el participante selecciona) en lugar de *free recall* (escribir nombres libremente). El roster reduce sesgos de memoria y estandariza respuestas.
- **Escala de frecuencia**: "Nunca / Rara vez / Mensualmente / Semanalmente / Diariamente" para calificar la intensidad de cada relación.
- **Límite de nombres**: Máximo **5-6 personas por pregunta**. Más opciones generan fatiga y respuestas aleatorias.
- **Tasa de respuesta mínima**: **80% o más**. Debajo de esto, los resultados tienen vacíos estructurales que invalidan el análisis. Una red con 60% de respuestas es como un mapa con 40% de calles borradas.

**Herramientas accesibles para Nivel 2:**

| Herramienta | Uso | Costo |
|---|---|---|
| Google Forms + Sheets | Encuesta + análisis manual | Gratis |
| Kumu.io | Visualización de redes | Freemium |
| ONA Survey (Polinode) | Encuesta + visualización + métricas | SaaS de pago |

---

## El elemento político: el sponsor ejecutivo

> *"Sin un sponsor que actúe sobre los resultados, el ONA crea expectativas y luego genera cinismo."* — Rob Cross

ONA revela dinámicas de poder. Muestra quién realmente influye, quién está aislado, y qué silos existen a pesar de los esfuerzos formales. Estos hallazgos son **políticamente sensibles**. Sin un ejecutivo con autoridad para actuar sobre los resultados — reasignar recursos, crear roles, modificar estructuras — el estudio se convierte en un ejercicio académico que deja a los participantes preguntándose para qué les pidieron su tiempo.

Antes de lanzar cualquier ONA, asegúrate de tener la respuesta a una pregunta: **¿Quién va a hacer algo con estos datos?**

---

## Caso LATAM: Hospital en Chile

La jefa de enfermería de un hospital chileno sospechaba que la coordinación de emergencias no seguía los protocolos formales. En lugar de una encuesta completa, optó por **Nivel 1**: 20 entrevistas semi-estructuradas de 30 minutos cada una con personal de urgencias.

El hallazgo fue revelador: una **única enfermera** — sin rol formal de coordinación, sin compensación adicional — funcionaba como hub informal que coordinaba el 70% de los casos urgentes entre especialidades. Médicos, residentes y técnicos acudían a ella porque conocía las disponibilidades, los temperamentos y los atajos del sistema.

**La acción:** El hospital creó un puesto formal de **"Enlace Clínico"** basado en este hallazgo, con remuneración y autoridad acorde. **El resultado:** los tiempos de coordinación en emergencias se redujeron un 35%. La inversión total del diagnóstico ONA fue de 10 horas de entrevistas y una hoja de cálculo.

---

### Tu turno

Diseña tu primera aproximación a un ONA: ¿qué nivel del espectro elegirías para tu organización y por qué? ¿Cuál de las 4 preguntas universales sería la más reveladora en tu contexto?

<!-- exercise:ona-s-ex-07 -->

---

**Referencias:**

- Cross, R. & Parker, A. (2004). *The Hidden Power of Social Networks*. Harvard Business School Press.
- Borgatti, S. P., Everett, M. G. & Johnson, J. C. (2013). *Analyzing Social Networks*. SAGE Publications.
- Scott, J. (2017). *Social Network Analysis*. 4th ed. SAGE Publications.
- Krackhardt, D. (1990). "Assessing the Political Landscape: Structure, Cognition, and Power in Organizations." *Administrative Science Quarterly*, 35(2), 342-369.',
  'text',
  7,
  20,
  true
)
,
-- Lesson 8: La política del ONA
(
  '0e030200-0000-0000-0000-000000000001',
  '0e000000-0000-0000-0000-000000000001',
  '0e030000-0000-0000-0000-000000000001',
  'La política del ONA',
  '# La política del ONA

### ONA no solo revela cómo fluye la información — revela quién tiene poder real y quién no. Y eso incomoda.

Ninguna herramienta de diagnóstico organizacional genera tanta resistencia como ONA. Las encuestas de clima miden percepciones. Las evaluaciones de desempeño miden resultados. Pero ONA mide **relaciones** — y las relaciones están tejidas con política, ego y territorio. Hacer visible lo invisible es un acto que tiene consecuencias, y quien lidera un proyecto de ONA necesita entender la dimensión política tanto como la metodológica.

---

## Por qué ONA genera resistencia

ONA tiene la capacidad de contradecir narrativas establecidas. Puede mostrar que el gerente "indispensable" es en realidad periférico — su equipo consulta a otros. Puede revelar que el departamento que se declara "colaborativo" opera como un silo hermético. Puede exponer que una persona sin título formal concentra más influencia que un director.

Estas verdades estructurales no son abstractas. **Afectan carreras, egos y presupuestos.** Por eso, antes de recopilar datos, necesitas anticipar los miedos que el proyecto va a despertar.

---

## Los 4 miedos del ONA

| Miedo | Quién lo tiene | ¿Es legítimo? | Cómo abordarlo |
|---|---|---|---|
| "Me van a despedir si resulto periférico" | Empleados | Parcialmente — depende de la cultura | Anonimizar resultados individuales, compartir solo patrones agregados |
| "Van a descubrir que no soy tan importante" | Managers cuyo equipo no los consulta | Legítimo — ONA puede contradecir la autoimagen | Presentar como oportunidad de desarrollo, no como evaluación |
| "Esto es vigilancia disfrazada" | Sindicatos, empleados | Legítimo si se usan datos digitales sin consentimiento | Transparencia total sobre qué datos se recopilan y cómo se usan |
| "Los resultados van a generar conflictos políticos" | HR, directivos | Muy legítimo — ONA revela lo que todos saben pero nadie dice | Planificar cómo comunicar resultados ANTES de recopilar datos |

Cada uno de estos miedos es racional. Ignorarlos no los elimina — los convierte en sabotaje pasivo: baja participación, respuestas falsas, rechazo a los hallazgos.

---

## Principios éticos no negociables

Un proyecto de ONA que viola la confianza de los participantes destruye la posibilidad de futuros diagnósticos. Estos cinco principios no son opcionales:

1. **Consentimiento informado**: Nadie participa sin saber exactamente qué se pregunta y cómo se usarán los datos. No basta un correo genérico — se necesita comunicación clara y oportunidad real de preguntar.
2. **Anonimización**: Los resultados individuales **NUNCA** se comparten. Solo se presentan patrones de red agregados. Ningún nombre debe aparecer en reportes ni presentaciones.
3. **Propósito declarado**: Se anuncia antes del estudio por qué se hace el ONA y qué se hará con los resultados. "Queremos entender cómo colaboramos para mejorar" es válido. "Ya veremos qué hacemos" no lo es.
4. **Derecho a no participar**: La participación es voluntaria, sin consecuencias negativas para quien decline. Esto debe ser explícito y creíble.
5. **Destrucción de datos**: Los datos individuales se destruyen después del análisis. Se conservan solo los hallazgos agregados.

> *"La confianza se construye gota a gota y se destruye a baldes. Un ONA mal manejado puede destruir años de credibilidad de HR."*

---

## Cómo comunicar los resultados

La comunicación de hallazgos es donde la mayoría de los proyectos de ONA fracasan políticamente. Este framework reduce el riesgo:

1. **Empezar con lo positivo** — qué funciona bien en la red. Ejemplos: "La conexión entre ventas y soporte es excepcionalmente fuerte", "Identificamos 12 energizantes que sostienen la cultura del equipo".
2. **Presentar patrones estructurales, no desempeño individual** — "Existe una brecha de comunicación entre las áreas X e Y" en lugar de "Juan no se comunica con el equipo de María".
3. **Usar lenguaje de red, no de personas** — "La red muestra que..." en lugar de "Carlos es..." o "Ana no...". La red es el sujeto, no los individuos.
4. **Conectar hallazgos con resultados de negocio** — "Esta brecha estructural explica el 40% de los retrasos en proyectos cross-funcionales" es más poderoso y menos personal que señalar culpables.

---

## El silo del CEO

A veces ONA revela que la persona más aislada de la organización es **el CEO**. Todos reportan a esta persona, pero nadie acude a ella para consejo, información informal o energía. Es el nodo con más autoridad formal y menos influencia relacional.

Este es el hallazgo políticamente más difícil de comunicar. Krackhardt (1990) documentó que los líderes formales frecuentemente sobreestiman su centralidad en la red informal — creen que son consultados más de lo que realmente son. Presentar esta brecha requiere tacto extremo: enmarcar como "oportunidad de amplificar su influencia" y proponer acciones concretas (reuniones informales, almuerzos con equipos operativos, office hours abiertas).

---

## Caso LATAM: Conglomerado familiar en Panamá

Un conglomerado familiar panameño contrató un estudio ONA como parte de su proceso de planificación de sucesión. El hijo mayor del fundador, VP de Operaciones y sucesor designado, era el candidato obvio.

Los resultados contaron otra historia: **el hijo era periférico en la red**. Los empleados respetaban su autoridad formal pero acudían al COO (no familiar) para consejo real, resolución de problemas y colaboración. El COO era el hub operativo de facto.

La reacción inicial del fundador fue predecible: quiso suprimir los resultados. Los consultores navegaron la situación con tres movimientos:

- Presentaron los datos como **"oportunidad de desarrollo"**, no como veredicto
- Diseñaron un programa de **acompañamiento de 6 meses** donde el hijo trabajó directamente con equipos de distintas áreas, construyendo relaciones orgánicas
- Establecieron un **segundo ONA** a los 6 meses para medir progreso

El resultado: cuando el hijo asumió como CEO, ya había construido relaciones genuinas con los nodos clave de la red. La transición, que la junta temía que generara una fuga de talento, fue la más fluida en la historia del conglomerado.

---

### Tu turno

Imagina que vas a presentar resultados de ONA a tu comité directivo. ¿Cuál sería el hallazgo más políticamente difícil de comunicar en tu organización? ¿Cómo lo enmarcarías?

<!-- exercise:ona-s-ex-08 -->

---

**Referencias:**

- Cross, R. & Parker, A. (2004). *The Hidden Power of Social Networks*. Harvard Business School Press.
- Borgatti, S. P. & Cross, R. (2003). "A Relational View of Information Seeking and Learning in Social Networks." *Management Science*, 49(4), 432-445.
- Krackhardt, D. (1990). "Assessing the Political Landscape: Structure, Cognition, and Power in Organizations." *Administrative Science Quarterly*, 35(2), 342-369.
- Reglamento General de Protección de Datos (GDPR). Regulación (UE) 2016/679. Aplicado como referencia para marcos éticos de datos organizacionales.',
  'text',
  8,
  20,
  true
)
,
-- Lesson 9: Tu plan de implementación de 90 días
(
  '0e030300-0000-0000-0000-000000000001',
  '0e000000-0000-0000-0000-000000000001',
  '0e030000-0000-0000-0000-000000000001',
  'Tu plan de implementación de 90 días',
  '# Tu plan de implementación de 90 días

### Ya sabes qué es ONA, por qué importa y qué revela. La pregunta ahora es concreta: ¿cómo lo haces en tu organización, con tus recursos, en los próximos 90 días?

Este no es un módulo teórico. Es una hoja de ruta. Al terminar esta lección tendrás un plan concreto para ejecutar tu primer proyecto de ONA — desde la conversación inicial con un sponsor hasta la presentación de resultados con acciones específicas.

---

## Hoja de ruta en 5 fases

| Fase | Semanas | Actividades clave | Entregable |
|---|---|---|---|
| **1. Explorar** | 1-2 | Definir objetivo, identificar sponsor, evaluar cultura de datos | Business case de 1 página |
| **2. Preparar** | 3-4 | Diseñar encuesta, seleccionar muestra, comunicar a la organización, obtener consentimiento | Encuesta lista + plan de comunicación |
| **3. Recopilar** | 5-7 | Lanzar encuesta, seguimiento de respuestas, alcanzar 80%+ participación | Dataset completo |
| **4. Analizar** | 8-10 | Procesar datos, identificar patrones, preparar visualizaciones | Informe de hallazgos |
| **5. Actuar** | 11-13 | Presentar resultados, diseñar intervenciones, iniciar acciones prioritarias | Plan de acción con owners y fechas |

La fase más importante no es la 4 (analizar) — es la **5 (actuar)**. Un ONA brillante que no produce cambios es peor que no haberlo hecho, porque consume tiempo, genera expectativas y luego las decepciona.

---

## Los 3 errores fatales

Tres errores que convierten un proyecto de ONA prometedor en uno que destruye credibilidad:

**1. Hacer ONA sin plan de acción.** Recopilar datos y no hacer nada genera cinismo organizacional: "¿Para qué nos preguntaron si nada cambió?" Antes de lanzar la encuesta, define qué tipo de intervenciones son posibles. Si la respuesta es "no sabemos", no estás listo para hacer ONA.

**2. Compartir resultados individuales.** Viola la confianza, destruye la posibilidad de futuros estudios y puede generar conflictos legales. Los resultados se presentan como **patrones de red** — nunca como perfiles individuales. "La red muestra un silo entre áreas" es válido. "Pedro no se comunica con nadie fuera de su equipo" no lo es.

**3. No tener sponsor ejecutivo.** Sin alguien con poder para actuar sobre los hallazgos — reasignar personas, crear roles, modificar estructuras — el ONA es un ejercicio académico. El sponsor ideal es alguien en la C-suite que tenga un problema de negocio concreto que ONA puede iluminar.

---

## Cuándo hacer ONA (y cuándo no)

ONA complementa — no reemplaza — las herramientas existentes de gestión de talento. La clave es el **timing**:

| Iniciativa | ONA antes | ONA durante | ONA después |
|---|---|---|---|
| Reestructuración | **Ideal** — identifica conexiones críticas antes de eliminarlas | Tarde — los cambios ya se hicieron | Útil para medir impacto |
| Fusión o adquisición | **Ideal** — mapea redes de ambas organizaciones | Valioso para detectar silos emergentes | Mide integración real |
| Transformación digital | **Ideal** — identifica influenciadores para la coalición de cambio | Valioso para ajustar estrategia | Mide adopción real |
| Evaluaciones de desempeño | Complemento permanente | N/A | N/A |
| Planificación de sucesión | **Ideal** — revela quién realmente influye | N/A | Mide transición |

> *"El mejor momento para hacer ONA es ANTES de una decisión importante. El peor momento es después de haberla tomado mal."* — Adaptado de Cross & Parker, 2004

---

## Canvas de Proyecto ONA

Antes de iniciar, completa este canvas que sintetiza las decisiones clave:

**Objetivo:** ¿Qué problema de negocio queremos resolver?
**Sponsor:** ¿Quién en la C-suite apoya esto y tiene poder para actuar?
**Alcance:** ¿Toda la organización o un segmento específico?
**Método:** ¿Nivel 0, 1, 2 o 3? (Ver Lección 7)
**Timeline:** ¿Cuántas semanas del plan de 90 días aplicamos?
**Comunicación:** ¿Cómo explicamos a los empleados qué es, por qué y cómo se protegen sus datos?
**Ética:** ¿Cómo garantizamos anonimización, consentimiento y destrucción de datos?
**Acción:** ¿Qué haremos con los resultados? ¿Qué intervenciones son viables?

Si no puedes responder **Sponsor** y **Acción**, el proyecto no está listo para lanzarse.

---

## Caso LATAM: Fintech en São Paulo

Una fintech brasileña de 80 personas decidió hacer su primer ONA con el método más accesible posible: **Nivel 2**. La inversión total fue un Google Form con las 4 preguntas universales de ONA, más aproximadamente 40 horas de trabajo de una analista de HR durante 6 semanas. Sin software especializado, sin consultores externos.

Los hallazgos revelaron **3 silos críticos** entre ingeniería, producto y customer success. Los equipos colaboraban internamente con alta frecuencia, pero las conexiones entre áreas eran mínimas — solo 2 personas de 80 funcionaban como puentes entre los tres grupos.

**Las intervenciones fueron simples y de bajo costo:**
- Standups cross-funcionales semanales de 15 minutos
- Un canal compartido de Slack para incidentes de clientes con visibilidad de ingeniería

**Los resultados a 3 meses:** el tiempo de ciclo para bugs reportados por clientes disminuyó un 18%, y la entrega de proyectos cross-equipo mejoró un 25%. La analista de HR que lideró el proyecto fue promovida a una posición de People Analytics — un rol que no existía antes del ONA.

---

## Tu siguiente paso

Si este curso te convenció de que ONA es valioso para tu organización, el siguiente nivel es el curso **ONA Fundamentals**, donde aprenderás a ejecutar un análisis de redes completo con herramientas de visualización, interpretar métricas de centralidad y diseñar intervenciones basadas en datos de red.

Pero no necesitas esperar al siguiente curso para empezar. Con lo que aprendiste en estas 9 lecciones, tienes suficiente para iniciar una conversación con un sponsor, hacer 15 entrevistas semi-estructuradas o diseñar un Google Form con las 4 preguntas universales. **El primer paso no requiere perfección — requiere acción.**

---

### Tu turno

Completa tu propio Canvas de Proyecto ONA para una iniciativa concreta en tu organización. Define objetivo, sponsor, alcance, método y las acciones que tomarías con los resultados.

<!-- exercise:ona-s-ex-09 -->

---

**Referencias:**

- Cross, R. & Parker, A. (2004). *The Hidden Power of Social Networks*. Harvard Business School Press.
- Pentland, A. (2014). *Social Physics: How Social Networks Can Make Us Smarter*. Penguin Books.
- Borgatti, S. P., Everett, M. G. & Johnson, J. C. (2013). *Analyzing Social Networks*. SAGE Publications.
- Cross, R., Taylor, S. & Zehner, D. (2021). "A Noble Purpose Alone Won''t Transform Your Company." *Harvard Business Review*.',
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

-- 4. Insertar los ejercicios (quizzes) como JSONB
-- Cada quiz tiene 6 preguntas, passing_score: 60

-- Quiz 1: Organigrama vs. red real (Lección 1)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  '0e000000-0000-0000-0000-000000000001',
  '0e010000-0000-0000-0000-000000000001',
  '0e010100-0000-0000-0000-000000000001',
  'ona-s-ex-01',
  'quiz',
  '{
  "id": "ona-s-ex-01",
  "title": "Organigrama vs. red real",
  "description": "Evalúa tu comprensión de la diferencia entre estructura formal e informal.",
  "questions": [
    {
      "question": "Toda organización opera con dos estructuras simultáneas. ¿Cuáles son?",
      "options": [
        "La estructura de costos y la estructura de ingresos",
        "El organigrama formal y la red informal de relaciones",
        "La estructura jerárquica y la estructura matricial",
        "La cultura explícita y la cultura implícita"
      ],
      "correct": 1,
      "explanation": "Las dos estructuras son el organigrama formal (líneas de reporte, comités) y la red informal (flujos de información, confianza, influencia). ONA hace visible la segunda."
    },
    {
      "question": "¿Qué mide específicamente el Análisis de Redes Organizacionales (ONA)?",
      "options": [
        "Satisfacción laboral y engagement de los empleados",
        "Productividad individual y cumplimiento de KPIs",
        "Flujos de información, lazos de confianza y patrones de influencia entre personas",
        "Competencias técnicas y potencial de liderazgo"
      ],
      "correct": 2,
      "explanation": "ONA mide estructura relacional: quién se conecta con quién, con qué frecuencia y para qué. No mide satisfacción (eso es clima) ni competencias (eso es evaluación de desempeño)."
    },
    {
      "question": "¿Quién introdujo el concepto de ''la fuerza de los lazos débiles'' (The Strength of Weak Ties)?",
      "options": [
        "Jacob Moreno en 1934",
        "Mark Granovetter en 1973",
        "Rob Cross en 2004",
        "Ron Burt en 1992"
      ],
      "correct": 1,
      "explanation": "Granovetter (1973) demostró que los lazos débiles — conexiones con personas fuera de tu círculo cercano — son los que conectan mundos distintos y facilitan el acceso a nueva información."
    },
    {
      "question": "En el caso de TechCorp Colombia, ¿qué ocurrió cuando despidieron a la analista de QA durante la reestructuración?",
      "options": [
        "La productividad del equipo de QA bajó temporalmente",
        "Los incidentes cross-team se duplicaron porque ella era el único puente informal entre TI y Producto",
        "El organigrama tuvo que ser rediseñado nuevamente",
        "Otros analistas asumieron sus funciones sin problema"
      ],
      "correct": 1,
      "explanation": "La analista era el broker invisible entre TI y Producto. Sin ella, los incidentes cross-team se duplicaron y el tiempo de resolución pasó de 2 a 8 días. ONA habría revelado su rol crítico."
    },
    {
      "question": "¿Por qué ONA es especialmente urgente en el contexto del trabajo híbrido?",
      "options": [
        "Porque los empleados remotos necesitan más supervisión",
        "Porque las herramientas digitales generan más datos para analizar",
        "Porque los lazos débiles entre equipos se erosionaron y los silos se profundizaron",
        "Porque las oficinas están vacías y hay que justificar el espacio"
      ],
      "correct": 2,
      "explanation": "Microsoft Research (2021) encontró que el trabajo remoto redujo lazos débiles en 25%, aumentó silos y disminuyó la comunicación espontánea. ONA restaura la visibilidad perdida."
    },
    {
      "question": "La centralidad de intermediación (betweenness centrality) mide:",
      "options": [
        "Cuántas personas conoce alguien en la organización",
        "Qué tan satisfecho está alguien con su posición",
        "Qué tanto una persona funciona como puente entre grupos desconectados",
        "El nivel jerárquico formal de una persona"
      ],
      "correct": 2,
      "explanation": "La centralidad de intermediación mide cuántos caminos más cortos entre pares de personas pasan por un nodo. Alta intermediación = persona que conecta grupos que de otra forma no se comunicarían."
    }
  ],
  "passing_score": 60,
  "exercise_type": "quiz",
  "difficulty": "beginner",
  "estimated_duration_minutes": 5
}'::jsonb,
  1
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- Quiz 2: Identifica el rol de red (Lección 2)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  '0e000000-0000-0000-0000-000000000001',
  '0e010000-0000-0000-0000-000000000001',
  '0e010200-0000-0000-0000-000000000001',
  'ona-s-ex-02',
  'quiz',
  '{
  "id": "ona-s-ex-02",
  "title": "Identifica el rol de red",
  "description": "Reconoce los cinco roles informales en escenarios organizacionales reales.",
  "questions": [
    {
      "question": "María es gerente de operaciones. Todos acuden a ella para resolver problemas, está en todas las reuniones importantes y su bandeja de entrada nunca baja de 200 correos. ¿Qué rol informal cumple?",
      "options": [
        "Broker (Puente)",
        "Energizante",
        "Hub (Conector central)",
        "Influenciador oculto"
      ],
      "correct": 2,
      "explanation": "María es un Hub: alto grado de centralidad, muchos acuden a ella. El riesgo es la sobrecarga — es un cuello de botella y single point of failure."
    },
    {
      "question": "Diego es analista junior, pero cuando opina en reuniones de equipo, los demás cambian de dirección. No tiene autoridad formal, pero sus ideas influyen en las decisiones del grupo. ¿Qué rol cumple?",
      "options": [
        "Hub (Conector central)",
        "Periférico",
        "Broker (Puente)",
        "Influenciador oculto"
      ],
      "correct": 3,
      "explanation": "Diego es un Influenciador oculto: sin autoridad formal, sus opiniones impactan decisiones de otros. Si no se le incluye en procesos de cambio, puede generar resistencia inexplicable."
    },
    {
      "question": "Lucía trabaja entre las oficinas de Lima y Bogotá. Es la única persona que mantiene relaciones activas en ambos países. Sin ella, los equipos de cada país no se comunican. ¿Qué rol cumple?",
      "options": [
        "Energizante",
        "Broker (Puente)",
        "Hub (Conector central)",
        "Periférico"
      ],
      "correct": 1,
      "explanation": "Lucía es un Broker: conecta grupos que de otra forma no se comunicarían. Si se va, los silos entre países se profundizan y la información deja de fluir."
    },
    {
      "question": "Después de hablar con Carlos, los miembros del equipo reportan sentirse más motivados y con más energía para enfrentar los desafíos del proyecto. ¿Qué rol cumple Carlos?",
      "options": [
        "Hub (Conector central)",
        "Influenciador oculto",
        "Periférico",
        "Energizante"
      ],
      "correct": 3,
      "explanation": "Carlos es un Energizante: las personas se sienten motivadas después de interactuar con él. Si se pierde, la moral y el engagement del equipo caen."
    },
    {
      "question": "Ana lleva 6 meses trabajando en remoto. Nadie fuera de su equipo inmediato sabe en qué trabaja. No participa en conversaciones informales y tiene solo 2 contactos en toda la organización. ¿Qué rol ocupa?",
      "options": [
        "Broker (Puente)",
        "Periférico",
        "Influenciador oculto",
        "Energizante"
      ],
      "correct": 1,
      "explanation": "Ana es Periférica: pocos lazos, desconectada de la red principal. La acción es investigar la causa (¿es por ser remota? ¿nueva? ¿excluida?) y crear puentes deliberados."
    },
    {
      "question": "¿Qué es la ''sobrecarga colaborativa'' (collaborative overload)?",
      "options": [
        "Tener demasiadas herramientas de colaboración (Slack, Teams, email)",
        "La carga desproporcionada de trabajo relacional que absorben los Hubs y Brokers sin que se reconozca ni compense",
        "Trabajar en demasiados proyectos simultáneamente",
        "El exceso de reuniones virtuales en trabajo remoto"
      ],
      "correct": 1,
      "explanation": "Cross et al. (2021) documentaron que el 20-35% de las colaboraciones de valor provienen del 3-5% de empleados, quienes dedican hasta 50% más de tiempo a ayudar a otros — sin reconocimiento ni compensación."
    }
  ],
  "passing_score": 60,
  "exercise_type": "quiz",
  "difficulty": "beginner",
  "estimated_duration_minutes": 5
}'::jsonb,
  2
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- Quiz 3: Diagnostica el caso de negocio (Lección 3)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  '0e000000-0000-0000-0000-000000000001',
  '0e010000-0000-0000-0000-000000000001',
  '0e010300-0000-0000-0000-000000000001',
  'ona-s-ex-03',
  'quiz',
  '{
  "id": "ona-s-ex-03",
  "title": "Diagnostica el caso de negocio",
  "description": "Decide si ONA aplica y qué problemas resolvería en escenarios específicos.",
  "questions": [
    {
      "question": "¿Cuál de estas herramientas diagnósticas captura quién colabora con quién y cómo fluye la información?",
      "options": [
        "Encuesta de clima organizacional",
        "Evaluación 360°",
        "Análisis de Redes Organizacionales (ONA)",
        "People analytics (rotación, productividad)"
      ],
      "correct": 2,
      "explanation": "ONA es la única herramienta que mapea la estructura relacional: quién se conecta con quién, con qué frecuencia y para qué. Clima mide satisfacción, 360 mide competencias percibidas, analytics mide productividad."
    },
    {
      "question": "¿En cuál de estas situaciones NO deberías hacer ONA?",
      "options": [
        "Antes de una fusión entre dos empresas",
        "Durante un ciclo activo de despidos",
        "Para evaluar la efectividad del onboarding",
        "Antes de una transformación digital"
      ],
      "correct": 1,
      "explanation": "Durante despidos activos, las personas no responderán honestamente por miedo a que la información se use en su contra. La confianza es prerrequisito para ONA válido."
    },
    {
      "question": "Según Cross y Parker (2004), ¿qué mejora se observa cuando ONA informa decisiones de reestructuración?",
      "options": [
        "Reducción del 50% en costos de personal",
        "Mejora del 20-30% en tiempo de productividad post-cambio",
        "Aumento del 40% en satisfacción laboral",
        "Eliminación total de silos organizacionales"
      ],
      "correct": 1,
      "explanation": "Cross y Parker documentaron que proteger las conexiones críticas (en lugar de destruirlas accidentalmente) mejora el tiempo de productividad post-reestructuración entre 20% y 30%."
    },
    {
      "question": "Una empresa está fusionando dos divisiones. ¿Qué revela ONA que otras herramientas no pueden?",
      "options": [
        "Si los empleados están satisfechos con la fusión",
        "Las conexiones reales entre ambas divisiones vs. lo que dice el nuevo organigrama",
        "Los costos de la integración",
        "Las competencias técnicas que faltan"
      ],
      "correct": 1,
      "explanation": "ONA revela qué tan conectados (o aislados) están realmente los equipos fusionados — más allá del organigrama formal. Puede mostrar que solo 4 personas de 800 conectan ambos lados."
    },
    {
      "question": "En el caso de Grupo Bimbo, ¿qué colapsó después de dos años de trabajo virtual?",
      "options": [
        "La productividad dentro de cada planta",
        "Los lazos fuertes entre equipos directos",
        "Los lazos débiles entre plantas de diferentes estados",
        "El sistema de comunicación formal"
      ],
      "correct": 2,
      "explanation": "Los lazos débiles entre plantas colapsaron — las reuniones virtuales no reemplazaron los encuentros presenciales informales. El intercambio de mejoras de proceso entre plantas cayó un 40%."
    },
    {
      "question": "Tu organización tiene 15 personas. ¿Deberías implementar un proyecto de ONA formal?",
      "options": [
        "Sí, toda organización necesita ONA",
        "No, con 15 personas puedes mapear la red conversando directamente — una encuesta formal es desproporcionada",
        "Sí, pero solo a nivel digital (análisis de emails)",
        "Depende del presupuesto"
      ],
      "correct": 1,
      "explanation": "Con menos de 20 personas, la red es suficientemente pequeña para mapearla conversando. Una encuesta formal agrega burocracia sin valor proporcional."
    }
  ],
  "passing_score": 60,
  "exercise_type": "quiz",
  "difficulty": "intermediate",
  "estimated_duration_minutes": 5
}'::jsonb,
  3
)
ON CONFLICT (course_id, exercise_id) DO UPDATE SET
  exercise_data = EXCLUDED.exercise_data,
  lesson_id = EXCLUDED.lesson_id;

-- Quiz 4: Diagnostica el silo (Lección 4)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  '0e000000-0000-0000-0000-000000000001',
  '0e020000-0000-0000-0000-000000000001',
  '0e020100-0000-0000-0000-000000000001',
  'ona-s-ex-04',
  'quiz',
  '{
  "id": "ona-s-ex-04",
  "title": "Diagnostica el silo",
  "description": "Identifica el tipo de silo, su severidad y la intervención más efectiva.",
  "questions": [
    {
      "question": "Las oficinas de CDMX y Lima de una multinacional duplican el mismo análisis de mercado sin saberlo. ¿Qué tipo de silo es?",
      "options": [
        "Funcional",
        "Generacional",
        "Geográfico",
        "De adquisición"
      ],
      "correct": 2,
      "explanation": "Es un silo geográfico: oficinas en distintas ciudades no se comunican. La señal típica es exactamente esta — trabajo duplicado entre ubicaciones."
    },
    {
      "question": "Tres años después de una adquisición, los empleados siguen diciendo ''nosotros'' y ''ellos'' al referirse a la empresa original y la adquirida. ¿Qué tipo de silo es?",
      "options": [
        "Geográfico",
        "Funcional",
        "Generacional",
        "De adquisición"
      ],
      "correct": 3,
      "explanation": "Es un silo de adquisición: post-fusión, las empresas originales siguen operando como entidades separadas. La identidad cultural no se integró a pesar de la fusión formal."
    },
    {
      "question": "¿Cuál de estas intervenciones tiene la MENOR efectividad para romper silos?",
      "options": [
        "Rotación de personal entre áreas",
        "Proyectos conjuntos con entregables compartidos",
        "Reorganizar el organigrama",
        "Espacios físicos de coincidencia (efecto cafetería)"
      ],
      "correct": 2,
      "explanation": "Reorganizar el organigrama tiene efectividad BAJA — cambia la estructura formal pero no las relaciones reales. Los silos informales persisten independientemente de las líneas de reporte."
    },
    {
      "question": "En el caso de CEMEX México/Colombia, ¿cuántas personas de 800 mantenían relaciones activas entre ambos países?",
      "options": [
        "Aproximadamente 50",
        "Solo 4",
        "Ninguna",
        "Alrededor de 200"
      ],
      "correct": 1,
      "explanation": "Solo 4 ''super-brokers'' de 800 empleados conectaban ambos países. Cuando uno fue promovido a un rol local, el 25% de los proyectos transfronterizos se estancó."
    },
    {
      "question": "Según Deloitte, ¿cuánta productividad pierden los knowledge workers por culpa de los silos?",
      "options": [
        "5-10%",
        "15-25%",
        "30-40%",
        "Menos del 5%"
      ],
      "correct": 1,
      "explanation": "Deloitte estima que las organizaciones con silos pronunciados pierden entre 15% y 25% de la productividad de los trabajadores de conocimiento — en trabajo duplicado, decisiones retrasadas e innovación atrapada."
    },
    {
      "question": "¿Qué intervención crea lazos duraderos entre áreas porque la persona lleva consigo relaciones y contexto?",
      "options": [
        "Crear comités interfuncionales",
        "Reorganizar el organigrama",
        "Rotación de personal entre áreas",
        "Enviar un email de la dirección pidiendo colaboración"
      ],
      "correct": 2,
      "explanation": "La rotación de personal tiene efectividad ALTA porque crea lazos que persisten después de la rotación — la persona lleva consigo las relaciones y el contexto de ambas áreas."
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

-- Quiz 5: Evalúa la dependencia crítica (Lección 5)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  '0e000000-0000-0000-0000-000000000001',
  '0e020000-0000-0000-0000-000000000001',
  '0e020200-0000-0000-0000-000000000001',
  'ona-s-ex-05',
  'quiz',
  '{
  "id": "ona-s-ex-05",
  "title": "Evalúa la dependencia crítica",
  "description": "Clasifica niveles de dependencia y prioriza acciones de mitigación.",
  "questions": [
    {
      "question": "''Solo María sabe cómo funciona el sistema de facturación.'' ¿Qué nivel de dependencia crítica es?",
      "options": [
        "Relacional",
        "Operativo",
        "Estratégico",
        "No es una dependencia crítica"
      ],
      "correct": 1,
      "explanation": "Es dependencia operativa: conocimiento tácito sobre procesos diarios. Es la más visible y fácil de resolver — con documentación y cross-training."
    },
    {
      "question": "''Los clientes solo hablan con Juan — es la única persona en quien confían.'' ¿Qué nivel de dependencia es?",
      "options": [
        "Operativo",
        "Estratégico",
        "Relacional",
        "No aplica"
      ],
      "correct": 2,
      "explanation": "Es dependencia relacional: la persona es el puente de confianza con clientes. Es difícil de transferir porque la confianza se construye con tiempo, no se asigna por decreto."
    },
    {
      "question": "¿Cuál es el error fundamental de los planes de sucesión tradicionales?",
      "options": [
        "No identifican sucesores con suficiente anticipación",
        "No evalúan competencias técnicas adecuadamente",
        "Planifican el reemplazo del rol, no de las relaciones",
        "No incluyen a candidatos externos"
      ],
      "correct": 2,
      "explanation": "Los planes de sucesión reemplazan ROLES pero no RELACIONES. Si el valor del ejecutivo estaba en su capital social (red de confianza, influencia lateral), el sucesor hereda el título pero no la red."
    },
    {
      "question": "En el caso de la aseguradora peruana, ¿por qué cayó la cartera 20% si el sucesor estaba preparado?",
      "options": [
        "El sucesor no tenía experiencia suficiente",
        "Los clientes tenían relación personal con el director, no con la empresa — la confianza no se transfirió",
        "La empresa cambió sus productos",
        "El mercado de seguros estaba en crisis"
      ],
      "correct": 1,
      "explanation": "La confianza estaba depositada en la persona, no en la empresa. Los clientes más grandes tenían relación personal con el director de 15 años. ONA habría revelado esta dependencia relacional."
    },
    {
      "question": "¿Qué es el ''networking en sombra'' como estrategia de sucesión?",
      "options": [
        "Un programa secreto para espiar a los empleados",
        "Construir relaciones en redes sociales",
        "El sucesor construye relaciones propias junto al titular durante 6-12 meses antes de la transición",
        "Contratar un consultor externo para mapear la red"
      ],
      "correct": 2,
      "explanation": "El networking en sombra permite que el sucesor construya relaciones orgánicas acompañando al titular en interacciones clave, para que la confianza se transfiera naturalmente antes de la salida."
    },
    {
      "question": "¿Cuál de los tres niveles de dependencia es el más difícil de transferir?",
      "options": [
        "Operativo — el conocimiento técnico es muy especializado",
        "Relacional — las relaciones de confianza toman años",
        "Estratégico — la influencia informal es sistémica, no individual",
        "Todos son igualmente difíciles"
      ],
      "correct": 2,
      "explanation": "La dependencia estratégica es la más peligrosa: la persona influye decisiones clave sin autoridad formal. Es sistémica — no se resuelve documentando procesos ni presentando al sucesor."
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

-- Quiz 6: ¿Red saludable o enferma? (Lección 6)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  '0e000000-0000-0000-0000-000000000001',
  '0e020000-0000-0000-0000-000000000001',
  '0e020300-0000-0000-0000-000000000001',
  'ona-s-ex-06',
  'quiz',
  '{
  "id": "ona-s-ex-06",
  "title": "¿Red saludable o enferma?",
  "description": "Evalúa la salud de una red organizacional e identifica patologías.",
  "questions": [
    {
      "question": "En una organización, todos están en todas las reuniones y todos tienen acceso a todos los canales. ¿Es señal de red saludable?",
      "options": [
        "Sí — máxima conectividad es siempre mejor",
        "No — es exceso de densidad (reunionitis crónica) que genera sobrecarga sin agregar valor",
        "Depende del tamaño de la organización",
        "Sí, si son reuniones cortas"
      ],
      "correct": 1,
      "explanation": "La densidad adecuada no es máxima densidad. Cuando todos están conectados con todos, se genera reunionitis y sobrecarga. Lo saludable es suficientes conexiones sin exceso."
    },
    {
      "question": "Las 3 personas más conectadas de tu organización se van de vacaciones al mismo tiempo y el trabajo se paraliza. ¿Qué señal de red falla?",
      "options": [
        "Densidad adecuada",
        "Diversidad de lazos",
        "Redundancia de puentes",
        "Reciprocidad"
      ],
      "correct": 2,
      "explanation": "Si la red depende de 3 personas para funcionar, falta redundancia de puentes. Una red saludable tiene múltiples personas que conectan los mismos grupos — la salida de uno no paraliza el flujo."
    },
    {
      "question": "En el modelo de capital social de Nahapiet y Ghoshal, ¿qué dimensión captura la confianza y la reciprocidad?",
      "options": [
        "Dimensión estructural",
        "Dimensión cognitiva",
        "Dimensión relacional",
        "Dimensión operativa"
      ],
      "correct": 2,
      "explanation": "La dimensión relacional captura la calidad de los vínculos: confianza, reciprocidad, normas compartidas. La estructural es quién está conectado con quién. La cognitiva es lenguaje y visión compartida."
    },
    {
      "question": "En el caso de Mercado Libre, ¿qué función cumplen las ''guildas'' en la red organizacional?",
      "options": [
        "Son equipos de ejecución de proyectos",
        "Son comunidades transversales que crean puentes entre squads — diversidad de lazos",
        "Son comités de dirección",
        "Son grupos de capacitación técnica"
      ],
      "correct": 1,
      "explanation": "Las guildas son comunidades de práctica transversales que crean puentes entre squads. Un ingeniero pertenece a su squad para ejecutar y a la guilda para aprender, generando diversidad de lazos."
    },
    {
      "question": "Un empleado nuevo lleva 6 meses en la empresa y no puede nombrar a nadie fuera de su equipo inmediato a quien pediría ayuda. ¿Qué señal de red falla?",
      "options": [
        "Densidad adecuada",
        "Reciprocidad",
        "Periferia conectada",
        "Redundancia de puentes"
      ],
      "correct": 2,
      "explanation": "Si un empleado nuevo no tiene lazos fuera de su equipo inmediato después de 6 meses, la periferia está desconectada. El onboarding no generó lazos transversales."
    },
    {
      "question": "¿Qué porcentaje más rápido entregaban funcionalidades los ingenieros de Mercado Libre que participaban en al menos una guilda?",
      "options": [
        "10%",
        "23%",
        "35%",
        "50%"
      ],
      "correct": 1,
      "explanation": "Los ingenieros en al menos una guilda entregaban funcionalidades un 23% más rápido — porque reutilizaban soluciones de otros squads en lugar de reinventarlas."
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

-- Quiz 7: Diseña tu proyecto ONA (Lección 7)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  '0e000000-0000-0000-0000-000000000001',
  '0e030000-0000-0000-0000-000000000001',
  '0e030100-0000-0000-0000-000000000001',
  'ona-s-ex-07',
  'quiz',
  '{
  "id": "ona-s-ex-07",
  "title": "Diseña tu proyecto ONA",
  "description": "Elige el método correcto y evita errores comunes de encuesta ONA.",
  "questions": [
    {
      "question": "Para una organización de 150 personas con un equipo de HR dedicado, ¿qué nivel de ONA es más recomendable?",
      "options": [
        "Nivel 0 — Observación",
        "Nivel 1 — Entrevistas",
        "Nivel 2 — Encuesta online",
        "Nivel 3 — Análisis digital"
      ],
      "correct": 2,
      "explanation": "Nivel 2 (encuesta) es ideal para 100-1000+ personas con HR dedicado. Nivel 1 es para 50-200, Nivel 0 para equipos pequeños, y Nivel 3 requiere herramientas de people analytics."
    },
    {
      "question": "¿Cuál es la tasa de respuesta mínima para que los resultados de una encuesta ONA sean válidos?",
      "options": [
        "50%",
        "60%",
        "80%",
        "95%"
      ],
      "correct": 2,
      "explanation": "Se necesita 80% o más. Debajo de esto, los resultados tienen vacíos estructurales que invalidan el análisis. Una red con 60% de respuestas es como un mapa con 40% de calles borradas."
    },
    {
      "question": "¿Cuál de estas NO es una de las 4 preguntas universales de ONA (Cross & Parker, 2004)?",
      "options": [
        "¿A quién acudes cuando necesitas información o consejo?",
        "¿Qué tan satisfecho estás con tu trabajo actual?",
        "¿Con quién interactúas regularmente para realizar tu trabajo?",
        "¿Quién te energiza o motiva en el trabajo?"
      ],
      "correct": 1,
      "explanation": "La satisfacción laboral es una pregunta de encuesta de clima, no de ONA. Las 4 preguntas ONA son: información/consejo, decisión, colaboración y energía."
    },
    {
      "question": "En el caso del hospital en Chile, ¿qué método de ONA usó la jefa de enfermería?",
      "options": [
        "Nivel 0 — Observación en la oficina",
        "Nivel 1 — 20 entrevistas semi-estructuradas de 30 minutos",
        "Nivel 2 — Encuesta online a todo el hospital",
        "Nivel 3 — Análisis de metadata de emails"
      ],
      "correct": 1,
      "explanation": "Usó Nivel 1: 20 entrevistas semi-estructuradas. Con solo 10 horas de entrevistas y una hoja de cálculo, descubrió que una enfermera coordinaba el 70% de los casos urgentes informalmente."
    },
    {
      "question": "¿Por qué el patrocinio ejecutivo (sponsorship) es no negociable para un proyecto de ONA?",
      "options": [
        "Porque solo los ejecutivos entienden ONA",
        "Porque sin alguien con poder para actuar sobre los resultados, el ONA se vuelve un ejercicio académico que genera cinismo",
        "Porque el presupuesto siempre viene de la dirección",
        "Porque los empleados solo participan si lo ordena un ejecutivo"
      ],
      "correct": 1,
      "explanation": "ONA revela dinámicas de poder. Sin un ejecutivo con autoridad para reasignar personas, crear roles o modificar estructuras, los datos se archivan y los participantes se preguntan para qué les pidieron su tiempo."
    },
    {
      "question": "¿Qué es el ''roster method'' en una encuesta ONA?",
      "options": [
        "Un método para organizar las respuestas por departamento",
        "Una lista pre-poblada de nombres donde el participante selecciona, en lugar de escribir nombres libremente",
        "Un ranking de las personas más conectadas",
        "Un método para anonimizar resultados"
      ],
      "correct": 1,
      "explanation": "El roster method presenta una lista de nombres para seleccionar (vs. free recall donde escriben nombres). Reduce sesgos de memoria y estandariza respuestas."
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

-- Quiz 8: Ética y política del ONA (Lección 8)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  '0e000000-0000-0000-0000-000000000001',
  '0e030000-0000-0000-0000-000000000001',
  '0e030200-0000-0000-0000-000000000001',
  'ona-s-ex-08',
  'quiz',
  '{
  "id": "ona-s-ex-08",
  "title": "Ética y política del ONA",
  "description": "Navega dilemas éticos y situaciones políticamente sensibles del ONA.",
  "questions": [
    {
      "question": "ONA revela que el CEO es la persona más aislada de la organización — todos reportan a él pero nadie acude a él para consejo. ¿Cómo comunicar este hallazgo?",
      "options": [
        "Presentar los datos directamente: ''Usted es periférico en la red''",
        "Enmarcar como ''oportunidad de amplificar su influencia'' y proponer acciones concretas como office hours abiertas",
        "No compartir ese dato — es demasiado político",
        "Compartir solo con el CHRO y dejar que ella decida"
      ],
      "correct": 1,
      "explanation": "Enmarcar como oportunidad, no como veredicto. Proponer acciones concretas (reuniones informales, almuerzos con equipos operativos) transforma un dato incómodo en un plan de desarrollo."
    },
    {
      "question": "¿Cuál principio ético establece que los resultados individuales de ONA NUNCA se comparten?",
      "options": [
        "Consentimiento informado",
        "Derecho a no participar",
        "Anonimización",
        "Destrucción de datos"
      ],
      "correct": 2,
      "explanation": "La anonimización garantiza que solo se presentan patrones de red agregados. Ningún nombre debe aparecer en reportes ni presentaciones. Los resultados individuales nunca se comparten."
    },
    {
      "question": "Al comunicar resultados de ONA, ¿qué debe ser el sujeto de las frases?",
      "options": [
        "Las personas específicas (''Carlos no colabora'')",
        "Los departamentos (''Marketing es un silo'')",
        "La red (''La red muestra una brecha entre las áreas X e Y'')",
        "El equipo de HR (''Nosotros detectamos que...'')"
      ],
      "correct": 2,
      "explanation": "''La red muestra que...'' es correcto. Nunca ''Carlos es...'' o ''Ana no...''. La red es el sujeto, no los individuos. Esto protege personas y mantiene el foco en patrones estructurales."
    },
    {
      "question": "En el caso del conglomerado familiar panameño, ¿qué reveló ONA sobre el hijo del fundador (sucesor designado)?",
      "options": [
        "Que era el hub más conectado de la organización",
        "Que era periférico en la red — los empleados acudían al COO (no familiar) para consejo real",
        "Que tenía conflictos con otros directivos",
        "Que no tenía las competencias técnicas necesarias"
      ],
      "correct": 1,
      "explanation": "El hijo era periférico: los empleados respetaban su autoridad formal pero acudían al COO para consejo real y colaboración. Los consultores enmarcaron esto como oportunidad de desarrollo."
    },
    {
      "question": "Un empleado teme que si aparece como periférico en el ONA lo van a despedir. ¿Es legítimo este miedo?",
      "options": [
        "No — ONA es solo diagnóstico, nunca se usa para despidos",
        "Parcialmente — depende de la cultura organizacional, por eso se debe anonimizar y compartir solo patrones",
        "Sí — siempre es un riesgo directo",
        "No — los resultados no se comparten con nadie"
      ],
      "correct": 1,
      "explanation": "El miedo es parcialmente legítimo porque depende de la cultura de la organización. Por eso es fundamental anonimizar resultados individuales y compartir solo patrones agregados."
    },
    {
      "question": "Según el framework de comunicación de resultados, ¿qué es lo PRIMERO que debes presentar?",
      "options": [
        "Los problemas más graves que encontraste",
        "Las recomendaciones de acción",
        "Lo que funciona bien en la red — empezar con lo positivo",
        "La metodología utilizada"
      ],
      "correct": 2,
      "explanation": "Siempre empezar con lo positivo: qué funciona bien en la red. Esto genera receptividad antes de presentar hallazgos más difíciles. Ejemplos: ''La conexión entre ventas y soporte es excepcionalmente fuerte.''"
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

-- Quiz 9: Quiz final integrativo (Lección 9)
INSERT INTO course_exercises (id, course_id, module_id, lesson_id, exercise_id, exercise_type, exercise_data, order_index)
VALUES (
  gen_random_uuid(),
  '0e000000-0000-0000-0000-000000000001',
  '0e030000-0000-0000-0000-000000000001',
  '0e030300-0000-0000-0000-000000000001',
  'ona-s-ex-09',
  'quiz',
  '{
  "id": "ona-s-ex-09",
  "title": "Quiz final integrativo",
  "description": "Integra todos los conceptos del curso en escenarios de decisión complejos.",
  "questions": [
    {
      "question": "Una empresa planifica una reestructuración. ¿Cuándo debería hacer ONA?",
      "options": [
        "Después de la reestructuración para medir el impacto",
        "ANTES — para identificar conexiones críticas antes de eliminarlas accidentalmente",
        "Durante — para ajustar en tiempo real",
        "No es relevante para reestructuraciones"
      ],
      "correct": 1,
      "explanation": "El mejor momento es ANTES. ONA identifica quién conecta áreas críticas, evitando que se destruyan puentes invisibles como en el caso de TechCorp Colombia."
    },
    {
      "question": "Una persona en tu organización es consultada por todos, conecta 3 departamentos y muestra señales de burnout. ¿Qué rol cumple y cuál es el riesgo principal?",
      "options": [
        "Energizante con riesgo de desmotivación",
        "Hub/Broker con sobrecarga colaborativa (collaborative overload)",
        "Influenciador oculto con riesgo de sabotaje",
        "Periférico con riesgo de fuga"
      ],
      "correct": 1,
      "explanation": "Es un Hub/Broker sufriendo collaborative overload: absorbe carga relacional desproporcionada sin reconocimiento. Cross et al. (2021) documentaron que el 3-5% de empleados genera 20-35% del valor colaborativo."
    },
    {
      "question": "Post-fusión, solo 2 personas conectan ambas empresas. ¿Qué dos conceptos del curso explican mejor esta situación?",
      "options": [
        "Densidad baja + periferia desconectada",
        "Agujeros estructurales (structural holes) + silo de adquisición",
        "Sobrecarga colaborativa + falta de reciprocidad",
        "Dependencia operativa + silo funcional"
      ],
      "correct": 1,
      "explanation": "Los agujeros estructurales (Burt) explican que hay un vacío de conexiones entre ambos grupos. El silo de adquisición explica que las empresas originales siguen operando como entidades separadas a pesar de la fusión."
    },
    {
      "question": "Hiciste un ONA pero no decidiste qué hacer con los resultados. ¿Cuál de los 3 errores fatales es?",
      "options": [
        "Compartir resultados individuales",
        "No tener sponsor ejecutivo",
        "Hacer ONA sin plan de acción",
        "No alcanzar 80% de respuestas"
      ],
      "correct": 2,
      "explanation": "Hacer ONA sin plan de acción genera cinismo: ''¿Para qué nos preguntaron si nada cambió?'' Antes de lanzar la encuesta, define qué intervenciones son posibles."
    },
    {
      "question": "En el caso de la fintech brasileña de 80 personas, ¿cuál fue la inversión total del proyecto ONA?",
      "options": [
        "Consultoría externa de $50,000",
        "Un Google Form con 4 preguntas + ~40 horas de una analista de HR",
        "Software de people analytics + 3 meses de implementación",
        "Entrevistas a los 80 empleados durante 2 meses"
      ],
      "correct": 1,
      "explanation": "La inversión fue mínima: un Google Form gratis + 40 horas de trabajo de una analista durante 6 semanas. Sin software especializado ni consultores. El resultado: cycle time bajó 18% y entregas cross-equipo mejoraron 25%."
    },
    {
      "question": "En el Canvas de Proyecto ONA, si no puedes responder dos campos específicos, el proyecto no está listo. ¿Cuáles son?",
      "options": [
        "Objetivo y Alcance",
        "Método y Timeline",
        "Sponsor y Acción",
        "Comunicación y Ética"
      ],
      "correct": 2,
      "explanation": "Sin Sponsor (quién tiene poder para actuar) y sin Acción (qué haremos con los resultados), el proyecto no debe lanzarse. Los demás campos son importantes pero estos dos son prerrequisitos."
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
    'Curso Intro ONA creado' as status,
    (SELECT COUNT(*) FROM courses WHERE slug = 'intro-ona') as cursos,
    (SELECT COUNT(*) FROM modules WHERE course_id = '0e000000-0000-0000-0000-000000000001') as modulos,
    (SELECT COUNT(*) FROM lessons WHERE course_id = '0e000000-0000-0000-0000-000000000001') as lecciones,
    (SELECT COUNT(*) FROM course_exercises WHERE course_id = '0e000000-0000-0000-0000-000000000001') as ejercicios;
