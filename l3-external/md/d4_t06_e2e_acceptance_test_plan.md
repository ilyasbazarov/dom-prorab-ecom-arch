<!-- SNAPSHOT-FRAGMENT | doc: Доработки в Битрикс (CRM + CMS) | tab: E2E Acceptance Test Plan | raw: l3-external/raw/d4_*.docx | snapshot-commit: 4b639ae repo state | date: 2026-07-17 -->

E2E Acceptance Test Plan

**ДОМ ПРОРАБА — Интеграция Bitrix**

**E2E Acceptance Test Plan**

Версия: 1.1 \| Дата: 2026-05-05

Документ: INF-E2E-01

| **Применимость:** Приёмочное тестирование (UAT) Bitrix-подрядчика. Три сквозных сценария покрывают полный путь: витрина (D&S) → продажа (Checkout/Processing/LastMile) → возврат. Проводятся после сдачи всех эпиков, до передачи в production. |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

| **Контрагент**           | Bitrix-подрядчик (CMS + CRM)                                                                                                                                  |
|--------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Источники**            | D&S TZ v1.1 / Checkout TZ v1.1 / Processing TZ v1.1 / LastMile TZ v1.1 / INF-MON-01 v1.1                                                                      |
| **Тестовая среда**       | Staging с рабочей копией 1С-sandbox (List.kg) + FTP-сервер                                                                                                    |
| **Ответственный за UAT** | Дом Прораба — технический лид                                                                                                                                 |
| **Покрытие**             | Сценарий 0: Slow Track + Fast Track → витрина. Сценарий 1: Физлицо, самовывоз, без OOS → WA-накладная. Сценарий 2: Физлицо, самовывоз, наличный возврат → NPS |

| **Принцип остановки:** При провале любого шага с пометкой 🔴 БЛОКЕР — тест прекращается. Подрядчик устраняет дефект и перезапускает сценарий с начала. |
|--------------------------------------------------------------------------------------------------------------------------------------------------------|

# **PRE-CONDITIONS — Условия запуска тестов**

| **\#** | **Условие**                                                                                                                                                                                                                                                                  | **Ответственный**          | **Статус**  |
|--------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------|-------------|
| PC-01  | Staging Bitrix CMS + Bitrix24 CRM задеплоены. Все эпики 8–33 реализованы.                                                                                                                                                                                                    | Bitrix-подрядчик           | ☐ Выполнено |
| PC-02  | 1С sandbox (List.kg) с эндпоинтами /create_order, /close_order, /create_return, /create_rko доступен.                                                                                                                                                                        | List.kg                    | ☐ Выполнено |
| PC-03  | Тестовый товар в каталоге: GUID=TEST-GUID-001, цена Price_Ecom=1500 сом, UF_IS_RETURNABLE=1, Stock_Free\[TEST-STORE-01\]≥5.                                                                                                                                                  | Bitrix-подрядчик           | ☐ Выполнено |
| PC-04  | Тестовый склад: store_id=TEST-STORE-01, UF_SOURCE_STORE_ID=TEST-STORE-01. Адрес склада заполнен.                                                                                                                                                                             | Bitrix-подрядчик           | ☐ Выполнено |
| PC-05  | HSM-шаблоны order_completed_invoice, return_nps_request зарегистрированы в Meta (или заглушка Wazzup для staging).                                                                                                                                                           | Дом Прораба                | ☐ Выполнено |
| PC-06  | Тестовый клиент: телефон +996700000001, имя Тестовый Клиент. Физлицо, без реквизитов юрлица.                                                                                                                                                                                 | Tester                     | ☐ Выполнено |
| PC-07  | Wazzup подключён к Bitrix24 staging (или WA-заглушка для staging, фиксирует исходящие сообщения в лог).                                                                                                                                                                      | Bitrix-подрядчик           | ☐ Выполнено |
| PC-08  | INF-MON-01 задеплоен: b_dom_ft_meta создана, b_dom_processed_1c_events содержит колонку status.                                                                                                                                                                              | Bitrix-подрядчик           | ☐ Выполнено |
| PC-06  | Тестовый клиент: телефон +996700000001, имя Тестовый Клиент. Физлицо, без реквизитов юрлица.                                                                                                                                                                                 | Tester                     | ☐ Выполнено |
| PC-07  | Wazzup подключён к Bitrix24 staging (или WA-заглушка для staging, фиксирует исходящие сообщения в лог).                                                                                                                                                                      | Bitrix-подрядчик           | ☐ Выполнено |
| PC-08  | INF-MON-01 задеплоен: b_dom_ft_meta создана, b_dom_processed_1c_events содержит колонку status.                                                                                                                                                                              | Bitrix-подрядчик           | ☐ Выполнено |
| PC-09  | FTP-сервер доступен. Тестовый bitrix_catalog.csv (UTF-8 BOM, разделитель ;) подготовлен с строкой: GUID=TEST-GUID-001, Name_Clean=Тестовый Гипсокартон, Ecom_Status=Stand_Alone, Is_Toxic_Offline=0, is_returnable=1, Unit_Base=лист, Unit_Alt=м², Ratio=3.00, Weight_kg=25. | Tester / Data Engineer     | ☐ Выполнено |
| PC-10  | \_DONE.flag-механизм: Tester может вручную положить CSV+флаг на FTP или запустить Slow Track импорт через adminку напрямую.                                                                                                                                                  | Bitrix-подрядчик           | ☐ Выполнено |
| PC-11  | Fast Track эндпоинт /update_fast_track задеплоен. X-Api-Key настроен. Тестовый IP добавлен в whitelist \[COM-PRE-04\].                                                                                                                                                       | Bitrix-подрядчик + List.kg | ☐ Выполнено |
| PC-12  | Таблица b_dom_stocks создана: (guid, store_id, stock_free, updated_at), UNIQUE KEY (guid, store_id) \[COM-PRE-05\].                                                                                                                                                          | Bitrix-подрядчик           | ☐ Выполнено |
| PC-13  | STORE_DEFAULT_ID = TEST-STORE-01 в константах CMS. Словарь Store_ID → Название: TEST-STORE-01 → Тестовый склад.                                                                                                                                                              | Bitrix-подрядчик           | ☐ Выполнено |

# **СЦЕНАРИЙ 0 — Витрина: Slow Track + Fast Track → товар доступен к покупке**

