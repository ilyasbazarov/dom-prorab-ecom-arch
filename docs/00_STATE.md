# FILE: docs/00_STATE.md

# STATE

**Версия:** v1.41 · **updated:** 2026-08-12 · session `arch_f4_17_brief`, блок 8 (Architect режим A, Claude Code, Opus): РАЗБОР ОЧЕРЕДИ НА ПАРАЛЛЕЛИМОСТЬ по вопросу Owner — `reference/2026-08-12_parallel_with_f4_17.md`. Параллельных СЕССИЙ у проекта нет до волны `M2` (ADR-037 §5), поэтому рядом с `F4-17` идут два вида работы: руки Owner, не занимающие дерева (строка 13 — она же гейт прогона, и `F4-21`), и пять строк, не залоченных `F4-17`, — 6 (`F4-13`), 9 (`F5-04`), 8 (`B2`), 11 (хвост `M1`), 3 (`M1-12`). Пересечений по файлам с `F4-17` ноль. НАЙДЕНО: `briefs/B2.md` не несёт обязательной секции «Файлы на запись» (К-31) и к запуску не готов. Раньше: тема правила выхода STATE закрыта, ADR-137 и ADR-138 в `accepted`; `F4-17` сужена до восьми шагов, гейта OQ-08 нет, `CQ-36`…`CQ-44` в SENT. Подробности — §Подробности для модели.


## Текущий фокус

### Стенд-ап
**Где мы.** Пара у подрядчика с 2026-08-11, `F4-22` закрыта. `F4-17` сужена до восьми шагов внутри
CRM и упирается в один гейт — заведённую воронку; восемь внешних шагов ушли в `F4-24`.

**Прошлый шаг.** `arch_f4_17_brief`: `F4-17` сужена до восьми шагов (ADR-136); STATE ужат с 268 до
21 КБ и правило въехало в процесс — ADR-137 и ADR-138 обе `accepted`, тема закрыта.

**Следующий шаг.** Строка 13 — завести 14 стадий воронки руками и снять снимок в `reference/`.
Сразу за ней Executor-сессия по `briefs/F4-17.md`: восемь шагов, первые восемь проверок проекта.

**Идёт своей дорожкой.** Руками Owner — строка 13 (гейт прогона) и `F4-21`. Сессиями по одной, не
залочены `F4-17`: строки 6 (`F4-13`), 9 (`F5-04`), 8 (`B2`), 11 (хвост `M1`), 3 (`M1-12`).

**На Owner лично.** Воронка (строка 13), подключение канала WhatsApp (`F4-21`), ответ про доступ к
Яндексу. Ещё открыты: момент старта таймера 72 часов, ответы List.kg и банка по `CQ-13` под `F4-23`.

Длинное сюда не пишется: история — `docs/00_STATE_ARCHIVE.md`, ход сессии — `sessions/`, решения —
`docs/02_ADR_LOG.md`, шрамы метода — `docs/10_SCARS.md`. Лимиты всех разделов проверяет хук.

**Как запускать сессии:** `docs/09_RUNBOOK.md`.

### Подробности для модели

Индекс, а не хранилище (ADR-137 §2, К-19). Строка на сессию: дата · сессия · предмет · адрес
носителя. Содержание живёт в `sessions/`, в `docs/02_ADR_LOG.md` и в `docs/00_STATE_ARCHIVE.md`;
сюда оно не переписывается. Строк 66, из них с собственным файлом сессии 43; остальные держит
журнал решений. Перенесённые абзацы лежат дословно в архиве, раздел «Перенос 2026-08-12».

