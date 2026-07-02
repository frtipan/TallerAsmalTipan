# 👨‍💻 Guía para Desarrolladores: Trabajar con Quality Gates

Este documento describe cómo trabajar con el nuevo sistema de Quality Gates integrado con SonarQube y Telegram.

---

## 📌 Lo que Necesitas Saber

### ¿Qué es un Quality Gate?

Un Quality Gate es un conjunto de **reglas de calidad que tu código DEBE cumplir** para ser aceptado:

- ✅ Sin problemas **Blocker** (errores críticos)
- ✅ Sin problemas **Critical** (vulnerabilidades de seguridad)
- ✅ Como máximo 5 problemas **Major** (defectos)
- ✅ **80% o más** de cobertura de código
- ✅ Máximo **3% de duplicación** de código
- ✅ Complejidad controlada

### ¿Qué pasa si mi código no cumple el Quality Gate?

1. GitHub Actions ejecuta el análisis
2. SonarQube evalúa tu código
3. Si falla:
   - ❌ El workflow falla
   - 🔴 Se envía notificación a Telegram
   - 🚫 **Tu PR podría no ser mergeado**
4. Debes corregir el código y hacer push nuevamente

---

## 🚀 Flujo de Trabajo

### Paso 1: Desarrollar Localmente

```bash
# Clonar o actualizar el repositorio
git clone <repository-url>
cd app-reservas

# Crear rama de feature
git checkout -b feature/mi-funcionalidad
```

### Paso 2: Escribir Código de Calidad

**Consejos:**
- ✅ Sigue las convenciones del proyecto
- ✅ Escribe pruebas unitarias
- ✅ Evita código duplicado
- ✅ Mantén funciones pequeñas y simples
- ✅ Comenta código complejo

**Ejemplo de buen código:**
```javascript
// ✅ BIEN: Función clara, con pruebas, sin duplicación
async function obtenerReservas(userId) {
  if (!userId) throw new Error('User ID requerido');
  
  const reservas = await Booking.find({ userId });
  return reservas.map(r => ({
    id: r._id,
    hotel: r.hotelName,
    fecha: r.date,
    estado: r.status
  }));
}

// ❌ MAL: Función compleja, sin pruebas, duplicación
async function getBookings(id) {
  let bookings = [];
  const db = await connect();
  const cursor = db.collection('bookings').find({userId: id});
  while (await cursor.hasNext()) {
    const b = await cursor.next();
    bookings.push(b);
  }
  return bookings;
}
```

### Paso 3: Hacer Commit y Push

```bash
# Staged los cambios
git add .

# Crear commit con mensaje descriptivo
git commit -m "feature: agregar búsqueda de reservas"

# Push a tu rama
git push origin feature/mi-funcionalidad
```

### Paso 4: Esperar Análisis de SonarQube

Cuando haces push, **automáticamente:**

1. ⏱️ GitHub Actions inicia el workflow SonarQube
2. 📊 Se instalan dependencias y se ejecuta el análisis
3. ⏳ Espera 2-5 minutos (depende del tamaño del proyecto)
4. 📢 Se envía notificación a Telegram

**En el canal de Telegram verás:**

Si **✅ PASÓ:**
```
✅ Quality Gate PASSED

Project: App Reservas
Commit: abc123def456
Author: mi-usuario
Branch: develop
Link: https://github.com/...
```

Si **❌ FALLÓ:**
```
❌ Quality Gate FAILED

Project: App Reservas
Commit: abc123def456
Author: mi-usuario
Branch: develop
Link: https://github.com/...

⚠️ Por favor revisar los resultados del análisis SonarQube.
```

### Paso 5: Si Falla el Quality Gate

1. **Haz clic en el enlace del commit** en el mensaje de Telegram
2. O **ve a SonarQube:** `http://localhost:9000/projects`
3. **Selecciona tu proyecto:** App Reservas
4. **Revisa los problemas encontrados:**

#### Ejemplo de problemas típicos:

| Problema | Solución |
|----------|----------|
| **Cobertura < 80%** | Escribir más pruebas unitarias |
| **Duplicación > 3%** | Extraer código duplicado a función común |
| **Complejidad alta** | Dividir función grande en funciones pequeñas |
| **Security Hotspot** | Revisar validación de entradas, SQL injection, etc. |
| **Code Smell** | Seguir convenciones, mejorar legibilidad |