| **Scope**           | Импорт каталога из BI (FTP) → обновление цен/остатков (Fast Track) → корректное отображение на витрине → управление ACTIVE → лист ожидания                |
|---------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Участники**       | FTP-сервер → CMS (Bitrix) → b_dom_stocks → CRM (Bitrix24)                                                                                                 |
| **TZ-источники**    | D&S TZ v1.1: INF-DS-01, INF-DS-01a, INF-DS-02, INF-DS-03, Эпики 1–7                                                                                       |
| **Ожидаемый исход** | Товар TEST-GUID-001 виден на витрине с ценой 1500 сом, остатком 5 шт на TEST-STORE-01. ACTIVE-правила верифицированы. Лист ожидания создаёт сделку в CRM. |
| **Зависимость**     | Должен быть пройден до Сценария 1: S1-01 чекаут зависит от наличия товара в инфоблоке и в b_dom_stocks.                                                   |
| **Блокеры провала** | Любой шаг 🔴 → стоп, дефект, перезапуск с S0-01                                                                                                           |

## **S0-01 — Slow Track: FTP-файл → импорт → товар в инфоблоке**

| **Механизм (INF-DS-01):** CMS опрашивает FTP каждые 30 мин с 04:00. При обнаружении \_DONE.flag в папке текущей даты — запускает импорт bitrix_catalog.csv. На staging Tester кладёт файл вручную и триггерит импорт. |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

<table>
<colgroup>
<col style="width: 7%" />
<col style="width: 15%" />
<col style="width: 10%" />
<col style="width: 28%" />
<col style="width: 20%" />
<col style="width: 18%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Актор</strong></th>
<th><strong>Действие</strong></th>
<th><strong>API / Событие</strong></th>
<th><strong>Ключевые поля payload</strong></th>
<th><strong>Ожидаемый результат</strong></th>
<th><strong>Проверка приёмки ✓</strong></th>
</tr>
<tr class="odd">
<th>Tester / FTP</th>
<th>Разместить bitrix_catalog.csv + _DONE.flag на FTP в /bi_catalog/YYYY-MM-DD/. Запустить Slow Track импорт (через adminку или ждать крон-цикла).</th>
<th>INF-DS-01 — Slow Track consumer</th>
<th><p><strong>CSV-строка:</strong></p>
<p>GUID=TEST-GUID-001</p>
<p>Name_Clean=Тест.Гипсокартон</p>
<p>Ecom_Status=Stand_Alone</p>
<p>Is_Toxic_Offline=0</p>
<p>is_returnable=1</p>
<p>Unit_Base=лист</p>
<p>Unit_Alt=м², Ratio=3.00</p>
<p>Weight_kg=25</p></th>
<th><p><strong>Инфоблок Битрикс:</strong></p>
<p>Элемент создан с XML_ID = TEST-GUID-001</p>
<p>NAME = Тестовый Гипсокартон</p>
<p>ACTIVE = Y (Stand_Alone, Toxic=0)</p>
<p>UF_IS_RETURNABLE = 1</p>
<p>UF_UNIT_BASE = лист, UF_UNIT_ALT = м²</p>
<p>UF_RATIO = 3.00</p>
<p>UF_WEIGHT_KG = 25</p>
<p><strong>b_dom_ft_meta:</strong></p>
<p>last_slow_track_date = сегодня</p>
<p>last_slow_track_ok = 1</p></th>
<th><p><strong>🔴 БЛОКЕР:</strong></p>
<p>Элемент TEST-GUID-001 существует в инфоблоке</p>
<p>ACTIVE = Y</p>
<p>XML_ID = TEST-GUID-001 (не изменять!)</p>
<p><strong>🔴 БЛОКЕР:</strong></p>
<p>last_slow_track_ok = 1 в b_dom_ft_meta</p>
<p><strong>🟡 ПРОВЕРИТЬ:</strong></p>
<p>Повторный запуск с той же датой → импорт не выполняется (last_imported_date уже обновлён)</p></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

## **S0-02 — Fast Track: POST /update_fast_track → b_dom_stocks → витрина**

| **Механизм (INF-DS-02):** 1С отправляет батч каждые 5 мин. Tester симулирует батч curl-запросом с X-Api-Key. Один товар × один склад = один объект в массиве. |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------|

<table>
<colgroup>
<col style="width: 8%" />
<col style="width: 14%" />
<col style="width: 14%" />
<col style="width: 19%" />
<col style="width: 27%" />
<col style="width: 13%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Актор</strong></th>
<th><strong>Действие</strong></th>
<th><strong>API / Событие</strong></th>
<th><strong>Ключевые поля payload</strong></th>
<th><strong>Ожидаемый результат</strong></th>
<th><strong>Проверка приёмки ✓</strong></th>
</tr>
<tr class="odd">
<th>Tester (curl / Postman)</th>
<th>Отправить POST /update_fast_track с тестовым батчем. Проверить обновление b_dom_stocks и отображение на витрине.</th>
<th>POST /update_fast_track (INF-DS-02)</th>
<th><p><strong>Payload (батч):</strong></p>
<p>[{</p>
<p>"GUID":"TEST-GUID-001",</p>
<p>"Store_ID":"TEST-STORE-01",</p>
<p>"Stock_Free": 5,</p>
<p>"Price_Retail": 1800.00,</p>
<p>"Price_B2B": 1600.00,</p>
<p>"Price_Ecom": 1500.00,</p>
<p>"Price_Promo": null</p>
<p>}]</p>
<p><strong>Заголовок:</strong></p>
<p>X-Api-Key: {test_secret}</p></th>
<th><p><strong>HTTP ответ:</strong></p>
<p>200 {"status":"ok",</p>
<p>"processed":1,"skipped":0}</p>
<p><strong>b_dom_stocks (upsert):</strong></p>
<p>guid=TEST-GUID-001</p>
<p>store_id=TEST-STORE-01</p>
<p>stock_free=5, updated_at=now()</p>
<p><strong>Витрина:</strong></p>
<p>Карточка товара: «В наличии»</p>
<p>Price_Ecom = 1500 сом (без зачёркивания)</p>
<p>Price_Promo = null → акционной цены нет</p></th>
<th><p><strong>🔴 БЛОКЕР:</strong></p>
<p>b_dom_stocks: stock_free=5 для TEST-GUID-001 / TEST-STORE-01</p>
<p>Витрина: плашка «В наличии»</p>
<p>Цена: 1500 сом, нет зачёркнутой цены</p>
<p><strong>🟡 ПРОВЕРИТЬ:</strong></p>
<p>Неверный X-Api-Key → HTTP 401</p>
<p>HTTP-запрос с IP не из whitelist → отклонён</p></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

## **S0-03 — Логика цены: Price_Promo и аномалия Price_Promo=0**

