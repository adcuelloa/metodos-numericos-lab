#!/usr/bin/env bash
# Convierte el notebook en un informe sin celdas de código.
#
#   ./exportar_informe.sh          -> informe.html (imprímelo como PDF desde el navegador)
#   ./exportar_informe.sh pdf      -> informe.pdf directamente (requiere Chromium)
#   ./exportar_informe.sh md       -> informe.md (editable; pásalo a .docx con pandoc)
#
# Por defecto ejecuta el notebook antes de convertir: si no, las gráficas y las
# tablas no aparecen, porque nbconvert solo copia las salidas ya guardadas.
# Usa SIN_EJECUTAR=1 para convertir tal cual está guardado (más rápido).
set -euo pipefail

NOTEBOOK="laboratorio_metodos_numericos.ipynb"
FORMATO="${1:-html}"

# remove-cell : la celda desaparece del informe (instalación, widgets, ayudas).
# hide-input  : se oculta el código y se conserva la salida.
OPCIONES=(
  --no-prompt
  --TagRemovePreprocessor.enabled=True
  --TagRemovePreprocessor.remove_cell_tags="['remove-cell']"
  --TagRemovePreprocessor.remove_input_tags="['hide-input']"
)

if [ "${SIN_EJECUTAR:-0}" != "1" ]; then
  OPCIONES+=(--execute --ExecutePreprocessor.timeout=600)
fi

case "$FORMATO" in
  html)
    jupyter nbconvert --to html "${OPCIONES[@]}" --output informe "$NOTEBOOK"
    echo "Listo: informe.html — ábrelo y usa Imprimir -> Guardar como PDF."
    ;;
  pdf)
    jupyter nbconvert --to webpdf --allow-chromium-download "${OPCIONES[@]}" \
      --output informe "$NOTEBOOK"
    echo "Listo: informe.pdf"
    ;;
  md)
    jupyter nbconvert --to markdown "${OPCIONES[@]}" --output informe "$NOTEBOOK"
    echo "Listo: informe.md (+ carpeta informe_files con las gráficas)."
    echo "Para editarlo en Word:  pandoc informe.md -o informe.docx"
    ;;
  *)
    echo "Uso: $0 [html|pdf|md]" >&2
    exit 1
    ;;
esac