#### Ejemplo: Aumentar Cobertura

```javascript
// archivo: src/services/user.service.js

export function calcularEdad(fechaNacimiento) {
  if (!fechaNacimiento) return null;
  const hoy = new Date();
  const edad = hoy.getFullYear() - fechaNacimiento.getFullYear();
  return edad;
}

// archivo: src/services/__tests__/user.service.test.js

describe('calcularEdad', () => {
  it('debe calcular la edad correctamente', () => {
    const fecha = new Date('1990-05-15');
    expect(calcularEdad(fecha)).toBe(34); // o el año actual
  });

  it('debe retornar null si no hay fecha', () => {
    expect(calcularEdad(null)).toBeNull();
    expect(calcularEdad(undefined)).toBeNull();
  });
});
```

### Paso 6: Hacer Push de Correcciones

```bash
# Editar archivos según sea necesario

# Hacer commit de correcciones
git add .
git commit -m "fix: aumentar cobertura de pruebas en user.service"

# Push
git push origin feature/mi-funcionalidad
```

**El workflow se ejecutará nuevamente automáticamente** ✨

### Paso 7: Crear Pull Request

Una vez que el Quality Gate pase:

1. Ve a GitHub → tu repositorio
2. Click en **Compare & pull request**
3. Llena la descripción:
   ```markdown
   ## Descripción
   Agrega funcionalidad de búsqueda de reservas
   
   ## Cambios
   - Nuevo endpoint GET /reservas?userId=xxx
   - Pruebas unitarias para el servicio
   - Documentación en README
   
   ## Checklist
   - [x] Quality Gate PASSED ✅
   - [x] Pruebas unitarias incluidas
   - [x] Cobertura > 80%
   - [x] Sin problemas de seguridad
   ```
4. Envía el PR

---

## 📊 Interpretar Resultados de SonarQube

### Dashboard de SonarQube

Accede a: `http://localhost:9000/projects`

**Métricas principales:**

```
┌─────────────────────────────────────┐
│ Coverage: 82% ✅                    │
│ Duplications: 2.1% ✅              │
│ Technical Debt: 1.5% ✅            │
│ Issues: Blocker (0) Critical (0) ✅│
│ Security Hotspots: 1 ⚠️            │
└─────────────────────────────────────┘
```

### Problemas Comunes y Soluciones

#### 1. Code Duplication (Duplicación de Código)

**Problema:** La misma lógica aparece en varios lugares

**Solución:**
```javascript
// ❌ ANTES: Código duplicado
function getUserData(id) {
  if (!id || typeof id !== 'number') throw new Error('ID inválido');
  // ... logica ...
}

function getAdminData(id) {
  if (!id || typeof id !== 'number') throw new Error('ID inválido');
  // ... logica similar ...
}

// ✅ DESPUÉS: Extraer a función común
function validateId(id) {
  if (!id || typeof id !== 'number') throw new Error('ID inválido');
}

function getUserData(id) {
  validateId(id);
  // ... logica ...
}

function getAdminData(id) {
  validateId(id);
  // ... logica ...
}
```

#### 2. Low Test Coverage (Baja Cobertura)

**Problema:** Menos del 80% del código tiene pruebas

**Solución:** Agregar pruebas unitarias
```javascript
// Escribe tests para todas las ramas de código
describe('crearReserva', () => {
  it('debe crear una reserva válida', () => {
    const reserva = crearReserva(usuarioId, hotelId, fecha);
    expect(reserva).toHaveProperty('id');
  });

  it('debe lanzar error si faltan parámetros', () => {
    expect(() => crearReserva(null, hotelId, fecha)).toThrow();
  });

  it('debe rechazar fechas pasadas', () => {
    const fechaPasada = new Date('2020-01-01');
    expect(() => crearReserva(usuarioId, hotelId, fechaPasada)).toThrow();
  });
});
```

#### 3. High Complexity (Complejidad Alta)

**Problema:** Una función hace demasiadas cosas