<table>
<colgroup>
<col style="width: 8%" />
<col style="width: 18%" />
<col style="width: 18%" />
<col style="width: 20%" />
<col style="width: 17%" />
<col style="width: 17%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Актор</strong></th>
<th><strong>Действие</strong></th>
<th><strong>API / Событие</strong></th>
<th><strong>Ключевые поля payload</strong></th>
<th><strong>Ожидаемый результат</strong></th>
<th><strong>Проверка приёмки ✓</strong></th>
</tr>
<tr class="odd">
<th>Tester</th>
<th>Шаг A: отправить батч с Price_Promo=990. Шаг B: отправить батч с Price_Promo=0 (аномалия). Шаг C: отправить батч с Price_Promo=null (восстановление).</th>
<th>POST /update_fast_track (INF-DS-02, COM-PRE-02)</th>
<th><p><strong>Шаг A — акция:</strong></p>
<p>"Price_Ecom": 1500.00,</p>
<p>"Price_Promo": 990.00</p>
<p><strong>Шаг B — аномалия:</strong></p>
<p>"Price_Promo": 0</p>
<p><strong>Шаг C — восстановление:</strong></p>
<p>"Price_Promo": null</p></th>
<th><p><strong>Шаг A — витрина:</strong></p>
<p>Зачёркнутая цена: 1500 сом</p>
<p>Акционная цена: 990 сом</p>
<p><strong>Шаг B — витрина [COM-PRE-02]:</strong></p>
<p>Price_Promo=0 трактуется как null</p>
<p>Акционная цена НЕ отображается</p>
<p>Лог Bitrix: WARN про аномалию</p>
<p><strong>Шаг C — витрина:</strong></p>
<p>Только Price_Ecom = 1500 сом</p></th>
<th><p><strong>🔴 БЛОКЕР (Шаг A):</strong></p>
<p>Зачёркнутая цена + акционная 990 сом</p>
<p><strong>🔴 БЛОКЕР (Шаг B):</strong></p>
<p>Price_Promo=0 → НЕ показывается как «990 сом» и НЕ как «0 сом»</p>
<p>Лог содержит WARN Fast Track anomaly: Price_Promo=0</p>
<p><strong>🔴 БЛОКЕР (Шаг C):</strong></p>
<p>Только Price_Ecom, никакой зачёркнутой цены</p></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

## **S0-04 — Правила ACTIVE: Is_Toxic_Offline и EDGE-04**

| **Механизм (INF-DS-01a + EDGE-04):** ACTIVE управляется только Slow Track. Fast Track НИКОГДА не меняет ACTIVE. Если ACTIVE=N — Fast Track батч по GUID игнорируется (не обновляет цены и остатки). |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

<table style="width:100%;">
<colgroup>
<col style="width: 8%" />
<col style="width: 17%" />
<col style="width: 11%" />
<col style="width: 27%" />
<col style="width: 19%" />
<col style="width: 15%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Актор</strong></th>
<th><strong>Действие</strong></th>
<th><strong>API / Событие</strong></th>
<th><strong>Ключевые поля payload</strong></th>
<th><strong>Ожидаемый результат</strong></th>
<th><strong>Проверка приёмки ✓</strong></th>
</tr>
<tr class="odd">
<th>Tester</th>
<th>Шаг A: запустить Slow Track с Is_Toxic_Offline=1 для TEST-GUID-001. Шаг B: отправить Fast Track батч. Шаг C: Slow Track с Is_Toxic_Offline=0 — восстановление.</th>
<th>INF-DS-01, INF-DS-01a, EDGE-04</th>
<th><p><strong>Шаг A (CSV):</strong></p>
<p>Is_Toxic_Offline=1</p>
<p>Ecom_Status=Stand_Alone</p>
<p><strong>Шаг B (Fast Track):</strong></p>
<p>"GUID":"TEST-GUID-001",</p>
<p>"Stock_Free": 99</p>
<p><strong>Шаг C (CSV):</strong></p>
<p>Is_Toxic_Offline=0</p></th>
<th><p><strong>Шаг A — результат:</strong></p>
<p>ACTIVE = N (приоритет 1 INF-DS-01a)</p>
<p>Товар скрыт из каталога и поиска</p>
<p><strong>Шаг B — EDGE-04:</strong></p>
<p>b_dom_stocks НЕ обновлён</p>
<p>stock_free остаётся прежним (5)</p>
<p>Лог: INFO 'GUID skipped, ACTIVE=N'</p>
<p><strong>Шаг C — восстановление:</strong></p>
<p>ACTIVE = Y, товар снова виден</p></th>
<th><p><strong>🔴 БЛОКЕР (Шаг A):</strong></p>
<p>ACTIVE = N после Slow Track</p>
<p>Товар не виден на витрине и в поиске</p>
<p><strong>🔴 БЛОКЕР (Шаг B / EDGE-04):</strong></p>
<p>stock_free в b_dom_stocks НЕ изменился до 99</p>
<p>Fast Track не может «поднять» ACTIVE=N товар</p>
<p><strong>🔴 БЛОКЕР (Шаг C):</strong></p>
<p>ACTIVE = Y восстановлен только Slow Track'ом</p></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

## **S0-05 — Stock_Free=0: статус «Под заказ» и лист ожидания (Эпик 7.2)**

<table>
<colgroup>
<col style="width: 6%" />
<col style="width: 12%" />
<col style="width: 8%" />
<col style="width: 30%" />
<col style="width: 22%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Актор</strong></th>
<th><strong>Действие</strong></th>
<th><strong>API / Событие</strong></th>
<th><strong>Ключевые поля payload</strong></th>
<th><strong>Ожидаемый результат</strong></th>
<th><strong>Проверка приёмки ✓</strong></th>
</tr>
<tr class="odd">
<th>Tester</th>
<th>Шаг A: отправить Fast Track с Stock_Free=0 для TEST-GUID-001. Шаг B: открыть карточку товара, отправить форму «Сообщить о поступлении». Шаг C: повторно отправить ту же форму (дедупликация).</th>
<th>Fast Track (INF-DS-02) + Эпик 7.2 (D&amp;S TZ)</th>
<th><p><strong>Шаг A — батч:</strong></p>
<p>"Stock_Free": 0</p>
<p><strong>Шаг B — форма (CMS → CRM):</strong></p>
<p>{</p>
<p>"phone":"+996700000001",</p>
<p>"GUID":"TEST-GUID-001",</p>
<p>"Name_Clean":"Тест.Гипсокартон",</p>
<p>"active_store_id":"TEST-STORE-01"</p>
<p>}</p></th>
<th><p><strong>Шаг A — витрина:</strong></p>
<p>ACTIVE = Y (Stock_Free=0 не меняет ACTIVE!)</p>
<p>Статус: «Под заказ / Сообщить о поступлении»</p>
<p>Кнопка «В корзину» скрыта</p>
<p>Попап «Где купить» скрыт (Total=0)</p>
<p><strong>Шаг B — CRM:</strong></p>
<p>Сделка создана в воронке «Лист ожидания»</p>
<p>Задача менеджеру: «Предложить аналог»</p>
<p><strong>Шаг C — дедупликация (EDGE-07):</strong></p>
<p>Новая сделка НЕ создана</p>
<p>UF_LAST_REQUEST_DATE обновлён</p>
<p>Задача менеджеру НЕ продублирована</p></th>
<th><p><strong>🔴 БЛОКЕР (Шаг A):</strong></p>
<p>ACTIVE остаётся Y (Stock=0 не скрывает товар)</p>
<p>Плашка «Под заказ», кнопка корзины скрыта</p>
<p><strong>🔴 БЛОКЕР (Шаг B):</strong></p>
<p>Сделка существует в воронке «Лист ожидания»</p>
<p>Поля: phone, GUID, Name_Clean, UF_ACTIVE_STORE_ID заполнены</p>
<p><strong>🔴 БЛОКЕР (Шаг C / EDGE-07):</strong></p>
<p>Одна сделка, не две. Только дата обновлена.</p></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

