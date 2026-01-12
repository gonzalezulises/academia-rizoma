# Diseñar una encuesta ONA efectiva

Los datos de ONA vienen de encuestas. A diferencia de una encuesta de clima donde preguntas "¿qué tan satisfecho estás?", en ONA preguntas "¿con quién interactúas?". Esto cambia todo: el diseño de las preguntas, el formato de respuesta, y cómo proteges la confidencialidad.

## Anatomía de una pregunta ONA

Una pregunta ONA tiene tres componentes:

1. **Relación**: ¿Qué tipo de interacción quieres mapear?
2. **Dirección**: ¿Quién inicia la interacción?
3. **Frecuencia**: ¿Con qué regularidad ocurre?

### Ejemplo de pregunta bien diseñada

> "En los últimos 3 meses, ¿a quién has consultado cuando necesitas información para tomar una decisión importante en tu trabajo?"
>
> Para cada persona, indica la frecuencia:
> - Diariamente
> - Semanalmente
> - Mensualmente
> - Rara vez

Esta pregunta es específica (decisiones importantes), tiene un marco temporal claro (3 meses), y captura frecuencia para ponderar la relación.

## Tipos de relaciones a mapear

No todas las redes son iguales. Dependiendo de tu objetivo, mapearás diferentes tipos de relaciones:

| Objetivo | Tipo de relación | Pregunta ejemplo |
|----------|------------------|------------------|
| Flujo de información | Consulta | "¿A quién consultas cuando necesitas información?" |
| Colaboración | Trabajo conjunto | "¿Con quién trabajas directamente en proyectos?" |
| Confianza | Consejo personal | "¿A quién acudirías para pedir consejo sobre un problema difícil?" |
| Innovación | Ideas | "¿Con quién compartes ideas nuevas?" |
| Influencia | Decisiones | "¿Quién influye en las decisiones que tomas?" |

**Regla de oro**: Mapea solo las relaciones que son relevantes para tu pregunta de negocio. Más tipos de relaciones = más fatiga de encuesta = peores datos.

## Errores comunes en preguntas ONA

### Error 1: Pregunta demasiado vaga
❌ "¿Con quién te comunicas?"
✅ "¿A quién consultas para resolver problemas técnicos?"

### Error 2: Sin marco temporal
❌ "¿A quién consultas habitualmente?"
✅ "En los últimos 3 meses, ¿a quién has consultado...?"

### Error 3: Escala de frecuencia confusa
❌ "Frecuentemente / A veces / Nunca"
✅ "Diariamente / Semanalmente / Mensualmente / Rara vez"

### Error 4: Demasiadas preguntas
❌ 10 tipos de relaciones x 50 personas = fatiga extrema
✅ 2-3 tipos de relaciones, máximo 5 minutos de encuesta

<!-- exercise:ex-05-constructor-preguntas -->

## Formato de respuesta: Roster vs. Free recall

Hay dos formas de capturar las relaciones:

### Roster (lista completa)
- Se muestra una lista de todas las personas de la organización
- El encuestado marca a quiénes aplica cada pregunta
- **Ventaja**: Captura relaciones que el encuestado podría olvidar
- **Desventaja**: Tedioso en organizaciones grandes

### Free recall (recuerdo libre)
- El encuestado escribe nombres libremente
- Puede incluir personas fuera de la organización
- **Ventaja**: Más rápido, menos fatiga
- **Desventaja**: Subestima relaciones débiles pero importantes

**Recomendación para LATAM**: En organizaciones de 50-200 personas, usa roster dividido por área. En organizaciones más grandes, usa free recall con límite de menciones (ej: "menciona hasta 10 personas").

## Confidencialidad y ética

ONA revela información sensible. Alguien podría descubrir que nadie lo consulta, o que todos evitan a cierto gerente. Esto requiere manejo cuidadoso:

### Principios de confidencialidad

1. **Anonimato de respuestas individuales**: Nunca reveles quién mencionó a quién
2. **Agregación de resultados**: Presenta métricas, no listas de nombres
3. **Consentimiento informado**: Explica qué se hará con los datos antes de la encuesta
4. **Acceso restringido**: Solo el equipo de análisis ve los datos crudos

### Comunicación al equipo

Antes de lanzar la encuesta, comunica:
- Por qué se hace el estudio
- Qué preguntas se harán
- Quién verá los resultados
- Qué se hará con los hallazgos

**Nunca hagas ONA como sorpresa**. La transparencia genera confianza y mejora la tasa de respuesta.

## Tasa de respuesta mínima

Para que los resultados de ONA sean confiables, necesitas alta participación:

| Tasa de respuesta | Interpretación |
|-------------------|----------------|
| < 60% | Resultados no confiables, no uses para decisiones |
| 60-75% | Aceptable para exploración, cuidado con conclusiones fuertes |
| 75-85% | Buena calidad, puedes confiar en patrones generales |
| > 85% | Excelente, análisis robusto posible |

**Estrategias para aumentar respuesta**:
- Apoyo visible del liderazgo
- Encuesta corta (máximo 5-7 minutos)
- Seguimiento personalizado a quienes no han respondido
- Compartir resultados agregados con todos los participantes

<!-- exercise:ex-06-auditor-encuestas -->

## Siguiente paso

Con las bases de diseño de encuesta, ahora puedes pasar a la acción. En el siguiente módulo aprenderás a **diagnosticar patrones problemáticos** en los datos de ONA: silos, dependencias críticas, y riesgos de persona clave.
