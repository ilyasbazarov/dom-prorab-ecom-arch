# FILE: reference/2026-08-11_bitrix_swagger_vs_d8.md

# Сверка машинной спецификации свагера с производным yaml (К-22, К-28)

Предмет: `l3-external/raw/bitrix_swagger_2026-08-11.json` (D9, внесён Owner коммитом `f81a9b1`)
против `l3-external/raw/1c_data_contract.yaml` (D8, внесён Owner коммитом `fd30f9a`).
Повод: ADR-127 §3 объявил перечень эндпоинтов D8 недоказанно полным и запретил вывод
«эндпоинта нет» из него (К-14). Настоящая сверка это ограничение снимает или подтверждает.

## Команда

```
python3 -c "import json,re,io; d=json.load(open('l3-external/raw/bitrix_swagger_2026-08-11.json')); \
y=io.open('l3-external/raw/1c_data_contract.yaml',encoding='utf-8').read(); \
print(sorted(set(d['paths'])-set(re.findall(r'path:\s*\"([^\"]+)\"',y))), \
      sorted(set(re.findall(r'path:\s*\"([^\"]+)\"',y))-set(d['paths'])))"
```

## Провенанс D9

| поле | значение |
|---|---|
| файл | `l3-external/raw/bitrix_swagger_2026-08-11.json` |
| размер, байт | 120 264 |
| строк | 3 129 по `wc -l`; последняя строка без перевода, всего 3 130 |
| sha256 первые 16 | `a49c1fa8d6ccbeb7` |
| формат | OpenAPI 3.0.3 |
| title / version | 1C Data Contract / 1.2.0 |
| путей | 10 |
| операций | 12 |
| схем в `components.schemas` | 44 |
| серверов | 1 |
| способ получения | выгрузка из авторизованного браузера Owner со страницы `https://bitrix.dompro.kg/api/v1/swagger/` |

## Результат сверки перечней (К-28 — утвердительно и числом)

- путей в спецификации: **10**
- уникальных путей в производном yaml: **10**
- есть в спецификации, отсутствует в yaml: **0**
- есть в yaml, отсутствует в спецификации: **0**

Перечни совпали ПОЛНОСТЬЮ, в обе стороны. Ограничение ADR-127 §3 в части ПЕРЕЧНЯ ЭНДПОИНТОВ
снимается: опасение о неполноте D8 не подтвердилось. На состав полей, коды ответов и схемы
сверка НЕ распространяется — она их не измеряла, и переносить вывод на них нельзя (К-1).

## Пути и операции спецификации

| # | путь | методы |
|---|---|---|
| 1 | `/api/v1/auth/token/` | POST |
| 2 | `/api/v1/categories/category_list` | POST |
| 3 | `/api/v1/counterparties/counterparty_list` | POST |
| 4 | `/api/v1/create_order/` | POST |
| 5 | `/api/v1/orders/status/` | GET |
| 6 | `/api/v1/orders/{orderId}/status/` | GET, POST, PUT |
| 7 | `/api/v1/products/fast_update/` | POST |
| 8 | `/api/v1/products/product_list` | POST |
| 9 | `/api/v1/products/properties` | POST |
| 10 | `/api/v1/products/store_list/` | POST |

## Что сверка НЕ устанавливает

- Соответствие спецификации фактическому поведению портала: описание интерфейса не есть
  прогон (К-1, ADR-105 §4). Это вход F4-17, а не его замена.
- Полноту относительно того, что подрядчик РЕАЛИЗОВАЛ: спецификация описывает заявленное.
- Совпадение схем и полей D8 с D9 — измерены только перечни путей.
