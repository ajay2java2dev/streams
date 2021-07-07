# Event Streaming (Confluent & Landoop)
Event Streaming Applications and stream management using Kafka, Kafka Connect (Sinks and Source), Zookeeper, Landoop, Confluent-Hub etc. The focus of the implementation is to get things working and future updates to get it improved further. 

# Kafka Cluster - Landoop Platform
### Tutorial contains the complete code step by step using the landoop image. Checkout the code samples below.
    Twitter developer account is required for twitter source integration. Apply here: https://developer.twitter.com/en/apply-for-access
    Main keys required are below. Give proper justification as to why you need developer access else justification will be asked again in emails.

    - "twitter.consumerkey": "<<available once you get access>>"
    - "twitter.consumersecret": "<<available once you get access>>"
    - "twitter.token": "<<available once you register your app>>"
    - "twitter.secret": "<<available once you register your app>>"


## Sample 1: Twitter Integration (Twitter Feeds --> Elasticsearch + Dejavu, Postgress, Sql Server)
<hr>

<p>The Sample twitter integration is done using landoop/fast-data-dev:cp3.3.0 and has old confluent implementation. The sample here connects twitter tweets with elastic search, postgres and sql server. NOTE: With Sql Server the auto-create feature doesn't work and the table has to be created up front.</p>

### 1. Docker compose and connector properties.
<p>This folder contain a simple shell script (twitter-kafka-elastic-postgres.sh) to run all the required steps.</p>

    $ Run Commands available in twitter-kafka-elastic-postgres.sh. Run them one by one.

    For SQL Server Kafka Connect implementation, table creation would be required before hand for SQL Server Connector to work properly. 
    
    Read the issue here : https://docs.confluent.io/kafka-connect-jdbc/current/sink-connector/sink_config_options.html.


### 2. docker ps - displays below info
| IMAGE  | PORTS | DESCRIPTION |
| ------------- | ------------- | ------------- |
| landoop/fast-data-dev:cp3.3.0 |  0.0.0.0:2181->2181/tcp, 0.0.0.0:3030->3030/tcp, 0.0.0.0:8081-8083->8081-8083/tcp, 0.0.0.0:9092->9092/tcp, 0.0.0.0:9581-9585->9581-9585/tcp, 3031/tcp  | http://localhost:3030/ - landoop, http://localhost:8083/connectors
| itzg/elasticsearch:2.4.3  | 0.0.0.0:9200->9200/tcp, 9300/tcp  | http://0.0.0.0:9200/ - elasticsearch health check|
| postgres:9.5-alpine  | 0.0.0.0:5432->5432/tcp  |
| SQL Server 2019      | Local install. Not docker.| https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-ubuntu?view=sql-server-ver15

### Links and Refrences:
    1. https://docs.confluent.io/kafka-connect-jdbc/current/source-connector/source_config_options.html
    2. https://docs.confluent.io/kafka-connect-jdbc/current/sink-connector/sink_config_options.html
    3. https://github.com/Eneco/kafka-connect-twitter
    4. https://developer.twitter.com/en/support/twitter-api/error-troubleshooting
    5. https://developer.twitter.com/en/apply-for-access
    6. https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-ubuntu?view=sql-server-ver15
    

# confluent-samples (latest)

<p>Checkout the confluent folder for the same. Included a docker custom image such that SQL Server Connector can be added.</p>