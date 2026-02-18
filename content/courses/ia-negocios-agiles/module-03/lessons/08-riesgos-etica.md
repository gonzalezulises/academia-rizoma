## Riesgos, ética y gobernanza

### Lo que nadie te dice en la demo

Todas las demostraciones de IA muestran el mejor escenario: el prompt perfecto, la respuesta impecable, el resultado transformador. Pero usar IA en un negocio real implica gestionar riesgos reales. Esta lección cubre los cinco riesgos críticos que cualquier profesional debe entender antes de integrar IA generativa en su organización.

No se trata de generar miedo. Se trata de usar estas herramientas con criterio profesional, de la misma manera que un contador usa una hoja de cálculo sabiendo que un error de fórmula puede costar millones.

---

### 1. Alucinaciones: cuando la IA miente con confianza

Como vimos en la Lección 1.1, los modelos de lenguaje generan texto estadísticamente plausible, no necesariamente verdadero. En un contexto empresarial, esto tiene consecuencias concretas:

| Escenario | Qué puede pasar | Consecuencia |
|---|---|---|
| Propuesta comercial | La IA cita una regulación que no existe | Pierdes credibilidad con el cliente |
| Asesoría legal interna | El modelo inventa un artículo del código tributario | Decisiones fiscales basadas en información falsa |
| Reporte financiero | Genera proyecciones con números inventados | Decisiones de inversión erróneas |
| Atención al cliente | Promete una política de devolución que no es la tuya | Obligación legal con el cliente |

**Cómo mitigar:**
- Toda información fáctica generada por IA debe verificarse contra fuentes primarias
- Nunca publiques datos, cifras o referencias legales sin confirmarlas
- Implementa un flujo de revisión humana antes de que cualquier contenido generado por IA llegue a un cliente o se use en una decisión

> *Regla de oro: usa la IA como borrador, nunca como fuente final. Si no puedes verificar algo que generó la IA, no lo uses.*

---

### 2. Datos confidenciales: lo que NUNCA debes enviar a un modelo de IA

Este es el riesgo más subestimado. Cada vez que escribes algo en un chatbot de IA, esa información viaja a servidores externos. Esto significa que debes tratar el prompt como si fuera un correo electrónico que podría ser leído por terceros.

**Nunca envíes a un modelo de IA:**
- Datos personales de clientes (nombres, cédulas, direcciones, números de cuenta)
- Contraseñas, tokens de acceso o credenciales de cualquier tipo
- Información financiera confidencial (estados financieros no publicados, márgenes reales)
- Fórmulas propietarias, recetas, algoritmos de negocio
- Documentos legales en proceso (contratos en negociación, demandas pendientes)
- Información de empleados (evaluaciones, salarios, datos médicos)

### Comparativa de privacidad entre modelos

| Aspecto | Claude (Anthropic) | Gemini (Google) | DeepSeek (self-hosted) |
|---|---|---|---|
| **¿Usa tus datos para entrenar?** | No (política explícita) | No en tier Enterprise; sí en versión gratuita | No aplica (corre en tu servidor) |
| **Certificaciones** | SOC 2 Type II | SOC 2, ISO 27001 | Depende de tu infraestructura |
| **Dónde se procesan los datos** | Servidores de Anthropic (EE.UU.) | Servidores de Google (global) | Tu servidor local |
| **Retención de datos** | No retiene conversaciones de API | Varía por plan y región | Tú controlas la retención |
| **Mejor para datos sensibles** | API con acuerdo empresarial | Workspace Enterprise | Máximo control, pero tú gestionas la seguridad |

> *Si tu empresa maneja datos sensibles de clientes (salud, finanzas, legales), considera seriamente modelos self-hosted como DeepSeek o acuerdos empresariales con cláusulas explícitas de no-entrenamiento.*

---

### 3. Sesgo en los outputs: la IA refleja (y amplifica) prejuicios

Los modelos de lenguaje aprenden de texto existente, y el texto existente contiene sesgos. Esto se manifiesta en situaciones de negocio de formas sutiles pero peligrosas:

- **Reclutamiento:** Si le pides a la IA que redacte un perfil de puesto para "ingeniero de software", puede usar pronombres masculinos por defecto o describir características asociadas culturalmente con hombres.
- **Análisis de mercado:** Puede subestimar el poder adquisitivo de ciertos segmentos demográficos o regiones porque sus datos de entrenamiento tienen sesgo hacia mercados desarrollados.
- **Generación de contenido:** Puede perpetuar estereotipos culturales en textos de marketing dirigidos a audiencias latinoamericanas.