## **S0-06 — window.activeStoreId: переключатель склада (INF-DS-03)**

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 13%" />
<col style="width: 11%" />
<col style="width: 20%" />
<col style="width: 21%" />
<col style="width: 22%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Актор</strong></th>
<th><strong>Действие</strong></th>
<th><strong>API / Событие</strong></th>
<th><strong>Ключевые поля payload</strong></th>
<th><strong>Ожидаемый результат</strong></th>
<th><strong>Проверка приёмки ✓</strong></th>
</tr>
<tr class="odd">
<th>Tester (браузер)</th>
<th>Добавить второй тестовый склад TEST-STORE-02 с остатком 3 шт (Fast Track батч). Переключить склад в шапке сайта на TEST-STORE-02. Проверить обновление попапа «Где купить» без перезагрузки страницы.</th>
<th>INF-DS-03 + Эпик 6.1</th>
<th><p><strong>Fast Track — склад 2:</strong></p>
<p>"GUID":"TEST-GUID-001",</p>
<p>"Store_ID":"TEST-STORE-02",</p>
<p>"Stock_Free": 3,</p>
<p>"Price_Ecom": 1500.00,</p>
<p>"Price_Promo": null</p></th>
<th><p><strong>После переключения:</strong></p>
<p>window.activeStoreId = TEST-STORE-02</p>
<p>Cookie active_store_id = TEST-STORE-02</p>
<p>Попап «Где купить»:</p>
<p>Тестовый склад — 5 шт</p>
<p>Тестовый склад 2 — 3 шт</p>
<p>Перезагрузка страницы → cookie сохранена, склад 2 активен</p></th>
<th><p><strong>🟠 ВАЖНО:</strong></p>
<p>window.activeStoreId обновляется без перезагрузки</p>
<p>Попап «Где купить» отражает оба склада с правильными остатками</p>
<p><strong>🟡 ПРОВЕРИТЬ:</strong></p>
<p>После перезагрузки: склад 2 остаётся активным (cookie)</p>
<p>При повреждённой cookie: fallback на STORE_DEFAULT_ID = TEST-STORE-01</p></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

| **✅ СЦЕНАРИЙ 0 ЗАВЕРШЁН:** 6 шагов пройдены. Товар TEST-GUID-001 импортирован через Slow Track, цены/остатки обновлены через Fast Track, Price_Promo-аномалия обработана корректно, ACTIVE-правила верифицированы, лист ожидания создал сделку в CRM без дублей. Витрина готова для Сценария 1. |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

# **СЦЕНАРИЙ 1 — Физлицо, самовывоз, без OOS**

| **Пред-условие**      | Сценарий 0 пройден: товар TEST-GUID-001 в инфоблоке, ACTIVE=Y, b_dom_stocks содержит stock_free=5 для TEST-STORE-01. |
|-----------------------|----------------------------------------------------------------------------------------------------------------------|
| **Scope**             | Полный happy path: чекаут → подтверждение заказа → сборка → выдача → WA-накладная                                    |
| **Участники системы** | CMS (Bitrix) → CRM (Bitrix24) → 1С (sandbox) → WA (Wazzup/заглушка)                                                  |
| **TZ-источники**      | Checkout TZ v1.1 Эпики 8–15 \| Processing TZ v1.1 Эпики 16–19 \| LastMile TZ v1.1 Эпики 23–24                        |
| **Ожидаемый исход**   | Сделка в статусе «Успешно реализовано», WA-накладная отправлена, 1С создал Чек ККМ                                   |
| **Блокеры провала**   | Любой шаг 🔴 → стоп, дефект, перезапуск с S1-01                                                                      |

## **S1-01 — Клиент оформляет заказ в CMS (чекаут)**

<table>
<colgroup>
<col style="width: 9%" />
<col style="width: 21%" />
<col style="width: 11%" />
<col style="width: 19%" />
<col style="width: 15%" />
<col style="width: 22%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Актор</strong></th>
<th><strong>Действие</strong></th>
<th><strong>API / Событие</strong></th>
<th><strong>Ключевые поля payload</strong></th>
<th><strong>Ожидаемый результат</strong></th>
<th><strong>Проверка приёмки ✓</strong></th>
</tr>
<tr class="odd">
<th>Клиент (браузер)</th>
<th>Добавить товар в корзину, перейти в чекаут, заполнить форму: Тип доставки=самовывоз, Дата=+1 день, Слот=10:00–12:00, Склад=TEST-STORE-01, Имя=Тестовый Клиент, Телефон=+996700000001</th>
<th>POST crm.deal.add (Bitrix API)</th>
<th><p><strong>Обязательные поля:</strong></p>
<p>UF_SOURCE_STORE_ID = "TEST-STORE-01"</p>
<p>UF_DELIVERY_TYPE = "pickup"</p>
<p>UF_CLIENT_TYPE = "physical"</p>
<p>UF_DATE_PICKUP = "+1 день"</p>
<p>UF_TIME_SLOT = "10:00–12:00"</p>
<p>OPPORTUNITY = 1500.00</p></th>
<th><p><strong>CRM:</strong></p>
<p>Сделка создана, статус: «Ожидает подтверждения»</p>
<p><strong>Поля сделки:</strong></p>
<p>Все 6 UF-полей заполнены корректно.</p>
<p>OPPORTUNITY = 1500.00 (= 1 × 1500)</p></th>
<th><p><strong>🔴 БЛОКЕР:</strong></p>
<p>Сделка существует в CRM</p>
<p>UF_SOURCE_STORE_ID = "TEST-STORE-01"</p>
<p>UF_CLIENT_TYPE = "physical"</p>
<p>OPPORTUNITY = 1500.00</p></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

## **S1-02 — Менеджер подтверждает заказ → /create_order**

