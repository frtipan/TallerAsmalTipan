# Guía Detallada: Crear Bot de Telegram y Grupo de Notificaciones

## 📱 Requisitos Previos

- Telegram instalado en tu dispositivo (móvil, desktop o web)
- Cuenta de Telegram activa
- Acceso a los secrets del repositorio GitHub

---

## 🤖 Paso 1: Crear el Bot con BotFather

### 1.1 Abrir Telegram y localizar BotFather

1. Abre la aplicación de Telegram
2. En la barra de búsqueda, escribe: `@BotFather`
3. Selecciona el resultado oficial (verificado con check azul)
4. Abre la conversación con BotFather

### 1.2 Crear un nuevo bot

1. En la conversación con BotFather, escribe: `/newbot`
2. BotFather responderá pidiendo información

### 1.3 Proporcionar información del bot

**BotFather preguntará:**

```
Alright, a new bot. How are we going to call it? 
Please choose a name for your bot.
```

**Responde:** Escribe un nombre descriptivo, por ejemplo:
- `EquipoDevNotifierBot`
- `Quality Gate Notifier`
- `App Reservas Bot`

> **Nota:** El nombre es visible al usuario

**Después, BotFather preguntará:**

```
Good. Now let's choose a username for your bot. 
It must end in `bot`. Example: TetrisBot or tetris_bot.
```

**Responde:** Escribe un username único que:
- Termine con `bot` (obligatorio)
- Solo contenga letras, números y guiones bajos
- Sea único en Telegram

Ejemplos:
- `equipodev_notifier_bot`
- `app_reservas_bot`
- `qualitygate_bot_2024`

### 1.4 Guardar el Token del Bot

BotFather responderá algo como:

```
Congratulations on your new bot. You'll find it at t.me/your_bot_username. 
You can now add a description, about section and profile picture for your bot, 
see /help for a list of commands. By the way, when you've finished with your bot, 
remember that you can always create a new bot by calling /newbot again.

Use this token to access the HTTP API:
123456789:ABCDEFGHIjklmnopqrstuvwxyz_AbCdEfGhIjKlMnOpQrStUvWxYz

For example:
- getMe
- setWebhook
- deleteWebhook

Keep your token secure and store it safely, it can be anyone if lost.
```

**⚠️ IMPORTANTE:** Copiar y guardar el token (ej: `123456789:ABCDEFGHIjklmnopqrstuvwxyz_AbCdEfGhIjKlMnOpQrStUvWxYz`)

Este token será necesario para:
- Enviar mensajes a través de la API de Telegram
- Configurar GitHub Actions
- Crear los secretos del repositorio

---

## 👥 Paso 2: Crear Grupo de Trabajo en Telegram

### 2.1 Crear un nuevo grupo

1. En Telegram, haz clic en el icono de **lápiz** (nuevo chat)
2. Selecciona **Nuevo grupo**
3. Elige los usuarios que deseas invitar (puedes dejarlos vacíos por ahora)
4. Dale un nombre descriptivo al grupo:
   - `App Reservas - Notificaciones`
   - `Dev Team - Quality Gate`
   - `Equipo de Desarrollo`
5. Presiona **Crear**

### 2.2 Agregar el bot al grupo

1. Abre el grupo recién creado
2. Toca el **nombre del grupo** en la parte superior
3. Haz clic en **Agregar miembros** (o el icono de +)
4. Busca tu bot (ej: `@equipodev_notifier_bot`)
5. Selecciona el bot y agrégalo
6. El bot se unirá al grupo

### 2.3 Dar permisos al bot (opcional pero recomendado)

1. Toca el **nombre del grupo** nuevamente
2. Selecciona el bot de la lista de miembros
3. En algunos casos, puedes ver opciones de permisos:
   - Permitir que el bot envíe mensajes
   - Permitir que el bot envíe fotos y videos
   - etc.

> **Nota:** En grupos públicos, es posible que necesites hacer que el bot sea administrador para algunas funciones

---

## 🔑 Paso 3: Obtener el Chat ID del Grupo

El Chat ID es un identificador único necesario para que el bot sepa a dónde enviar mensajes.

### Método 1: Usando la API de Telegram (Recomendado)

#### En Windows (PowerShell):

