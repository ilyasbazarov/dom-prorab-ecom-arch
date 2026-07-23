# STATE

**Версия:** v0.5 · **updated:** 2026-07-23 · Architect (сессия arch_review_outbound_contour, дельта 3)

## Текущий фокус
(Owner) применить rev3 тикета BITRIX-B1-06 → отправить 1С-пакет и Bitrix-пакет; апрув ADR-015, ADR-016, К-13, К-14; далее F5-01, F5-02, F4-01.

## Статус фаз
| Фаза/трек | Статус |
|---|---|
| 0. Архитектура процесса (ADR-001…006) | DONE |
| PREP. Операционная модель: роли, протокол, промты, verify (ADR-007) | DONE |
| 1. Knowledge Repository (состав L0) | DONE — ADR-011 [ARCH]; seed l0-canon/invariants.md, l0-canon/domain_model.md, l2-registers/decisions_xref.md |
| 2–3. Роли и pipeline | FOLDED в PREP |
| 4. Business Canon + Canonical Order Flow | Canonical Order Flow — ADOPTED (ADR-013, l0-canon/canonical_order_flow.md); Business Canon — pending Business; вход готовит бриф F4-01 |
| 5. Анализ корпуса D1–D6 | ACTIVE (волны F5-01…F5-04; брифы F5-01, F5-02 выданы) |
| 6. Исправления ТЗ | — |
| 7. Diff → задачи подрядчикам | — |
| Track B волна 1 (P-01,02,03,05,06,19) | DONE — тикеты финализированы (P-02 vB — 0 кода 1С; P-03/P-05 contract-first, параллельная реализация; graceful degradation снимает жёсткий порядок деплоя). Отправка: 1С — готов; Bitrix — HOLD до rev3 (AC BITRIX-B1-06 противоречит канону §4 T2). |

## Ключевые якоря
- Канонический снапшот корпуса D1–D6: определяется хэшами в l3-external/MANIFEST.md (26 md-фрагментов); для цитат используется SHA текущей сессии
- Метод-базис: holika `_METHOD` v1.0 @ `ec7e6cc` (адаптирован, см. ADR-007)

## Открытые вопросы
- [Business] OQ-02 — платёжная механика предоплаты (pre-auth vs charge), API-refund и SLA-цифра возврата; DEFER до документации Бакай Банка (CON-11), контрольная точка 2026-08-05.
- [Architect/Owner] OQ-03 — целевой рефактор исходящего потока событий 1С→CRM (транзакционная очередь исходящих, P-16); снимает порядок доставки (P-03/P-05), эхо (P-02), гарантию доставки; defer post-MVP.
- [Architect] OQ-04 — инвентарь событий 1С→CRM: канон §4 T2 подтверждён прямым чтением (`d5_t01@8ed653a4:1449-1456`, 4 события включая `order_partial`); открыт остаток — где в контракте `oos_at_picking`/`check_printed` (см. l2-registers/open_questions.md).

## Блокеры
- нет
