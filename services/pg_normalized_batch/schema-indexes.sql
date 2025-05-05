CREATE INDEX ON tweet_tags(id_tweets, tag);
CREATE INDEX ON tweet_tags(tag, id_tweets);
CREATE INDEX ON tweets(id_tweets, lang);
CREATE INDEX ON tweets USING GIN (to_tsvector('english', text));
CREATE INDEX ON tweets(lang); 
