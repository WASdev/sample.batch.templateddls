-- This script creates the tables on an oracle db that batch container runtime uses. 
-- Edit this ddl to provide suitable values for place holder ({databaseName},{tablespace}, {schema},{tablePrefix}):
-- 1. Replace {databaseName} with the actual database name
-- 2. Replace all occurrances of {tablespace} with a valid tablespace
-- 3. Replace all occurrances of {tablePrefix} with a valid table prefix.
--    The default table prefix that the runtime will use is "".  Replace {tablePrefix} with "" (empty string) to use default value.
-- 4. Replace all occurrances of  {schema} with a valid schema.  
--    For example, if SCOTT is the schema, set
-- 	      ALTER SESSION SET CURRENT_SCHEMA = SCOTT;
-- 
-- Process this script using SQL*Plus
--     SQL> @batch-oracle.ddl
--
-- Note: currently a few of the table names and sequence name are almost to the limit of 30 char 
-- Adding table prefix to them might cause them to be over the limit, and resulted in error.
-- This is a limitation that will be addressed in later update.

--------------------------------------------
-- Set schema
--------------------------------------------
ALTER SESSION SET CURRENT_SCHEMA = {schema};

--------------------------------------------
-- Drop sequence generator
-- Uncomment if drop tables
---------------------------------------------
-- DROP SEQUENCE {tablePrefix}JOBINSTANCEDATA_SEQ;
-- DROP SEQUENCE {tablePrefix}EXECUTIONINSTANCEDATA_SEQ;
-- DROP SEQUENCE {tablePrefix}STEPEXECUTIONINSTANCEDATA_SEQ;  
   
-- DROP TABLESPACE {tablespace} INCLUDING CONTENTS AND DATAFILES;

---------------------------------------------
-- create tablespace
---------------------------------------------
CREATE TABLESPACE {tablespace} DATAFILE '/home/oracle/app/oracle/oradata/&{databaseName}/{tablespace}.dbf' 
   SIZE 5M AUTOEXTEND ON NEXT 1M MAXSIZE UNLIMITED DEFAULT 
   STORAGE (INITIAL 1M NEXT 1M MAXEXTENTS UNLIMITED PCTINCREASE 0);

---------------------------------------------
-- create tables and sequence
---------------------------------------------
   
CREATE TABLE {tablePrefix}JOBINSTANCEDATA(
	jobinstanceid               NUMBER(19,0) PRIMARY KEY,
    name                VARCHAR2(512),
    apptag VARCHAR(512),
  	appname   VARCHAR(512))
TABLESPACE {tablespace};
   
CREATE SEQUENCE {tablePrefix}JOBINSTANCEDATA_SEQ;
   
    CREATE OR REPLACE TRIGGER {tablePrefix}JOBINSTANCEDATA_TRG
    BEFORE INSERT ON {tablePrefix}JOBINSTANCEDATA
    FOR EACH ROW
    BEGIN
      SELECT {tablePrefix}JOBINSTANCEDATA_SEQ.nextval INTO :new.jobinstanceid FROM dual;
    END;
    /
   
CREATE TABLE {tablePrefix}EXECUTIONINSTANCEDATA(
	jobexecid       NUMBER(19,0) PRIMARY KEY,
    jobinstanceid   NUMBER(19,0),
    createtime      TIMESTAMP,
    starttime       TIMESTAMP,
    endtime         TIMESTAMP,
    updatetime      TIMESTAMP,
    parameters      BLOB,
    batchstatus     VARCHAR2(512),
    exitstatus      VARCHAR2(512),
    serverId 		VARCHAR(512),
	CONSTRAINT {tablePrefix}JOBINST_JOBEXEC_FK FOREIGN KEY (jobinstanceid) REFERENCES {tablePrefix}JOBINSTANCEDATA (jobinstanceid))
TABLESPACE {tablespace};

CREATE SEQUENCE {tablePrefix}EXECUTIONINSTANCEDATA_SEQ;
   
CREATE OR REPLACE TRIGGER {tablePrefix}EXECUTIONINSTANCEDATA_TRG
    BEFORE INSERT ON {tablePrefix}EXECUTIONINSTANCEDATA
    FOR EACH ROW
    BEGIN
      SELECT {tablePrefix}EXECUTIONINSTANCEDATA_SEQ.nextval INTO :new.jobexecid FROM dual;
    END;
    /
   
CREATE TABLE {tablePrefix}STEPEXECUTIONINSTANCEDATA(
	stepexecid			NUMBER(19,0) PRIMARY KEY,
    jobexecid      		NUMBER(19,0),
    batchstatus    		VARCHAR2(512),
    exitstatus     		VARCHAR2(512),
    stepname       		VARCHAR2(512),
    readcount      		NUMBER(11, 0),
    writecount     		NUMBER(11, 0),
    commitcount    		NUMBER(11, 0),
    rollbackcount  		NUMBER(11, 0),
    readskipcount  		NUMBER(11, 0),
    processskipcount    NUMBER(11, 0),
    filtercount    		NUMBER(11, 0),
    writeskipcount      NUMBER(11, 0),
    startTime           TIMESTAMP,
    endTime             TIMESTAMP,
    persistentData      BLOB,
	CONSTRAINT {tablePrefix}JOBEXEC_STEPEXEC_FK FOREIGN KEY (jobexecid) REFERENCES {tablePrefix}EXECUTIONINSTANCEDATA (jobexecid))
TABLESPACE {tablespace};

CREATE SEQUENCE {tablePrefix}STEPEXECUTIONINSTANCEDATA_SEQ;
   
CREATE OR REPLACE TRIGGER {tablePrefix}STEPEXECUTIONINSTANCEDATA_TRG
    BEFORE INSERT ON {tablePrefix}STEPEXECUTIONINSTANCEDATA
    FOR EACH ROW
    BEGIN
      SELECT {tablePrefix}STEPEXECUTIONINSTANCEDATA_SEQ.nextval INTO :new.stepexecid FROM dual;
    END;
    /
   
CREATE TABLE {tablePrefix}JOBSTATUS (
	id     NUMBER(19,0) PRIMARY KEY,
	obj    BLOB,
  	CONSTRAINT {tablePrefix}JOBSTATUS_JOBINST_FK FOREIGN KEY (id) REFERENCES {tablePrefix}JOBINSTANCEDATA (jobinstanceid) ON DELETE CASCADE)
TABLESPACE {tablespace};
   
CREATE TABLE {tablePrefix}STEPSTATUS(
  id		NUMBER(19,0) PRIMARY KEY,
  obj		BLOB,
  CONSTRAINT {tablePrefix}STEPSTATUS_STEPEXEC_FK FOREIGN KEY (id) REFERENCES {tablePrefix}STEPEXECUTIONINSTANCEDATA (stepexecid) ON DELETE CASCADE)
TABLESPACE {tablespace};
   
CREATE TABLE {tablePrefix}CHECKPOINTDATA(
	id      VARCHAR2(512) PRIMARY KEY,
  	obj		BLOB)
TABLESPACE {tablespace};

COMMIT WORK;
 