<table>
<colgroup>
<col style="width: 9%" />
<col style="width: 13%" />
<col style="width: 11%" />
<col style="width: 12%" />
<col style="width: 26%" />
<col style="width: 26%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Актор</strong></th>
<th><strong>Действие</strong></th>
<th><strong>API / Событие</strong></th>
<th><strong>Ключевые поля payload</strong></th>
<th><strong>Ожидаемый результат</strong></th>
<th><strong>Проверка приёмки ✓</strong></th>
</tr>
<tr class="odd">
<th>Менеджер (CRM)</th>
<th>Открыть сделку, нажать кнопку «Подтверждён» (Эпик 15.2 Checkout TZ v1.1)</th>
<th>POST /create_order (IC-PR-01)</th>
<th><p><strong>Payload → 1С:</strong></p>
<p>CRM_Deal_ID = {deal_id}</p>
<p>store_id = "TEST-STORE-01"</p>
<p>items: [{</p>
<p>GUID: "TEST-GUID-001",</p>
<p>Qty: 1,</p>
<p>Price: 1500.00</p>
<p>}]</p></th>
<th><p><strong>1С ответ:</strong></p>
<p>{ "status": "success",</p>
<p>"purchase_order_guid":</p>
<p>"PO-GUID-001",</p>
<p>"purchase_order_number":</p>
<p>"ЗКЧ-000001" }</p>
<p><strong>CRM сохраняет:</strong></p>
<p>UF_PURCHASE_ORDER_GUID = PO-GUID-001</p>
<p>UF_1C_ORDER_NUMBER = ЗКЧ-000001</p></th>
<th><p><strong>🔴 БЛОКЕР:</strong></p>
<p>UF_PURCHASE_ORDER_GUID заполнен</p>
<p>UF_1C_ORDER_NUMBER = ЗКЧ-000001</p>
<p><strong>🟠 ВАЖНО:</strong></p>
<p>WA клиенту отправлен (лог Wazzup)</p></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

## **S1-03 — 1С отправляет вебхук order_confirmed → CRM**

<table style="width:100%;">
<colgroup>
<col style="width: 7%" />
<col style="width: 11%" />
<col style="width: 23%" />
<col style="width: 19%" />
<col style="width: 22%" />
<col style="width: 15%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Актор</strong></th>
<th><strong>Действие</strong></th>
<th><strong>API / Событие</strong></th>
<th><strong>Ключевые поля payload</strong></th>
<th><strong>Ожидаемый результат</strong></th>
<th><strong>Проверка приёмки ✓</strong></th>
</tr>
<tr class="odd">
<th>1С (sandbox)</th>
<th>Автоматически: смена статуса заказа → «В работе / Ожидает сборки» → триггер 1С-РТ-03</th>
<th>POST CRM_Webhook_URL_OrderStatus (INF-PR-01, event=order_confirmed)</th>
<th><p><strong>Payload 1С → CRM:</strong></p>
<p>CRM_Deal_ID: {deal_id}</p>
<p>event: "order_confirmed"</p>
<p>purchase_order_guid: "PO-GUID-001"</p>
<p>purchase_order_number: "ЗКЧ-000001"</p></th>
<th><p><strong>CRM:</strong></p>
<p>Записать в b_dom_processed_1c_events</p>
<p>Сделка → «В работе / Ожидает сборки»</p>
<p>Ответ 1С: HTTP 200</p></th>
<th><p><strong>🔴 БЛОКЕР:</strong></p>
<p>Статус сделки = «В работе / Ожидает сборки»</p>
<p>Дубль вебхука → HTTP 200 без дублирования статуса (идемпотентность)</p></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

## **S1-04 — Кнопка «Сборка завершена» (UF_DELIVERY_TYPE=pickup)**

| **Логика CRM-LM-01a (Checkout TZ v1.1):** Кнопка «Сборка завершена» → CRM-робот читает UF_DELIVERY_TYPE = "pickup" → сделка → «Ожидает выдачи» → старт таймера «Автоотмена 72ч». |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

<table>
<colgroup>
<col style="width: 12%" />
<col style="width: 15%" />
<col style="width: 14%" />
<col style="width: 21%" />
<col style="width: 18%" />
<col style="width: 17%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Актор</strong></th>
<th><strong>Действие</strong></th>
<th><strong>API / Событие</strong></th>
<th><strong>Ключевые поля payload</strong></th>
<th><strong>Ожидаемый результат</strong></th>
<th><strong>Проверка приёмки ✓</strong></th>
</tr>
<tr class="odd">
<th>Менеджер / Кладовщик (CRM)</th>
<th>Нажать кнопку «Сборка завершена» в карточке сделки (статус «В работе / Ожидает сборки»)</th>
<th>CRM-робот CRM-LM-01a (Checkout TZ v1.1)</th>
<th><p><strong>Маршрутизация:</strong></p>
<p>UF_DELIVERY_TYPE = "pickup"</p>
<p>→ «Ожидает выдачи»</p>
<p>→ Старт таймера 72ч</p>
<p>(Вызовов к 1С нет)</p></th>
<th><p><strong>CRM:</strong></p>
<p>Сделка → «Ожидает выдачи»</p>
<p>CRM-робот «Автоотмена 72ч» запущен</p></th>
<th><p><strong>🔴 БЛОКЕР:</strong></p>
<p>Статус = «Ожидает выдачи»</p>
<p>Таймер 72ч стартовал</p>
<p><strong>🟡 ПРОВЕРИТЬ:</strong></p>
<p>Повторное нажатие кнопки игнорируется</p></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

## **S1-05 — Кассир пробивает чек → 1С отправляет check_printed**

<table>
<colgroup>
<col style="width: 8%" />
<col style="width: 12%" />
<col style="width: 26%" />
<col style="width: 15%" />
<col style="width: 25%" />
<col style="width: 12%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Актор</strong></th>
<th><strong>Действие</strong></th>
<th><strong>API / Событие</strong></th>
<th><strong>Ключевые поля payload</strong></th>
<th><strong>Ожидаемый результат</strong></th>
<th><strong>Проверка приёмки ✓</strong></th>
</tr>
<tr class="odd">
<th>1С (sandbox)</th>
<th>Симулировать пробитие Чека ККМ по заказу PO-GUID-001 → триггер 1С-CK-03</th>
<th>POST CRM_Webhook_Path_CheckPrinted (Эпик 24.1 LastMile TZ v1.1)</th>
<th><p><strong>Payload 1С → CRM:</strong></p>
<p>CRM_Deal_ID: {deal_id}</p>
<p>event: "check_printed"</p>
<p>receipt_id: "КЧКМ-000001"</p></th>
<th><p><strong>CRM маршрутизация:</strong></p>
<p>UF_DELIVERY_TYPE="pickup"</p>
<p>UF_CLIENT_TYPE="physical"</p>
<p>→ order_completed флоу:</p>
<p>CRM вызывает /close_order</p>
<p>(IC-LM-05)</p></th>
<th><p><strong>🔴 БЛОКЕР:</strong></p>
<p>Обработчик check_printed сработал</p>
<p>CRM вызвал /close_order</p>
<p><strong>🟠 ВАЖНО:</strong></p>
<p>Таймер 72ч сброшен</p></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

