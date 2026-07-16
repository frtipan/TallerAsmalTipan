import json
import os
import urllib.request

bot_token = os.getenv('TELEGRAM_BOT_TOKEN', '8846138406:AAGi34fd5fREf7PcPBT-SHxTTNVJGeKKgFY')
chat_id = os.getenv('TELEGRAM_CHAT_ID', '-5483065079')
payload = {'chat_id': chat_id, 'text': 'Prueba directa desde Python OK'}
data = json.dumps(payload).encode('utf-8')
req = urllib.request.Request(
    f'https://api.telegram.org/bot{bot_token}/sendMessage',
    data=data,
    headers={'Content-Type': 'application/json'},
    method='POST',
)
with urllib.request.urlopen(req, timeout=20) as resp:
    print(resp.read().decode('utf-8'))
