# Solución de ecuaciones no lineales por métodos numéricos

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/adcuelloa/metodos-numericos-lab/blob/main/laboratorio_metodos_numericos.ipynb)

Notebook que funciona como **informe académico ejecutable**: resuelve una ecuación no
lineal por tres métodos numéricos, documenta el desarrollo matemático de las
iteraciones en LaTeX y se exporta a HTML/PDF **sin celdas de código a la vista**.

## Qué hace

- Define la función de forma **simbólica con SymPy** y obtiene la derivada con `sp.diff`,
  de modo que la fórmula mostrada y la que usan los algoritmos no pueden diferir.
- Documenta cada iteración con sus ecuaciones sustituidas paso a paso, no solo números.
- Grafica el intervalo, la recta secante y la recta tangente según el método.
- Compara los tres métodos: iteraciones, raíz, residuo y cambio final, con gráficas de
  convergencia y del residuo en escala logarítmica.
- Incluye exploradores interactivos (sliders) que quedan fuera del informe exportado.

## Métodos implementados

| Método         | Idea                                    | Necesita                      |
| -------------- | --------------------------------------- | ----------------------------- |
| Bisección      | punto medio del intervalo               | intervalo con cambio de signo |
| Regla Falsa    | corte de la recta secante con el eje x  | intervalo con cambio de signo |
| Newton-Raphson | corte de la recta tangente con el eje x | `x0` y la derivada `f'(x)`    |

## Ecuación general

```
f(x)  = D·ln(x) − (E/10)·e^(0.02x)
f'(x) = D/x − 0.002·E·e^(0.02x)
```

`f'(x)` no está escrita a mano: la calcula SymPy a partir de `f(x)`.

## Parámetros del caso analizado

Están reunidos en una sola celda (sección 2.1 del notebook). Al cambiarlos y volver a
ejecutar el documento se recalcula **todo** el informe: ecuaciones, tablas, gráficas y
resultados numéricos.

| Parámetro  | Valor por defecto |
| ---------- | ----------------- |
| D          | 9                 |
| E          | 6                 |
| a          | 200               |
| b          | 250               |
| x0         | 225               |
| tolerancia | 0.001             |

Además, los sliders de **D**, **E**, `a`, `b`, `x0` y tolerancia alimentan los
exploradores iteración por iteración de cada método, para revisar el desarrollo sin
volver a ejecutar el documento. Si un cambio de D o E deja el intervalo sin raíz, el
botón **Autoajustar intervalo** busca un cambio de signo y reubica `[a, b]` y `x0`.

## Exportar el informe (HTML / PDF)

Las celdas están etiquetadas para la exportación:

| Etiqueta      | Efecto en el informe                                                      |
| ------------- | ------------------------------------------------------------------------- |
| `hide-input`  | oculta el código y conserva la salida (tablas, gráficas, ecuaciones)      |
| `remove-cell` | elimina la celda por completo (instalación, widgets, utilidades internas) |

```bash
./exportar_informe.sh          # informe.html  -> Imprimir -> Guardar como PDF
./exportar_informe.sh pdf      # informe.pdf directo (descarga Chromium la 1.ª vez)
./exportar_informe.sh md       # informe.md editable + carpeta con las gráficas
```

El script **ejecuta el notebook antes de convertir**. Es imprescindible: nbconvert solo
copia las salidas ya guardadas, así que sobre un notebook sin ejecutar el informe sale
sin gráficas ni tablas. Si ya lo ejecutaste y quieres ahorrarte ese paso:

```bash
SIN_EJECUTAR=1 ./exportar_informe.sh
```

### Si necesitas editar el texto del informe

- `./exportar_informe.sh md` produce Markdown editable; para pasarlo a Word:
  `pandoc informe.md -o informe.docx`.
- `informe.html` también se puede abrir directamente con Word o Google Docs, que lo
  convierten en documento editable conservando las gráficas.

**Desde Google Colab**, sin instalar nada: ejecuta todas las celdas y usa
*Archivo → Imprimir → Guardar como PDF*. Se imprime lo que esté visible, así que el
código sí aparecerá; para el informe limpio usa el script anterior.

## Ejecutar en Google Colab

1. Pulsa el badge **Open In Colab**.
2. Ejecuta las celdas en orden con **Shift + Enter** (la primera instala `ipywidgets`
   y `sympy`).
3. Mueve los sliders para explorar; edita la celda de parámetros para cambiar el caso.

## Ejecutar localmente

```bash
python -m venv .venv
source .venv/bin/activate        # Linux / macOS
pip install -r requirements.txt
jupyter lab
```

En PowerShell (Windows):

```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install -r requirements.txt
jupyter lab
```

## Dependencias

`numpy`, `pandas`, `matplotlib`, `sympy`, `ipywidgets`. `jupyterlab` y `nbconvert` solo
hacen falta para ejecutarlo y exportarlo localmente.