## **S1-06 — CRM вызывает /close_order → 1С создаёт Чек ККМ**

<table>
<colgroup>
<col style="width: 6%" />
<col style="width: 11%" />
<col style="width: 10%" />
<col style="width: 23%" />
<col style="width: 25%" />
<col style="width: 22%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Актор</strong></th>
<th><strong>Действие</strong></th>
<th><strong>API / Событие</strong></th>
<th><strong>Ключевые поля payload</strong></th>
<th><strong>Ожидаемый результат</strong></th>
<th><strong>Проверка приёмки ✓</strong></th>
</tr>
<tr class="odd">
<th>CRM → 1С</th>
<th>Вызов /close_order в рамках обработки check_printed (IC-LM-05)</th>
<th>POST /close_order</th>
<th><p><strong>Payload CRM → 1С:</strong></p>
<p>{</p>
<p>"purchase_order_guid":</p>
<p>"PO-GUID-001"</p>
<p>}</p></th>
<th><p><strong>1С ответ:</strong></p>
<p>{ "status": "ok",</p>
<p>"closing_doc_guid":</p>
<p>"CD-GUID-001",</p>
<p>"closing_doc_number":</p>
<p>"КЧКМ-000001",</p>
<p>"closing_doc_type": "check",</p>
<p>"idempotent": false }</p>
<p><strong>CRM сохраняет:</strong></p>
<p>UF_CLOSING_DOC_GUID = CD-GUID-001</p>
<p>UF_CLOSING_DOC_NUMBER = КЧКМ-000001</p>
<p>UF_CLOSING_DOC_TYPE = check</p>
<p>Сделка → «Успешно реализовано»</p></th>
<th><p><strong>🔴 БЛОКЕР:</strong></p>
<p>Все три UF_CLOSING_DOC_* заполнены</p>
<p>UF_CLOSING_DOC_TYPE = "check" (не "realization")</p>
<p>Статус = «Успешно реализовано»</p>
<p><strong>🟡 ПРОВЕРИТЬ:</strong></p>
<p>Идемпотентность: повторный /close_order с тем же GUID → idempotent:true, без дублирования</p></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

## **S1-07 — WA-накладная клиенту (Эпик 23)**

| **Триггер (LastMile TZ v1.1, Эпик 23):** Сделка → «Успешно реализовано» → CRM-робот → WA HSM-шаблон order_completed_invoice через Wazzup. |
|-------------------------------------------------------------------------------------------------------------------------------------------|

<table>
<colgroup>
<col style="width: 8%" />
<col style="width: 15%" />
<col style="width: 22%" />
<col style="width: 21%" />
<col style="width: 15%" />
<col style="width: 16%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Актор</strong></th>
<th><strong>Действие</strong></th>
<th><strong>API / Событие</strong></th>
<th><strong>Ключевые поля payload</strong></th>
<th><strong>Ожидаемый результат</strong></th>
<th><strong>Проверка приёмки ✓</strong></th>
</tr>
<tr class="odd">
<th>CRM-робот</th>
<th>Автоматически: сделка перешла в «Успешно реализовано» → отправить WA-накладную</th>
<th>Wazzup API (HSM order_completed_invoice)</th>
<th><p><strong>Переменные шаблона:</strong></p>
<p>UF_1C_ORDER_NUMBER = "ЗКЧ-000001"</p>
<p>Состав: 1 × TEST-GUID-001</p>
<p>= 1500 сом</p>
<p>OPPORTUNITY = 1500.00 сом</p></th>
<th><p><strong>WA содержит:</strong></p>
<p>Заказ №ЗКЧ-000001 доставлен!</p>
<p>• Товар × 1 = 1500 сом</p>
<p>Итого: 1500.00 сом</p>
<p>Спасибо, что выбрали Дом Прораба!</p>
<p><strong>Fallback:</strong></p>
<p>SMS через 60 сек при недоставке WA</p></th>
<th><p><strong>🔴 БЛОКЕР:</strong></p>
<p>WA/SMS зафиксирован в логе Wazzup</p>
<p>В тексте: номер ЗКЧ-000001 (не CRM_Deal_ID)</p>
<p>Итого = OPPORTUNITY (1500 сом)</p>
<p>Состав = финальный состав сделки</p></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

| **✅ СЦЕНАРИЙ 1 ЗАВЕРШЁН:** Все 7 шагов пройдены. Сделка в «Успешно реализовано». 1С создал Чек ККМ (КЧКМ-000001). WA-накладная отправлена с номером ЗКЧ-000001 и суммой 1500 сом. ID closing_doc сохранён в сделке (потребуется в Сценарии 2). |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

# **СЦЕНАРИЙ 2 — Физлицо, самовывоз, наличный возврат → NPS**

| **Пред-условие**    | Сценарий 1 пройден полностью. Сделка в «Успешно реализовано». UF_CLOSING_DOC_GUID = CD-GUID-001.    |
|---------------------|-----------------------------------------------------------------------------------------------------|
| **Scope**           | Создание возврата → складская приёмка → /create_return → наличная выплата → /create_rko → NPS       |
| **Участники**       | CRM → 1С (sandbox) → WA (Wazzup/заглушка)                                                           |
| **TZ-источники**    | LastMile TZ v1.1 Эпики 26–29                                                                        |
| **Ожидаемый исход** | Смарт-процесс «Возвраты» в «Успешно закрыт». 1С создал Возврат товаров и РКО. NPS-запрос отправлен. |
| **Блокеры провала** | Любой шаг 🔴 → стоп, дефект, перезапуск с S2-01                                                     |

## **S2-01 — Создание смарт-процесса «Возвраты»**

