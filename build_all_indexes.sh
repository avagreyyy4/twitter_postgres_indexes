#!/bin/bash

LOG="index_build.log"
CONTAINER="twitter_postgres_indexes-pg_denormalized-1"

# Helper function to create each index with guard
create_index() {
  local index_name="$1"
  local sql="$2"

  echo "[$(date)] Attempting to build $index_name..." | tee -a "$LOG"

  docker exec "$CONTAINER" psql -U postgres -d postgres -c "
  DO \$\$
  BEGIN
    IF NOT EXISTS (
      SELECT 1 FROM pg_indexes 
      WHERE tablename = 'tweets_jsonb' AND indexname = '$index_name'
    ) THEN
      RAISE NOTICE 'Building $index_name...';
      SET LOCAL maintenance_work_mem = '2GB';
      SET LOCAL max_parallel_maintenance_workers = 10;
      $sql;
    ELSE
      RAISE NOTICE '$index_name already exists, skipping.';
    END IF;
  END
  \$\$;
  " | tee -a "$LOG"

  echo "[$(date)] Done with $index_name." | tee -a "$LOG"
}

# Index definitions
create_index "tweets_hashtags_idx" "
  CREATE INDEX tweets_hashtags_idx ON tweets_jsonb 
  USING gin((data->'entities'->'hashtags')) 
  WHERE jsonb_typeof(data->'entities'->'hashtags') = 'array'
"

create_index "tweets_ext_hashtags_idx" "
  CREATE INDEX tweets_ext_hashtags_idx ON tweets_jsonb 
  USING gin((data->'extended_tweet'->'entities'->'hashtags')) 
  WHERE jsonb_typeof(data->'extended_tweet'->'entities'->'hashtags') = 'array'
"

create_index "tweets_text_search_idx" "
  CREATE INDEX tweets_text_search_idx ON tweets_jsonb 
  USING gin(to_tsvector('english', coalesce(data->'extended_tweet'->>'full_text', data->>'text'))) 
  WHERE data->>'lang' = 'en'
"

create_index "tweets_lang_idx" "
  CREATE INDEX tweets_lang_idx ON tweets_jsonb((data->>'lang'))
"

