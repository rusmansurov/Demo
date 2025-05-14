-- Example with mutation

CREATE TABLE events
(
    id UInt64,
    event_time DateTime,
    user_id UInt32,
    event_type String,
    value Float32
)
ENGINE = MergeTree
PARTITION BY toYYYYMM(event_time)
ORDER BY (event_time, user_id);

INSERT INTO events
SELECT
    number AS id,
    now() - INTERVAL intDiv(number, 1000) SECOND AS event_time,
    rand() % 1000 AS user_id,
    arrayElement(['click', 'view', 'purchase', 'logout'], rand() % 4 + 1) AS event_type,
    round(rand() % 1000 / 10.0, 2) AS value
FROM numbers(10000);

SELECT event_type, count(*) AS cnt
FROM events
GROUP BY event_type
ORDER BY cnt DESC;

ALTER TABLE events UPDATE value = 0 WHERE event_type = 'click';

DROP TABLE events;
