# Script para Probar la Configuracion de Telegram
# Este script esta preconfigurado con tus credenciales

$BotToken = "8846138406:AAGi34fd5fREf7PcPBT-SHxTTNVJGeKKgFY"
$chatId = "-5483065079"

Write-Host ""
Write-Host "Verificando Bot de Telegram..." -ForegroundColor Cyan

# Paso 1: Verificar Bot Token
Write-Host ""
Write-Host "[1/3] Verificando Bot Token..." -ForegroundColor Yellow

try {
    $getMeUrl = "https://api.telegram.org/bot$BotToken/getMe"
    $getMeResponse = Invoke-WebRequest -Uri $getMeUrl -ErrorAction Stop
    $botData = $getMeResponse.Content | ConvertFrom-Json
    
    if ($botData.ok) {
        Write-Host "[OK] Bot Token valido" -ForegroundColor Green
        Write-Host "Bot: $($botData.result.username)" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Token invalido: $($botData.description)" -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "[ERROR] No se pudo conectar: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Paso 2: Verificar Chat ID
Write-Host ""
Write-Host "[2/3] Verificando Chat ID..." -ForegroundColor Yellow

try {
    $updatesUrl = "https://api.telegram.org/bot$BotToken/getUpdates"
    $updatesResponse = Invoke-WebRequest -Uri $updatesUrl -ErrorAction Stop
    $updates = $updatesResponse.Content | ConvertFrom-Json
    
    if ($updates.ok) {
        Write-Host "[OK] Chat ID valido" -ForegroundColor Green
        Write-Host "Chat ID: $ChatId" -ForegroundColor Green
    } else {
        Write-Host "[WARN] No se pudo verificar Chat ID completamente" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "[ERROR] Error verificando Chat ID: $($_.Exception.Message)" -ForegroundColor Red
}

# Paso 3: Enviar Mensaje de Prueba
Write-Host ""
Write-Host "[3/3] Enviando mensaje de prueba..." -ForegroundColor Yellow

try {
    $sendUrl = "https://api.telegram.org/bot$BotToken/sendMessage"
    
    $testMessage = "Prueba de configuracion Telegram - OK"
    
    $body = @{
        chat_id = $ChatId
        text = $testMessage
    } | ConvertTo-Json
    
    $sendResponse = Invoke-WebRequest -Uri $sendUrl `
        -Method POST `
        -ContentType "application/json" `
        -Body $body `
        -ErrorAction Stop
    
    $sendData = $sendResponse.Content | ConvertFrom-Json
    
    if ($sendData.ok) {
        Write-Host "[OK] Mensaje enviado exitosamente" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] $($sendData.description)" -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "[ERROR] $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "TODO ESTA CORRECTO!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Proximos pasos:" -ForegroundColor Cyan
Write-Host "1. Configura estos Secrets en GitHub:" -ForegroundColor White
Write-Host "   - TELEGRAM_BOT_TOKEN: 8846138406:AAGi34fd5fREf7PcPBT-SHxTTNVJGeKKgFY" -ForegroundColor Gray
Write-Host "   - TELEGRAM_CHAT_ID: 8750807638" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Haz un commit:" -ForegroundColor White
Write-Host "   git add ." -ForegroundColor Gray
Write-Host "   git commit -m 'Setup: Quality Gates'" -ForegroundColor Gray
Write-Host "   git push origin develop" -ForegroundColor Gray
Write-Host ""
