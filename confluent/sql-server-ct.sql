
-- Use below commands to bring up the Agent.
EXEC SP_CONFIGURE 'Agent XPs'


EXEC SP_CONFIGURE 'show advanced options',1
GO
RECONFIGURE
GO
EXEC SP_CONFIGURE 'show advanced options'


EXEC SP_CONFIGURE 'Agent XPs',1
GO
RECONFIGURE


-- Sometime the SQL Server Agent doesnt start so restarting SQL server does the trick.
-- https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-sql-agent?view=sql-server-ver15. Most likely
-- On my ubuntu I did : sudo systemctl restart mssql-server


-- Enable the DB for CDC
exec sys.sp_cdc_enable_db;
-- exec sys.sp_cdc_disable_db;

-- Enable Table
exec sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name = N'kafka_source_twitter_topic_geek_tweets',
@role_name = null,
@filegroup_name = N'Primary',
@supports_net_changes = 1
GO

-- Run few queries as below to understand the structure of CDC tables. 

-- If tweets are still coming to you kafka table then you should see the changes in your CT table

SELECT *  FROM [twitter].[cdc].[dbo_kafka_source_twitter_topic_geek_tweets_CT];
SELECT *  FROM [twitter].[cdc].[change_tables];
SELECT *  FROM [twitter].[cdc].[captured_columns];  
SELECT *  FROM [twitter].[cdc].[lsn_time_mapping] order by tran_end_time desc;
select *  FROM [twitter].[dbo].[kafka_source_twitter_topic_geek_tweets] ;

-- Now if you are getting records upto this point then great. Else keep trying to restart
-- the service and trying to make it work.

-- Capturing Changed events finally. Note you have also got additional functions under Programmability --> Functions --> Table-Valued Functions

declare @begin_time datetime = getdate() - 1;
declare @end_time datetime = getdate();
declare @from_lsn binary(10) = sys.fn_cdc_map_time_to_lsn('smallest greater than or equal', @begin_time);
declare @to_lsn binary(10) = sys.fn_cdc_map_time_to_lsn('largest less than or equal', @end_time);

select @begin_time, @end_time, @from_lsn, @to_lsn
select * from cdc.fn_cdc_get_net_changes_dbo_kafka_source_twitter_topic_geek_tweets(@from_lsn, @to_lsn, 'all with mask');

/*
__$operation status: (should be useful kafka event updates)
        1 = DELETE
        2 = INSERT
        4 = UPDATE
*/
