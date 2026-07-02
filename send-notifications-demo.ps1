# Script para Probar Notificaciones Detalladas de Telegram
# Uso: .\send-notifications-demo.ps1

$BotToken = "8846138406:AAGi34fd5fREf7PcPBT-SHxTTNVJGeKKgFY"
$ChatId = "-5483065079"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "DEMO: Notificaciones Detalladas Telegram" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Funcion para enviar notificacion
function Send-Notification {
    param(
        [string]$Title,
        [string]$Message
    )
    
    Write-Host "Enviando: $Title" -ForegroundColor Yellow
    
    $sendUrl = "https://api.telegram.org/bot$BotToken/sendMessage"
    
    $body = @{
        chat_id = $ChatId
        text = $Message
        parse_mode = "Markdown"
    } | ConvertTo-Json
    
    try {
        $response = Invoke-WebRequest -Uri $sendUrl `
            -Method POST `
            -ContentType "application/json" `
            -Body $body `
            -ErrorAction Stop -UseBasicParsing
        
        $data = $response.Content | ConvertFrom-Json
        
        if ($data.ok) {
            Write-Host "OK - Enviado" -ForegroundColor Green
        } else {
            Write-Host "Error: $($data.description)" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# NOTIFICACION 1: Analisis EXITOSO con Metricas
$mensajeExito = @"
ANALISIS COMPLETADO - EXITO

Author: juan123
Branch: develop
Commit: a1b2c3d4

RESULTADOS:
Status: PASSED

SEGURIDAD:
Vulnerabilidades: 0
Issues Blocker: 0
Issues Critical: 0
Issues Major: 2
Security Hotspots: 1 (100% revisados)

COBERTURA Y DUPLICACION:
Cobertura: 85% (meta: 80%)
Duplicacion: 2.1% (meta: <3%)
Deuda Tecnica: 1.8% (meta: <2.5%)

COMPLEJIDAD:
Complejidad Ciclomatica: 42 (meta: <50)
Complejidad Cognitiva: 28 (meta: <30)

ARCHIVOS:
- auth-service/ (5 archivos)
- booking-service/ (3 archivos)
- frontend/ (12 archivos)

Listo para merge!
"@

Send-Notification -Title "Notificacion EXITOSA con Metricas" -Message $mensajeExito

Write-Host ""
Start-Sleep -Seconds 2

# NOTIFICACION 2: Con VULNERABILIDADES
$mensajeFallo = @"
ANALISIS COMPLETADO - CON PROBLEMAS

Author: maria456
Branch: feature/login
Commit: x9y8z7w6

RESULTADOS:
Status: FAILED

SEGURIDAD:
Vulnerabilidades: 3 CRITICAS
Issues Blocker: 2
Issues Critical: 3
Issues Major: 8
Security Hotspots: 5 (60% revisados)

VULNERABILIDADES ENCONTRADAS:
1. SQL Injection - auth-service/auth.controller.js
2. XSS Vulnerability - frontend/login.tsx
3. Hardcoded Credentials - notification-service/mailer.js

COBERTURA Y DUPLICACION:
Cobertura: 62% (meta: 80%) - FALLO
Duplicacion: 5.2% (meta: <3%) - FALLO
Deuda Tecnica: 4.1% (meta: <2.5%) - FALLO

COMPLEJIDAD:
Complejidad Ciclomatica: 67 (meta: <50) - FALLO
Complejidad Cognitiva: 41 (meta: <30) - FALLO

ACCIONES REQUERIDAS:
- Revisar vulnerabilidades de seguridad
- Aumentar cobertura de pruebas (62% -> 80%)
- Reducir duplicacion de codigo
- Simplificar funciones complejas
"@

Send-Notification -Title "Notificacion CON VULNERABILIDADES" -Message $mensajeFallo

Write-Host ""
Start-Sleep -Seconds 2

# NOTIFICACION 3: Resumen Rapido
$mensajeResumen = @"
RESUMEN RAPIDO - ANALISIS

Proyecto: App Reservas
Branch: develop
Archivos Modificados: 8

RESULTADO: QUALITY GATE PASSED

DATOS PRINCIPALES:
Vulnerabilidades: 0
Cobertura: 85%
Complejidad: 42/50
Tiempo: 2m 14s

Listo para merge!
"@

Send-Notification -Title "Resumen Rapido" -Message $mensajeResumen

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "DEMO COMPLETADA" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Se enviaron 3 ejemplos a Telegram:" -ForegroundColor Cyan
Write-Host "1. Analisis Exitoso con Metricas" -ForegroundColor Green
Write-Host "2. Analisis con Vulnerabilidades" -ForegroundColor Red
Write-Host "3. Resumen Rapido" -ForegroundColor Yellow
Write-Host ""

