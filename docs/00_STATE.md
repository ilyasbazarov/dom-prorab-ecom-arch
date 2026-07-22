# STATE

**Версия:** v0.3 · **updated:** 2026-07-22 · Architect (сессия arch_trackB_wave1_tasks_rev2)

## Текущий фокус
(Owner) коммит + отправка задач; (Architect) формат клиентского номера (ADR-010:60) / Canonical Order Flow (Фаза 4).

## Статус фаз
| Фаза/трек | Статус |
|---|---|
| 0. Архитектура процесса (ADR-001…006) | DONE |
| PREP. Операционная модель: роли, протокол, промты, verify (ADR-007) | DONE |
| 1. Knowledge Repository (состав L0) | DONE — ADR-011 [ARCH]; seed l0-canon/invariants.md, l0-canon/domain_model.md, l2-registers/decisions_xref.md |
| 2–3. Роли и pipeline | FOLDED в PREP |
| 4. Business Canon + Canonical Order Flow | — |
| 5. Анализ корпуса D1–D6 | — |
| 6. Исправления ТЗ | — |
| 7. Diff → задачи подрядчикам | — |
| Track B волна 1 (P-01,02,03,05,06,19) | ACTIVE → тикеты финализированы (P-02 vB — 0 кода 1С; P-03/P-05 contract-first, параллельная реализация; graceful degradation снимает жёсткий порядок деплоя). Отправка — Owner. |

## Ключевые якоря
- Канонический снапшот корпуса D1–D6: определяется хэшами в l3-external/MANIFEST.md (26 md-фрагментов); для цитат используется SHA текущей сессии
- Метод-базис: holika `_METHOD` v1.0 @ `ec7e6cc` (адаптирован, см. ADR-007)

## Открытые вопросы
- [Business] OQ-02 — платёжная механика предоплаты (pre-auth vs charge), API-refund и SLA-цифра возврата; DEFER до документации Бакай Банка (CON-11), контрольная точка 2026-08-05.
- [Architect/Owner] OQ-03 — целевой рефактор исходящего потока событий 1С→CRM (транзакционная очередь исходящих, P-16); снимает порядок доставки (P-03/P-05), эхо (P-02), гарантию доставки; defer post-MVP.

## Блокеры
- нет
