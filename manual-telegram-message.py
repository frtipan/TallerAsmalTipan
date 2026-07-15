import json
import urllib.request

bot_token = '8846138406:AAGi34fd5fREf7PcPBT-SHxTTNVJGeKKgFY'
chat_id = '-5483065079'
message = '''✅ QUALITY GATES + DAST APROBADO

Responsable: prueba-manual
Evento: manual
Rama: local-test
Repositorio: TallerAsmalTipan
Commit: local

🔎 RESULTADOS
• SonarQube: análisis de código completado
• DAST: escaneo dinámico ejecutado con OWASP ZAP
• Estado final: APROBADO
'''
payload = {'chat_id': chat_id, 'text': message}
data = json.dumps(payload).encode('utf-8')
req = urllib.request.Request(
    f'https://api.telegram.org/bot{bot_token}/sendMessage',
    data=data,
    headers={'Content-Type': 'application/json'},
    method='POST',
)
with urllib.request.urlopen(req, timeout=20) as resp:
    print(resp.read().decode('utf-8'))