```powershell
# Reemplaza BOT_TOKEN con tu token
$BotToken = "123456789:ABCDEFGHIjklmnopqrstuvwxyz_AbCdEfGhIjKlMnOpQrStUvWxYz"

# Obtener actualizaciones
$url = "https://api.telegram.org/bot$BotToken/getUpdates"
$response = Invoke-WebRequest -Uri $url
$response.Content | ConvertFrom-Json | ConvertTo-Json -Depth 10 | Out-Host
```

#### En Linux/Mac (Terminal):

```bash
BOT_TOKEN="123456789:ABCDEFGHIjklmnopqrstuvwxyz_AbCdEfGhIjKlMnOpQrStUvWxYz"

curl "https://api.telegram.org/bot$BOT_TOKEN/getUpdates"
```

#### En el navegador:

1. Abre en tu navegador (reemplaza BOT_TOKEN):
   ```
   https://api.telegram.org/bot<BOT_TOKEN>/getUpdates
   ```

### Obtener el Chat ID de la respuesta

1. Envía un mensaje en el grupo (ej: "test" o cualquier mensaje)
2. Ejecuta el comando anterior
3. Busca en la respuesta JSON el campo `"chat"`:

```json
{
  "update_id": 123456789,
  "message": {
    "message_id": 1,
    "date": 1704067200,
    "chat": {
      "id": -1001234567890,
      "is_supergroup": true,
      "title": "App Reservas - Notificaciones",
      "type": "supergroup"
    },
    "from": { ... },
    "text": "test"
  }
}
```

**El Chat ID está en el campo `"chat"."id"`**
- Ejemplo: `-1001234567890` (negativo para grupos)

> **Nota:** El valor puede ser positivo (chats privados) o negativo (grupos)

### Método 2: Usando un Bot Auxiliar

1. Busca el bot `@userinfobot` en Telegram
2. Inicia una conversación: `/start`
3. El bot te mostrará tu información (puede mostrar el chat ID en algunos casos)

---

## 🧪 Paso 4: Probar el Bot Manualmente

### Prueba 1: Enviar mensaje simple

#### Usando PowerShell (Windows):

```powershell
$BotToken = "123456789:ABCDEFGHIjklmnopqrstuvwxyz_AbCdEfGhIjKlMnOpQrStUvWxYz"
$ChatId = "-1001234567890"  # Reemplazar con tu Chat ID
$Message = "Hola, soy el bot de notificaciones. ¿Funciona?"

$url = "https://api.telegram.org/bot$BotToken/sendMessage"
$body = @{
    chat_id = $ChatId
    text = $Message
} | ConvertTo-Json

Invoke-WebRequest -Uri $url -Method POST -ContentType "application/json" -Body $body
```

#### Usando Terminal (Linux/Mac):

```bash
BOT_TOKEN="123456789:ABCDEFGHIjklmnopqrstuvwxyz_AbCdEfGhIjKlMnOpQrStUvWxYz"
CHAT_ID="-1001234567890"

curl -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
  -d "chat_id=$CHAT_ID" \
  -d "text=Hola, soy el bot de notificaciones. ¿Funciona?"
```

### Prueba 2: Usar los Scripts Proporcionados

En el repositorio existen scripts de prueba:

#### En Windows:
```powershell
.\test-telegram.ps1 -BotToken "123456789:..." -ChatId "-1001234567890" -TestType "test"
```

#### En Linux/Mac:
```bash
./test-telegram.sh "123456789:..." "-1001234567890" "test"
```

Si todo funciona correctamente, recibirás un mensaje en el grupo de Telegram. ✅

---

## 🔐 Paso 5: Configurar Secrets en GitHub

### 5.1 Acceder a los Secrets del Repositorio

1. Ve a tu repositorio en GitHub
2. Click en **Settings** (⚙️)
3. En el menú lateral, selecciona **Secrets and variables** → **Actions**

### 5.2 Crear los Secrets

Haz clic en **New repository secret** y crea los siguientes:

#### Secret 1: `TELEGRAM_BOT_TOKEN`

- **Name:** `TELEGRAM_BOT_TOKEN`
- **Value:** Pega el token de BotFather (ej: `123456789:ABCDEFGHIjklmnopqrstuvwxyz_AbCdEfGhIjKlMnOpQrStUvWxYz`)
- Haz clic en **Add secret**

