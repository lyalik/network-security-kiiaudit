# Соответствие требованиям (187-ФЗ, 1119, ФСТЭК №235)

| Требование | Мера | Артефакт/доказательство | Статус |
| --- | --- | --- | --- |
| 187-ФЗ ст.18 — уведомление о инциденте ≤24ч | Процедура реагирования + шаблон уведомления ФСБ/ФСТЭК | `day4/incident-scenario.md`, `day4/fsb-notification-template.md`, `final-project/security-measures/incident-scenario.md` | Готово |
| Пост. 1119 п.14 — изоляция АСУ ТП | VLAN/ACL сегментация, запрет прямого доступа из корпоративной сети | `day1/vlan-configs.txt`, `day1/isolation-why.md`, архитектура в `final-project/architecture/kii-architecture.md` | Готово |
| ФСТЭК №235 ЗИС.4 — сегментация КИИ | DMZ для мониторинга, шлюз С-Терра на границе | `final-project/architecture/kii-architecture.md`, схемы потоков | Готово |
| ФСТЭК №235 ЗИС.5 — DMZ | Сервер мониторинга вынесен в DMZ, доступ только 443↔502 | `final-project/architecture/kii-architecture.md` | Готово |
| ФСТЭК №235 ЗИС.19 — шифрование каналов | С-Терра, ГОСТ 34.12-2015 «Кузнечик» | `final-project/security-measures/gost-core.md`, `final-project/components.md` | Частично (описано, нужен скрин политики) |
| ФСТЭК №235 ЗИС.20 — аутентификация | С-Терра с ГОСТ 34.10-2012, управляемые ключи | `final-project/security-measures/gost-core.md` | Частично |
| ФСТЭК №235 ЗИС.9 — защита L2 | BPDU Guard, DHCP Snooping, DAI, Port Security | `day2/l2-security-core.md`, `day2/attack-scenario.md`, `day2/lab-screenshot.png` | Готово |
| ФСТЭК №235 ЗИС.13 — контроль доступа | ACL белые списки на шлюзе, ограничение портов | `day1/vlan-configs.txt`, `final-project/components.md` | Готово |
| ГОСТ Р 57580 — аудит | Чек-лист 20 пунктов, пример отчёта | `day5/kiiaudit-checklist.md`, `day5/audit-report-example.md` | Готово |
| Журналы и мониторинг | Сбор событий С-Терра → SIEM/ГосСОПКА, ротация логов | `final-project/security-measures/incident-core.md`, `final-project/components.md` | Частично (нужен пример выгрузки) |
