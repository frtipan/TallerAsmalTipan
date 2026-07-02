# 🔐 GUÍA VISUAL: Configurar Secretos en GitHub

## 📌 TUS VALORES (Copiar y Pegar)

```
Bot Token:    8846138406:AAGi34fd5fREf7PcPBT-SHxTTNVJGeKKgFY
Chat ID:      -5483065079
```

---

## ⏩ PASOS RÁPIDOS

### Paso 1: Abrir GitHub

```
https://github.com/tu-usuario/app-reservas/settings/secrets/actions
```

*(Reemplaza `tu-usuario` con tu usuario de GitHub)*

O en tu navegador:
1. Ve a tu repositorio
2. Click **Settings** (⚙️ esquina superior derecha)
3. En el menú izquierdo: **Secrets and variables** → **Actions**

---

### Paso 2: Crear Secreto 1 - TELEGRAM_BOT_TOKEN

**Click en: "New repository secret"**

```
Name:  TELEGRAM_BOT_TOKEN
Value: 8846138406:AAGi34fd5fREf7PcPBT-SHxTTNVJGeKKgFY
```

**Click: "Add secret"**

---

### Paso 3: Crear Secreto 2 - TELEGRAM_CHAT_ID

**Click en: "New repository secret"**

```
Name:  TELEGRAM_CHAT_ID
Value: 8750807638
```

**Click: "Add secret"**

---

### Paso 4: Crear Secreto 3 - SONAR_LOGIN

**Click en: "New repository secret"**

```
Name:  SONAR_LOGIN
Value: [Tu token de SonarQube - pregunta si no lo tienes]
```

**Click: "Add secret"**

---

### Paso 5: Crear Secreto 4 - SONAR_HOST_URL

**Click en: "New repository secret"**

```
Name:  SONAR_HOST_URL
Value: http://localhost:9000
```

**Click: "Add secret"**

---

## ✅ VERIFICAR QUE ESTÁ CORRECTO

Después de crear los 4 secretos, deberías ver:

```
Actions secrets

SONAR_HOST_URL                    Updated 1 minute ago
SONAR_LOGIN                       Updated 1 minute ago
TELEGRAM_BOT_TOKEN                Updated 1 minute ago
TELEGRAM_CHAT_ID                  Updated 1 minute ago
```

Si ves esto, ¡está correcto! ✅

---

## 🧪 PRUEBA ANTES DE COMMITEAR

Abre PowerShell en tu carpeta del proyecto y ejecuta:

```powershell
# Verificar que todo funciona
.\verify-telegram-setup.ps1
```

Deberías ver:
- ✅ Bot Token VÁLIDO
- ✅ Chat ID VÁLIDO  
- ✅ Mensaje enviado exitosamente

---

## 🚀 HACER PRIMER COMMIT

Una vez que todo esté configurado:

```bash
# Ir a la carpeta del proyecto
cd "d:\Desarrollo de S.Seguro\TercerParcial\app-reservas"

# Agregar cambios
git add .

# Hacer commit
git commit -m "Setup: Quality Gates con SonarQube y Telegram"

# Push
git push origin develop
```

---

## ⏱️ ¿QUÉ PASA DESPUÉS?

1. **GitHub Actions se ejecuta automáticamente** (1-2 min)
2. **Recibes notificación en Telegram** con información del commit
3. **Dashboard de SonarQube se actualiza** con análisis

---

## 🎯 VALORES EXACTOS PARA COPIAR

### TELEGRAM_BOT_TOKEN
```
8846138406:AAGi34fd5fREf7PcPBT-SHxTTNVJGeKKgFY
```

### TELEGRAM_CHAT_ID
```
8750807638
```

---

## 🔗 ENLACES ÚTILES

- GitHub Secrets: https://github.com/tu-usuario/app-reservas/settings/secrets/actions
- GitHub Actions: https://github.com/tu-usuario/app-reservas/actions
- Telegram Bot: https://web.telegram.org

---

## ❓ ¿ALGO FALLA?

### Error: "Invalid token"
- Verifica que el token no tenga espacios
- Copia exactamente de esta guía

### No recibo notificación
- Verifica que los 2 secretos de Telegram estén en GitHub
- Ejecuta: `.\verify-telegram-setup.ps1`
- Revisa GitHub Actions logs

### Mensaje incorrecto en Telegram
- Verifica Chat ID (debe ser `8750807638`)
- Ejecuta el verificador: `.\verify-telegram-setup.ps1`

---

**¡Listo! Ahora solo configura los secretos en GitHub y estarás listo.** 🎉
