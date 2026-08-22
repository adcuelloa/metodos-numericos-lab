#!/usr/bin/env bash
# Convierte el notebook en un informe sin celdas de código.
#
#   ./exportar_informe.sh                              -> informe_laboratorio_metodos_numericos.html
#   ./exportar_informe.sh html parcial2_ruta_de_vuelo.ipynb -> informe_parcial2_ruta_de_vuelo.html
#   ./exportar_informe.sh pdf  [notebook]  -> PDF directo (requiere Chromium)
#   ./exportar_informe.sh md   [notebook]  -> Markdown editable (pásalo a .docx con pandoc)
#
# El notebook es el segundo argumento; por defecto, el del Parcial 1.
# El nombre del informe se deriva del notebook: informe_<nombre>.<formato>
#
# Por defecto ejecuta el notebook antes de convertir: si no, las gráficas y las
# tablas no aparecen, porque nbconvert solo copia las salidas ya guardadas.
# Usa SIN_EJECUTAR=1 para convertir tal cual está guardado (más rápido).
set -euo pipefail

NOTEBOOK="${2:-laboratorio_metodos_numericos.ipynb}"
SALIDA="informe_$(basename "$NOTEBOOK" .ipynb)"
FORMATO="${1:-html}"

# remove-cell : la celda desaparece del informe (instalación, widgets, ayudas).
# hide-input  : se oculta el código y se conserva la salida.
OPCIONES=(
  --no-prompt
  --output-dir .
  --TagRemovePreprocessor.enabled=True
  --TagRemovePreprocessor.remove_cell_tags="['remove-cell']"
  --TagRemovePreprocessor.remove_input_tags="['hide-input']"
)

# Ejecutar y recortar en la MISMA pasada no funciona: nbconvert elimina las celdas
# etiquetadas antes de ejecutar, y con ellas las funciones auxiliares que el resto
# del documento necesita. Por eso se ejecuta primero a un notebook temporal.
FUENTE="$NOTEBOOK"

if [ "${SIN_EJECUTAR:-0}" != "1" ]; then
  TEMPORAL="$(mktemp -d)"
  trap 'rm -rf "$TEMPORAL"' EXIT
  jupyter nbconvert --to notebook --execute --ExecutePreprocessor.timeout=600 \
    --output-dir "$TEMPORAL" --output ejecutado "$NOTEBOOK"
  FUENTE="$TEMPORAL/ejecutado.ipynb"
fi

case "$FORMATO" in
  html)
    jupyter nbconvert --to html "${OPCIONES[@]}" --output "$SALIDA" "$FUENTE"
    echo "Listo: $SALIDA.html — ábrelo y usa Imprimir -> Guardar como PDF."
    ;;
  pdf)
    jupyter nbconvert --to webpdf --allow-chromium-download "${OPCIONES[@]}" \
      --output "$SALIDA" "$FUENTE"
    echo "Listo: $SALIDA.pdf"
    ;;
  md)
    jupyter nbconvert --to markdown "${OPCIONES[@]}" --output "$SALIDA" "$FUENTE"
    echo "Listo: $SALIDA.md (+ carpeta ${SALIDA}_files con las gráficas)."
    echo "Para editarlo en Word:  pandoc $SALIDA.md -o $SALIDA.docx"
    ;;
  *)
    echo "Uso: $0 [html|pdf|md] [notebook.ipynb]" >&2
    exit 1
    ;;
esac