<table>
<colgroup>
<col style="width: 9%" />
<col style="width: 16%" />
<col style="width: 10%" />
<col style="width: 18%" />
<col style="width: 22%" />
<col style="width: 22%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Актор</strong></th>
<th><strong>Действие</strong></th>
<th><strong>API / Событие</strong></th>
<th><strong>Ключевые поля payload</strong></th>
<th><strong>Ожидаемый результат</strong></th>
<th><strong>Проверка приёмки ✓</strong></th>
</tr>
<tr class="odd">
<th>Менеджер (CRM)</th>
<th>Открыть карточку сделки → нажать «Создать возврат». Заполнить UF_RETURN_ITEMS: GUID=TEST-GUID-001, qty=1. Прикрепить тестовое фото.</th>
<th>crm.item.add (Смарт-процесс «Возвраты»)</th>
<th><p><strong>Автозаполнение CRM:</strong></p>
<p>UF_LINKED_DEAL_ID = {deal_id}</p>
<p>UF_CLOSING_DOC_GUID = "CD-GUID-001"</p>
<p>(скопировано из сделки IC-RT-01)</p>
<p><strong>Ручной ввод:</strong></p>
<p>UF_RETURN_ITEMS = [{</p>
<p>guid: "TEST-GUID-001",</p>
<p>qty: 1 }]</p></th>
<th><p><strong>CRM авторасчёт (LM-P7):</strong></p>
<p>UF_REFUND_AMOUNT =</p>
<p>1 × 1500 (цена из сделки) = 1500.00</p>
<p><strong>Смарт-процесс:</strong></p>
<p>return_id = {auto_id}</p>
<p>Статус: «Новый»</p>
<p>UF_CLOSING_DOC_GUID заполнен</p></th>
<th><p><strong>🔴 БЛОКЕР:</strong></p>
<p>Смарт-процесс создан отдельной сущностью</p>
<p>UF_CLOSING_DOC_GUID = CD-GUID-001 (скопировано автоматически)</p>
<p>UF_REFUND_AMOUNT = 1500.00 (формула из сделки, не каталог)</p>
<p><strong>🟠 ВАЖНО:</strong></p>
<p>Проверить: смарт-процесс НЕ вложен в сделку и НЕ является «Рекламацией» [CON-18]</p></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

## **S2-02 — Менеджер переводит в «В обработке», верификация**

<table>
<colgroup>
<col style="width: 12%" />
<col style="width: 16%" />
<col style="width: 16%" />
<col style="width: 16%" />
<col style="width: 20%" />
<col style="width: 17%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Актор</strong></th>
<th><strong>Действие</strong></th>
<th><strong>API / Событие</strong></th>
<th><strong>Ключевые поля payload</strong></th>
<th><strong>Ожидаемый результат</strong></th>
<th><strong>Проверка приёмки ✓</strong></th>
</tr>
<tr class="odd">
<th>Менеджер (CRM)</th>
<th>Перевести смарт-процесс в статус «В обработке». Убедиться что фото прикреплено.</th>
<th>CRM (ручной переход статуса)</th>
<th>Нет вызовов к 1С.</th>
<th><p><strong>Смарт-процесс:</strong></p>
<p>Статус: «В обработке»</p>
<p>Фото прикреплено к карточке</p></th>
<th><p><strong>🟡 ПРОВЕРИТЬ:</strong></p>
<p>Кнопка «Принято складом» НЕ активна пока COMMIT-25 не снят (если не снят в staging — ожидаемо)</p>
<p><strong>🟠 ВАЖНО:</strong></p>
<p>Если COMMIT-25 снят: кнопка активна — переходить к S2-03</p></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

## **S2-03 — «Принято складом» → /create_return**

| **Пред-условие шага:** COMMIT-25 снят (подтверждение метода оценки запасов от List.kg получено). Иначе — шаг пропустить, зафиксировать как ожидаемый гэп. |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------|

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 11%" />
<col style="width: 13%" />
<col style="width: 24%" />
<col style="width: 21%" />
<col style="width: 18%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Актор</strong></th>
<th><strong>Действие</strong></th>
<th><strong>API / Событие</strong></th>
<th><strong>Ключевые поля payload</strong></th>
<th><strong>Ожидаемый результат</strong></th>
<th><strong>Проверка приёмки ✓</strong></th>
</tr>
<tr class="odd">
<th>Менеджер (CRM)</th>
<th>Перевести смарт-процесс в «Принято складом» (кнопка доступна только после COMMIT-25)</th>
<th>POST /create_return (IC-RT-02)</th>
<th><p><strong>Payload CRM → 1С:</strong></p>
<p>{</p>
<p>"return_id": "{return_id}",</p>
<p>"closing_doc_guid": "CD-GUID-001",</p>
<p>"items": [{</p>
<p>"guid": "TEST-GUID-001",</p>
<p>"qty": 1</p>
<p>}]</p>
<p>}</p></th>
<th><p><strong>1С ответ:</strong></p>
<p>{ "status": "ok",</p>
<p>"return_doc_id":</p>
<p>"RD-GUID-001" }</p>
<p><strong>CRM сохраняет:</strong></p>
<p>return_doc_id = RD-GUID-001</p>
<p>Смарт-процесс → «Ожидает финансового возврата»</p></th>
<th><p><strong>🔴 БЛОКЕР:</strong></p>
<p>return_doc_id сохранён в карточке (LM-P6)</p>
<p>Статус = «Ожидает финансового возврата»</p>
<p><strong>🟡 ПРОВЕРИТЬ:</strong></p>
<p>Идемпотентность: повторный /create_return с тем же return_id → idempotent:true, без второго документа в 1С</p></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

## **S2-04 — «Выплачено наличными» → /create_rko**

<table>
<colgroup>
<col style="width: 11%" />
<col style="width: 13%" />
<col style="width: 11%" />
<col style="width: 25%" />
<col style="width: 14%" />
<col style="width: 24%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Актор</strong></th>
<th><strong>Действие</strong></th>
<th><strong>API / Событие</strong></th>
<th><strong>Ключевые поля payload</strong></th>
<th><strong>Ожидаемый результат</strong></th>
<th><strong>Проверка приёмки ✓</strong></th>
</tr>
<tr class="odd">
<th>Менеджер (CRM)</th>
<th>Нажать кнопку «Выплачено наличными» (активна только после «Ожидает финансового возврата»)</th>
<th>POST /create_rko (IC-RT-03)</th>
<th><p><strong>Payload CRM → 1С:</strong></p>
<p>{</p>
<p>"return_id": "{return_id}",</p>
<p>"amount": 1500.00,</p>
<p>"closing_doc_guid": "CD-GUID-001"</p>
<p>}</p>
<p>amount = UF_REFUND_AMOUNT из карточки смарт-процесса (LM-P7)</p></th>
<th><p><strong>1С ответ:</strong></p>
<p>HTTP 200, { "status": "ok" }</p>
<p><strong>CRM:</strong></p>
<p>Смарт-процесс → «Успешно закрыт»</p>
<p>Таймер NPS: +4 часа</p></th>
<th><p><strong>🔴 БЛОКЕР:</strong></p>
<p>amount в payload = UF_REFUND_AMOUNT = 1500.00 (не хардкод)</p>
<p>Статус = «Успешно закрыт»</p>
<p><strong>🟡 ПРОВЕРИТЬ:</strong></p>
<p>Кнопка «Выплачено наличными» была заблокирована пока статус ≠ «Ожидает финансового возврата»</p>
<p>Идемпотентность: повторное нажатие → idempotent:true</p></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

