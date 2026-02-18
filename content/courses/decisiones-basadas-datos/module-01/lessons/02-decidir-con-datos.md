# ¿Qué significa decidir con datos?

### No es lo que crees

"Somos una empresa data-driven." Si tuvieras un dólar por cada organización que dice esto sin serlo, probablemente no necesitarías este curso.

Decidir con datos **no** es:
- Hacer un dashboard bonito y revisarlo en la reunión semanal
- Pedir un reporte para justificar una decisión ya tomada
- Agregar números a una presentación para que parezca más seria

Decidir con datos **sí** es:
- Formular una pregunta antes de buscar la respuesta
- Estar dispuesto a cambiar de opinión si la evidencia contradice tu hipótesis
- Tener un proceso estructurado que reduce sesgos cognitivos

---

## El espectro de la toma de decisiones

Las decisiones no son binarias entre "pura intuición" y "puro análisis". Existe un espectro:

| Nivel | Descripción | Ejemplo |
|---|---|---|
| **0 — Intuición pura** | "Lo siento en el estómago" | "Creo que deberíamos expandirnos a Colombia" |
| **1 — Opinión informada** | Experiencia + algo de información | "He trabajado en 3 mercados similares y creo que Colombia funcionaría" |
| **2 — Datos descriptivos** | Datos del pasado, sin análisis causal | "Las ventas en mercados similares crecieron 15% el último año" |
| **3 — Análisis causal** | Entender por qué pasan las cosas | "El crecimiento se correlaciona con ingreso disponible per cápita > $8K" |
| **4 — Decisión basada en evidencia** | Datos + framework + mitigación de sesgos | "El modelo muestra 73% de probabilidad de éxito bajo los supuestos X, Y, Z" |

La mayoría de las organizaciones operan entre el nivel 1 y el 2. Creen que están en el 3 o 4 porque tienen dashboards, pero tener datos no es lo mismo que usarlos para decidir.

---

## Anatomía de una decisión con datos vs. sin datos

Veamos el mismo escenario resuelto de las dos formas:

### Escenario: ¿Renovamos el contrato con el proveedor de logística?

**Sin datos (nivel 0-1):**
1. El gerente de operaciones dice: "Siempre hemos trabajado con ellos, no hay quejas"
2. El director financiero dice: "Son caros, busquemos alternativas"
3. Se decide por quién argumenta con más convicción (o más seniority)
4. No se documenta el razonamiento

**Con datos (nivel 3-4):**
1. Se define la pregunta: "¿El proveedor actual maximiza la relación costo/calidad vs. alternativas?"
2. Se recopilan datos: costo por envío, tasa de entregas a tiempo, tasa de daños, tiempo de resolución de incidentes (últimos 12 meses)
3. Se compara con benchmarks del mercado y 2-3 cotizaciones alternativas
4. Se analiza: el proveedor actual tiene 94% de entregas a tiempo (mercado: 89%) pero cuesta 18% más que el promedio
5. Se decide: el sobrecosto de 18% se justifica si el valor de las entregas a tiempo (menos ventas perdidas, menos quejas) supera el diferencial. Se calcula.
6. Se documenta la decisión y los criterios para revisarla en 6 meses

La diferencia no es que una sea "mejor" — es que la segunda es **auditable, repetible y mejorable**.

---

## El mito del análisis perfecto

Roger Martin, ex decano de Rotman School of Management, advierte en *Playing to Win* (2013) sobre un error opuesto: **la parálisis por análisis**.

Decidir con datos no significa esperar hasta tener información perfecta. Significa:

1. **Definir qué información es suficiente** antes de buscarla
2. **Establecer un deadline** para la decisión
3. **Aceptar incertidumbre** — toda decisión se toma con información incompleta
4. **Documentar los supuestos** para poder revisarlos después

Jeff Bezos popularizó la regla del 70%: "La mayoría de las decisiones deberían tomarse con aproximadamente el 70% de la información que desearías tener. Si esperas al 90%, en la mayoría de los casos, estás siendo demasiado lento."

---

## Decisiones reversibles vs. irreversibles

No todas las decisiones merecen el mismo rigor analítico. Bezos distingue entre:

| Tipo | Característica | Enfoque |
|---|---|---|
| **Puerta de un sentido** (irreversible) | Difícil o imposible de revertir | Análisis riguroso, múltiples perspectivas |
| **Puerta de dos sentidos** (reversible) | Fácil de revertir si no funciona | Decide rápido, itera, aprende |

**Ejemplo:** Cambiar el precio de un producto digital es una puerta de dos sentidos — si no funciona, lo reviertes en minutos. Cerrar una planta de manufactura es una puerta de un sentido — el costo de revertir es enorme.

El error más común en organizaciones grandes es tratar todas las decisiones como puertas de un sentido, creando burocracia innecesaria para decisiones reversibles.

---

### Tu turno

¿Puedes distinguir entre una decisión basada en datos y una basada en intuición disfrazada de análisis?

<!-- exercise:db-ex-02 -->

---

**Referencias:**

- Martin, R. & Lafley, A.G. (2013). *Playing to Win*. Harvard Business Review Press.
- Bezos, J. (2016). Carta a accionistas de Amazon.
- Davenport, T.H. (2006). "Competing on Analytics." *Harvard Business Review*.
- Pfeffer, J. & Sutton, R.I. (2006). *Hard Facts, Dangerous Half-Truths, and Total Nonsense*. Harvard Business School Press.