**Solución:** Dividir en funciones más pequeñas
```javascript
// ❌ ANTES: Función muy compleja
function procesarReserva(datos) {
  // 50+ líneas de código
  // múltiples niveles de anidamiento
  // muchas condiciones
}

// ✅ DESPUÉS: Funciones pequeñas y especializadas
function validarDatos(datos) { /* ... */ }
function calcularPrecio(tipoHabitacion, noches) { /* ... */ }
function generarConfirmacion(reserva) { /* ... */ }

function procesarReserva(datos) {
  validarDatos(datos);
  const precio = calcularPrecio(datos.habitacion, datos.noches);
  return generarConfirmacion({ ...datos, precio });
}
```

#### 4. Security Hotspots

**Problema:** Posibles vulnerabilidades de seguridad

**Ejemplos y soluciones:**

```javascript
// ❌ SQL Injection
const query = `SELECT * FROM usuarios WHERE id = ${userId}`;

// ✅ Query parametrizado
const query = 'SELECT * FROM usuarios WHERE id = ?';
db.query(query, [userId]);

// ❌ XSS Vulnerability
res.send(`<h1>Hola ${nombreUsuario}</h1>`);

// ✅ Sanitizar entrada
const nombreSanitizado = DOMPurify.sanitize(nombreUsuario);
res.send(`<h1>Hola ${nombreSanitizado}</h1>`);

// ❌ Contraseña en logs
console.log('Password:', password);

// ✅ No registrar información sensible
console.log('User authenticated');
```

---

## 🎯 Checklist Antes de Hacer Push

Antes de hacer push, verifica:

- [ ] Pruebas unitarias escritas
- [ ] Cobertura de pruebas > 80%
- [ ] Sin código duplicado
- [ ] Funciones tienen máximo 20 líneas
- [ ] Nombres de variables/funciones son claros
- [ ] Sin console.log() en código final
- [ ] Sin contraseñas o tokens en código
- [ ] Código está formateado
- [ ] Linting pasado (`npm run lint`)
- [ ] Tests pasados (`npm test`)

**Comando para verificar localmente:**
```bash
# Ejecutar linter
npm run lint

# Ejecutar tests
npm test

# Ver cobertura
npm run test:coverage

# Ejecutar SonarQube localmente (opcional)
sonar-scanner -Dsonar.projectKey=app-reservas \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=tu_token
```

---

## 💡 Tips para Mantener Alta Calidad

### 1. **Escribe Tests Mientras Develops**

```javascript
// TDD: Test-Driven Development
describe('crearReserva', () => {
  it('...', () => { /* Test */ });
  it('...', () => { /* Test */ });
});

// DESPUÉS: Implementar la función
function crearReserva(...) { /* Código */ }
```

### 2. **Refactoriza Regularmente**

- Si ves código duplicado, extrae a función
- Si una función es muy larga, divídela
- Si hay código confuso, comenta o renombra

### 3. **Revisa Otros Proyectos**

Aprender de código de otros ayuda a mejorar tu estilo:
- GitHub: busca proyectos similares
- Code Review: pide feedback a colegas

### 4. **Mantenerse Informado**

- Lee documentación de mejores prácticas
- Participa en code reviews
- Aprende nuevas técnicas

---

## ❓ Preguntas Frecuentes

### P: ¿Puedo pushear si el Quality Gate falla?

R: **Sí**, pero no se recomienda. El PR no será mergeado hasta que pase.

### P: ¿Cuánto tarda el análisis?

R: Típicamente 2-5 minutos, depende del tamaño del proyecto.

### P: ¿Puedo re-ejecutar el análisis?

R: Sí, haz un nuevo commit y push. O usa:
```bash
# Re-ejecutar workflow en GitHub Actions
# (click en "Re-run jobs" en Actions)
```

### P: ¿Qué pasa si tengo falsos positivos?

R: Reporta al Líder de Calidad. Puede ajustar los umbrales.

### P: ¿Puedo cambiar el Quality Gate?

R: No, es responsabilidad del Líder de Calidad. Si tienes sugerencias, comunica.

### P: ¿Es obligatorio llegar a 100% cobertura?

R: No, mínimo 80%. Pero intenta llegar lo más alto posible.

### P: ¿Qué hago si SonarQube está caído?

R: Contacta al DevOps. El workflow fallará hasta que SonarQube esté operativo.

---

## 📞 Contacto y Soporte

- **Líder de Calidad:** Contactar para ajustes de Quality Gate
- **DevOps:** Contactar para problemas de workflow o bot
- **Canal Telegram:** #quality-gates-notifications

---

**¡A escribir código de calidad! 💪**
