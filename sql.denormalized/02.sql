SELECT '#' || tag AS tag, count(*) AS count
FROM (
    SELECT DISTINCT 
        data->>'id' AS id_tweet,
        jsonb_array_elements_text(
            COALESCE(
                data->'extended_tweet'->'entities'->'hashtags',
                data->'entities'->'hashtags',
                '[]'
            )
        )::jsonb ->> 'text' AS tag
    FROM tweets_jsonb
    WHERE (
        jsonb_typeof(data->'entities'->'hashtags') = 'array'
        AND data->'entities'->'hashtags' @> '[{"text": "coronavirus"}]'
    )
    OR (
        jsonb_typeof(data->'extended_tweet'->'entities'->'hashtags') = 'array'
        AND data->'extended_tweet'->'entities'->'hashtags' @> '[{"text": "coronavirus"}]'
    )
) t
GROUP BY tag
ORDER BY count DESC, tag
LIMIT 1000;

