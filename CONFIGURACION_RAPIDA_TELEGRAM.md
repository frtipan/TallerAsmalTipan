# ⚡ Configuración Rápida - Telegram Bot

## 🔑 Tus Credenciales

```
Bot Token:    8846138406:AAGi34fd5fREf7PcPBT-SHxTTNVJGeKKgFY
Chat ID:      -5483065079
```

---

## 📋 Paso 1: Configurar Secretos en GitHub

### Acceder a los Secretos

1. Ve a tu repositorio en GitHub
2. Haz clic en **Settings** (⚙️)
3. En el menú izquierdo, selecciona **Secrets and variables** → **Actions**
4. Haz clic en **New repository secret**

### Crear los 4 Secretos

#### Secreto 1: `TELEGRAM_BOT_TOKEN`

- **Name:** `TELEGRAM_BOT_TOKEN`
- **Value:** Copia esto exactamente:
```
8846138406:AAGi34fd5fREf7PcPBT-SHxTTNVJGeKKgFY
```
- Click en **Add secret**

#### Secreto 2: `TELEGRAM_CHAT_ID`

- **Name:** `TELEGRAM_CHAT_ID`
- **Value:** Copia esto exactamente:
```
8750807638
```
- Click en **Add secret**

#### Secreto 3: `SONAR_LOGIN` (si no existe)

- **Name:** `SONAR_LOGIN`
- **Value:** Tu token de SonarQube (pregunta al Líder de Calidad si no lo tienes)
- Click en **Add secret**

#### Secreto 4: `SONAR_HOST_URL` (opcional)

- **Name:** `SONAR_HOST_URL`
- **Value:** `http://localhost:9000`
- Click en **Add secret**

### ✅ Verificar Secretos

Deberías ver en la lista:
```
SONAR_HOST_URL
SONAR_LOGIN
TELEGRAM_BOT_TOKEN         ← ¡IMPORTANTE!
TELEGRAM_CHAT_ID           ← ¡IMPORTANTE!
```

---

## 🧪 Paso 2: Probar que Funciona

### Opción A: PowerShell (Windows)

```powershell
# Abre PowerShell en la carpeta del proyecto
cd "d:\Desarrollo de S.Seguro\TercerParcial\app-reservas"

# Ejecuta el test
.\test-telegram.ps1 `
  -BotToken "8846138406:AAGi34fd5fREf7PcPBT-SHxTTNVJGeKKgFY" `
  -ChatId "8750807638" `
  -TestType "test"
```

**Resultado esperado:** Recibirás un mensaje en Telegram con el grupo indicado ✅

### Opción B: Bash (Linux/Mac)

```bash
cd "d:\Desarrollo de S.Seguro\TercerParcial\app-reservas"

chmod +x test-telegram.sh

./test-telegram.sh "8846138406:AAGi34fd5fREf7PcPBT-SHxTTNVJGeKKgFY" "8750807638" "test"
```

---

## 🚀 Paso 3: Hacer Primer Commit

```bash
# Navegar al proyecto
cd "d:\Desarrollo de S.Seguro\TercerParcial\app-reservas"

# Agregar todos los archivos
git add .

# Hacer commit
git commit -m "Setup: Quality Gates con SonarQube y Telegram"

# Push a la rama develop
git push origin develop
```

**¿Qué pasará?**
1. GitHub Actions ejecutará automáticamente el workflow SonarQube
2. En 1-2 minutos verás una notificación en Telegram ✅
3. La notificación incluirá el autor, rama, archivos modificados, etc.

---

## 🔗 URLs Importantes

| Servicio | URL |
|----------|-----|
| SonarQube | http://localhost:9000 |
| GitHub Actions | https://github.com/tu-usuario/app-reservas/actions |
| Telegram | https://web.telegram.org (para ver mensajes) |

---

## ❓ Verificación Rápida

### ¿Tu Chat ID está correcto?

Ejecuta esto en PowerShell:

```powershell
$BotToken = "8846138406:AAGi34fd5fREf7PcPBT-SHxTTNVJGeKKgFY"
$url = "https://api.telegram.org/bot$BotToken/getUpdates"
$response = Invoke-WebRequest -Uri $url
$response.Content | ConvertFrom-Json | ConvertTo-Json -Depth 10
```

Busca en la respuesta: `"chat"."id"` debe ser `8750807638`

### ¿Tu Bot Token es válido?

```powershell
$BotToken = "8846138406:AAGi34fd5fREf7PcPBT-SHxTTNVJGeKKgFY"
$url = "https://api.telegram.org/bot$BotToken/getMe"
$response = Invoke-WebRequest -Uri $url
$response.Content | ConvertFrom-Json
```

Deberías ver: `"ok": true` ✅

---

## 📝 Checklist Final

- [ ] Token de bot guardado: `8846138406:AAGi34fd5fREf7PcPBT-SHxTTNVJGeKKgFY`
- [ ] Chat ID guardado: `8750807638`
- [ ] Secreto `TELEGRAM_BOT_TOKEN` creado en GitHub
- [ ] Secreto `TELEGRAM_CHAT_ID` creado en GitHub
- [ ] Test de Telegram pasó ✅
- [ ] Primer commit realizado
- [ ] Notificación recibida en Telegram ✅

---

## 🆘 Si Algo No Funciona

### No recibo notificación en Telegram

1. **Verifica secretos:**
   - Settings → Secrets → Verifica que los 2 secretos estén presentes
   
2. **Ejecuta el test manualmente:**
   ```powershell
   .\test-telegram.ps1 -BotToken "8846138406:AAGi34fd5fREf7PcPBT-SHxTTNVJGeKKgFY" -ChatId "8750807638" -TestType "test"
   ```

3. **Revisa GitHub Actions:**
   - Actions → Workflow reciente → Click en step "Notify Telegram"
   - Busca errores en los logs

### El test en PowerShell falla

1. Verifica que el bot token sea exacto (sin espacios)
2. Verifica que el Chat ID sea `8750807638`
3. Intenta en navegador:
   ```
   https://api.telegram.org/bot8846138406:AAGi34fd5fREf7PcPBT-SHxTTNVJGeKKgFY/sendMessage?chat_id=8750807638&text=test
   ```

---

**¡Listo! Tu sistema de notificaciones Telegram está configurado.** 🎉

Próximo paso: Hacer un commit y ver la notificación en tiempo real.
