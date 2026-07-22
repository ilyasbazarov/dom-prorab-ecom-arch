# STATE

**Версия:** v0.3 · **updated:** 2026-07-22 · Applier (сессия arch_phase1_seed)

## Текущий фокус
Architect — (1) формат клиентского номера заказа (ADR-010:60, назначено Architect); (2) Canonical Order Flow (Фаза 4) — разблокирован (Business-входы получены); Track B (5 задач) — по-прежнему отложен (решение Owner).

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
| Track B волна 1 (P-01,02,03,05,06,19) | ACTIVE → P-02 деэскалирован (CONFIRMED-DOC), P-19 эскалирован в Business (OQ-01). Architect-решение по 2 ESCALATE (P-02,P-19) → DONE. Ждёт: (а) Applier-коммит REGISTER_PATCHES + verify GREEN [этот коммит], (б) Business-решение OQ-01 → DONE (ADR-010 [BUSINESS] accepted; ADR-009 [ARCH] активирован), (в) Owner-решение о формировании 5 контрактных задач Track B — отложено |

## Ключевые якоря
- Канонический снапшот корпуса D1–D6: определяется хэшами в l3-external/MANIFEST.md (26 md-фрагментов); для цитат используется SHA текущей сессии
- Метод-базис: holika `_METHOD` v1.0 @ `ec7e6cc` (адаптирован, см. ADR-007)

## Открытые вопросы
- [Business] OQ-02 — платёжная механика предоплаты (pre-auth vs charge), API-refund и SLA-цифра возврата; DEFER до документации Бакай Банка (CON-11), контрольная точка 2026-08-05.

## Блокеры
- нет
