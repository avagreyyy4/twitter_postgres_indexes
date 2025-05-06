SELECT COUNT(DISTINCT data->>'id') AS count
FROM tweets_jsonb
WHERE (
  (jsonb_typeof(data->'entities'->'hashtags') = 'array'
   AND data->'entities'->'hashtags' @> '[{"text": "coronavirus"}]')
  OR
  (jsonb_typeof(data->'extended_tweet'->'entities'->'hashtags') = 'array'
   AND data->'extended_tweet'->'entities'->'hashtags' @> '[{"text": "coronavirus"}]')
);
