-- TABLE HAS TO BE CREATED BEFORE HAND. This is same structure postgress SQL creates
-- It very unfortunate the connector doesn't handle __connect_topic text primary key field since its a field without specific length.
-- Such things one would expect the connector would be able to handle based on the dialect.

create table kafka_source_twitter_topic_geek_tweets
(
	__connect_topic varchar(256) not null,
	__connect_partition integer not null,
	__connect_offset bigint not null,
	created_at text,
	id bigint not null,
	text text,
	lang text,
	is_retweet binary not null,
	constraint source_twitter_topic_geek_tweets_pkey
		primary key (__connect_topic, __connect_partition, __connect_offset)
);

select * from kafka_source_twitter_topic_geek_tweets;
