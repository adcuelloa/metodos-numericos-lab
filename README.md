# Laboratorio interactivo de Métodos Numéricos

Visualiza y compara Bisección, Regla Falsa y Newton-Raphson sobre:

\[
f(x)=D\ln(x)-\frac{E}{10}e^{0.02x}
\]

## Configuración original
- D = 9
- E = 6
- a = 200
- b = 250
- x0 = 225
- tolerancia = 0.001

D, E, a, b, x0 y la tolerancia se pueden cambiar desde widgets.

## Google Colab
Abre `laboratorio_metodos_numericos.ipynb` y ejecuta las celdas con Shift + Enter.

## Local
```bash
python -m venv .venv
```

PowerShell:
```powershell
.venv\Scripts\Activate.ps1
pip install -r requirements.txt
jupyter lab
```
