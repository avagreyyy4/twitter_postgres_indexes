SELECT
  COUNT(*)
FROM tweets_jsonb
WHERE to_tsvector('english', data ->> 'text') @@ to_tsquery('english', 'coronavirus')
  AND data ->> 'lang' = 'en';
