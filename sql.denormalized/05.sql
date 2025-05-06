SELECT '#' || tag AS tag, count(*) AS count
FROM (
    SELECT DISTINCT
        data->>'id' AS id_tweet,
        jsonb_array_elements_text(
            coalesce(
                data->'extended_tweet'->'entities'->'hashtags',
                data->'entities'->'hashtags',
                '[]'
            )
        )::jsonb ->> 'text' AS tag
    FROM tweets_jsonb
    WHERE
        to_tsvector('english', coalesce(data->'extended_tweet'->>'full_text', data->>'text')) @@ to_tsquery('english', 'coronavirus')
        AND data->>'lang' = 'en'
) t
GROUP BY tag
ORDER BY count DESC, tag
LIMIT 1000;
