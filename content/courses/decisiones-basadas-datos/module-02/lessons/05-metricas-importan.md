# Métricas que importan vs. ruido

### El problema de medir todo

"Lo que no se mide, no se gestiona." Esta frase, frecuentemente atribuida a Peter Drucker (aunque él nunca la dijo exactamente así), se ha convertido en una excusa para medir absolutamente todo.

El resultado: dashboards con 50+ indicadores que nadie lee, reportes mensuales que nadie acciona y una falsa sensación de control que Pfeffer y Sutton (2000) llaman **teatro de datos** — la ilusión de que más medición equivale a mejores decisiones.

La pregunta correcta no es "¿qué podemos medir?" sino **"¿qué necesitamos saber para decidir?"**

---

## Métricas accionables vs. decorativas

Una métrica **accionable** cambia tu comportamiento cuando la ves. Una métrica **decorativa** te hace sentir informado sin provocar acción alguna.

| Característica | Métrica accionable | Métrica decorativa |
|---|---|---|
| **Umbral definido** | "Si supera X, hacemos Y" | "La monitoreamos" |
| **Dueño claro** | Una persona responsable de actuar | Se presenta "al equipo" |
| **Frecuencia adecuada** | Se revisa cuando se puede actuar | Se revisa por ritual |
| **Conectada a decisión** | Responde una pregunta específica | "Es interesante saberlo" |

### Test rápido: ¿Es accionable?

Para cada métrica en tu dashboard, hazte estas 3 preguntas:

1. **¿Qué harías diferente si este número cambia 20%?** Si la respuesta es "nada" o "no sé", es decorativa.
2. **¿Quién es responsable de actuar?** Si la respuesta es "todos" o "nadie", es decorativa.
3. **¿Cuándo fue la última vez que esta métrica cambió una decisión?** Si no recuerdas, probablemente es decorativa.

---

## Vanity metrics: métricas que alimentan el ego

Eric Ries, en *The Lean Startup* (2011), acuñó el término **vanity metrics** — números que se ven impresionantes pero no informan decisiones.

| Vanity metric | Por qué engaña | Alternativa accionable |
|---|---|---|
| "Tenemos 100,000 usuarios registrados" | No dice cuántos usan el producto | Usuarios activos mensuales (MAU) |
| "El sitio tuvo 500,000 visitas" | No dice si generaron valor | Tasa de conversión por canal |
| "Enviamos 10,000 emails" | No dice si alguien los leyó | Tasa de apertura + tasa de clic |
| "Completamos 200 story points" | No dice si entregaron valor | Cycle time de features entregadas |
| "El NPS es 72" | No dice qué hacer al respecto | Temas recurrentes en detractores |

**La regla de Ries:** Si una métrica sube y te sientes bien pero no haces nada diferente, es una vanity metric.

---

## Indicadores adelantados vs. rezagados

Kaplan y Norton, en *The Balanced Scorecard* (1996), introdujeron una distinción fundamental:

| Tipo | Definición | Ejemplo |
|---|---|---|
| **Indicador rezagado** (lagging) | Mide el resultado final — ya pasó | Ingresos trimestrales, rotación anual |
| **Indicador adelantado** (leading) | Predice el resultado futuro — puedes actuar | Pipeline de ventas, satisfacción de empleados |

**Analogía:** Tu peso actual es un indicador rezagado — ya pasó, no puedes cambiarlo. Tu ingesta calórica diaria y minutos de ejercicio son indicadores adelantados — puedes actuar sobre ellos hoy para cambiar el resultado futuro.

**Error común en organizaciones:** El 80% de los dashboards ejecutivos solo tienen indicadores rezagados. Cuando el CEO ve que los ingresos cayeron, ya es demasiado tarde para actuar sobre ese trimestre. Los indicadores adelantados permiten intervenir antes de que el resultado se materialice.

---

## ¿Cuántas métricas necesitas?

Menos de las que crees. Investigaciones sugieren:

| Nivel | Métricas recomendadas | Fuente |
|---|---|---|
| Equipo operativo | 3-5 métricas clave | Anderson, *Kanban* (2010) |
| Unidad de negocio | 5-8 métricas clave | Kaplan & Norton (1996) |
| Nivel ejecutivo | 8-12 métricas clave | Marr, *KPIs* (2015) |

**El principio de Pareto aplicado a métricas:** El 20% de tus indicadores genera el 80% del valor de decisión. El otro 80% es ruido que compite por atención con las métricas que realmente importan.

Bernard Marr propone el **test de las 3 semanas**: si una métrica desaparece de tu dashboard durante 3 semanas y nadie pregunta por ella, elimínala permanentemente.

---

## Diseñando métricas accionables: el framework SMART-A

Adaptando el clásico SMART para métricas (no objetivos):

| Criterio | Pregunta | Ejemplo bueno | Ejemplo malo |
|---|---|---|---|
| **S**pecífica | ¿Qué exactamente mides? | "Tiempo de respuesta de soporte nivel 1" | "Calidad de servicio" |
| **M**edible | ¿Cómo lo calculas? | "Mediana de minutos desde ticket hasta primera respuesta" | "Más o menos rápido" |
| **A**ccionable | ¿Qué haces cuando cambia? | "> 30 min → reasignar agentes" | "Seguimos monitoreando" |
| **R**elevante | ¿Conecta con un objetivo? | "Reducir churn de clientes premium" | "Porque podemos medirlo" |
| **T**emporal | ¿Con qué frecuencia? | "Diario, revisión semanal" | "Cuando alguien pregunta" |
| **A**signable | ¿Quién actúa? | "Líder de soporte, escalamiento a VP si > 48h" | "El equipo" |

---

### Tu turno

¿Puedes distinguir entre métricas accionables y decorativas en situaciones reales?

<!-- exercise:db-ex-05 -->

---

**Referencias:**

- Ries, E. (2011). *The Lean Startup*. Crown Business.
- Kaplan, R.S. & Norton, D.P. (1996). *The Balanced Scorecard*. Harvard Business Press.
- Marr, B. (2015). *Key Performance Indicators*. Pearson.
- Pfeffer, J. & Sutton, R.I. (2000). *The Knowing-Doing Gap*. Harvard Business School Press.
- Anderson, D.J. (2010). *Kanban: Successful Evolutionary Change*. Blue Hole Press.
