SELECT
  tag,
  COUNT(*) AS count
FROM (
  SELECT DISTINCT
    id,
    elem ->> 'text' AS tag
  FROM tweets_jsonb,
       LATERAL jsonb_array_elements(
         COALESCE(
           data -> 'entities' -> 'hashtags',
           data -> 'extended_tweet' -> 'entities' -> 'hashtags',
           '[]'::jsonb
         )
       ) AS elem
  WHERE to_tsvector('english', data ->> 'text') @@ to_tsquery('english', 'coronavirus')
    AND data ->> 'lang' = 'en'
) AS t
WHERE tag IS NOT NULL
GROUP BY tag
ORDER BY count DESC, tag
LIMIT 1000;
