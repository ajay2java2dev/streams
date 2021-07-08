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

<p>Upto this point we have a Kafka Cluster up and running with SQL Server also working and capturing Tweets from Twitter. Next checkout the confluent folder for the latest confluent way of doing things. I have included a docker custom (available in confluent) image such that SQL Server Connector can be added through confluent-hub command this time. I am running this stack on seperate machine now as to not disturb the above setup but you can very well migrate the whole thing to confluent based implementation and leave your SQL Server running in your previous machine.</p>

## Sample 1: Debezium based SQL Server Connector
<hr/>

### Task 1: CDC - Changes for Enabling Change-Data-Capture (CDC)
<hr/>


<p> On SQL server you created above you enable CDC and that then can be used for generating changed events to you Kafka topic. Kafka can read the whole table (bulk) or you provide and incremental column mechanism to identify delta changes. Since many times tables are owned by different teams, it rather becomes difficult to convince other teams to add a new column or have a ETL process configured to copy (messy) data from source to new table. So instead CDC (if you can get convice DBA's to enable it) can be used to capture changed events for your Kafka events to get generated correctly.</p>

    - For CDC to work, first you need to ensure Sql Server Agent is up and running. If not follow this link: https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-sql-agent?view=sql-server-ver15. Most likely

    - sql-server-ct.sql: contains few commands to get the CDC started and enabled on a specific table. Once the Change Transaction table (CT) table is created under Systems, notice the records getting generated and the __$opteration column value. Deleting the records from source table would mark the value in this column as 1.
    
    __$operation status: (should be useful later on with kafka event updates)
        1 = DELETE
        2 = INSERT
        4 = UPDATE

    - Note you have also got additional functions under Programmability --> Functions --> Table-Valued Functions if CDC is enabled correctly. These can help in capturing changed records.

<p>PS: Probably after this you might say changing the table itself was simple enough but sometimes and on a larger scale thats not always a possibility. Also few good features are offered here by CDC as well as database level itself. So why not leverage those rather than have your developer write additional scripts. </p>

### Task 2: Kafka Connect
<hr>