**Cómo mitigar:**
- Revisa críticamente cualquier output que involucre personas, demografía o decisiones que afecten a grupos específicos
- Especifica en tus prompts que quieres lenguaje inclusivo y perspectivas diversas
- No uses IA como única fuente para decisiones que afecten a personas (contratación, promociones, evaluaciones)

---

### 4. Sobre-dependencia: el peligro de dejar de pensar

Quizás el riesgo más insidioso no es técnico sino cognitivo. Cuando una herramienta te da respuestas rápidas y articuladas, es tentador dejar de cuestionar esas respuestas.

Señales de alerta de sobre-dependencia:
- Aceptas la primera respuesta de la IA sin cuestionarla
- Dejaste de investigar por cuenta propia porque "la IA ya lo hizo"
- Tus documentos son esencialmente copy-paste de outputs de IA sin edición sustancial
- No puedes explicar el razonamiento detrás de una recomendación que presentaste (porque la generó la IA)

**La regla del 70/30:** Usa la IA para el 70% del trabajo mecánico (borradores, estructura, investigación inicial). Pero el 30% de criterio profesional, verificación y decisión final debe ser humano. Ese 30% es lo que justifica tu salario.

---

### 5. Panorama regulatorio en América Latina

La regulación de IA en la región está en construcción. No existe aún una ley comprehensiva equivalente al EU AI Act en ningún país latinoamericano, pero hay avances importantes:

| País | Estado actual | Implicaciones para tu empresa |
|---|---|---|
| **Colombia** | Marco ético de IA (MinTIC, 2024). Lineamientos voluntarios para sector público y privado | Referencia útil para diseñar políticas internas |
| **Brasil** | LGPD (Ley General de Protección de Datos) aplica a datos procesados por IA. Proyecto de ley de IA en trámite | Si operas en Brasil, los datos personales enviados a IA están sujetos a LGPD |
| **Panamá** | Ley 81 de Protección de Datos Personales (2019). Sin regulación específica de IA | Protección de datos personales aplica independientemente de si los procesa un humano o una IA |
| **México** | NOM-151 para mensajes de datos. Discusión activa sobre regulación de IA | Atención a evolución regulatoria; los datos personales ya están protegidos por la Ley Federal |
| **Chile** | Política Nacional de IA (2021). Proyecto de ley de IA avanzado | Uno de los marcos más avanzados de la región |

**Regla práctica:** Aunque no exista ley específica de IA en tu país, las leyes de protección de datos personales ya aplican a cualquier dato que envíes a un modelo de IA. Si es dato personal, necesitas base legal para procesarlo.

---

### Marco de gobernanza para tu organización

No necesitas un comité de ética de 20 personas. Necesitas respuestas claras a estas preguntas:

| Pregunta de gobernanza | Ejemplo de respuesta |
|---|---|
| **¿Quién autoriza nuevos casos de uso de IA?** | El líder de área + una revisión de TI/legal |
| **¿Qué tipos de datos se pueden enviar a IA externa?** | Solo datos públicos o anonimizados. Datos sensibles solo en modelos self-hosted |
| **¿Quién revisa los outputs antes de uso externo?** | El autor + un revisor que no usó IA para el mismo documento |
| **¿Cómo documentamos el uso de IA?** | Registro simple: qué herramienta, para qué tarea, quién revisó |
| **¿Cada cuánto revisamos las políticas?** | Cada 6 meses (el campo evoluciona rápido) |

> *La gobernanza de IA no debe frenar la innovación. Debe canalizarla. Una empresa sin políticas de uso de IA no es más ágil — es más vulnerable.*

---

### Tu turno

<!-- exercise:ia-ex-08 -->

---

**Referencias:**

- European Parliament (2024). "EU Artificial Intelligence Act." Regulation (EU) 2024/1689.
- Floridi, L. et al. (2018). "AI4People — An Ethical Framework for a Good AI Society." *Minds and Machines*, 28, 689-707.
- OECD (2019). "Recommendation of the Council on Artificial Intelligence." OECD Legal Instruments.
- UNESCO (2021). "Recommendation on the Ethics of Artificial Intelligence."
- MinTIC Colombia (2024). "Marco Ético para la Inteligencia Artificial en Colombia."
- Brasil, Lei Geral de Proteção de Dados (LGPD), Lei n. 13.709/2018.
