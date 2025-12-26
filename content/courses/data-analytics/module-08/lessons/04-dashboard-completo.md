# Dashboard completo

Combinaremos todo: datos, gráficos y widgets en un dashboard funcional.

## Estructura de un dashboard

```python
import streamlit as st
import pandas as pd
import plotly.express as px

# Configuración
st.set_page_config(page_title="Dashboard", layout="wide")

# Título
st.title("📊 Dashboard de Ventas")

# Cargar datos
@st.cache_data
def cargar_datos():
    return pd.read_csv("ventas.csv")

df = cargar_datos()

# Sidebar - Filtros
st.sidebar.header("Filtros")
año = st.sidebar.selectbox("Año", df["año"].unique())
categoria = st.sidebar.multiselect("Categoría", df["categoria"].unique())

# Aplicar filtros
df_filtrado = df[df["año"] == año]
if categoria:
    df_filtrado = df_filtrado[df_filtrado["categoria"].isin(categoria)]

# Métricas
col1, col2, col3 = st.columns(3)
with col1:
    st.metric("Ventas totales", f"${df_filtrado['ventas'].sum():,.0f}")
with col2:
    st.metric("Transacciones", len(df_filtrado))
with col3:
    st.metric("Ticket promedio", f"${df_filtrado['ventas'].mean():,.0f}")

# Gráficos
col1, col2 = st.columns(2)

with col1:
    fig = px.line(df_filtrado, x="mes", y="ventas", title="Tendencia mensual")
    st.plotly_chart(fig, use_container_width=True)

with col2:
    fig = px.pie(df_filtrado, values="ventas", names="categoria", title="Por categoría")
    st.plotly_chart(fig, use_container_width=True)

# Tabla
st.subheader("Datos detallados")
st.dataframe(df_filtrado)
```

<!-- exercise:ex-08-05-dashboard -->

## Despliegue

Streamlit Cloud ofrece hosting gratuito:
1. Sube tu código a GitHub
2. Conecta en share.streamlit.io
3. Deploy

## Resumen del módulo

- Plotly Graph Objects para control total
- Streamlit para apps interactivas
- Widgets para filtros dinámicos
- Layout con columns, sidebar, tabs
- @st.cache_data para performance
