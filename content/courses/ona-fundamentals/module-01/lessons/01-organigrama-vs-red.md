# El organigrama vs. la red real

## Antes de comenzar: Prueba tu intuición

Antes de aprender sobre redes organizacionales, prueba qué tan bien predice tu intuición la realidad de las organizaciones.

<!-- exercise:quiz-00-intuicion -->

---

Toda organización tiene dos estructuras: la que aparece en el organigrama y la que realmente funciona. El organigrama te dice quién reporta a quién. La red informal te dice quién consulta a quién, quién confía en quién, quién tiene la información que otros necesitan.

## ¿Por qué el organigrama no es suficiente?

El organigrama es una ficción útil. Define responsabilidades, establece cadenas de mando, facilita la toma de decisiones formales. Pero no captura cómo fluye realmente el trabajo.

Considera estas preguntas que el organigrama no puede responder:
- ¿A quién recurren los empleados cuando tienen un problema técnico difícil?
- ¿Quién realmente toma las decisiones en este proyecto?
- ¿Por qué dos departamentos que deberían colaborar nunca lo hacen?
- ¿Quién se enteraría primero si hubiera un cambio importante en la estrategia?

Las respuestas a estas preguntas viven en la **red informal** de tu organización.

## ¿Qué revela el Análisis de Redes Organizacionales (ONA)?

ONA es una metodología que mapea las relaciones reales entre personas en una organización. No reemplaza al organigrama—lo complementa con información que de otra forma sería invisible.

Con ONA puedes identificar:

| Lo que buscas | Lo que encuentras |
|---------------|-------------------|
| **Conectores** | Personas que unen grupos que de otra forma estarían aislados |
| **Expertos ocultos** | Gente a quien todos consultan pero no tiene un título que lo refleje |
| **Silos** | Departamentos o equipos que no se comunican con otros |
| **Cuellos de botella** | Puntos donde se acumula información y se frena el flujo |
| **Riesgo de persona clave** | Individuos cuya salida paralizaría procesos críticos |

## Caso: Manufactura Regional

En una empresa de manufactura con 120 empleados, el gerente de calidad no aparecía en ninguna reunión de dirección. Sin embargo, al mapear la red de "¿a quién consultas cuando tienes un problema de producción?", resultó ser la persona más consultada de toda la planta.

El organigrama lo ubicaba tres niveles abajo del director de operaciones. La red real lo ubicaba en el centro de todas las decisiones técnicas.

<!-- exercise:ex-01-detectar-red -->

## Visualizando la diferencia

Cuando graficamos una red organizacional, cada persona es un **nodo** (un punto) y cada relación es un **enlace** (una línea que conecta dos puntos).

### Organigrama como red
- Los enlaces van de arriba hacia abajo
- La estructura es jerárquica (árbol)
- Solo captura relaciones de reporte

### Red informal
- Los enlaces van en múltiples direcciones
- La estructura puede tener clusters, puentes, centros
- Captura quién realmente interactúa con quién

La diferencia visual es dramática. Un organigrama luce ordenado, simétrico, predecible. Una red real luce orgánica, a veces caótica, siempre reveladora.

## El rol del broker

Un **broker** es alguien que conecta grupos que de otra forma no se comunicarían. En el organigrama, puede parecer una persona de nivel medio sin mayor relevancia. En la red real, es un puente crítico.

Si el broker se va, los grupos que conectaba quedan aislados. Si el broker está sobrecargado, la información se frena. Si el broker tiene sesgo, la información se distorsiona.

Identificar a los brokers de tu organización es una de las revelaciones más valiosas de ONA.

<!-- exercise:ex-02-identificar-broker -->

## Síntesis: Tu turno

Ahora que entiendes la diferencia entre estructura formal e informal, reflexiona:

> **Pregunta para tu organización:** Identifica UNA pregunta sobre tu empresa que el organigrama no puede responder.
>
> Ejemplos:
> - "¿Por qué el equipo de [X] siempre está desalineado con [Y]?"
> - "¿A quién realmente consultan cuando hay un problema de [Z]?"
> - "¿Qué pasaría si [persona clave] se fuera?"

Esta pregunta será tu caso de uso para el resto del curso.

## Quiz de consolidación

Antes de continuar, verifica tu comprensión de los conceptos clave de este capítulo.

<!-- exercise:quiz-01-consolidacion -->

## Siguiente paso

El próximo capítulo te enseñará a **medir** estas redes con tres métricas fundamentales:

| Métrica | Pregunta que responde |
|---------|----------------------|
| **Grado (Degree)** | ¿Quién es más consultado? |
| **Intermediación (Betweenness)** | ¿Quién conecta silos? |
| **Cercanía (Closeness)** | ¿Quién tiene acceso más rápido a información? |

**Predicción:** ¿Cuál de estas tres métricas crees que es más útil para identificar a un "experto oculto" como el Analista QA Sr. del caso Manufactura?
