#!/bin/bash
# Script para crear el Quality Gate "StrictGate" en SonarQube automáticamente
# Uso: ./setup-quality-gate.sh <SONAR_URL> <SONAR_TOKEN>

set -e

SONAR_URL="${1:-http://localhost:9000}"
SONAR_TOKEN="${2:-admin}"
QG_NAME="StrictGate"

echo "🔧 Configurando Quality Gate: $QG_NAME"
echo "📍 SonarQube URL: $SONAR_URL"

# Crear el Quality Gate
echo "📝 Creando Quality Gate: $QG_NAME"
QG_RESPONSE=$(curl -s -X POST "$SONAR_URL/api/qualitygates/create" \
  -u "$SONAR_TOKEN:" \
  -d "name=$QG_NAME")

QG_ID=$(echo "$QG_RESPONSE" | grep -o '"id":[0-9]*' | head -1 | cut -d: -f2)

if [ -z "$QG_ID" ]; then
  echo "⚠️  Quality Gate podría haber sido creado previamente o hubo un error"
  # Intentar obtener el ID del QG existente
  QG_ID=$(curl -s -X GET "$SONAR_URL/api/qualitygates/list" \
    -u "$SONAR_TOKEN:" | grep -o "\"name\":\"$QG_NAME\"" -A 5 | grep -o '"id":[0-9]*' | head -1 | cut -d: -f2)
fi

if [ -z "$QG_ID" ]; then
  echo "❌ Error: No se pudo obtener el ID del Quality Gate"
  exit 1
fi

echo "✅ Quality Gate ID: $QG_ID"

# Array de condiciones a crear
declare -a CONDITIONS=(
  "blocker_violations:is_greater_than:0"
  "critical_violations:is_greater_than:0"
  "major_violations:is_greater_than:5"
  "security_rating:is_worse_than:A"
  "coverage:is_less_than:80"
  "duplicated_lines_density:is_greater_than:3"
  "sqale_rating:is_worse_than:A"
  "cyclomatic_complexity:is_greater_than:50"
  "cognitive_complexity:is_greater_than:30"
)

# Crear las condiciones
echo "➕ Agregando condiciones al Quality Gate..."
for condition in "${CONDITIONS[@]}"; do
  IFS=':' read -r metric operator threshold <<< "$condition"
  
  echo "  └─ Añadiendo: $metric ($operator $threshold)"
  
  curl -s -X POST "$SONAR_URL/api/qualitygates/create_condition" \
    -u "$SONAR_TOKEN:" \
    -d "gateId=$QG_ID" \
    -d "metric=$metric" \
    -d "op=$operator" \
    -d "error=$threshold" \
    > /dev/null
done

echo ""
echo "✅ Quality Gate '$QG_NAME' configurado exitosamente!"
echo ""
echo "📋 Próximos pasos:"
echo "  1. Ir a SonarQube → Proyectos → Seleccionar 'App Reservas'"
echo "  2. Project Settings → Quality Gate"
echo "  3. Seleccionar '$QG_NAME'"
echo "  4. Guardar cambios"
