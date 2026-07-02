# 📱 Ejemplos de Notificaciones en Telegram

## Notificación de ÉXITO (Quality Gate PASSED)

```
✅ Quality Gate PASSED

Project: App Reservas
Commit: abc123def456
Author: tu-usuario
Branch: develop
Repository: owner/app-reservas
Link: https://github.com/owner/app-reservas/commit/abc123def456
```

**Lo que significa:**
- ✅ Tu código pasó todas las validaciones de SonarQube
- ✅ No hay problemas Blocker o Critical
- ✅ La cobertura de pruebas es suficiente
- ✅ La complejidad está dentro de los límites
- ✅ Tu PR puede ser mergeado

---

## Notificación de FALLO (Quality Gate FAILED)

```
❌ Quality Gate FAILED

Project: App Reservas
Commit: abc123def456
Author: tu-usuario
Branch: develop
Repository: owner/app-reservas
Link: https://github.com/owner/app-reservas/commit/abc123def456

⚠️ Please review the SonarQube analysis results.
```

**Lo que significa:**
- ❌ Tu código NO pasó las validaciones de SonarQube
- ❌ Hay problemas que deben ser corregidos
- 🔗 Haz clic en el enlace para ver los detalles del análisis
- 🚫 Tu PR NO será mergeado hasta que corrijas los problemas

---

## 📊 Información Disponible en Cada Notificación

| Campo | Descripción | Ejemplo |
|-------|-------------|---------|
| Status | ✅ PASSED o ❌ FAILED | ✅ Quality Gate PASSED |
| Project | Nombre del proyecto | App Reservas |
| Commit | Hash del commit | abc123def456 |
| Author | Quién hizo el commit | tu-usuario |
| Branch | Rama donde se hizo push | develop |
| Repository | Repositorio completo | owner/app-reservas |
| Link | Enlace directo al commit | https://github.com/owner/app-reservas/commit/abc123def456 |

---

## 🔍 Problemas Típicos que Verás

### Ejemplo 1: Baja Cobertura
```
❌ Quality Gate FAILED

⚠️ Coverage is 72% but must be at least 80%
   Necesitas escribir más pruebas unitarias
```

### Ejemplo 2: Código Duplicado
```
❌ Quality Gate FAILED

⚠️ Duplicated Lines is 5.2% but must be less than 3%
   Extrae código duplicado a funciones comunes
```

### Ejemplo 3: Vulnerabilidad de Seguridad
```
❌ Quality Gate FAILED

⚠️ Critical Issue: SQL Injection Risk
   Usa queries parametrizadas en lugar de concatenación
```

### Ejemplo 4: Complejidad Alta
```
❌ Quality Gate FAILED

⚠️ Cyclomatic Complexity exceeds threshold
   Divide la función en funciones más pequeñas
```

---

## 🔗 Cómo Acceder a Más Detalles

Cuando recibas una notificación en Telegram:

1. **Haz clic en el enlace del commit**
   - Te llevará a GitHub

2. **Ve a GitHub Actions**
   - Actions → Workflow reciente
   - Mira los logs del análisis SonarQube

3. **Abre SonarQube directamente**
   - Navega a http://localhost:9000
   - Selecciona el proyecto "App Reservas"
   - Ver detalles completos del análisis

---

## 📋 Checklist: Lo que Recibirás

✅ Notificación inmediata en Telegram cuando hagas push
✅ Información del autor del commit
✅ Rama afectada
✅ Enlace directo al commit
✅ Estado del Quality Gate (PASSED/FAILED)
✅ Recomendación si falla

---

## 🧪 Probar Notificaciones Manualmente

### Enviar Notificación de Éxito
```powershell
.\test-telegram.ps1 -BotToken "8846138406:AAGi34fd5fREf7PcPBT-SHxTTNVJGeKKgFY" -ChatId "8750807638" -TestType "success"
```

### Enviar Notificación de Fallo
```powershell
.\test-telegram.ps1 -BotToken "8846138406:AAGi34fd5fREf7PcPBT-SHxTTNVJGeKKgFY" -ChatId "8750807638" -TestType "failure"
```

### Enviar Notificación de Prueba
```powershell
.\test-telegram.ps1 -BotToken "8846138406:AAGi34fd5fREf7PcPBT-SHxTTNVJGeKKgFY" -ChatId "8750807638" -TestType "test"
```

---

## ⚙️ Personalizar Notificaciones

Si quieres cambiar el formato de las notificaciones, edita el archivo:

```
.github/workflows/sonarqube.yml
```

Busca las secciones:
- `Notify Telegram on Success` (línea ~57)
- `Notify Telegram on Failure` (línea ~68)

Y modifica el mensaje según tus necesidades.

---

## 🎯 Resumen

**Cada push/PR dispara:**
1. Análisis automático de SonarQube (1-2 min)
2. Evaluación del Quality Gate
3. Notificación a Telegram (✅ o ❌)
4. Información clara sobre qué hacer

**Todo sucede en tiempo real** ⚡
