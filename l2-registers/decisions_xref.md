# РЕЕСТР ПРОЕКТНЫХ РЕШЕНИЙ — СВЕРКА (L2)

Наши решения DEC/COM/CON, принятые в сессиях написания ТЗ и вложенные в корпус D4/D5
(авторство наше; текст снапшота — L3 immutable: цитируем, не правим). Не канон
автоматически; промоушен/отмена — через ADR. Заполняется **по касанию** (ADR-011, К-4),
не front-load.

Диспозиции: **RATIFIED** — промоутировано в L0-канон/инвариант; **SUPERSEDED→ADR-xxx** —
заменено нашим решением; **NEUTRAL** — справочно, силы канона не несёт; **OPEN** — не решено (TBD).
Где решение завязано в подтверждённое противоречие Problem Register — диспозиция ссылается
на P-xx; слепой RATIFIED запрещён (ADR-011 п.3).

| Код | Определён (файл@SHA:строки) | Диспозиция | Связь |
|---|---|---|---|
| CON-11 (payment_timeout_minutes) | d5_t05@bb88448464cef4d8a57a22d37fef6f2841eb0dbd:72 | OPEN | OQ-02 (DEFER до доков Бакай, чек-поинт 2026-08-05) |
| CON-19 (toxic_offline_threshold) | d5_t05@bb88448464cef4d8a57a22d37fef6f2841eb0dbd:50,77 | OPEN | BI-контур; вне e-com MVP |
| DEC-15 / DEC-CK-05 (гейт: /create_order только после платежа/подтверждения) | d6_t03@65f2bba:159,180 | RATIFIED→canon | ADR-010; canonical_order_flow §2 |
| CON-06 (стоимость доставки не в предоплату) | d6_t03@65f2bba:88,96 | RATIFIED→canon | ADR-010; canonical_order_flow §2 |
| DEC-33 (HTTP 200 = проведение + резерв≠0) | d1_t03@65f2bba:91 | RATIFIED→invariant | canonical_order_flow §4/T1; обработка partial/rejected — P-01/BITRIX-B1-01 |
