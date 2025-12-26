# Streamlit básico

Streamlit convierte scripts de Python en apps web interactivas.

## Tu primera app

Crea un archivo \`app.py\`:

```python
import streamlit as st
import pandas as pd

st.title("Mi primer dashboard")

# Cargar datos
df = pd.read_csv("datos.csv")

# Mostrar datos
st.dataframe(df)

# Métricas
st.metric("Total ventas", f"${df['ventas'].sum():,.0f}")
```

Ejecuta con: \`streamlit run app.py\`

<!-- exercise:ex-08-03-streamlit-basico -->

## Widgets interactivos

```python
# Slider
edad = st.slider("Edad", 0, 100, 25)

# Select
opcion = st.selectbox("Categoría", ["A", "B", "C"])

# Multi-select
seleccion = st.multiselect("Productos", ["P1", "P2", "P3"])

# Text input
nombre = st.text_input("Nombre")

# Button
if st.button("Calcular"):
    st.write("Resultado...")
```

<!-- exercise:ex-08-04-widgets -->

## Layout

```python
# Columnas
col1, col2 = st.columns(2)
with col1:
    st.metric("Ventas", "$100K")
with col2:
    st.metric("Clientes", "500")

# Sidebar
st.sidebar.title("Filtros")
filtro = st.sidebar.selectbox("Año", [2023, 2024])

# Tabs
tab1, tab2 = st.tabs(["Gráficos", "Datos"])
with tab1:
    st.plotly_chart(fig)
with tab2:
    st.dataframe(df)
```

## Siguiente paso

Integrarás Plotly con Streamlit para dashboards completos.
