## Anatomía de un buen prompt

### Por qué el prompt importa más que el modelo

Aquí va una verdad incómoda: la mayoría de las personas que dicen "la IA no me sirvió" simplemente escribieron un mal prompt. Es como quejarse de que Google no funciona porque buscaste "esa cosa que vi ayer".

La calidad de la respuesta de un modelo de lenguaje depende directamente de la calidad de la instrucción que le das. Un prompt mediocre con el mejor modelo del mundo produce resultados mediocres. Un prompt bien estructurado con un modelo básico puede sorprenderte.

La buena noticia: escribir buenos prompts no es arte ni magia. Es una habilidad con estructura, y la puedes aprender hoy.

---

### La fórmula: Rol + Contexto + Tarea + Formato

Todo prompt efectivo tiene cuatro componentes. No siempre necesitas los cuatro, pero mientras más incluyas, mejor será la respuesta.

| Componente | Qué hace | Ejemplo |
|---|---|---|
| **Rol** | Define desde qué perspectiva debe responder el modelo | "Eres un consultor financiero con experiencia en PYMES latinoamericanas" |
| **Contexto** | Proporciona la información de fondo necesaria | "Nuestra empresa tiene 45 empleados, opera en 3 países y factura $2M anuales" |
| **Tarea** | Especifica exactamente qué quieres que haga | "Analiza estos datos de ventas e identifica los 3 productos con mayor margen" |
| **Formato** | Indica cómo quieres la respuesta | "Presenta los resultados en una tabla con columnas: producto, margen, recomendación" |

> *Sin Rol, el modelo responde como un asistente genérico. Sin Contexto, adivina tu situación. Sin Tarea clara, divaga. Sin Formato, elige uno que probablemente no es el que necesitas.*

---

### Zero-shot vs. few-shot: dos estrategias fundamentales

**Zero-shot** significa pedirle algo al modelo sin darle ejemplos. Simplemente describes lo que quieres:

```
Clasifica el siguiente comentario de cliente como positivo, negativo o neutro:
"El producto llegó rápido pero el empaque estaba dañado"
```

**Few-shot** significa incluir ejemplos de lo que esperas antes de la tarea real:

```
Clasifica los siguientes comentarios de clientes:

Comentario: "Excelente servicio, todo perfecto"
Clasificación: Positivo

Comentario: "No vuelvo a comprar aquí"
Clasificación: Negativo

Comentario: "El producto llegó rápido pero el empaque estaba dañado"
Clasificación:
```

El enfoque few-shot casi siempre produce mejores resultados porque el modelo entiende exactamente el formato y criterio que esperas. Úsalo cuando la precisión importa.

---

### Tres prompts de negocio: antes y después

**Ejemplo 1: Resumir un reporte trimestral**

| | Prompt |
|---|---|
| **Malo** | "Resume este reporte" |
| **Bueno** | "Eres el CFO preparando una presentación para el directorio. Resume este reporte trimestral en máximo 5 bullets, enfocándote en: ingresos vs. meta, principales desviaciones y una recomendación accionable. Usa lenguaje ejecutivo, sin jerga contable." |

**Ejemplo 2: Redactar un correo a un cliente difícil**

| | Prompt |
|---|---|
| **Malo** | "Escribe un correo para un cliente enojado" |
| **Bueno** | "Eres el gerente de atención al cliente de una empresa de logística en Lima. Un cliente corporativo (representa el 8% de nuestra facturación) está molesto porque el último envío llegó 5 días tarde. Redacta un correo que: (1) reconozca el problema sin excusas, (2) explique la causa raíz (retraso aduanero), (3) ofrezca una compensación concreta y (4) proponga una medida preventiva. Tono: profesional, empático, no servil. Máximo 200 palabras." |

**Ejemplo 3: Analizar competencia**

| | Prompt |
|---|---|
| **Malo** | "Analiza a mi competencia" |
| **Bueno** | "Eres un estratega de negocios especializado en retail de moda en Centroamérica. Basándote en la siguiente información sobre 3 competidores [pegar datos], crea una tabla comparativa con: propuesta de valor, rango de precios, canales de venta, presencia digital y debilidad principal. Al final, identifica un espacio de mercado desatendido que nuestra marca podría aprovechar." |

---

### Los 5 errores más comunes

| Error | Por qué falla | Cómo corregirlo |
|---|---|---|
| **Demasiado vago** | "Ayúdame con marketing" no le dice nada útil al modelo | Especifica industria, audiencia, canal, objetivo y restricciones |
| **Demasiado largo sin estructura** | Un párrafo de 500 palabras sin organización confunde al modelo | Usa listas numeradas, separa rol/contexto/tarea/formato |
| **No especificar formato** | El modelo elige un formato que probablemente no necesitas | Pide explícitamente: tabla, bullets, párrafo corto, JSON, etc. |
| **Tratar la IA como buscador** | "¿Cuál es el PIB de Colombia?" es mejor en Google | Usa la IA para analizar, sintetizar y crear — no para buscar datos puntuales |
| **Abandonar al primer resultado malo** | Un mal output no significa que la herramienta no sirve | Refina el prompt: agrega contexto, cambia el rol, da ejemplos |

---

### El arte de iterar

Si la primera respuesta no es lo que esperabas, **no empieces de cero**. Itera sobre el prompt:

1. **Demasiado genérico** --> Agrega contexto específico de tu industria o situación
2. **Formato incorrecto** --> Especifica exactamente cómo quieres la salida
3. **Tono inadecuado** --> Define el tono: "ejecutivo", "técnico", "conversacional", "persuasivo"
4. **Falta profundidad** --> Pide que "explique su razonamiento paso a paso" (esto se llama Chain-of-Thought)
5. **Demasiado largo** --> Establece límites: "máximo 3 párrafos" o "responde en 100 palabras"

> *Un buen prompt rara vez sale perfecto a la primera. Los profesionales más efectivos con IA no escriben mejores prompts iniciales — iteran más rápido.*

La próxima vez que obtengas una respuesta insatisfactoria, antes de culpar al modelo, revisa tu prompt con esta lista. En la mayoría de los casos, el problema está en la instrucción, no en la herramienta.

---

### Tu turno

<!-- exercise:ia-ex-03 -->

---

**Referencias:**

- OpenAI (2023). "Prompt Engineering Guide." platform.openai.com/docs/guides/prompt-engineering.
- White, J. et al. (2023). "A Prompt Pattern Catalog to Enhance Prompt Engineering with ChatGPT." *arXiv:2302.11382*.
- Wei, J. et al. (2022). "Chain-of-Thought Prompting Elicits Reasoning in Large Language Models." *arXiv:2201.11903*.
- Anthropic (2024). "Prompt Engineering Guide." docs.anthropic.com.
- Zamfirescu-Pereira, J.D. et al. (2023). "Why Johnny Can't Prompt." *Proceedings of CHI 2023*.
