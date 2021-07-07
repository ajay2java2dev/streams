# Connect to docker container running our kafka cluster and kafka connect.
sudo docker run --rm -it --net=host landoop/fast-data-dev:cp3.3.0 bash

# Create a connector through rest call here or directly through postman.
curl -X POST \
  http://localhost:8083/connectors \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -d '{
  "name": "source-sqlserver-twitter-geek-tweets-distributed",
  "config": {
    "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
    "tasks.max": "1",
    "topics": "source_twitter_topic_geek_tweets",    
    "connection.url": "jdbc:sqlserver://192.168.1.167:1433;databaseName=twitter",
    "connection.user": "SA",
    "connection.password": "123@noida",
    "schema.pattern": "dbo"
    "table.whitelist": "CA_BRANDING_INT",
    "poll.interval.ms": "3600000",
    "mode": "bulk",
    "numeric_mapping": "best_fit",    
    "connection.attempts": "2",
    "query": "select CBI.REFID, CBI.LOAN_NUMBER, CBI.NEW_LOAN_NUMBER, CBI.BORR1_FIRST_NAME, CBI.BORR1_LAST_NAME, CBI.EMAIL, CBI.PHONE, CBI.CLOSEDDATE, CBI.LOAN_PURPOSE, CBI.SOURCE, CBI.TEMPLATE, CBI.SENDDATE
from CA_BRANDING_INT CBI WHERE CBI.SOURCE LIKE \"%Trustpilot Email%\" and CBI.REFID not in (SELECT REF_ID from CA_BRANDING_EVENT_STATUS CBES where CBES.REF_ID = CBI.REFID
and CBES.EVENT_STATUS = \"SUCCESS\");"
  }
}'

curl -s 127.0.0.1:8083/connectors/sink-postgres-twitter-geek-tweets-distributed/status | jq

curl -X POST \
  http://localhost:8083/connectors \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -d '{
  "name": "sink-sqlserver-twitter-geek-tweets-distributed",
  "config": {
    "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
    "tasks.max": "1",
    "topic.prefix": "source_twitter_topic_geek_tweets",    
    "connection.url": "jdbc:sqlserver://192.168.1.167:1433;databaseName=twitter",
    "connection.user": "SA",
    "connection.password": "123@noida",
    "poll.interval.ms": "3600000",
    "mode": "bulk",
    "numeric_mapping": "best_fit",    
    "connection.attempts": "2"
  }
}'

curl -s 127.0.0.1:8083/connectors/sink-sqlserver-twitter-geek-tweets-distributed/status | jq


