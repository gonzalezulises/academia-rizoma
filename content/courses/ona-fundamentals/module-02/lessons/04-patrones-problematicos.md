# Patrones problemáticos

Las métricas de centralidad cobran sentido cuando las usas para identificar **patrones que frenan a tu organización**. En esta lección aprenderás a diagnosticar tres de los problemas más comunes que revela ONA: silos, dependencias críticas y riesgo de persona clave.

## Patrón 1: Silos

Un silo es un grupo que está densamente conectado internamente pero tiene pocas conexiones con el exterior. En el gráfico de red, los silos aparecen como clusters separados con pocos enlaces entre ellos.

### Síntomas de silos en las métricas

| Métrica | Lo que indica un silo |
|---------|----------------------|
| Grado interno alto | Las personas del grupo se consultan mucho entre sí |
| Grado externo bajo | Pocas consultas hacia o desde otros grupos |
| Intermediación alta en pocos individuos | Solo 1-2 personas conectan el grupo con el exterior |
| Cercanía baja para el grupo | El grupo está "lejos" del resto de la organización |

### Causas comunes de silos

1. **Geográficas**: Oficinas en diferentes ciudades o países
2. **Funcionales**: Departamentos con lenguaje técnico propio
3. **Históricas**: Fusiones o adquisiciones mal integradas
4. **Culturales**: Diferencias de idioma, horario o estilo de trabajo

### Caso: Retail Multipaís

Una cadena de retail con operaciones en 4 países latinoamericanos notó que las mejores prácticas no se compartían entre países. Al hacer ONA, encontraron:

- Dentro de cada país: redes densas y bien conectadas
- Entre países: solo los directores se comunicaban, y solo mensualmente
- Resultado: cada país "reinventaba la rueda" constantemente

La solución no fue reorganizar el organigrama—fue crear **roles puente** que conectaran equipos equivalentes entre países (ej: los gerentes de logística de los 4 países empezaron a reunirse semanalmente).

<!-- exercise:ex-07-diagnostico-silos -->

## Patrón 2: Dependencia crítica (Hub sobrecargado)

Un hub es una persona con grado muy alto—todos la consultan. Hasta cierto punto, los hubs son valiosos: son expertos, líderes informales, puntos de referencia. Pero cuando un hub concentra demasiadas conexiones, se convierte en un cuello de botella.

### Señales de alerta de hub sobrecargado

- **Grado > 3x el promedio**: Esta persona tiene más conexiones que lo normal
- **Intermediación muy alta**: Muchos flujos de información pasan por ella
- **Tiempos de respuesta lentos**: La persona no da abasto
- **Burnout inminente**: Sobrecarga sostenida sin redistribución

### Cómo cuantificar la dependencia

La dependencia se mide como el porcentaje de conexiones que pasan por una persona:

```
Dependencia = (Conexiones del hub / Total de conexiones) x 100
```

Si una persona concentra más del 15% de las conexiones en una organización de 100+ personas, hay dependencia crítica.

### Intervenciones para reducir dependencia

1. **Documentación**: Que el hub documente su conocimiento
2. **Formación de respaldos**: Entrenar a 2-3 personas en las áreas del hub
3. **Redistribución formal**: Reasignar algunas responsabilidades
4. **Comunidades de práctica**: Crear espacios donde otros puedan responder consultas

<!-- exercise:ex-08-riesgo-dependencia -->

## Patrón 3: Riesgo de persona clave

El riesgo de persona clave es diferente de la dependencia. No se trata de que alguien esté sobrecargado—se trata de qué pasaría si esa persona se fuera.

### Métricas que indican riesgo alto

| Condición | Por qué importa |
|-----------|-----------------|
| Intermediación alta + sin respaldos | Si se va, grupos quedan desconectados |
| Único puente entre silos | No hay ruta alternativa de comunicación |
| Conocimiento no documentado | El conocimiento se va con la persona |
| Cercanía alta en red crítica | Retrasos en comunicación afectarán a muchos |

### Simulación de impacto: ¿Qué pasa si X se va?

Una herramienta poderosa de ONA es simular la red **sin** una persona. Esto te permite visualizar:

- ¿Se fragmenta la red? (grupos quedan aislados)
- ¿Aumentan las distancias? (la información tarda más en llegar)
- ¿Cambian las métricas de centralidad de otros? (nuevos cuellos de botella emergen)

### Caso: Manufactura Regional (continuación)

El gerente de calidad que identificamos antes como el más consultado de la planta tenía un riesgo crítico. Al simular su salida:

- Producción e Ingeniería quedaban desconectados
- La distancia promedio entre nodos aumentaba 40%
- El siguiente candidato a "puente" tenía solo 2 años de experiencia

La empresa implementó un plan de sucesión que incluía: documentación de procesos, asignación de un segundo en todas las reuniones clave, y contratación de un ingeniero senior como respaldo.

<!-- exercise:ex-09-simulador-impacto -->

## De diagnóstico a intervención

Identificar patrones es solo el primer paso. El valor de ONA está en las **decisiones que tomas** a partir del diagnóstico.

### Framework de intervención

Para cada patrón problemático, pregúntate:

1. **¿Qué comportamientos causan este patrón?** (No qué personas—qué comportamientos)
2. **¿Qué incentivos mantienen el patrón?** (Por qué persiste)
3. **¿Qué cambio estructural reduciría el problema?** (Roles, procesos, espacios)
4. **¿Cómo mediremos si la intervención funcionó?** (Métricas de seguimiento)

### Intervenciones típicas por patrón

| Patrón | Intervención estructural | Intervención de comportamiento |
|--------|-------------------------|-------------------------------|
| Silos | Roles puente, proyectos cross-funcionales | Reuniones periódicas entre grupos |
| Hub sobrecargado | Redistribuir responsabilidades | Entrenar respaldos, documentar |
| Persona clave | Plan de sucesión | Redundancia en conocimiento crítico |

## Siguiente paso

En la siguiente lección aplicarás todo lo aprendido a un **caso integrador**. Analizarás los datos de ONA de una aseguradora, identificarás patrones problemáticos y formularás recomendaciones de intervención.
