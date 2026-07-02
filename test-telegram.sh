#!/bin/bash
# Script para enviar notificaciones de prueba a Telegram
# Uso: ./test-telegram.sh <BOT_TOKEN> <CHAT_ID> [test|success|failure]

set -e

BOT_TOKEN="${1}"
CHAT_ID="${2}"
TEST_TYPE="${3:-test}"

if [ -z "$BOT_TOKEN" ] || [ -z "$CHAT_ID" ]; then
    echo "❌ Uso: $0 <BOT_TOKEN> <CHAT_ID> [test|success|failure]"
    echo ""
    echo "Ejemplos:"
    echo "  $0 123456789:ABCDEFGHIjklmnopqrstuvwxyz -1001234567890 test"
    echo "  $0 123456789:ABCDEFGHIjklmnopqrstuvwxyz -1001234567890 success"
    echo "  $0 123456789:ABCDEFGHIjklmnopqrstuvwxyz -1001234567890 failure"
    exit 1
fi

API_URL="https://api.telegram.org/bot$BOT_TOKEN/sendMessage"

case "$TEST_TYPE" in
    test)
        MESSAGE="🤖 Bot de Notificaciones activado correctamente!
        
Éste es un mensaje de prueba del bot de Quality Gate.
Si recibes este mensaje, la integración está funcionando."
        ;;
    success)
        MESSAGE="✅ Quality Gate PASSED

Project: App Reservas
Commit: abc123def456
Author: developer@example.com
Branch: develop
Repository: owner/app-reservas
Link: https://github.com/owner/app-reservas/commit/abc123def456"
        ;;
    failure)
        MESSAGE="❌ Quality Gate FAILED

Project: App Reservas
Commit: abc123def456
Author: developer@example.com
Branch: develop
Repository: owner/app-reservas
Link: https://github.com/owner/app-reservas/commit/abc123def456

⚠️ Por favor revisar los resultados del análisis SonarQube."
        ;;
    *)
        echo "❌ Tipo de prueba inválido: $TEST_TYPE"
        echo "Opciones: test, success, failure"
        exit 1
        ;;
esac

echo "📤 Enviando notificación de prueba ($TEST_TYPE)..."
echo "🤖 Bot Token: ${BOT_TOKEN:0:20}..."
echo "💬 Chat ID: $CHAT_ID"
echo ""

RESPONSE=$(curl -s -X POST "$API_URL" \
    -d "chat_id=$CHAT_ID" \
    -d "text=$MESSAGE" \
    -d "parse_mode=Markdown")

if echo "$RESPONSE" | grep -q '"ok":true'; then
    echo "✅ Notificación enviada exitosamente!"
    echo ""
    echo "Mensaje:"
    echo "$MESSAGE"
else
    echo "❌ Error al enviar notificación:"
    echo "$RESPONSE"
    exit 1
fi
