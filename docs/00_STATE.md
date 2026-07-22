# STATE

**Версия:** v0.3 · **updated:** 2026-07-22 · Applier (сессия arch_phase1_skeleton, ADR-011 accepted)

## Текущий фокус
ADR-011 [ARCH] accepted → seed l0-canon/invariants.md, l0-canon/domain_model.md и каркас l2-registers/decisions_xref.md (Architect, следующий apply). Формирование 5 контрактных задач Track B — отложено (решение Owner).

## Статус фаз
| Фаза/трек | Статус |
|---|---|
| 0. Архитектура процесса (ADR-001…006) | DONE |
| PREP. Операционная модель: роли, протокол, промты, verify (ADR-007) | DONE |
| 1. Knowledge Repository (состав L0) | NEXT — ADR-011 [ARCH] accepted (структура L0-канона); seed l0-canon/{invariants,domain_model}.md — следующий apply |
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
- [Фаза 1] Судьба DEC/COM/CON → решено (ADR-011 accepted: наши проектные решения, embedded L3; L2 decisions_xref с диспозицией RATIFIED/SUPERSEDED/NEUTRAL/OPEN).
- [Фаза 1] Состав L0-доков → решено (ADR-011 accepted); seed l0-canon/{invariants,domain_model}.md — следующий шаг Architect.
- [Business] OQ-02 — платёжная механика предоплаты (pre-auth vs charge), API-refund и SLA-цифра возврата; DEFER до документации Бакай Банка (CON-11), контрольная точка 2026-08-05.

## Блокеры
- нет
