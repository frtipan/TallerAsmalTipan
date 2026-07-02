# 🎯 Quality Gates con SonarQube y Notificaciones vía Telegram

## Descripción General

Este proyecto implementa un **sistema integral de Quality Gates** que garantiza que todos los cambios de código cumplan con estándares estrictos de calidad, seguridad y mantenibilidad. Los resultados se notifican automáticamente a través de un bot de Telegram.

---

## 📦 Archivos Incluidos

### Archivos de Configuración

1. **`.github/workflows/sonarqube.yml`** - Workflow de GitHub Actions que:
   - Ejecuta análisis de SonarQube en cada push y PR
   - Espera el resultado del Quality Gate
   - Envía notificaciones a Telegram

2. **`sonar-project.properties`** - Configuración del proyecto SonarQube

3. **`setup-quality-gate.sh`** - Script Bash para crear Quality Gate automáticamente (Linux/Mac)

4. **`setup-quality-gate.ps1`** - Script PowerShell para crear Quality Gate (Windows)

### Documentación

1. **`CONFIGURACION_SONARQUBE_TELEGRAM.md`** - Guía completa de configuración con:
   - Instalación de SonarQube (Docker y local)
   - Creación del Quality Gate "StrictGate"
   - Configuración de GitHub Actions
   - Creación del bot de Telegram

2. **`GUIA_BOT_TELEGRAM_PASO_A_PASO.md`** - Guía detallada para crear el bot:
   - Paso a paso con BotFather
   - Creación del grupo de trabajo
   - Obtención del Chat ID
   - Pruebas manuales

### Scripts de Prueba

1. **`test-telegram.sh`** - Script Bash para enviar notificaciones de prueba
2. **`test-telegram.ps1`** - Script PowerShell para enviar notificaciones de prueba

---

## 🚀 Inicio Rápido (5 minutos)

### Paso 1: Crear el Bot en Telegram
```bash
# Buscar @BotFather en Telegram
# Enviar /newbot
# Guardar el token generado
```
→ Ver detalles en: [`GUIA_BOT_TELEGRAM_PASO_A_PASO.md`](GUIA_BOT_TELEGRAM_PASO_A_PASO.md)

### Paso 2: Obtener el Chat ID
```bash
# Crear grupo de Telegram
# Agregar el bot al grupo
# Ejecutar: https://api.telegram.org/bot<TOKEN>/getUpdates
# Buscar y copiar "chat.id"
```

### Paso 3: Configurar Secrets en GitHub
```
Settings → Secrets and variables → Actions → New repository secret
```

Agregar:
- `TELEGRAM_BOT_TOKEN` = Token de BotFather
- `TELEGRAM_CHAT_ID` = ID del grupo
- `SONAR_LOGIN` = Token de SonarQube
- `SONAR_HOST_URL` = http://localhost:9000

### Paso 4: Hacer un Commit de Prueba
```bash
git add .
git commit -m "Setup: Quality Gates y notificaciones Telegram"
git push origin develop
```

**Resultado:** Recibirás una notificación en Telegram en 1-2 minutos ✅

---

## 📊 Quality Gate "StrictGate" - Condiciones

| Métrica | Operador | Umbral | Tipo |
|---------|----------|--------|------|
| **Blocker Issues** | > | 0 | 🔴 Error |
| **Critical Issues** | > | 0 | 🔴 Error |
| **Major Issues** | > | 5 | 🟡 Warning |
| **Security Hotspots Reviewed** | < | 100% | 🔴 Error |
| **Coverage** | < | 80% | 🟡 Warning |
| **Duplicated Lines %** | > | 3% | 🟡 Warning |
| **Technical Debt Ratio** | > | 2.5% | 🟡 Warning |
| **Cyclomatic Complexity** | > | 50 | 🟡 Warning |
| **Cognitive Complexity** | > | 30 | 🟡 Warning |

---

## 🛠️ Instalación Detallada

### Requisitos Previos

- Node.js 18+
- Docker (para SonarQube)
- Git
- GitHub (repositorio)
- Telegram

### Instalación de SonarQube

#### Opción 1: Docker (Recomendado)
```bash
docker volume create sonarqube_data
docker volume create sonarqube_logs

docker run -d \
  --name sonarqube \
  -p 9000:9000 \
  -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLED=true \
  -v sonarqube_data:/opt/sonarqube/data \
  -v sonarqube_logs:/opt/sonarqube/logs \
  sonarqube:latest
```

