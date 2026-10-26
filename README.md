# Advokat VPN — подписка для Happ

Готовая подписка Hysteria2 для клиента [Happ](https://github.com/Happ-proxy/happ-desktop).

## Как добавить в Happ

1. Откройте Happ → **Добавить подписку** / **From URL**
2. Вставьте raw-ссылку (после публикации репозитория на GitHub):

```text
https://raw.githubusercontent.com/maximf71/subscription_Advokat_vpn/main/happ
```

Альтернатива:

```text
https://raw.githubusercontent.com/maximf71/subscription_Advokat_vpn/main/subscription
```

3. Обновите подписку в приложении

## Что внутри

| Файл | Назначение |
|------|------------|
| `happ` | Base64-подписка для Happ |
| `subscription` | То же содержимое (запасное имя) |
| `links.txt` | Расшифрованные URI (ручной импорт) |
| `SOURCE_URL.txt` | Исходная ссылка панели |

Ноды:

- `Hy2-443-Advokat` — порт 443
- `Hy2-Hop` — порт 20000

Срок (из панели): до **24 ноября 2026, 08:00 (Europe/Samara)**.

## Обновление

Подписка здесь — снимок с панели. Чтобы обновить файлы, заново скачайте содержимое с URL из `SOURCE_URL.txt` (нужен заголовок `x-hwid`) и замените `happ` / `subscription`.
