# STATE

**Версия:** v0.8 · **updated:** 2026-07-28 · Architect (сессия arch_wave1_pack_and_method)

## Текущий фокус
Собрать пакет волны 1 — применить этот блок, затем F4-02 rev3 на Executor, затем Reviewer-сессия (Fable) перед отправкой, затем отправка с фиксацией даты и переводом CQ-01…CQ-04 в SENT. Параллельно: F4-03 (verify.sh) и F4-01 rev2 → Business-сессия по business_canon. Далее F5-01, F5-02, волна 2 Track B.

## Статус фаз
| Фаза/трек | Статус |
|---|---|
| 0. Архитектура процесса (ADR-001…006) | DONE |
| PREP. Операционная модель: роли, протокол, промты, verify (ADR-007) | DONE |
| 1. Knowledge Repository (состав L0) | DONE — ADR-011 [ARCH]; seed l0-canon/invariants.md, l0-canon/domain_model.md, l2-registers/decisions_xref.md |
| 2–3. Роли и pipeline | FOLDED в PREP |
| 4. Business Canon + Canonical Order Flow | Canonical Order Flow — ADOPTED (ADR-013, l0-canon/canonical_order_flow.md); Business Canon — pending Business; вход готовит бриф F4-01; добавлена роль Reviewer (ADR-024), артефакт prompts/reviewer.md |
| 5. Анализ корпуса D1–D6 | ACTIVE (волны F5-01…F5-04; брифы F5-01, F5-02 выданы) |
| 6. Исправления ТЗ | — |
| 7. Diff → задачи подрядчикам | — |
| Track B волна 1 (P-01,02,03,05,06,19) | В РАБОТЕ — пять тикетов готовы (`tasks/trackB_wave1_bitrix.md:11,41,90`, `tasks/trackB_wave1_1c.md:22,58`); rev4 BITRIX-B1-06 (узкий AC) и rev2 BITRIX-B1-03 (`event_id` не существует → ключ `CRM_Deal_ID + event`, ADR-015) применены. Шестой тикет — P-19, готовится по брифу F4-02 rev3: эскалация Executor'а закрыта ADR-019 (алгоритм контрольной цифры; пример `…-8` невалиден) и ADR-020 (закрытый перечень 11 позиций перепривязки), HOLD по этим пунктам снят. Отправка: оба пакета синхронно, одним куском (решение Owner 2026-07-26); 1С-пакет готов и ждёт. Отправки не было, дата не зафиксирована (подтверждено Owner 2026-07-28). |

## Ключевые якоря
- Канонический снапшот корпуса D1–D6: определяется хэшами в l3-external/MANIFEST.md (26 md-фрагментов); для цитат используется SHA текущей сессии
- Метод-базис: holika `_METHOD` v1.0 @ `ec7e6cc` (адаптирован, см. ADR-007)

## Открытые вопросы
- [Business] OQ-02 — платёжная механика предоплаты (pre-auth vs charge), API-refund и SLA-цифра возврата; DEFER до документации Бакай Банка (CON-11), контрольная точка 2026-08-05.
- [Architect/Owner] OQ-03 — целевой рефактор исходящего потока событий 1С→CRM (транзакционная очередь исходящих, P-16); снимает порядок доставки (P-03/P-05), эхо (P-02), гарантию доставки; defer post-MVP.
- [Architect] OQ-04 — RESOLVED (ADR-017): контур 1С→CRM = три канала со своими URL (статус-маппинг; `oos_at_picking` IC-PR-03; `check_printed` IC-CK-05). Состав статус-канала: три подтверждённых события + `order_partial` условное до ответа CQ-02.
- [Business] BQ-01…BQ-07 — RESOLVED (ADR-021), сессия 2026-07-27; детали — l2-registers/open_questions.md.
- [Owner] Дата отправки пакетов подрядчикам не зафиксирована (сессия 2026-07-26); фиксируется при отправке.

## Блокеры
- нет
