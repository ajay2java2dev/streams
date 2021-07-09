## To delete Topic's. 
docker-compose exec broker kafka-topics --bootstrap-server broker:9092 --topic SOURCE_CMPGN_MNGR_BRANDING_EVENTS --delete

## Create the Source topic we want.
docker-compose exec broker kafka-topics --bootstrap-server broker:9092 --topic SOURCE_CMPGN_MNGR_BRANDING_EVENTS --create --replication-factor 1 --partitions 1 --config cleanup.policy=compact
 
 ## Or Alter default config, add compact policy
docker-compose exec broker kafka-configs --bootstrap-server broker:9092 --entity-type topics --entity-name SOURCE_CMPGN_MNGR_BRANDING_EVENTS --alter --add-config "cleanup.policy=[delete,compact], retention.ms=1800000, retention.bytes=1073741824"

# Create a connector through rest call here or directly through postman.
curl -X POST \
  http://localhost:8083/connectors \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -d '{
  "name": "ENTERPRISE.DIGI.TRUSTPILOT.CABRANDING.SOURCE",
  "config": {
    "key.converter.schemas.enable": "false",
    "value.converter.schemas.enable": "true",
    "name": "ENTERPRISE.DIGI.TRUSTPILOT.CABRANDING.SOURCE",
    "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
    "tasks.max": "1",
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "transforms": "createKey, extractInt",
    "transforms.createKey.type": "org.apache.kafka.connect.transforms.ValueToKey",
    "transforms.createKey.fields": "REFID",
    "transforms.extractInt.type": "org.apache.kafka.connect.transforms.ExtractField$Key",
    "transforms.extractInt.field": "REFID",
    "connection.url": "jdbc:sqlserver://localhost:1433;database=mydatabase;encrypt=true;trustServerCertificate=true;hostNameCertificate=*.database.windows.net;loginTimeout=30;",
    "connection.user": "************",
    "connection.password": "************",
    "numeric.mapping": "best_fit",
    "dialect.name": "SqlServerDatabaseDialect",
    "mode": "bulk",
    "query": "select CBI.REFID, CBI.LOAN_NUMBER, CBI.NEW_LOAN_NUMBER, CBI.BORR1_FIRST_NAME, CBI.BORR1_LAST_NAME, CBI.EMAIL, CBI.PHONE, CBI.CLOSEDDATE, CBI.LOAN_PURPOSE, CBI.SOURCE, CBI.TEMPLATE, CBI.SENDDATE from CA_BRANDING_INT CBI WHERE CBI.SOURCE LIKE '%Trustpilot Email%' and CBI.REFID not in (SELECT REF_ID from CA_BRANDING_EVENT_STATUS CBES where CBES.REF_ID = CBI.REFID and CBES.EVENT_STATUS = 'SUCCESS');",
    "poll.interval.ms": "60000",
    "topic.prefix": "SOURCE_CMPGN_MNGR_BRANDING_EVENTS"
  }
}'

