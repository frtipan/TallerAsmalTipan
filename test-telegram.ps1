# Script para enviar notificaciones de prueba a Telegram (Windows)
# Uso: .\test-telegram.ps1 -BotToken "..." -ChatId "..." -TestType "test|success|failure"

param(
    [Parameter(Mandatory=$false)]
    [string]$BotToken = "8846138406:AAGi34fd5fREf7PcPBT-SHxTTNVJGeKKgFY",
    
    [Parameter(Mandatory=$false)]
    [string]$ChatId = "8750807638",
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("test", "success", "failure")]
    [string]$TestType = "test"
)

$ErrorActionPreference = "Stop"

Write-Host "[INFO] Preparando notificacion de prueba ($TestType)..." -ForegroundColor Cyan
Write-Host "[BOT] Token: $($BotToken.Substring(0, 20))..." -ForegroundColor Gray
Write-Host "[CHAT] Chat ID: $ChatId" -ForegroundColor Gray
Write-Host ""

# Preparar el mensaje según el tipo de prueba
switch ($TestType) {
    "test" {
        $Message = @"
🤖 Bot de Notificaciones activado correctamente!

Éste es un mensaje de prueba del bot de Quality Gate.
Si recibes este mensaje, la integración está funcionando.
"@
    }
    "success" {
        $Message = @"
✅ Quality Gate PASSED

Project: App Reservas
Commit: abc123def456
Author: developer@example.com
Branch: develop
Repository: owner/app-reservas
Link: https://github.com/owner/app-reservas/commit/abc123def456
"@
    }
    "failure" {
        $Message = @"
❌ Quality Gate FAILED

Project: App Reservas
Commit: abc123def456
Author: developer@example.com
Branch: develop
Repository: owner/app-reservas
Link: https://github.com/owner/app-reservas/commit/abc123def456

⚠️ Por favor revisar los resultados del análisis SonarQube.
"@
    }
}

# Enviar el mensaje
try {
    $ApiUrl = "https://api.telegram.org/bot$BotToken/sendMessage"
    
    $body = @{
        chat_id = $ChatId
        text = $Message
        parse_mode = "Markdown"
    } | ConvertTo-Json
    
    $response = Invoke-WebRequest -Uri $ApiUrl `
        -Method POST `
        -ContentType "application/json" `
        -Body $body
    
    $responseData = $response.Content | ConvertFrom-Json
    
    if ($responseData.ok) {
        Write-Host "✅ Notificación enviada exitosamente!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Mensaje enviado:" -ForegroundColor Cyan
        Write-Host "$Message" -ForegroundColor White
    }
    else {
        Write-Host "❌ Error al enviar notificación:" -ForegroundColor Red
        Write-Host $responseData -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