#### Opción 2: Local
Descargar desde [sonarqube.org/downloads](https://www.sonarqube.org/downloads/)

### Crear Quality Gate "StrictGate"

#### Método 1: Automático (PowerShell en Windows)
```powershell
.\setup-quality-gate.ps1 -SonarUrl "http://localhost:9000" -SonarToken "tu_token"
```

#### Método 2: Automático (Bash en Linux/Mac)
```bash
chmod +x setup-quality-gate.sh
./setup-quality-gate.sh http://localhost:9000 tu_token
```

#### Método 3: Manual
1. Ir a `http://localhost:9000`
2. Administration → Quality Gates
3. Create → Nombre: `StrictGate`
4. Agregar condiciones (ver tabla arriba)

### Crear Bot de Telegram

Ver guía completa: [`GUIA_BOT_TELEGRAM_PASO_A_PASO.md`](GUIA_BOT_TELEGRAM_PASO_A_PASO.md)

### Configurar GitHub Actions

1. Los archivos del workflow ya están incluidos:
   - `.github/workflows/sonarqube.yml`

2. Configurar secrets (Settings → Secrets):
   - `TELEGRAM_BOT_TOKEN`
   - `TELEGRAM_CHAT_ID`
   - `SONAR_LOGIN`
   - `SONAR_HOST_URL` (opcional)

---

## 🧪 Pruebas

### Probar Bot de Telegram

#### PowerShell:
```powershell
.\test-telegram.ps1 `
  -BotToken "123456789:ABCDEFGHIjklmnopqrstuvwxyz..." `
  -ChatId "-1001234567890" `
  -TestType "test"
```

#### Bash:
```bash
./test-telegram.sh "123456789:ABCDEFGHIjklmnopqrstuvwxyz..." "-1001234567890" "test"
```

### Probar Quality Gate Localmente

```bash
# Instalar sonar-scanner
npm install -g sonarqube-scanner

# Ejecutar análisis
sonar-scanner \
  -Dsonar.projectKey=app-reservas \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=tu_token
```

### Probar Workflow Completo

1. Haz un commit
2. Push a `develop` o `main`
3. Ve a Actions en GitHub
4. Observa el workflow ejecutándose
5. Verifica la notificación en Telegram

---

## 📋 Roles y Responsabilidades

### 👑 Líder de Calidad
- ✅ Configurar SonarQube
- ✅ Crear Quality Gate "StrictGate"
- ✅ Revisar métricas regularmente
- ✅ Ajustar umbrales según necesidad

### 🚀 DevOps
- ✅ Configurar GitHub Actions
- ✅ Crear y mantener bot de Telegram
- ✅ Administrar secrets
- ✅ Monitorear pipelines

### 👨‍💻 Desarrolladores
- ✅ Escribir código de calidad
- ✅ Cumplir con Quality Gates
- ✅ Mejorar cobertura de pruebas
- ✅ Reducir deuda técnica

---

## 📊 Monitoreo y Análisis

### Dashboard de SonarQube
Acceder a: `http://localhost:9000/dashboard`

Métricas clave a monitorear:
- **Coverage:** Cobertura de código (objetivo: > 80%)
- **Duplications:** Líneas duplicadas (objetivo: < 3%)
- **Technical Debt:** Deuda técnica (objetivo: < 2.5%)
- **Issues:** Blocker (0), Critical (0), Major (< 5)

### Reportes útiles
- `http://localhost:9000/admin/security/hotspots` - Hotspots de seguridad
- `http://localhost:9000/dashboard` - Dashboard general
- `http://localhost:9000/code` - Vista de código

---

## 🔧 Solución de Problemas

### GitHub Actions no envía notificaciones

1. **Verificar secrets:**
   ```bash
   # En GitHub: Settings → Secrets
   # Asegurar que todos los secretos estén presentes
   ```

2. **Revisar logs:**
   - Ir a Actions → Workflow reciente
   - Ver los logs del paso "Notify Telegram"

3. **Probar bot manualmente:**
   ```powershell
   .\test-telegram.ps1 -BotToken "..." -ChatId "..." -TestType "test"
   ```

### SonarQube no analiza el código

1. **Verificar instalación:**
   ```bash
   curl http://localhost:9000/api/system/status
   ```

2. **Revisar configuración:**
   - Archivo: `sonar-project.properties`
   - Asegurar que `sonar.sources` sea correcto

3. **Ver logs:**
   ```bash
   docker logs sonarqube  # Si usas Docker
   ```

### Bot de Telegram no recibe mensajes

1. **Verificar Chat ID:**
   ```bash
   curl "https://api.telegram.org/bot<TOKEN>/getUpdates"
   ```

2. **Verificar permisos:**
   - El bot debe estar en el grupo
   - El grupo debe permitir bots

3. **Revisar logs de GitHub:**
   - Actions → Workflow → Step: "Notify Telegram"

---

## 📚 Documentación Adicional

- [SonarQube Documentation](https://docs.sonarqube.org/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Telegram Bot API](https://core.telegram.org/bots/api)
- [appleboy/telegram-action](https://github.com/appleboy/telegram-action)

---

## 📝 Notas Importantes

⚠️ **Seguridad:**
- Los tokens nunca deben commitirse
- Usar siempre GitHub Secrets
- Cambiar contraseña default de SonarQube

⚠️ **Mantenimiento:**
- Revisar SonarQube regularmente
- Actualizar dependencias
- Monitorear recursos de SonarQube

⚠️ **Performance:**
- SonarQube requiere ~2GB RAM
- Análisis puede tomar 1-5 minutos
- Optimizar si el proyecto es muy grande

---

## ✅ Checklist de Implementación

- [ ] SonarQube instalado y ejecutándose
- [ ] Quality Gate "StrictGate" creado
- [ ] Bot de Telegram creado
- [ ] Grupo de Telegram creado
- [ ] Chat ID obtenido
- [ ] Secrets configurados en GitHub
- [ ] Workflow `.github/workflows/sonarqube.yml` en place
- [ ] Primer commit de prueba hecho
- [ ] Notificación recibida en Telegram
- [ ] Dashboard de SonarQube accesible
- [ ] Equipo informado sobre el nuevo flujo

---

## 🎉 ¡Listo!

Tu sistema de Quality Gates está operativo. Cada commit ahora será analizado automáticamente y tu equipo recibirá notificaciones en tiempo real sobre la calidad del código.

**Próximos pasos:**
1. Monitorear los primeros commits
2. Ajustar umbrales según sea necesario
3. Mejorar la cobertura de pruebas
4. Reducir deuda técnica

---

**Última actualización:** 2024  
**Versión:** 1.0  
**Estado:** ✅ Completado
