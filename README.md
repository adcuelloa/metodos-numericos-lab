# Métodos numéricos — laboratorio Montería Drone Delivery

Parcial 1: [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/adcuelloa/metodos-numericos-lab/blob/main/laboratorio_metodos_numericos.ipynb)
Parcial 2: [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/adcuelloa/metodos-numericos-lab/blob/main/parcial2_ruta_de_vuelo.ipynb)

Dos notebooks independientes, uno por parcial. Cada uno funciona como **informe
académico ejecutable**: documenta el desarrollo matemático en LaTeX y se exporta a
HTML/PDF **sin celdas de código a la vista**.

| Notebook                              | Parcial | Problema                                                | Métodos                                              |
| ------------------------------------- | ------- | ------------------------------------------------------- | ---------------------------------------------------- |
| `laboratorio_metodos_numericos.ipynb` | 1       | punto de retorno seguro: raíz de una ecuación no lineal | Bisección, Regla Falsa, Newton-Raphson               |
| `parcial2_ruta_de_vuelo.ipynb`        | 2       | reconstrucción de la ruta tras un fallo de GPS          | Mínimos cuadrados (Gauss), Interpolación de Lagrange |

Ambos usan los mismos parámetros personales `D` y `E` (últimos dígitos de las cédulas),
cada uno definido en su propia celda de parámetros.

---

## Parcial 1 — `laboratorio_metodos_numericos.ipynb`

Resuelve una ecuación no lineal por tres métodos y compara su convergencia.

### Qué hace

- Define la función de forma **simbólica con SymPy** y obtiene la derivada con `sp.diff`,
  de modo que la fórmula mostrada y la que usan los algoritmos no pueden diferir.
- Documenta cada iteración con sus ecuaciones sustituidas paso a paso, no solo números.
- Grafica el intervalo, la recta secante y la recta tangente según el método.
- Compara los tres métodos: iteraciones, raíz, residuo y cambio final, con gráficas de
  convergencia y del residuo en escala logarítmica.
- Incluye exploradores interactivos (sliders) que quedan fuera del informe exportado.

### Métodos implementados

| Método         | Idea                                    | Necesita                      |
| -------------- | --------------------------------------- | ----------------------------- |
| Bisección      | punto medio del intervalo               | intervalo con cambio de signo |
| Regla Falsa    | corte de la recta secante con el eje x  | intervalo con cambio de signo |
| Newton-Raphson | corte de la recta tangente con el eje x | `x0` y la derivada `f'(x)`    |

### Ecuación general

```
f(x)  = D·ln(x) − (E/10)·e^(0.02x)
f'(x) = D/x − 0.002·E·e^(0.02x)
```

`f'(x)` no está escrita a mano: la calcula SymPy a partir de `f(x)`.

### Parámetros del caso analizado

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

---

## Parcial 2 — `parcial2_ruta_de_vuelo.ipynb`

El GPS del dron perdió la señal en el segundo 5 de un vuelo de 10 segundos. El informe
reconstruye esa altitud por dos caminos y decide cuál es más seguro.

### Qué hace

- Construye la tabla de telemetría personalizada: `y(3) = 10 + D` y `y(6) = 22 + E`.
- Ajusta por **mínimos cuadrados** polinomios de grado 2 y 3: ecuaciones normales,
  sumatorias, coeficientes `y = ax² + bx + c`, `R²` y tabla de residuos.
- Reconstruye la altitud del segundo 5 por **interpolación de Lagrange** con los
  vecinos `x = 3, 4, 6, 7`, mostrando cada base `L_i(x)` y el polinomio interpolador
  (verificado: pasa exactamente por sus nodos).
- Compara ambas estimaciones contra el obstáculo del terreno (árboles de 15 m) y
  justifica el criterio técnico.
- Simula la **ráfaga de viento** de la sustentación: `y(4)` al 150 % y al 50 %, y su
  efecto sobre `R²` y sobre la estabilidad de la ecuación.

### Métodos implementados

| Método            | Idea                                     | Necesita                      |
| ----------------- | ---------------------------------------- | ----------------------------- |
| Mínimos cuadrados | minimiza la suma de residuos al cuadrado | todas las lecturas y el grado |
| Lagrange          | polinomio que pasa por los nodos vecinos | los puntos vecinos del hueco  |

### Parámetros del caso analizado

En la sección 1.1 del notebook: `D`, `E`, el segundo del fallo y la altura de los
árboles. Al cambiarlos y volver a ejecutar se recalcula todo el informe.

| Parámetro             | Valor por defecto |
| --------------------- | ----------------- |
| D                     | 9                 |
| E                     | 6                 |
| segundo del fallo     | 5                 |
| altura de los árboles | 15 m              |

---

## Exportar el informe (HTML / PDF)

Las celdas están etiquetadas para la exportación:

| Etiqueta      | Efecto en el informe                                                      |
| ------------- | ------------------------------------------------------------------------- |
| `hide-input`  | oculta el código y conserva la salida (tablas, gráficas, ecuaciones)      |
| `remove-cell` | elimina la celda por completo (instalación, widgets, utilidades internas) |

El segundo argumento es el notebook (por defecto, el del Parcial 1). El nombre del
informe se deriva del notebook: `informe_<nombre>.<formato>`.

```bash
./exportar_informe.sh                                     # Parcial 1 -> HTML
./exportar_informe.sh pdf                                 # Parcial 1 -> PDF directo
./exportar_informe.sh html parcial2_ruta_de_vuelo.ipynb   # Parcial 2 -> HTML
./exportar_informe.sh md   parcial2_ruta_de_vuelo.ipynb   # Parcial 2 -> Markdown editable
```

El script **ejecuta el notebook antes de convertir**. Es imprescindible: nbconvert solo
copia las salidas ya guardadas, así que sobre un notebook sin ejecutar el informe sale
sin gráficas ni tablas. Si ya lo ejecutaste y quieres ahorrarte ese paso:

```bash
SIN_EJECUTAR=1 ./exportar_informe.sh
```

### Si necesitas editar el texto del informe

- `./exportar_informe.sh md [notebook]` produce Markdown editable; para pasarlo a Word:
  `pandoc informe_<nombre>.md -o informe.docx`.
- El HTML también se puede abrir directamente con Word o Google Docs, que lo convierten
  en documento editable conservando las gráficas.

**Desde Google Colab**, sin instalar nada: ejecuta todas las celdas y usa
*Archivo → Imprimir → Guardar como PDF*. Se imprime lo que esté visible, así que el
código sí aparecerá; para el informe limpio usa el script anterior.

## Ejecutar en Google Colab

1. Pulsa el badge **Open In Colab** del parcial que quieras abrir.
2. Ejecuta las celdas en orden con **Shift + Enter** (la primera instala `ipywidgets`
   y `sympy`).
3. En el Parcial 1, mueve los sliders para explorar; en ambos, edita la celda de
   parámetros para cambiar el caso.

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
