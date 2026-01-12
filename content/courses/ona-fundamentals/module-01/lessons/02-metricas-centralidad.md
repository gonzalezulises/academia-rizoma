# Las 3 métricas que importan

Cuando tienes una red con 50, 100 o 500 personas, no puedes simplemente "mirar el gráfico" para entender quién es importante. Necesitas métricas que cuantifiquen la posición de cada persona en la red.

De las docenas de métricas que existen en análisis de redes, solo tres son esenciales para tomar decisiones organizacionales:

1. **Grado (Degree)**: ¿Quién es más consultado?
2. **Intermediación (Betweenness)**: ¿Quién conecta silos?
3. **Cercanía (Closeness)**: ¿Quién llega rápido a todos?

## Grado (Degree Centrality)

El grado es la métrica más intuitiva: cuenta cuántas conexiones directas tiene una persona.

### ¿Qué significa un grado alto?
- Esta persona es consultada por muchos otros
- Puede ser un experto reconocido, un líder informal, o alguien con recursos que otros necesitan
- Alto grado = alta demanda de su tiempo y atención

### ¿Qué significa un grado bajo?
- Esta persona tiene pocas conexiones directas
- Puede estar aislada, ser nueva, o trabajar en algo muy especializado
- Bajo grado no siempre es malo—depende del rol

### Ejemplo práctico
En una red de "¿a quién consultas para resolver problemas técnicos?", la persona con mayor grado es quien más consultas recibe. Si esta persona tiene grado 15 en una red de 50, significa que el 30% de la organización la consulta directamente.

**Decisión típica**: Si alguien tiene grado muy alto, ¿está sobrecargada? ¿Necesita un equipo de soporte? ¿Deberíamos documentar su conocimiento para reducir la dependencia?

## Intermediación (Betweenness Centrality)

La intermediación mide cuántos "caminos más cortos" pasan por una persona. En términos prácticos: ¿cuántas veces esta persona es puente entre otras dos que no están conectadas directamente?

### ¿Qué significa una intermediación alta?
- Esta persona conecta grupos que de otra forma estarían aislados
- Es un broker, un puente entre silos
- Si se va, algunos flujos de información se interrumpen

### ¿Qué significa una intermediación baja?
- Esta persona no es un puente crítico
- Puede estar en un cluster bien conectado donde hay redundancia
- Baja intermediación con alto grado = experto dentro de un grupo, no conector entre grupos

### Ejemplo práctico
El gerente de calidad de Manufactura Regional tenía intermediación alta porque conectaba producción con ingeniería y con ventas. Ninguno de esos departamentos hablaba directamente con los otros—todo pasaba por él.

**Decisión típica**: Si alguien tiene intermediación muy alta, ¿qué pasa si se enferma o se va? ¿Deberíamos crear redundancia? ¿Los silos que conecta deberían tener más conexiones directas?

## Cercanía (Closeness Centrality)

La cercanía mide qué tan rápido puede una persona alcanzar a todas las demás en la red. Se calcula como el inverso de la distancia promedio a todos los nodos.

### ¿Qué significa una cercanía alta?
- Esta persona puede llegar a cualquier otra en pocos pasos
- Si necesita difundir información, lo hace rápidamente
- Está "cerca" del centro de la red, aunque no necesariamente tenga muchas conexiones directas

### ¿Qué significa una cercanía baja?
- Esta persona está en la periferia de la red
- Le toma más pasos alcanzar a otros
- Puede recibir información tarde o distorsionada

### Ejemplo práctico
Un director puede tener grado bajo (solo 5 reportes directos) pero cercanía alta porque esos 5 reportes conectan con el resto de la organización. Un empleado de primera línea puede tener grado alto (habla con todos en su turno) pero cercanía baja porque su turno es un cluster aislado del resto.

**Decisión típica**: Si necesitamos difundir un cambio importante, ¿quiénes son las personas con mayor cercanía para usarlos como embajadores?

<!-- exercise:ex-03-calculadora-centralidad -->

## Interpretando las métricas en conjunto

Las métricas no se interpretan en aislamiento. Lo interesante está en las combinaciones:

| Grado | Intermediación | Cercanía | Interpretación |
|-------|----------------|----------|----------------|
| Alto | Alto | Alto | Líder informal central—posición de máxima influencia |
| Alto | Bajo | Alto | Experto popular dentro de un grupo bien integrado |
| Bajo | Alto | Medio | Broker silencioso—conecta silos sin ser muy consultado |
| Bajo | Bajo | Bajo | Periférico—puede estar aislado o ser muy especializado |
| Alto | Bajo | Bajo | Estrella local—muy consultado en su cluster pero desconectado del resto |

## Caso: Banco Regional

El Banco Regional del Sur quería entender por qué los tiempos de aprobación de crédito variaban tanto entre sucursales. El organigrama mostraba una estructura idéntica en todas las sucursales.

Al aplicar ONA con la pregunta "¿a quién consultas cuando tienes dudas sobre un caso de crédito?", encontraron que:

- En sucursales rápidas: los analistas consultaban directamente al gerente comercial (cercanía alta del gerente)
- En sucursales lentas: los analistas consultaban a un "experto informal" que luego consultaba al gerente (intermediación alta del experto, cercanía baja del gerente)

El cuello de botella no era falta de personal—era una estructura de red ineficiente.

<!-- exercise:ex-04-caso-banco -->

## Siguiente paso

Ahora que sabes interpretar las métricas, el siguiente paso es aprender a **obtener los datos**. Diseñar una encuesta ONA efectiva requiere preguntas precisas que capturen las relaciones que realmente importan.
