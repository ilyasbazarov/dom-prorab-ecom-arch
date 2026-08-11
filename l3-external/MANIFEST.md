# L3 MANIFEST — корпус документации

**Снапшот:** 2026-07-17 (docx-экспорт из Google Docs, закоммичен в l3-external/raw/)
**Конвертация:** pandoc docx→gfm, разрез по вкладкам (маркер = plain-параграф с названием вкладки, вставляемый Google при экспорте). Все 78 img-ссылок в исходниках — глифы чекбоксов, контентные изображения отсутствуют.
**Единица цитирования:** md-фрагмент (файл вкладки) + номера строк. Docx — оригинал для арбитража.

## Документы

| ID | Документ | Google Doc ID | Raw-файл | Вкладок |
|---|---|---|---|---|
| D1 | Интеграционные контракты: 1С + Bitrix24, CMS | 1LzsGmYVfcgKDUDn0l3fcLU--I2oIfUs4ktAkJztSGIQ | raw/d1_*.docx | 4 |
| D2 | Дата-контракт: Битрикс Каталог (BI→CMS) | 1JHEsAJwr2fGeAvadPbEwyhInPHjaHvyueGX73fe-2kE | raw/d2_*.docx | 1 |
| D3 | Контракты на выгрузку данных из 1С | 1PBsU-2WTMGJvJcJtBoPpaNYkNDz2wtAE2fLdubnYIGQ | raw/d3_*.docx | 2 |
| D4 | Доработки в Битрикс (CRM + CMS) | 1TI5nh6IXl6RsIAb69Y-gnbf6jzD2yB3wclectTvBuwc | raw/d4_*.docx | 7 |
| D5 | Доработки в 1С | 1MXnpaZuMdbna6jc2nSwhFkmqWCkubP2nnu-HHh-pk8E | raw/d5_*.docx | 6 |
| D6 | Оформление заказа (User Story Map) | 1KOxOJ1y8v977bT9Sm_iQ2DjgO9S6ZvH3FAge5aaTKS4 | raw/d6_*.docx | 6 |
| D7 | Эквайринг: API-документация процессинга (Alatau City Bank, эквайер — Оптима Банк) | — | raw/AlatauCityBank_ecom.pdf | — |

D7 — отдельный провенанс. Снапшот 2026-08-02Z, источник — PDF от банка, не Google Docs,
поэтому схема конвертации D1–D6 (pandoc docx→gfm, разрез по вкладкам) к нему не применяется.
Внесён Owner коммитом d796340b. Файл raw/AlatauCityBank_ecom.pdf: 1 291 613 байт,
sha256 первые 16 91e4b56fccac0cba, 27 страниц, генератор Microsoft Word 2019 (текстовый
слой присутствует). Задача F4-05 исполнена 2026-08-03: md-фрагмент, отчёт извлечения и строка в таблице
«Фрагменты» на месте. Единица цитирования D7 — `md/d7_t01_acquiring_api.md` плюс номера
строк; ссылка на PDF доказательством по-прежнему не является (К-1). Одиннадцать страниц
(1, 3-10, 19, 20) при извлечении дали мало текста и были выписаны кандидатами на второй
проход; перечень закрыт без прохода решением ADR-069 §3, основание — содержание страниц
(интерфейс личного кабинета банка и иллюстрации). Понадобится их содержимое — заводится
отдельной задачей, второй проход даёт файл с пометкой «не машинная выгрузка» и цитируется
отдельно от D7 (ADR-063 §4).

## Фрагменты

