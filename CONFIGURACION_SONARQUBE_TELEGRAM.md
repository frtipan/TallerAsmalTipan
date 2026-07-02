# Guía de Configuración: SonarQube, Quality Gates y Bot de Telegram

## 1. Instalación y Configuración de SonarQube

### Opción A: Instalación Local con Docker (Recomendado)

```bash
# Crear volumen para persistencia
docker volume create sonarqube_data
docker volume create sonarqube_logs

# Ejecutar SonarQube en contenedor
docker run -d \
  --name sonarqube \
  -p 9000:9000 \
  -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLED=true \
  -v sonarqube_data:/opt/sonarqube/data \
  -v sonarqube_logs:/opt/sonarqube/logs \
  sonarqube:latest
```

Acceder a SonarQube en: `http://localhost:9000`
- Usuario: `admin`
- Contraseña: `admin` (cambiar en la primera ejecución)

### Opción B: Instalación en Servidor Remoto

1. Descargar SonarQube Community Edition desde https://www.sonarqube.org/downloads/
2. Configurar SONAR_HOME y JAVA_HOME
3. Ejecutar `./bin/[OS]/sonar.sh start`

---

## 2. Creación del Quality Gate "StrictGate"

### Pasos en la UI de SonarQube

1. **Ingresar a SonarQube** (http://localhost:9000)
2. **Navegar a:** Administration → Quality Gates
3. **Crear nuevo Quality Gate** → Nombre: `StrictGate`
4. **Configurar las siguientes condiciones:**

#### Tabla de Condiciones

| Métrica | Operador | Umbral | Tipo |
|---------|----------|--------|------|
| Blocker Issues | is greater than | 0 | Error |
| Critical Issues | is greater than | 0 | Error |
| Major Issues | is greater than | 5 | Warning |
| Security Hotspots Reviewed | is less than | 100 | Error |
| Coverage | is less than | 80 | Warning |
| Duplicated Lines (%) | is greater than | 3 | Warning |
| Technical Debt Ratio | is greater than | 2.5 | Warning |
| Cyclomatic Complexity | is greater than | 50 | Warning |
| Cognitive Complexity | is greater than | 30 | Warning |

### Pasos Detallados en SonarQube

1. En **Administration → Quality Gates**, hacer clic en **Create**
2. Nombrar como `StrictGate`
3. Para cada condición:
   - Hacer clic en **Add Condition**
   - Seleccionar la métrica de la lista desplegable
   - Elegir el operador (is greater than / is less than)
   - Ingresar el umbral
   - Seleccionar el tipo (Error / Warning)
4. Hacer clic en **Save**

### Asignar a Proyectos

1. Ir a **Projects** y seleccionar el proyecto
2. En **Project Settings → Quality Gate**, seleccionar `StrictGate`
3. Guardar

---

## 3. Configuración de Secretos en GitHub

### Crear Secretos del Repositorio

1. Ir a **Settings → Secrets and variables → Actions**
2. Crear los siguientes secretos:

```
SONAR_LOGIN = <TOKEN_DE_SONARQUBE>
SONAR_HOST_URL = http://localhost:9000 (o URL del servidor remoto)
TELEGRAM_BOT_TOKEN = <TOKEN_DEL_BOT>
TELEGRAM_CHAT_ID = <ID_DEL_GRUPO>
```

### Obtener Token de SonarQube

1. En SonarQube, ir a **User → My Account → Security**
2. Bajo "Tokens", hacer clic en **Generate New Token**
3. Nombrar el token (ej: `github-actions`)
4. Guardar el token generado

---

## 4. Crear Bot de Telegram

### Paso 1: Crear el Bot con BotFather

1. Abrir Telegram y buscar **@BotFather**
2. Enviar el comando: `/newbot`
3. BotFather solicitará:
   - **Nombre del bot:** `EquipoDevNotifierBot` (o similar)
   - **Username:** `equipo_dev_notifier_bot` (debe ser único y terminar en _bot)
4. **BotFather responderá con el Token HTTP:**
   ```
   Use this token to access the HTTP API:
   123456789:ABCDEFGHIjklmnopqrstuvwxyz123456789
   ```
5. **Guardar este Token** - será necesario para GitHub

### Paso 2: Crear Grupo de Trabajo en Telegram

1. Crear un grupo nuevo en Telegram (o usar uno existente)
2. Nombrar el grupo: `App Reservas - Notificaciones`
3. Invitar al bot al grupo (usar `/start` o agregar directamente)

### Paso 3: Obtener el Chat ID del Grupo

1. Agregar el bot al grupo
2. Enviar cualquier mensaje al grupo
3. Ejecutar en una terminal o navegador:
   ```bash
   curl "https://api.telegram.org/bot<TOKEN_BOTFATHER>/getUpdates"
   ```
   Reemplazar `<TOKEN_BOTFATHER>` con el token obtenido

4. Buscar en la respuesta JSON el campo `"chat"."id"`:
   ```json
   {
     "update_id": 123456789,
     "message": {
       "message_id": 1,
       "date": 1234567890,
       "chat": {
         "id": -1001234567890,
         ...
       }
     }
   }
   ```
5. **Guardar el Chat ID** (será negativo si es un grupo)

### Paso 4: Prueba del Bot

Enviar un mensaje de prueba:
```bash
curl -X POST "https://api.telegram.org/bot<TOKEN>/sendMessage" \
  -d "chat_id=<CHAT_ID>" \
  -d "text=Hola, soy el bot de notificaciones"
```

---

## 5. Configuración de GitHub Actions

### Archivo: `.github/workflows/sonarqube.yml`

El archivo ya está creado en el repositorio con las siguientes características:

- ✅ Ejecuta en cada push a `main` y `develop`
- ✅ Ejecuta en pull requests
- ✅ Instala dependencias de todos los servicios
- ✅ Ejecuta análisis de SonarQube
- ✅ Envía notificaciones a Telegram en caso de éxito o fallo
- ✅ Espera el resultado del Quality Gate

### Configurar Secrets en GitHub

1. Ir al repositorio en GitHub
2. **Settings → Secrets and variables → Actions**
3. Crear los siguientes secretos:

| Secret Name | Valor |
|-------------|-------|
| `SONAR_LOGIN` | Token obtenido de SonarQube |
| `SONAR_HOST_URL` | `http://localhost:9000` o URL del servidor |
| `TELEGRAM_BOT_TOKEN` | Token de BotFather |
| `TELEGRAM_CHAT_ID` | ID del grupo de Telegram |

---

## 6. Pruebas y Validación

### Prueba 1: Ejecutar SonarQube Localmente

```bash
# Navegar a la raíz del proyecto
cd app-reservas

# Ejecutar sonar-scanner (debe estar instalado)
sonar-scanner \
  -Dsonar.projectKey=app-reservas \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=<TOKEN_SONARQUBE>
```

### Prueba 2: Verificar Notificación de Telegram

1. Hacer un push a la rama `develop`
2. GitHub Actions ejecutará el workflow
3. Verificar que el mensaje llega al grupo de Telegram

### Prueba 3: Verificar Quality Gate

1. Navegar a SonarQube
2. Ver el proyecto `App Reservas`
3. Verificar que el Quality Gate se está evaluando

---

## 7. Asignación de Roles

| Rol | Responsabilidad |
|-----|-----------------|
| **Líder de Calidad** | Configurar SonarQube, crear/ajustar Quality Gates, revisar métricas |
| **DevOps** | Configurar GitHub Actions, integración con Telegram, mantener secrets |
| **Desarrolladores** | Corregir código para cumplir Quality Gates, mejorar cobertura |

---

## 8. Monitoreo Continuo

### Dashboard de SonarQube

Acceder regularmente a `http://localhost:9000` para:
- Ver tendencias de calidad
- Identificar deuda técnica
- Revisar vulnerabilidades de seguridad
- Ajustar umbral según sea necesario

### Reportes Útiles

- **Hotspots de Seguridad:** Administration → Security Hotspots
- **Cobertura de Código:** Dashboard → Coverage
- **Deuda Técnica:** Dashboard → Technical Debt

---

## Notas Importantes

⚠️ **SonarQube Local vs Remoto:**
- Local: Accesible solo en desarrollo
- Remoto: Requiere configuración de red y seguridad

⚠️ **Permisos de Bot de Telegram:**
- El bot debe tener permisos para enviar mensajes
- El grupo debe permitir mensajes de bots

⚠️ **Validación de Certificados SSL:**
- Si usas SONAR_HOST_URL con HTTPS, asegurar que el certificado sea válido

⚠️ **Performance:**
- SonarQube puede consumir recursos significativos
- Monitorear memoria y CPU si está en un servidor compartido
