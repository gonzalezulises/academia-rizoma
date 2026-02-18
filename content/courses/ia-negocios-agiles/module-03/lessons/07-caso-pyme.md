## Caso: Transformación de una PyME

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