| Файл | Документ | Вкладка | Строк | sha256 |
|---|---|---|---|---|
| md/d1_t01_discovery_selection.md | D1 | Discovery & Selection | 81 | `2b91e32543cc79ef` |
| md/d1_t02_cross_sell_bundle_korzina_i_chekaut.md | D1 | Cross-sell & Bundle + Корзина и Чекаут | 505 | `7386e756a057596c` |
| md/d1_t03_podtverzhdenie_i_ozhidanie_processing.md | D1 | Подтверждение и Ожидание (Processing) | 379 | `da0fcc5f2f8bb5e6` |
| md/d1_t04_poslednyaya_milya_vozvraty_reklamatsii.md | D1 | Последняя миля / Возвраты / Рекламации | 579 | `fbafb1b1d39f978b` |
| md/d2_t01_bitrix_catalog_csv.md | D2 | bitrix_catalog.csv | 176 | `aaa4e303600f2eb4` |
| md/d3_t01_slow_track.md | D3 | Slow Track | 168 | `9be14716cb80f92a` |
| md/d3_t02_fast_track.md | D3 | Fast Track | 98 | `1f094798b81fa4e7` |
| md/d4_t01_vitrina_i_sinhronizatsiya_dannyh.md | D4 | Витрина и синхронизация данных | 676 | `9e3479b79585b2f0` |
| md/d4_t02_cross_sell_bundle_korzina_i_chekaut.md | D4 | Cross-sell & Bundle + Корзина и Чекаут | 858 | `f44100221c1cea32` |
| md/d4_t03_podtverzhdenie_i_ozhidanie_processing.md | D4 | Подтверждение и Ожидание (Processing) | 612 | `137c6e77813dbdc0` |
| md/d4_t04_poslednyaya_milya_vozvraty_reklamatsii.md | D4 | Последняя миля + Возвраты + Рекламации | 895 | `f5d62af6b1ba0b64` |
| md/d4_t05_sloy_nablyudaemosti_za_infrastrukturoy.md | D4 | Слой наблюдаемости за инфраструктурой | 419 | `3e5afd723ab1d864` |
| md/d4_t06_e2e_acceptance_test_plan.md | D4 | E2E Acceptance Test Plan | 1065 | `da4fa2260e5cf515` |
| md/d4_t07_reestr_wa_hsm_shablonov.md | D4 | Реестр WA HSM-шаблонов | 621 | `8e14d532fa116cfa` |
| md/d5_t01_discovery_selection_vitrina_i_sinhronizatsiya.md | D5 | Discovery & Selection — Витрина и синхронизация | 1754 | `0ccccfb21c5f37e8` |
| md/d5_t02_korzina_i_chekaut.md | D5 | Корзина и Чекаут | 659 | `7111df0d392c3959` |
| md/d5_t03_podtverzhdenie_i_ozhidanie_processing.md | D5 | Подтверждение и Ожидание (Processing) | 577 | `dcb4a99843433c0e` |
| md/d5_t04_poslednyaya_milya_vozvraty_i_brak.md | D5 | Последняя миля, возвраты и брак | 1033 | `a7ff68d9f56310bd` |
| md/d5_t05_reestr_resheniy_ogranicheniy_i_identifikatorov.md | D5 | Реестр решений, ограничений и идентификаторов | 82 | `d5f7cea623c3286a` |
| md/d5_t06_reestr_konfiguratsionnyh_izmeneniy.md | D5 | Реестр конфигурационных изменений | 457 | `a85d0bed2de7b212` |
| md/d6_t01_discovery_selection.md | D6 | Discovery & Selection | 274 | `8e66b776dc2a4625` |
| md/d6_t02_cross_sell_bundle_komplektatsiya.md | D6 | Cross-sell & Bundle (Комплектация) | 164 | `3c4d3d475b431fc0` |
| md/d6_t03_korzina_i_chekaut_checkout.md | D6 | Корзина и Чекаут (Checkout) | 216 | `f749cea647ac121f` |
| md/d6_t04_podtverzhdenie_i_ozhidanie_processing.md | D6 | Подтверждение и Ожидание (Processing) | 180 | `a67ba43a232cbbea` |
| md/d6_t05_poslednyaya_milya_last_mile.md | D6 | Последняя миля (Last Mile) | 128 | `3cb44e1377a44ed3` |
| md/d6_t06_vozvrat_izlishkov_i_reklamatsii.md | D6 | Возврат излишков и рекламации | 268 | `42d2a2f9813c1a87` |
| md/d7_t01_acquiring_api.md | D7 | —, PDF постранично | 1134 | `dc24c1acca220017` |
| md/d9_t01_bitrix_api_spec.md | D9 | —, JSON pretty-print | 3154 | `fe47b19aeb47a503` |

D8 — отдельный провенанс и отдельная природа. Файл `raw/1c_data_contract.yaml`: 29 186 байт,
sha256 первые 16 `e10009ada112c96f`, 864 строки, YAML. Внесён Owner коммитом `fd30f9a` 2026-08-11,
внесение санкционировано ADR-127 §1 задним числом (К-12).
ЭТО НЕ МАШИННЫЙ ЭКСПОРТ СВАГЕРА, а производный контракт обмена: корневых ключей `openapi:` либо
`swagger:` в файле нет, структура своя — `meta`, `auth`, `common`, `sync_modes`, `schemas`;
эндпоинтов 13. Действующий свагер живёт по пути `/api/v1/swagger/`, на который указывает сам файл
полем `meta.swagger_ui`. Отсюда ограничение цитирования: перечень эндпоинтов файла НЕ доказанно
полон относительно свагера, и вывод «эндпоинта нет» из него не делается (К-14, ADR-127 §3).
Происхождение (кто составил, из чего получен, соответствует ли действующему свагеру) НЕ
установлено — строка открытого вопроса в `docs/00_STATE.md` (ADR-127 §4). Схема конвертации
D1-D6 (pandoc docx→gfm, разрез по вкладкам) к нему не применяется: исходник не docx.
Предмет — API Битрикса, который вызывают 1С и BI, несмотря на имя файла, называющее 1С.

D9 — машинная спецификация и ИСТОЧНИК ИСТИНЫ по интерфейсу Битрикса. Файл
`raw/bitrix_swagger_2026-08-11.json`: 120 264 байта, sha256 первые 16 `a49c1fa8d6ccbeb7`,
3 129 строк по `wc -l` (последняя строка без перевода, всего 3 130), OpenAPI 3.0.3, `info.title` «1C Data Contract» версии 1.2.0. Путей 10, операций 12,
схем в `components.schemas` 44, серверов 1. Внесён Owner коммитом `f81a9b1` 2026-08-11 локально
с `ALLOW_RAW_CHANGE=1` (класс B, К-11, К-12); оформление — ADR-128.
Получен выгрузкой из авторизованного браузера Owner со страницы
`https://bitrix.dompro.kg/api/v1/swagger/`: спецификация закрыта авторизацией портала, `curl`
без входа отдаёт форму «Войти в Битрикс24», путей `swagger.json` и `swagger.yaml` не существует
(404). Схема конвертации D1-D6 (pandoc docx→gfm) к нему не применяется: исходник — JSON.
Отношение к D8: D9 старше по весу и заменяет его как источник, D8 остаётся производным входом
и снимком (К-33), из корпуса не изымается. Перечни путей обоих файлов сверены и совпали
полностью — 10 против 10, расхождений 0 в обе стороны; носитель сверки
`reference/2026-08-11_bitrix_swagger_vs_d8.md`. Сверка измеряла ТОЛЬКО перечни путей: на состав
полей, коды ответов и схемы её вывод не переносится (К-1). Спецификация описывает ЗАЯВЛЕННЫЙ
интерфейс; вердикт «реализовано» из неё не выводится — это вход F4-17, а не его замена.

