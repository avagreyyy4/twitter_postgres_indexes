CREATE INDEX tweets_lang_idx ON tweets_jsonb((data->>'lang'))

CREATE INDEX tweets_text_search_idx ON tweets_jsonb 
  USING gin(to_tsvector('english', coalesce(data->'extended_tweet'->>'full_text', data->>'text'))) 
  WHERE data->>'lang' = 'en'

CREATE INDEX tweets_ext_hashtags_idx ON tweets_jsonb
  USING gin((data->'extended_tweet'->'entities'->'hashtags'))
  WHERE jsonb_typeof(data->'extended_tweet'->'entities'->'hashtags') = 'array'

CREATE INDEX tweets_hashtags_idx ON tweets_jsonb
  USING gin((data->'entities'->'hashtags'))
  WHERE jsonb_typeof(data->'entities'->'hashtags') = 'array'
