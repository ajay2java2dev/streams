## Bring all required services up
sudo docker-compose up kafka-cluster elasticsearch postgres
## Get into landoop bash to execute kafka commands
sudo docker run --rm -it --net=host landoop/fast-data-dev:cp3.3.0 bash

apk update && apk add jq
# SOURCE CONFIGURATION
#--------------------------------------------------
## To delete Topic
kafka-topics --delete --topic source-twitter-topic-geek-tweets --zookeeper 127.0.0.1:2181
kafka-topics --delete --topic tweets --zookeeper 127.0.0.1:2181

## Create the Source topic we want.
kafka-topics --create --topic source-twitter-topic-geek-tweets --partitions 3 --replication-factor 1 --zookeeper 127.0.0.1:2181
## Alter default config, add compact policy
kafka-configs --zookeeper 127.0.0.1:2181 --entity-type topics --entity-name source-twitter-topic-geek-tweets --alter --add-config "cleanup.policy=[delete,compact]"


## Execute the below command to create the connector

curl -X POST \
  http://localhost:8083/connectors \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -d '{
  "name": "source-twitter-geek-tweets-distributed",
  "config": {
    "connector.class": "com.eneco.trading.kafka.connect.twitter.TwitterSourceConnector",
    "tasks.max": "1",
    "topic": "source-twitter-topic-geek-tweets",
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "key.converter.schemas.enable": "true",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter.schemas.enable": "true",
    "twitter.consumerkey": "<<rahasya>>",
    "twitter.consumersecret": "<<rahasya>>",
    "twitter.token": "<<rahasya>>",
    "twitter.secret": "<<rahasya>>",
    "track.terms": "programming,java,kafka,scala,R,google,apache,confluent",
    "language": "en"
  }
}'

curl -s 127.0.0.1:8083/connectors/source-twitter-geek-tweets-distributed/status | jq

### SINK CONFIGURATION
#--------------------------------------------------

## ELASTIC SEARCH SINK CONFIG

curl -X POST \
  http://localhost:8083/connectors \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -d '{
  "name": "sink-twitter-elasticsearch-geek-processed-distributed",
  "config": {
    "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
    "tasks.max": "2",
    "topics": "source-twitter-topic-geek-tweets",
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "key.converter.schemas.enable": "true",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter.schemas.enable": "true",
    "connection.url": "http://elasticsearch:9200",
    "type.name": "kafka-connect",
    "key.ignore": "true"
  }
}'

curl -s 127.0.0.1:8083/connectors/sink-twitter-geek-processed-distributed/status | jq

###POSTGRES JDBC CONFIG

curl -X POST \
  http://localhost:8083/connectors \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -d '{
  "name": "sink-postgres-twitter-geek-tweets-distributed",
  "config": {
    "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
    "tasks.max": "1",
    "topics": "source-twitter-topic-geek-tweets",
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "key.converter.schemas.enable": "true",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter.schemas.enable": "true",
    "connection.url": "jdbc:postgresql://postgres:5432/postgres",
    "connection.user": "postgres",
    "connection.password": "postgres",
    "insert.mode": "upsert",
    "pk.mode": "kafka",
    "pk.fields": "__connect_topic,__connect_partition,__connect_offset",
    "fields.whitelist": "id,created_at,text,lang,is_retweet",
    "auto.create": "true",
    "auto.evolve": "true"
  }
}'

curl -s 127.0.0.1:8083/connectors/sink-postgres-twitter-geek-tweets-distributed/status | jq


#### SQLSERVER JDBC CONFIG (Table needs to created as a prerequisite. Refer to sql-server-ddl.sql file)


### CONNECTOR CONFIG (auto.create = false, table created upfront)

curl -X POST \
  http://localhost:8083/connectors \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -d '{
  "name": "sink-sqlserver-twitter-geek-tweets-distributed",
  "config": {
    "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
    "tasks.max": "1",
    "topics": "source-twitter-topic-geek-tweets",
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "key.converter.schemas.enable": "true",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter.schemas.enable": "true",
    "connection.url": "jdbc:sqlserver://192.168.1.167:1433;databaseName=twitter",
    "connection.user": "SA",
    "connection.password": "123@noida",
    "insert.mode": "upsert",
    "pk.mode": "kafka",
    "table.name.format":"kafka_source_twitter_topic_geek_tweets",
    "pk.fields": "__connect_topic,__connect_partition,__connect_offset",
    "fields.whitelist": "id,created_at,text,lang,is_retweet",
    "connection.attempts": "2"
  }
}'