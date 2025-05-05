SELECT
  data ->> 'lang' AS lang,
  COUNT(DISTINCT id) AS count
FROM tweets_jsonb
WHERE data -> 'entities' -> 'hashtags' @@ '$[*].text == "coronavirus"'
   OR data -> 'extended_tweet' -> 'entities' -> 'hashtags' @@ '$[*].text == "coronavirus"'
GROUP BY lang
ORDER BY count DESC, lang;