| Дата | Сессия | Предмет | Носитель |
|---|---|---|---|
| 2026-07-31 | — | Легаси-преамбула раздела: порядок сборки пакета волны 1 и запуска пилота Claude Code | журнал решений |
| 2026-08-03 | — | Трек OQ-02, состояние на 2026-08-03 | журнал решений |
| 2026-07-31 | `arch_m1_next_step_review` | Ревью следующего шага 2026-07-31: состав пачек A и B выведен из блоков последствий ADR-036 | `sessions/2026-07-31_arch_m1_next_step_review.md` |
| 2026-08-01 | `arch_m1_adr045_path_check` | Ревью пачки A 2026-08-01: состав двенадцати файлов сверен построчно против блоков последст | `sessions/2026-08-01_arch_m1_adr045_path_check.md` |
| 2026-08-01 | `arch_adr046_correction` | Корректирующая сессия 2026-08-01 (arch_adr046_correction) по находкам Reviewer | `sessions/2026-08-01_arch_adr046_correction.md` |
| 2026-08-01 | `arch_open_questions_5` | Разбор открытых вопросов 2026-08-01 | `sessions/2026-08-01_arch_open_questions_5.md` |
| 2026-08-01 | `reviewer_adr046_049` | Reviewer-сессия 2026-08-01 (reviewer_adr046_049) по ADR-046, ADR-047, ADR-048, ADR-049 пер | `sessions/2026-08-01_reviewer_adr046_049.md` |
| 2026-08-01 | `arch_adr050_findings` | Архитекторская сессия 2026-08-01 (arch_adr050_findings, разовое исключение мандата №7) по | `sessions/2026-08-01_arch_adr050_findings.md` |
| 2026-08-01 | `arch_goal_calibration_stop` | Аудит 2026-08-01 | `sessions/2026-08-01_arch_goal_calibration_stop.md` |
| 2026-08-01 | — | Решение Owner по развилке Р-1, 2026-08-01 (решение Owner, получено в чате 2026-08-01, зафи | журнал решений |
| 2026-08-01 | `adr_044_050_approval` | Апрув пакета ADR-044…ADR-050, 2026-08-01 (Owner, в чате, одним сообщением; сессия adr_044_ | `sessions/2026-08-01_adr_044_050_approval.md` |
| — | — | Приоритезация Фазы 5 против волн M решается правилом ADR-051 §5 (метод только по названном | журнал решений |
| 2026-08-01 | `f5_01_status_stage_contour` | Executor-сессия F5-01 в Claude Code, 2026-08-01 | `sessions/2026-08-01_f5_01_status_stage_contour.md` |
| 2026-08-01 | `f5_02_create_order_events` | Executor-сессия F5-02 в Claude Code, 2026-08-01 | `sessions/2026-08-01_f5_02_create_order_events.md` |
| 2026-08-02 | `arch_f5_02_returns_1` | Разбор возврата F5-02, 2026-08-02 | `sessions/2026-08-02_arch_f5_02_returns_1.md` |
| — | — | Находка по формату идемпотентного повтора /create_order (ADR-053) теперь несёт ID P-33, а | журнал решений |
| — | — | ID в docs/00_STATE.md живёт в двух ролях, и проверка 5 хука их не различает: учётная строк | журнал решений |
| 2026-08-02 | `f4_03_verify_defect2` | Executor-сессия F4-03 в Claude Code, 2026-08-02 | `sessions/2026-08-02_f4_03_verify_defect2.md` |
| 2026-08-02 | `arch_cc_method_escalation` | Архитекторская сессия 2026-08-02 (arch_cc_method_escalation), чатовый путь, SHA 5d5ffba3 | `sessions/2026-08-02_arch_cc_method_escalation.md` |
| 2026-08-02 | `arch_m1_batch_a_text` | Сессия 2026-08-02 (arch_m1_batch_a_text) написала дословный текст пачки A и закрыла три ра | `sessions/2026-08-02_arch_m1_batch_a_text.md` |
| 2026-08-02 | `arch_cc_pilot_close` | Сессия arch_m1_batch_b_text (2026-08-02) разобрала расхождение между строками статуса STAT | журнал решений |
| 2026-08-02 | `f4_02_client_order_no` | Executor-сессия F4-02 в Claude Code, 2026-08-02 | `sessions/2026-08-02_f4_02_client_order_no.md` |
| 2026-08-02 | — | Корректирующая Architect-сессия 2026-08-02 (arch_trackB_wave1_findings_close, чат, Claude | журнал решений |
| 2026-08-03 | `arch_outbound_packages` | Архитекторская сессия 2026-08-03 (arch_outbound_packages, чат, Claude Opus 5, @05d6d1ce) в | `sessions/2026-08-03_arch_outbound_packages.md` |
| 2026-08-03 | `arch_oq02_f407_brief` | Архитекторская сессия 2026-08-03 (arch_oq02_f407_brief, чат, Claude Opus 5, @4b5627ce) | `sessions/2026-08-03_arch_oq02_f407_brief.md` |
| 2026-08-03 | `arch_oq02_f407_brief` | Блок 2 сессии arch_oq02_f407_brief (2026-08-03) | `sessions/2026-08-03_arch_oq02_f407_brief.md` |
| 2026-08-03 | `arch_f4_07_payment_scenarios` | Architect-сессия F4-07 в Claude Code, 2026-08-03 (arch_f4_07_payment_scenarios), режим A | `sessions/2026-08-03_arch_f4_07_payment_scenarios.md` |
| 2026-08-03 | `arch_f4_07_payment_scenarios` | Блок 2 сессии arch_f4_07_payment_scenarios (2026-08-03) | `sessions/2026-08-03_arch_f4_07_payment_scenarios.md` |
| 2026-08-03 | — | F4-01 DONE 2026-08-03: повестка Business — BQ-08…BQ-17 (l2-registers/open_questions.md); д | журнал решений |
| 2026-08-04 | — | Business-сессия 2026-08-04 закрыла BQ-08…BQ-17 (ADR-077, детально — l0-canon/business_cano | журнал решений |
| 2026-08-04 | — | Сессия arch_f4_08_launch_form (2026-08-04, чат, Opus 5, SHA bc8711f4) | журнал решений |
| 2026-08-04 | — | F4-08 (2026-08-04): payment_scenarios разошёлся с ADR-077 п.4 (три опции при протухшем счё | журнал решений |
| 2026-08-04 | `arch_f4_08b_gate_release` | Сессия F4-08b (arch_f4_08b_gate_release, 2026-08-04, чат, SHA a5a61286cca15ae73ef418756add | `sessions/2026-08-04_arch_f4_08b_gate_release.md` |
| 2026-08-04 | — | Решения Owner по развилкам сессии F4-08b (2026-08-04): Р-1 вариант (а) — в §7 канона поток | журнал решений |
| 2026-08-04 | `rev_adr073_gate` | Ревью ADR-073 2026-08-04 | `sessions/2026-08-04_rev_adr073_gate.md` |
| 2026-08-05 | `arch_listkg_intake` | Ответы List.kg получены 2026-08-05 | `sessions/2026-08-05_arch_listkg_intake.md` |
| 2026-08-05 | `arch_listkg_outbound_rev2` | 2026-08-05, сессия arch_listkg_outbound_rev2 | `sessions/2026-08-05_arch_listkg_outbound_rev2.md` |
| 2026-08-05 | `arch_listkg_rev3_findings_close` | 2026-08-05, сессия arch_listkg_rev3_findings_close | `sessions/2026-08-05_arch_listkg_rev3_findings_close.md` |
| 2026-08-05 | — | Сессия F5-02-rev2, 2026-08-05 (Architect режим A+B, чат, Opus 5, @b8b5a82) | журнал решений |
| 2026-08-05 | — | Сессия arch_f4_09_stop_and_approval_rule (2026-08-05, Architect, чат) | журнал решений |
| 2026-08-07 | `arch_next_steps_calibration` | Сверка отправок 2026-08-07 | `sessions/2026-08-07_arch_next_steps_calibration.md` |
| 2026-08-07 | — | Сессия arch_next_steps_naming, 2026-08-07 (Architect режим A, Claude Code, Opus 5) | журнал решений |
| 2026-08-07 | — | Сессия arch_f4_11_brief, 2026-08-07 (Architect режим B, Claude Code, Opus 5, SHA d4173d0) | журнал решений |
| 2026-08-07 | `arch_f4_11_brief` | Блок 2 сессии arch_f4_11_brief, 2026-08-07 (SHA на старте блока — e4b9eac) | `sessions/2026-08-07_arch_f4_11_brief.md` |
| 2026-08-07 | `arch_f4_11_brief` | Блок 3 сессии arch_f4_11_brief, 2026-08-07: исполнение задачи F4-11 (SHA c35e205, Architec | `sessions/2026-08-07_arch_f4_11_brief.md` |
| 2026-08-07 | `reviewer_f4_11_presend` | Reviewer-сессия 2026-08-07 (reviewer_f4_11_presend, Claude Code, Fable, @9b581fc) — ревью | `sessions/2026-08-07_reviewer_f4_11_presend.md` |
| 2026-08-07 | `arch_e2e_flow_decision` | Отработка находок и форма сквозного ордер-флоу, 2026-08-07 | `sessions/2026-08-07_arch_e2e_flow_decision.md` |
| — | — | Основание задачи F4-14 — не жалоба подрядчика (она голосом и по К-30 фактом не является) | журнал решений |
| 2026-08-07 | `f4_14_order_flow_e2e` | Исполнение F4-14 в Claude Code, 2026-08-07 | `sessions/2026-08-07_f4_14_order_flow_e2e.md` |
| 2026-08-07 | `reviewer_f4_14_map` | Reviewer-сессия 2026-08-07 (reviewer_f4_14_map, Claude Code, Fable, SHA b9b2dd7) по выходу | `sessions/2026-08-07_reviewer_f4_14_map.md` |
| 2026-08-07 | `arch_f4_14_findings_close` | Архитекторская сессия 2026-08-07 (arch_f4_14_findings_close, Claude Code, Opus, SHA 37a0a7 | `sessions/2026-08-07_arch_f4_14_findings_close.md` |
| 2026-08-07 | — | Сведение очереди 2026-08-07 (тот же заход, блок 4) | журнал решений |
| 2026-08-11 | — | Сессия `arch_f4_19_brief` 2026-08-11 (Architect режим B, Claude Code, Opus) | журнал решений |
| — | — | Блок 3 той же сессии, решение Owner по развилке Р-2 (вариант В, ADR-130 `accepted`) | журнал решений |
| 2026-08-11 | `arch_f4_19_accept` | Приёмка выхода F4-19, 2026-08-11 | `sessions/2026-08-11_arch_f4_19_accept.md` |
| 2026-08-11 | — | Апрув Owner по ADR-131, 2026-08-11 (тот же arch_f4_19_accept, блок 2) | журнал решений |
| 2026-08-11 | — | Выпуск брифа F4-22, 2026-08-11 (тот же arch_f4_19_accept, блок 3, Architect режим B) | журнал решений |
| 2026-08-11 | `f4_22_bitrix_rev11` | Исполнение брифа F4-22, 2026-08-11 | `sessions/2026-08-11_f4_22_bitrix_rev11.md` |
| 2026-08-11 | `reviewer_f4_22_rev11` | Reviewer-сессия reviewer_f4_22_rev11 в Claude Code, 2026-08-11 (`sessions/2026-08-11_revie | `sessions/2026-08-11_reviewer_f4_22_rev11.md` |
| 2026-08-11 | `arch_rev11_findings` | Architect-сессия arch_rev11_findings в Claude Code, 2026-08-11, SHA сессии `ac3023f7b1ef84 | `sessions/2026-08-11_arch_rev11_findings.md` |
| 2026-08-11 | `arch_rev11_findings` | Апрув Owner по итогам блока 1, 2026-08-11 | `sessions/2026-08-11_arch_rev11_findings.md` |
| 2026-08-11 | `arch_rev11_findings` | Факт отправки, 2026-08-11 | `sessions/2026-08-11_arch_rev11_findings.md` |
| 2026-08-11 | `arch_rev11_findings` | Сужение объёма F4-17, 2026-08-11 | `sessions/2026-08-11_arch_rev11_findings.md` |
| 2026-08-11 | `arch_f4_17_brief` | Выпуск брифа F4-17, 2026-08-11 | `sessions/2026-08-11_arch_f4_17_brief.md` |
| 2026-08-11 | `arch_f4_17_brief` | Замер готовности прогона F4-17, 2026-08-11 | `sessions/2026-08-11_arch_f4_17_brief.md` |
| 2026-08-11 | `arch_f4_17_brief` | Решение Owner по развилке Р-1, 2026-08-11 | `sessions/2026-08-11_arch_f4_17_brief.md` |
| 2026-08-12 | `arch_f4_17_brief` | Замер веса STATE и правило выхода для каждого его раздела: файл 268 → 21 КБ без потерь | `sessions/2026-08-11_arch_f4_17_brief.md` |
| 2026-08-12 | `arch_f4_17_brief` | Апрув ADR-137 и достройка: К-23, форма session-блока, карта репо и план волны догнаны сплошным поиском | `sessions/2026-08-11_arch_f4_17_brief.md` |
| 2026-08-12 | `arch_f4_17_brief` | Апрув ADR-138: обе записи про STATE в `accepted`, тема правила выхода закрыта | `sessions/2026-08-11_arch_f4_17_brief.md` |
| 2026-08-12 | `arch_f4_17_brief` | Разбор очереди на параллелимость с `F4-17`: две работы руками Owner и пять незалоченных строк, пересечений 0 | `sessions/2026-08-11_arch_f4_17_brief.md` |

## Статус фаз
| Фаза/трек | Статус |
|---|---|
| 0. Архитектура процесса (ADR-001…006) | DONE |
| PREP. Операционная модель: роли, протокол, промты, verify (ADR-007) | DONE |
| 1. Knowledge Repository (состав L0) | DONE — ADR-011 [ARCH]; seed l0-canon/invariants.md, l0-canon/domain_model.md, l2-registers/decisions_xref.md |
| 2–3. Роли и pipeline | FOLDED в PREP |
| 4. Business Canon + Canonical Order Flow | Canonical Order Flow — ADOPTED (ADR-013, l0-canon/canonical_order_flow.md); Business Canon — pending Business; вход готовит бриф F4-01; добавлена роль Reviewer (ADR-024), артефакт prompts/reviewer.md |
| 5. Анализ корпуса D1–D6 | ACTIVE (волны F5-01…F5-04; F5-01 и F5-02 исполнены 2026-08-01 — `l2-registers/problem_register.md` §F5-01, §F5-02; F5-03/04 GATED/запланирована) |
| 6. Исправления ТЗ | — |
| 7. Diff → задачи подрядчикам | — |
| Track B волна 1 (P-01,02,03,05,06,19) | В РАБОТЕ — шесть тикетов готовы (`tasks/trackB_wave1_bitrix.md:11,41,90,126`, `tasks/trackB_wave1_1c.md:22,58`); rev4 BITRIX-B1-06 (узкий AC) и rev2 BITRIX-B1-03 (`event_id` не существует → ключ `CRM_Deal_ID + event`, ADR-015) применены. Шестой тикет — `BITRIX-B1-07` (P-19) — написан по брифу F4-02 rev3 (сессия f4_02_client_order_no, `tasks/trackB_wave1_bitrix.md:126`): новый реквизит `UF_CLIENT_ORDER_NO`, генератор с контрольной цифрой (ADR-019, дословно, пример `…-8` не воспроизведён), перепривязка одиннадцати HSM-шаблонов (ADR-020 п.2, сверка грепом — расхождений нет), снос COM-WA-02, условие триггера `#15` (ADR-026), норма выдачи на кассе, источник поля в ЛК. Пакет волны 1 полон. Отправка: оба пакета синхронно, одним куском (решение Owner 2026-07-26); 1С-пакет готов и ждёт; Reviewer-сессия (Fable) 2026-08-02 @647549cd проведена: №1 STOP (duplicate в приёмке B1-07 против ADR-053), №2-№4 FIX, №5 FIX формальная; отправка — после закрытия №1-№4. Отправки не было, дата не зафиксирована (подтверждено Owner 2026-07-28). |
| CC-пилот (ADR-027…029; success-критерий — ADR-034) | SCAFFOLD применён этим коммитом; пилотный бриф — F5-01 (Owner); гейт запуска: самотест хука на машине Owner «провалено 0» |
| Метод (разбор METHOD_OPTIMIZATION_BRIEF) | Волна 1 применена (ADR-030…035). План, гейты и статусы волн — docs/08_METHOD_PLAN.md. C-2 отклонён с порогом возврата (ADR-030 §1) |
| Метод M (portable_method, ADR-036…050) | ACCEPTED: ADR-036…043 и К-27…К-33 апрувлены Owner 2026-07-31 после двух Reviewer-сессий; волна M1 стартовала 2026-07-31. Пачка A: ПРИМЕНЕНА 2026-08-02 коммитом 70277b3073c063bee977b9b88f9652cbc5cfbdf5 через Claude Code (36 правок по 13 файлам, хук пройден, самотест «провалено 0» на 40 кейсах, verify.sh зелёный); это первое зачётное применение по ADR-034 §1b. Пачка B: дословный текст написан 2026-08-02 (сессия arch_m1_batch_b_text), состав — один файл docs/06_BRIEF_TEMPLATE.md, применение — второе зачётное. ADR-044…ADR-050 апрувлены Owner одним сообщением 2026-08-01 (сессия adr_044_050_approval), вместе с К-34, К-35, К-36. Трекер — строки M в docs/08_METHOD_PLAN.md; спека — reference/2026-07-29_portable_method_review.md |

## Ключевые якоря
- Канонический снапшот корпуса D1–D6: определяется хэшами в l3-external/MANIFEST.md (26 md-фрагментов); для цитат используется SHA текущей сессии
- Метод-базис: holika `_METHOD` v1.0 @ `ec7e6cc` (адаптирован, см. ADR-007)
- Claude Code-базис: holika `CLAUDE.md` + `.claude/` + `tools/hooks` @ `c229bb7` (адаптированы, ADR-028/029)

## Мандат: классы задач (ADR-036)
| Класс | Что это | Перечень |
|---|---|---|
| A | обычные задачи, идут постоянно в рамках роли | всё, что не отнесено к классу B |
| B | необратимые операции; каждая требует отдельного решения Owner и отдельного подтверждения перед исполнением | отправка пакета подрядчику · git push · правка l3-external/raw |

При сомнении в классе — класс B. Расширение перечня — только отдельным решением (первый кандидат — прод-операции Bitrix/1С при их появлении).

## Открытые вопросы

Раздел держит указатели, а не содержание (ADR-137 §3).

- Учётные строки вопросов с владельцем и признаком закрытия — `l2-registers/open_questions.md`.
- Наблюдения о методе без владельца — `docs/10_SCARS.md`, пункты `Ш-01`…`Ш-73`.
- Аномалия по К-23 заводится строкой реестра либо шрамом в `docs/10_SCARS.md`, а не здесь.
- Перенесённые дословно три учётных пункта и прежний состав раздела — `docs/00_STATE_ARCHIVE.md`.

## Блокеры
- нет
