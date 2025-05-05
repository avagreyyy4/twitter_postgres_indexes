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
  WHERE data -> 'entities' -> 'hashtags' @@ '$[*].text == "coronavirus"'
     OR data -> 'extended_tweet' -> 'entities' -> 'hashtags' @@ '$[*].text == "coronavirus"'
) AS tags
WHERE tag IS NOT NULL AND tag <> 'coronavirus'
GROUP BY tag
ORDER BY count DESC, tag
LIMIT 1000;
