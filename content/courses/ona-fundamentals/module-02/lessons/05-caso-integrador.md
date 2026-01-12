# Caso integrador: Aseguradora del Pacífico

Has aprendido a distinguir el organigrama de la red real, a calcular e interpretar métricas de centralidad, a diseñar encuestas ONA y a diagnosticar patrones problemáticos. Ahora es momento de integrar todo en un caso completo.

## Contexto del caso

**Aseguradora del Pacífico** es una compañía de seguros con sede en Lima y operaciones en Perú, Ecuador y Colombia. Tiene 450 empleados distribuidos en:

- **Sede central (Lima)**: 280 personas - Dirección, Actuariado, Legal, TI, RRHH
- **Colombia (Bogotá)**: 90 personas - Ventas, Servicio al cliente, Operaciones
- **Ecuador (Quito)**: 80 personas - Ventas, Servicio al cliente, Operaciones

### El problema de negocio

El CEO ha notado que:
1. Los tiempos de lanzamiento de nuevos productos son el doble que los de la competencia
2. Las quejas de clientes se resuelven más lento en Ecuador que en Colombia
3. Tres personas clave del área de suscripción renunciaron en los últimos 6 meses

El equipo de RRHH realizó una encuesta ONA con dos preguntas:

**Pregunta 1 - Flujo de información**:
> "En los últimos 3 meses, ¿a quién has consultado cuando necesitas información para hacer tu trabajo?"

**Pregunta 2 - Colaboración en proyectos**:
> "En los últimos 3 meses, ¿con quién has trabajado directamente en proyectos o iniciativas?"

Tasa de respuesta: 82% (369 de 450 empleados).

## Los datos

El análisis de la red de consultas revela los siguientes hallazgos:

### Métricas agregadas por país

| País | Grado promedio interno | Grado promedio externo | Densidad interna |
|------|----------------------|----------------------|------------------|
| Perú | 8.2 | 2.1 | 0.34 |
| Colombia | 6.5 | 1.8 | 0.41 |
| Ecuador | 5.9 | 0.9 | 0.38 |

### Top 5 personas por intermediación

| Rank | Nombre | Área | País | Intermediación |
|------|--------|------|------|----------------|
| 1 | Martín Rojas | Actuariado | Perú | 0.42 |
| 2 | Claudia Vega | TI | Perú | 0.31 |
| 3 | Roberto Mendoza | Suscripción | Perú | 0.28 |
| 4 | Ana Lucía Torres | Legal | Perú | 0.19 |
| 5 | Diego Paredes | Ventas | Colombia | 0.11 |

### Hallazgo crítico

Ecuador tiene el grado externo más bajo (0.9) y su único enlace significativo con sede central es a través de una sola persona: la Gerente de Operaciones Ecuador, quien tiene 15 conexiones con Lima pero ninguno de sus reportes tiene conexiones directas con sede central.

## Tu tarea

En el ejercicio integrador, analizarás los datos completos de la Aseguradora del Pacífico y responderás:

1. **¿Existen silos?** ¿Dónde están y qué tan severos son?
2. **¿Hay dependencias críticas?** ¿Quiénes son los hubs sobrecargados?
3. **¿Cuál es el riesgo de persona clave?** ¿Qué pasaría si Martín Rojas (mayor intermediación) se fuera?
4. **¿Qué intervenciones recomiendas?** Propón 3 acciones concretas con prioridad y métricas de éxito.

<!-- exercise:ex-10-caso-aseguradora -->

## Reflexión final

El Análisis de Redes Organizacionales no es un fin en sí mismo—es una herramienta para tomar mejores decisiones. Los números y visualizaciones solo importan si te llevan a **acciones** que mejoran cómo funciona tu organización.

### Lo que aprendiste en este curso

1. El organigrama muestra autoridad formal; ONA muestra influencia real
2. Tres métricas son suficientes: grado, intermediación, cercanía
3. Las encuestas ONA requieren preguntas específicas y confidencialidad estricta
4. Los patrones problemáticos (silos, hubs, riesgo de persona clave) tienen intervenciones conocidas
5. El valor está en la decisión, no en el análisis

### Siguiente paso en tu organización

Si quieres aplicar ONA en tu empresa:

1. **Define la pregunta de negocio**: ¿Qué problema quieres entender mejor?
2. **Diseña 2-3 preguntas de encuesta**: Enfocadas en relaciones relevantes
3. **Obtén apoyo del liderazgo**: Para asegurar participación y acción posterior
4. **Analiza los patrones**: Usando las métricas y frameworks de este curso
5. **Prioriza intervenciones**: No intentes arreglar todo—elige 2-3 acciones de alto impacto

## Evaluación final

Antes de terminar, completa el quiz final para consolidar tu aprendizaje.

<!-- exercise:quiz-final -->
