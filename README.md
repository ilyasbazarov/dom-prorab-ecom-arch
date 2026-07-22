# dom-prorab-ecom-arch

Инженерная операционная система проекта интеграции 1С ↔ Bitrix24 CRM ↔ CMS (Dom Prorab, E-com запуск). Знание живёт в этом репо, а не в чатах: свежий чат + промт роли + SHA = рабочая сессия.

## Уровни доверия артефактов
- **L0 Канон** (`l0-canon/`) — источники истины. Изменения только через ADR. Наполняется с Фазы 4.
- **L1 Решения** (`docs/02_ADR_LOG.md`) — append-only лог решений (теги: `[BUSINESS]` `[ARCH]` `[PROCESS]`).
- **L2 Регистры** (`l2-registers/`) — проблемы, вопросы подрядчикам, открытые вопросы, допущения.
- **L3 Внешние объекты** (`l3-external/`) — immutable снапшоты корпуса D1–D6 (raw docx + md-фрагменты по вкладкам + MANIFEST с хэшами). Объект анализа, НЕ источник истины.

## Роли (полностью — docs/03_ROLES.md)
| Роль | Модель | Промт | Зона |
|---|---|---|---|
| Business (CEO) | Fable | `prompts/business.md` | бизнес-решения: Order Flow для клиента и денег, политика, приоритеты |
| Architect | Opus | `prompts/architect.md` | ADR, целостность, ревью, роудмап + выпуск брифов |
| Executor | Sonnet | `prompts/executor.md` | исполнение одного брифа |
| Applier | Sonnet | `prompts/applier.md` | session-блок → один commit-скрипт |
| Owner | человек | — | запуск сессий, скрипты, коммиты, verify, апрувы |

## Как запустить сессию (quickstart)
1. Возьми актуальный SHA (последний apply-скрипт печатает его последней строкой; либо `git log --format='%H' -1`).
2. Открой свежий чат нужной модели. Вставь файл промта роли целиком.
3. Добавь строку `SHA сессии: <хэш>` и вопрос/задачу (launch-строка — в конце каждого промта).
4. В конце сессии забери session-блок → скорми Applier'у → выполни выданный bash → `bash tools/verify.sh` → новый SHA в следующую сессию.

## Рабочий цикл
```
Open Questions / Роудмап «текущий фокус»
   │
   ├─ бизнес-развилка ──► [Business/Fable] ──► ADR [BUSINESS] ─┐
   ▼                                                            │
[Architect/Opus: режим A решения+роудмап · режим B брифы] ◄─────┘
   │ briefs/<ID>.md
   ▼
[Executor/Sonnet] ──► артефакт + session-блок
   ▼
[Applier/Sonnet] ──► один bash ──► Owner: коммит → verify.sh → новый SHA
```

## Железные правила
- Доступ агентов к репо — ТОЛЬКО `curl` по commit-SHA (web-fetch кэширует). SHA не приложен → агент обязан спросить.
- Anti-improvisation: гэп → `CONTEXT GAP`, не догадка. Истину о поведении 1С знает только List.kg (К-7).
- Цитаты из корпуса — только `l3-external/md/<файл>@<SHA>:строки` (К-1).
- Каждый apply-коммит проверяется `bash tools/verify.sh`. RED → чиним прежде, чем двигаться.

## Карта репо
```
docs/00_STATE.md            — статус, текущий фокус, блокеры (LIVING)
docs/01_CONVENTIONS.md      — конвенции К-x
docs/02_ADR_LOG.md          — ADR append-only
docs/03_ROLES.md            — роли и биндинг моделей
docs/04_SESSION_PROTOCOL.md — жизненный цикл сессий, session-блок
docs/05_ROADMAP.md          — фазы Track A + Track B
docs/06_BRIEF_TEMPLATE.md   — шаблон брифа
docs/07_OPERATIONAL_LESSONS.md — известные грабли инструментария (shell/apply-скрипты)
prompts/{business,architect,executor,applier}.md
briefs/<ID>.md              — брифы задач
sessions/<дата>_<id>.md     — логи сессий
l2-registers/               — problem / contractor_questions / open_questions / assumptions
l3-external/                — MANIFEST.md · raw/*.docx · md/<26 фрагментов>
tools/verify.sh             — детерминированный гейт целостности
```
Связанный репо: `dom-propraba-strategy` — Master KB (по SHA-ссылке; твёрдые секции [1],[2],[9], остальное по К-5).
