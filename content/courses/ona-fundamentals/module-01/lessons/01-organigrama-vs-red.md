# El organigrama vs. la red real

## Antes de comenzar: Prueba tu intuicion

Antes de aprender sobre redes organizacionales, prueba que tan bien predice tu intuicion la realidad de las organizaciones.

Para cada afirmacion, decide si crees que es **Verdadera** o **Falsa**:

| # | Afirmacion | Tu prediccion |
|---|------------|---------------|
| 1 | La persona mas consultada de una organizacion siempre tiene un cargo gerencial o directivo. | V / F |
| 2 | Si dos departamentos comparten un director en el organigrama, en la practica colaboran frecuentemente. | V / F |
| 3 | Cuando una persona clave renuncia, la organizacion generalmente sabe exactamente que conocimiento se pierde. | V / F |
| 4 | Las redes informales pueden mapearse y medirse de forma sistematica. | V / F |

<details>
<summary><strong>Ver respuestas</strong></summary>

1. **FALSO.** Las investigaciones en ONA muestran que los "expertos ocultos" a menudo estan en posiciones medias o tecnicas. La influencia informal rara vez coincide con la jerarquia formal.

2. **FALSO.** El organigrama muestra relaciones de reporte, no de colaboracion. Dos departamentos bajo el mismo VP pueden operar como silos completos.

3. **FALSO.** El conocimiento informal (a quien consultar, como navegar procesos, relaciones con clientes) es invisible hasta que se pierde. ONA puede mapear este riesgo antes de que ocurra.

4. **VERDADERO.** ONA (Organizational Network Analysis) es una metodologia establecida con metricas cuantitativas. No es intuicion ni politica de oficina: es ciencia de redes aplicada a organizaciones.

**Dato revelador:** En un estudio de McKinsey, solo el 35% de los ejecutivos podia identificar correctamente quienes eran los conectores clave de su organizacion. El otro 65% asumia que coincidian con la jerarquia formal.

</details>

---

Toda organizacion tiene dos estructuras: la que aparece en el organigrama y la que realmente funciona. El organigrama te dice quien reporta a quien. La red informal te dice quien consulta a quien, quien confia en quien, quien tiene la informacion que otros necesitan.

## Por que el organigrama no es suficiente

El organigrama es una ficcion util. Define responsabilidades, establece cadenas de mando, facilita la toma de decisiones formales. Pero no captura como fluye realmente el trabajo.

Considera estas preguntas que el organigrama no puede responder:
- A quien recurren los empleados cuando tienen un problema tecnico dificil?
- Quien realmente toma las decisiones en este proyecto?
- Por que dos departamentos que deberian colaborar nunca lo hacen?
- Quien se enteraria primero si hubiera un cambio importante en la estrategia?

Las respuestas a estas preguntas viven en la **red informal** de tu organizacion.

## Que revela el Analisis de Redes Organizacionales (ONA)

ONA es una metodologia que mapea las relaciones reales entre personas en una organizacion. No reemplaza al organigrama—lo complementa con informacion que de otra forma seria invisible.

Con ONA puedes identificar:

| Lo que buscas | Lo que encuentras |
|---------------|-------------------|
| **Conectores** | Personas que unen grupos que de otra forma estarian aislados |
| **Expertos ocultos** | Gente a quien todos consultan pero no tiene un titulo que lo refleje |
| **Silos** | Departamentos o equipos que no se comunican con otros |
| **Cuellos de botella** | Puntos donde se acumula informacion y se frena el flujo |
| **Riesgo de persona clave** | Individuos cuya salida paralizaria procesos criticos |

## Caso: Manufactura Regional

En una empresa de manufactura con 120 empleados, el gerente de calidad no aparecia en ninguna reunion de direccion. Sin embargo, al mapear la red de "a quien consultas cuando tienes un problema de produccion?", resulto ser la persona mas consultada de toda la planta.

El organigrama lo ubicaba tres niveles abajo del director de operaciones. La red real lo ubicaba en el centro de todas las decisiones tecnicas.

<!-- exercise:ex-01-detectar-red -->

## Visualizando la diferencia

Cuando graficamos una red organizacional, cada persona es un **nodo** (un punto) y cada relacion es un **enlace** (una linea que conecta dos puntos).

### Organigrama como red
- Los enlaces van de arriba hacia abajo
- La estructura es jerarquica (arbol)
- Solo captura relaciones de reporte

### Red informal
- Los enlaces van en multiples direcciones
- La estructura puede tener clusters, puentes, centros
- Captura quien realmente interactua con quien

La diferencia visual es dramatica. Un organigrama luce ordenado, simetrico, predecible. Una red real luce organica, a veces caotica, siempre reveladora.

## El rol del broker

Un **broker** es alguien que conecta grupos que de otra forma no se comunicarian. En el organigrama, puede parecer una persona de nivel medio sin mayor relevancia. En la red real, es un puente critico.

Si el broker se va, los grupos que conectaba quedan aislados. Si el broker esta sobrecargado, la informacion se frena. Si el broker tiene sesgo, la informacion se distorsiona.

Identificar a los brokers de tu organizacion es una de las revelaciones mas valiosas de ONA.

<!-- exercise:ex-02-identificar-broker -->

## Sintesis: Tu turno

Ahora que entiendes la diferencia entre estructura formal e informal, reflexiona:

> **Pregunta para tu organizacion:** Identifica UNA pregunta sobre tu empresa que el organigrama no puede responder.
>
> Ejemplos:
> - "Por que el equipo de [X] siempre esta desalineado con [Y]?"
> - "A quien realmente consultan cuando hay un problema de [Z]?"
> - "Que pasaria si [persona clave] se fuera?"

Esta pregunta sera tu caso de uso para el resto del curso.

## Siguiente paso

El proximo capitulo te ensenara a **medir** estas redes con tres metricas fundamentales:

| Metrica | Pregunta que responde |
|---------|----------------------|
| **Grado (Degree)** | Quien es mas consultado? |
| **Intermediacion (Betweenness)** | Quien conecta silos? |
| **Cercania (Closeness)** | Quien tiene acceso mas rapido a informacion? |

**Prediccion:** Cual de estas tres metricas crees que es mas util para identificar a un "experto oculto" como el Analista QA Sr. del caso Manufactura?