## **S2-05 — NPS-запрос через Wazzup (Эпик 29)**

| **Тайминг:** В staging-среде таймер 4 часа симулируется принудительным запуском CRM-робота или ожиданием (на усмотрение тестировщика). |
|----------------------------------------------------------------------------------------------------------------------------------------|

<table>
<colgroup>
<col style="width: 9%" />
<col style="width: 16%" />
<col style="width: 20%" />
<col style="width: 14%" />
<col style="width: 19%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Актор</strong></th>
<th><strong>Действие</strong></th>
<th><strong>API / Событие</strong></th>
<th><strong>Ключевые поля payload</strong></th>
<th><strong>Ожидаемый результат</strong></th>
<th><strong>Проверка приёмки ✓</strong></th>
</tr>
<tr class="odd">
<th>CRM-робот + Wazzup</th>
<th>Автоматически через 4ч после «Успешно закрыт» — отправить NPS WA</th>
<th>Wazzup API (HSM return_nps_request)</th>
<th><p><strong>Отправка WA:</strong></p>
<p>«Как всё прошло? Оцените сервис возврата от 1 до 5 (ответьте цифрой)»</p>
<p><strong>Симуляция ответа:</strong></p>
<p>Tester отвечает «5» в WA тестового клиента</p></th>
<th><p><strong>CRM:</strong></p>
<p>Wazzup матчит ответ «5» по телефону +996700000001</p>
<p>UF_NPS_SCORE = 5 (в карточке смарт-процесса)</p>
<p>CRM отправляет WA: «Спасибо! Рады что смогли помочь»</p></th>
<th><p><strong>🔴 БЛОКЕР:</strong></p>
<p>NPS-запрос зафиксирован в логе Wazzup</p>
<p>UF_NPS_SCORE = 5 в карточке смарт-процесса</p>
<p><strong>🟡 ПРОВЕРИТЬ:</strong></p>
<p>Ответ «1» → задача менеджеру создана (проверить отдельно)</p>
<p>Нет ответа 48ч → NPS = null, без изменений статуса</p></th>
</tr>
</thead>
<tbody>
</tbody>
</table>

| **✅ СЦЕНАРИЙ 2 ЗАВЕРШЁН:** Все 5 шагов пройдены. Смарт-процесс «Возвраты» в «Успешно закрыт». 1С создал документы «Возврат товаров» (RD-GUID-001) и РКО на 1500 сом. NPS = 5, благодарственный WA отправлен. |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

# **CROSS-CHECKS — Проверки поверх сценариев**

**Следующие проверки выполняются после прохождения обоих сценариев как отдельный прогон.**

## **CC-01 — Идемпотентность вебхуков 1С**

| **ID**  | **Действие**                                                           | **Ожидаемый результат**                                                                                              |
|---------|------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| CC-01.1 | Повторно отправить вебхук order_confirmed с тем же CRM_Deal_ID и event | HTTP 200. Статус сделки не изменился. Новая запись в b_dom_processed_1c_events НЕ создана (UNIQUE KEY).              |
| CC-01.2 | Повторно отправить check_printed с тем же CRM_Deal_ID                  | HTTP 200. /close_order не вызван повторно. Дублирующего Чека ККМ в 1С нет.                                           |
| CC-01.3 | Вызвать /create_return дважды с одинаковым return_id                   | Второй вызов: idempotent:true. Смарт-процесс остаётся в «Ожидает финансового возврата». В 1С один документ возврата. |

## **CC-02 — Именование полей: CRM ↔ 1С**

| **Назначение:** Самый частый класс интеграционных багов — поле сохранено в CRM под правильным именем, но в payload к 1С передаётся под старым именем. Проверить SQL-запросом или через дебаг-лог. |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

| **Поле в CRM-сделке**  | **Имя в payload к 1С**                           | **Проверка**                                                 |
|------------------------|--------------------------------------------------|--------------------------------------------------------------|
| UF_SOURCE_STORE_ID     | store_id (в /create_order)                       | Убедиться: НЕ UF_STORE_ID, НЕ SOURCE_STORE_ID                |
| OPPORTUNITY            | declared_value (в claims/create)                 | Убедиться: НЕ UF_NEW_ORDER_TOTAL, НЕ new_order_total         |
| UF_PURCHASE_ORDER_GUID | purchase_order_guid (в /close_order)             | Убедиться: GUID, не номер заказа                             |
| UF_CLOSING_DOC_GUID    | closing_doc_guid (в /create_return, /create_rko) | Убедиться: поле скопировано из сделки, не введено вручную    |
| UF_REFUND_AMOUNT       | amount (в /create_rko)                           | Убедиться: значение из формулы (×цена из сделки), не хардкод |

## **CC-03 — Мониторинг: проверка INF-MON-01 v1.1**

| **ID**  | **Симуляция**                                                                            | **Ожидаемый алерт**                                            |
|---------|------------------------------------------------------------------------------------------|----------------------------------------------------------------|
| CC-03.1 | Остановить Fast Track handler на 20 мин (имитировать недоступность 1С-сервиса)           | MON-01: Telegram + email ≤ 15 мин после остановки              |
| CC-03.2 | Добавить запись в b_dom_processed_1c_events со status='dlq' + received_at = 40 мин назад | MON-02: CRM-задача менеджеру создана ≤ 10 мин                  |
| CC-03.3 | Перевести сделку в «Уточнение состава» и не трогать 25 ч                                 | MON-06: CRM-задача менеджеру создана (оба OOS-статуса покрыты) |

# **ACCEPTANCE SIGN-OFF**

| **Условие успешной приёмки:** Все шаги с пометкой 🔴 БЛОКЕР пройдены без дефектов. Cross-checks CC-01..CC-03 пройдены. Таблица Sign-Off подписана обеими сторонами. |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|

| **Критерий**                    | **Статус**             | **Примечание** |
|---------------------------------|------------------------|----------------|
| S1 (7 шагов) — все 🔴 пройдены  | ☐ Пройден / ☐ Провален |                |
| S2 (5 шагов) — все 🔴 пройдены  | ☐ Пройден / ☐ Провален |                |
| CC-01 Идемпотентность (3 кейса) | ☐ Пройден / ☐ Провален |                |
| CC-02 Именование полей (5 пар)  | ☐ Пройден / ☐ Провален |                |
| CC-03 MON-01, MON-02, MON-06    | ☐ Пройден / ☐ Провален |                |

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th><p><strong>Bitrix-подрядчик</strong></p>
<p>Подпись: ____________________________</p>
<p>Дата: ________________________________</p></th>
<th><p><strong>Дом Прораба (заказчик)</strong></p>
<p>Подпись: ____________________________</p>
<p>Дата: ________________________________</p></th>
</tr>
</thead>
<tbody>
</tbody>
</table>
