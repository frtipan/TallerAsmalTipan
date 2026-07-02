# Script para crear el Quality Gate "StrictGate" en SonarQube automáticamente (Windows)
# Uso: .\setup-quality-gate.ps1 -SonarUrl "http://localhost:9000" -SonarToken "admin"

param(
    [Parameter(Mandatory=$false)]
    [string]$SonarUrl = "http://localhost:9000",
    
    [Parameter(Mandatory=$false)]
    [string]$SonarToken = "admin"
)

$QGName = "StrictGate"
$ErrorActionPreference = "Stop"

Write-Host "🔧 Configurando Quality Gate: $QGName" -ForegroundColor Cyan
Write-Host "📍 SonarQube URL: $SonarUrl" -ForegroundColor Cyan

# Convertir token a base64 para autenticación básica
$base64Token = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("${SonarToken}:"))
$headers = @{
    "Authorization" = "Basic $base64Token"
    "Content-Type" = "application/x-www-form-urlencoded"
}

try {
    # Crear el Quality Gate
    Write-Host "📝 Creando Quality Gate: $QGName" -ForegroundColor Yellow
    $createUrl = "$SonarUrl/api/qualitygates/create?name=$QGName"
    $response = Invoke-WebRequest -Uri $createUrl -Method POST -Headers $headers
    $qgData = $response.Content | ConvertFrom-Json
    
    if ($qgData.id) {
        $QGId = $qgData.id
        Write-Host "✅ Quality Gate creado. ID: $QGId" -ForegroundColor Green
    }
    else {
        Write-Host "⚠️  Quality Gate podría haber sido creado previamente, buscando..." -ForegroundColor Yellow
        
        # Obtener lista de QGs
        $listUrl = "$SonarUrl/api/qualitygates/list"
        $listResponse = Invoke-WebRequest -Uri $listUrl -Method GET -Headers $headers
        $qgList = $listResponse.Content | ConvertFrom-Json
        
        $existingQG = $qgList.qualitygates | Where-Object { $_.name -eq $QGName }
        if ($existingQG) {
            $QGId = $existingQG.id
            Write-Host "✅ Quality Gate existente encontrado. ID: $QGId" -ForegroundColor Green
        }
        else {
            throw "No se pudo crear ni encontrar el Quality Gate"
        }
    }
    
    # Array de condiciones a crear
    $conditions = @(
        @{metric="blocker_violations"; op="is_greater_than"; threshold="0"},
        @{metric="critical_violations"; op="is_greater_than"; threshold="0"},
        @{metric="major_violations"; op="is_greater_than"; threshold="5"},
        @{metric="security_rating"; op="is_worse_than"; threshold="A"},
        @{metric="coverage"; op="is_less_than"; threshold="80"},
        @{metric="duplicated_lines_density"; op="is_greater_than"; threshold="3"},
        @{metric="sqale_rating"; op="is_worse_than"; threshold="A"},
        @{metric="cyclomatic_complexity"; op="is_greater_than"; threshold="50"},
        @{metric="cognitive_complexity"; op="is_greater_than"; threshold="30"}
    )
    
    # Crear las condiciones
    Write-Host ""
    Write-Host "➕ Agregando condiciones al Quality Gate..." -ForegroundColor Yellow
    
    foreach ($condition in $conditions) {
        $metric = $condition.metric
        $op = $condition.op
        $threshold = $condition.threshold
        
        Write-Host "  └─ Añadiendo: $metric ($op $threshold)" -ForegroundColor Gray
        
        $conditionUrl = "$SonarUrl/api/qualitygates/create_condition?gateId=$QGId&metric=$metric&op=$op&error=$threshold"
        
        try {
            Invoke-WebRequest -Uri $conditionUrl -Method POST -Headers $headers | Out-Null
        }
        catch {
            Write-Host "    ⚠️  Error agregando condición: $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }
    
    Write-Host ""
    Write-Host "✅ Quality Gate '$QGName' configurado exitosamente!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 Próximos pasos:" -ForegroundColor Cyan
    Write-Host "  1. Ir a SonarQube → Proyectos → Seleccionar 'App Reservas'" -ForegroundColor White
    Write-Host "  2. Project Settings → Quality Gate" -ForegroundColor White
    Write-Host "  3. Seleccionar '$QGName'" -ForegroundColor White
    Write-Host "  4. Guardar cambios" -ForegroundColor White
    
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
