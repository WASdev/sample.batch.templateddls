-------------------------------------------------------------
-- COPYRIGHT LICENSE: This information contains sample code provided in source code form. You may copy, modify, and distribute these sample programs in any form without payment to IBM for the purposes of developing, using, marketing or distributing application programs conforming to the application programming interface for the operating platform for which the sample code is written. Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.

-- (C) Copyright IBM Corp. 2014.
-- All Rights Reserved. Licensed Materials - Property of IBM.  
-------------------------------------------------------------

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
-- DROP SEQUENCE {tablePrefix}STEPEXECINSTDATA_SEQ;  
   
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
  	appname   VARCHAR(512),
    jobxmlname VARCHAR(512),
    submitter VARCHAR(512),
    jobxml    BLOB)
TABLESPACE {tablespace};
   
CREATE SEQUENCE {tablePrefix}JOBINSTANCEDATA_SEQ;
   
    CREATE OR REPLACE TRIGGER {tablePrefix}JOBINSTDATA_TRG
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
    logpath         VARCHAR(512),
	CONSTRAINT {tablePrefix}JOBINST_JOBEXEC_FK FOREIGN KEY (jobinstanceid) REFERENCES {tablePrefix}JOBINSTANCEDATA (jobinstanceid) ON DELETE CASCADE)
TABLESPACE {tablespace};

CREATE SEQUENCE {tablePrefix}EXECUTIONINSTANCEDATA_SEQ;
   
CREATE OR REPLACE TRIGGER {tablePrefix}EXECINSTDATA_TRG
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
	CONSTRAINT {tablePrefix}JOBEXEC_STEPEXEC_FK FOREIGN KEY (jobexecid) REFERENCES {tablePrefix}EXECUTIONINSTANCEDATA (jobexecid) ON DELETE CASCADE)
TABLESPACE {tablespace};

CREATE SEQUENCE {tablePrefix}STEPEXECINSTDATA_SEQ;
   
CREATE OR REPLACE TRIGGER {tablePrefix}STEPEXECINSTDATA_TRG
    BEFORE INSERT ON {tablePrefix}STEPEXECUTIONINSTANCEDATA
    FOR EACH ROW
    BEGIN
      SELECT {tablePrefix}STEPEXECINSTDATA_SEQ.nextval INTO :new.stepexecid FROM dual;
    END;
    /
   
CREATE TABLE {tablePrefix}JOBSTATUS (
	jobinstanceid     NUMBER(19,0) PRIMARY KEY,
    batchstatus  VARCHAR(512),
    exitstatus   VARCHAR(512),
    latestjobexecid   NUMBER(19,0),
    currentstepid VARCHAR(512),
    restarton VARCHAR(512),
    CONSTRAINT {tablePrefix}JOBSTATUS_JOBINST_FK FOREIGN KEY (jobinstanceid) REFERENCES {tablePrefix}JOBINSTANCEDATA (jobinstanceid) ON DELETE CASCADE,
    CONSTRAINT {tablePrefix}JOBSTATUS_JOBEXEC_FK FOREIGN KEY (latestjobexecid) REFERENCES {tablePrefix}EXECUTIONINSTANCEDATA (jobexecid) ON DELETE CASCADE)
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
 