#### Secret 2: `TELEGRAM_CHAT_ID`

- **Name:** `TELEGRAM_CHAT_ID`
- **Value:** Pega el Chat ID del grupo (ej: `-1001234567890`)
- Haz clic en **Add secret**

#### Secret 3: `SONAR_LOGIN` (si aún no existe)

- **Name:** `SONAR_LOGIN`
- **Value:** Token generado en SonarQube
- Haz clic en **Add secret**

#### Secret 4: `SONAR_HOST_URL` (opcional)

- **Name:** `SONAR_HOST_URL`
- **Value:** `http://localhost:9000` (o la URL de tu servidor SonarQube)
- Haz clic en **Add secret**

### Verificar los Secrets

En la página de Secrets, deberías ver algo como:

```
SONAR_HOST_URL
SONAR_LOGIN
TELEGRAM_BOT_TOKEN
TELEGRAM_CHAT_ID
```

---

## 🚀 Paso 6: Probar la Integración End-to-End

### 6.1 Crear un commit de prueba

```bash
# Navega a tu repositorio local
cd app-reservas

# Crea un cambio menor (ej: agregar un comentario)
echo "# Test commit para verificar notificaciones" >> README.md

# Commit y push
git add README.md
git commit -m "Test: Verificar notificaciones de Telegram"
git push origin develop
```

### 6.2 Verificar GitHub Actions

1. Ve a **Actions** en tu repositorio
2. Selecciona el workflow **SonarQube Quality Gate Analysis**
3. Observa el estado de ejecución

### 6.3 Verificar Telegram

Abre el grupo de Telegram y verifica que:

✅ Recibas una notificación con la información del commit
✅ El mensaje incluya: autor, rama, archivos modificados, enlace al commit

Si todo funciona, ¡la integración está completa! 🎉

---

## 🛠️ Solución de Problemas

### Problema: "Invalid token"

**Solución:**
- Verifica que el token sea correcto (cópialo nuevamente de BotFather)
- Asegúrate de que no haya espacios adicionales
- Verifica que esté en el formato: `NÚMEROS:LETRAS_Y_NÚMEROS`

### Problema: "Chat not found"

**Solución:**
- Verifica que el Chat ID sea correcto
- Recuerda que debe ser negativo para grupos (ej: `-1001234567890`)
- Asegúrate de que el bot esté en el grupo

### Problema: "Bot kicked from the group"

**Solución:**
- Vuelve a agregar el bot al grupo
- Verifica los permisos del bot en el grupo
- Intenta enviar un mensaje directamente al bot para reactivarlo

### Problema: No recibo notificaciones en GitHub Actions

**Solución:**
- Verifica que los secrets estén correctamente configurados
- Revisa los logs del workflow en GitHub Actions
- Asegúrate de que el workflow se ejecutó sin errores
- Verifica la rama donde se está empujando (main o develop)

---

## 📋 Checklist Final

- [ ] Bot creado en Telegram (BotFather)
- [ ] Token del bot guardado de forma segura
- [ ] Grupo de Telegram creado
- [ ] Bot agregado al grupo
- [ ] Chat ID del grupo obtenido
- [ ] Notificación de prueba enviada correctamente
- [ ] Secrets configurados en GitHub:
  - [ ] `TELEGRAM_BOT_TOKEN`
  - [ ] `TELEGRAM_CHAT_ID`
  - [ ] `SONAR_LOGIN`
  - [ ] `SONAR_HOST_URL` (opcional)
- [ ] Workflow de SonarQube creado (`.github/workflows/sonarqube.yml`)
- [ ] Primer commit de prueba hecho
- [ ] Notificación recibida en Telegram

---

## 📚 Recursos Adicionales

- [Documentación de Telegram Bot API](https://core.telegram.org/bots/api)
- [BotFather Guide](https://core.telegram.org/bots)
- [Telegram Bot PHP Library](https://github.com/irazasyed/telegram-bot-sdk) (para uso avanzado)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

---

**Última actualización:** 2024
**Autor:** Equipo de DevOps
**Estado:** ✅ Completado
