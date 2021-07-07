# Confluent Quick Start Guide
https://docs.confluent.io/platform/6.2.0/quickstart/ce-docker-quickstart.html#ce-docker-quickstart

Base file location: curl --silent --output docker-compose.yml \
  https://raw.githubusercontent.com/confluentinc/cp-all-in-one/6.2.0-post/cp-all-in-one/docker-compose.yml
    
Connectors: 
1. https://www.confluent.io/hub/confluentinc/kafka-connect-jdbc
2. https://debezium.io/documentation/reference/connectors/sqlserver.html
        The Debezium SQL Server connector captures row-level changes that occur in the schemas of a SQL Server database.

The first time that the Debezium SQL Server connector connects to a SQL Server database or cluster, 
it takes a consistent snapshot of the schemas in the database. After the initial snapshot is complete, 
the connector continuously captures row-level changes for INSERT, UPDATE, or DELETE operations that are 
committed to the SQL Server databases that are enabled for CDC. The connector produces events for each 
data change operation, and streams them to Kafka topics. 

The connector streams all of the events for a table to a dedicated Kafka topic. 
Applications and services can then consume data change event records from that topic.

3. https://docs.confluent.io/home/connect/confluent-hub/client.html#linux
4. https://www.confluent.io/blog/kafka-connect-deep-dive-jdbc-source-connector/
5. 