-------------------------------------------------------------
-- COPYRIGHT LICENSE: This information contains sample code provided in source code form. You may copy, modify, and distribute these sample programs in any form without payment to IBM for the purposes of developing, using, marketing or distributing application programs conforming to the application programming interface for the operating platform for which the sample code is written. Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.

-- (C) Copyright IBM Corp. 2014.
-- All Rights Reserved. Licensed Materials - Property of IBM.  
-------------------------------------------------------------

-- This script creates the tables on a db2 instance that batch container runtime uses.  
-- Edit this ddl to provide suitable values for place holder ({databaseName},{schema},{tablePrefix}):
-- 1. Replace {databaseName} with the name of database
-- 2. All instances of {schema} and {tablePrefix} should be substituted with values chosen by the user.
-- The default schema name that the runtime will use JBATCH. Replace {schema} with JBATCH to use the default value
-- The default table prefix that the runtime will use is "".  Replace {tablePrefix} with "" (empty string) to use default value.
-- An example of using JBATCH for schema, and no table prefix is
--  	DROP TABLE JBATCH.JOBSTATUS

-- 3. The following are tablespace defined for individual table, replace with a different 
--    value if requires.  Customize the parameters for table space creation as appropriate
-- JBJIDTS : table space for {tablePrefix}JOBINSTANCEDATA table
-- JBEIDTS : table space for {tablePrefix}EXECUTIONINSTANCEDATA table
-- JBSIDTS : table space for {tablePrefix}STEPEXECUTIONINSTANCEDATA table
-- JBJSTTS : table space for {tablePrefix}JOBSTATUS table
-- JBSSTTS : table space for {tablePrefix}STEPSTATUS table
-- JBCPDTS : table space for {tablePrefix}CHECKPOINTDATA

-- 4. The sample GRANT command are issued to/from PUBLIC.  Customize with desired auth id(s)


-- 5. The following command can be issued from DB2 command line processor to execute the ddl
--             db2 -tf batch-db2.ddl

--------------------------------------------------
-- Uncomment if need to drop all existing tables
--------------------------------------------------
-- CONNECT TO {databaseName};
-- SET CURRENT SCHEMA = '{schema}';
-- DROP TABLE {tablePrefix}JOBSTATUS;
-- DROP TABLE {tablePrefix}STEPSTATUS;
-- DROP TABLE {tablePrefix}CHECKPOINTDATA;
-- DROP TABLE {tablePrefix}JOBINSTANCEDATA;
-- DROP TABLE {tablePrefix}EXECUTIONINSTANCEDATA;
-- DROP TABLE {tablePrefix}STEPEXECUTIONINSTANCEDATA;

-- DROP TABLESPACE JBJIDTS;
-- DROP TABLESPACE JBEIDTS;
-- DROP TABLESPACE JBSIDTS;
-- DROP TABLESPACE JBJSTTS;
-- DROP TABLESPACE JBSSTTS;
-- DROP TABLESPACE JBCPDTS;
--------------------------------------------------
-- Uncomment if need to drop database
--------------------------------------------------
-- DROP DATABASE {databaseName};
CREATE DATABASE {databaseName};

CONNECT TO {databaseName};

SET CURRENT SCHEMA = '{schema}';

--------------------------------------------------
-- Create table spaces

CREATE TABLESPACE JBJIDTS IN DATABASE PARTITION GROUP IBMDEFAULTGROUP
						PAGESIZE 4096 MANAGED BY AUTOMATIC STORAGE USING STOGROUP IBMSTOGROUP
						AUTORESIZE YES BUFFERPOOL IBMDEFAULTBP OVERHEAD INHERIT TRANSFERRATE
						INHERIT DROPPED TABLE RECOVERY ON DATA TAG INHERIT;

GRANT USE OF TABLESPACE JBJIDTS TO PUBLIC;

CREATE TABLESPACE JBEIDTS IN DATABASE PARTITION GROUP IBMDEFAULTGROUP
						PAGESIZE 4096 MANAGED BY AUTOMATIC STORAGE USING STOGROUP IBMSTOGROUP
						AUTORESIZE YES BUFFERPOOL IBMDEFAULTBP OVERHEAD INHERIT TRANSFERRATE
						INHERIT DROPPED TABLE RECOVERY ON DATA TAG INHERIT;

GRANT USE OF TABLESPACE JBEIDTS TO PUBLIC;

CREATE TABLESPACE JBSIDTS IN DATABASE PARTITION GROUP IBMDEFAULTGROUP
						PAGESIZE 4096 MANAGED BY AUTOMATIC STORAGE USING STOGROUP IBMSTOGROUP
						AUTORESIZE YES BUFFERPOOL IBMDEFAULTBP OVERHEAD INHERIT TRANSFERRATE
						INHERIT DROPPED TABLE RECOVERY ON DATA TAG INHERIT;
						
GRANT USE OF TABLESPACE JBSIDTS TO PUBLIC;

CREATE TABLESPACE JBJSTTS IN DATABASE PARTITION GROUP IBMDEFAULTGROUP
						PAGESIZE 4096 MANAGED BY AUTOMATIC STORAGE USING STOGROUP IBMSTOGROUP
						AUTORESIZE YES BUFFERPOOL IBMDEFAULTBP OVERHEAD INHERIT TRANSFERRATE
						INHERIT DROPPED TABLE RECOVERY ON DATA TAG INHERIT;

GRANT USE OF TABLESPACE JBJSTTS TO PUBLIC;

CREATE TABLESPACE JBSSTTS IN DATABASE PARTITION GROUP IBMDEFAULTGROUP
						PAGESIZE 4096 MANAGED BY AUTOMATIC STORAGE USING STOGROUP IBMSTOGROUP
						AUTORESIZE YES BUFFERPOOL IBMDEFAULTBP OVERHEAD INHERIT TRANSFERRATE
						INHERIT DROPPED TABLE RECOVERY ON DATA TAG INHERIT;

GRANT USE OF TABLESPACE JBSSTTS TO PUBLIC;

CREATE TABLESPACE JBCPDTS IN DATABASE PARTITION GROUP IBMDEFAULTGROUP
						PAGESIZE 4096 MANAGED BY AUTOMATIC STORAGE USING STOGROUP IBMSTOGROUP
						AUTORESIZE YES BUFFERPOOL IBMDEFAULTBP OVERHEAD INHERIT TRANSFERRATE
						INHERIT DROPPED TABLE RECOVERY ON DATA TAG INHERIT;
						
GRANT USE OF TABLESPACE JBCPDTS TO PUBLIC;

--------------------------------------------------

-- Create new tables
--------------------------------------------------

CREATE TABLE {tablePrefix}JOBINSTANCEDATA(
  jobinstanceid BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1) CONSTRAINT {tablePrefix}JOBINSTANCE_PK PRIMARY KEY,
  name		VARCHAR(512), 
  apptag VARCHAR(512),
  appname   VARCHAR(512),
  jobxmlname VARCHAR(512),
  submitter VARCHAR(512),
  jobxml    BLOB
) IN JBJIDTS INDEX IN JBJIDTS;

GRANT ALL ON TABLE {tablePrefix}JOBINSTANCEDATA TO PUBLIC;

CREATE UNIQUE INDEX JBI_INDEX ON
      {tablePrefix}JOBINSTANCEDATA(jobinstanceid);
      
CREATE TABLE {tablePrefix}EXECUTIONINSTANCEDATA(
  jobexecid BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1) CONSTRAINT {tablePrefix}JOBEXECUTION_PK PRIMARY KEY,
  jobinstanceid BIGINT,
  createtime	TIMESTAMP,
  starttime		TIMESTAMP,
  endtime		TIMESTAMP,
  updatetime	TIMESTAMP,
  parameters	BLOB,
  batchstatus	VARCHAR(512),
  exitstatus	VARCHAR(512),
  serverId 		VARCHAR(512),
  logpath       VARCHAR(512),
  CONSTRAINT {tablePrefix}JOBINST_JOBEXEC_FK FOREIGN KEY (jobinstanceid) REFERENCES {tablePrefix}JOBINSTANCEDATA (jobinstanceid) ON DELETE CASCADE
  ) IN JBEIDTS INDEX IN JBEIDTS;
  
GRANT ALL ON TABLE {tablePrefix}EXECUTIONINSTANCEDATA TO PUBLIC;

ALTER TABLE {tablePrefix}EXECUTIONINSTANCEDATA VOLATILE;

CREATE UNIQUE INDEX EXI_INDEX ON
      {tablePrefix}EXECUTIONINSTANCEDATA(jobexecid);

CREATE UNIQUE INDEX JBI_EXI_INDEX ON
      {tablePrefix}EXECUTIONINSTANCEDATA(jobinstanceid, jobexecid);
      
CREATE TABLE {tablePrefix}STEPEXECUTIONINSTANCEDATA(
	stepexecid BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1) CONSTRAINT {tablePrefix}STEPEXECUTION_PK PRIMARY KEY,
	jobexecid			BIGINT,
	batchstatus         VARCHAR(512),
    exitstatus			VARCHAR(512),
    stepname			VARCHAR(512),
	readcount			INTEGER,
	writecount			INTEGER,
	commitcount         INTEGER,
	rollbackcount		INTEGER,
	readskipcount		INTEGER,
	processskipcount	INTEGER,
	filtercount			INTEGER,
	writeskipcount		INTEGER,
	startTime           TIMESTAMP,
	endTime             TIMESTAMP,
	persistentData		BLOB,
	CONSTRAINT {tablePrefix}JOBEXEC_STEPEXEC_FK FOREIGN KEY (jobexecid) REFERENCES {tablePrefix}EXECUTIONINSTANCEDATA (jobexecid) ON DELETE CASCADE
) IN JBSIDTS INDEX IN JBSIDTS; 

GRANT ALL ON TABLE {tablePrefix}STEPEXECUTIONINSTANCEDATA TO PUBLIC;

ALTER TABLE {tablePrefix}STEPEXECUTIONINSTANCEDATA VOLATILE;

CREATE UNIQUE INDEX STP_INDEX ON
      {tablePrefix}STEPEXECUTIONINSTANCEDATA (stepexecid);

CREATE UNIQUE INDEX EXI_STP_INDEX ON
      {tablePrefix}STEPEXECUTIONINSTANCEDATA (jobexecid, stepexecid);      
      
CREATE TABLE {tablePrefix}JOBSTATUS (
  jobinstanceid BIGINT NOT NULL CONSTRAINT {tablePrefix}JOBSTATUS_PK PRIMARY KEY,
  batchstatus  VARCHAR(512),
  exitstatus   VARCHAR(512),
  latestjobexecid BIGINT,
  currentstepid VARCHAR(512),
  restarton VARCHAR(512),
  CONSTRAINT {tablePrefix}JOBSTATUS_JOBINST_FK FOREIGN KEY (jobinstanceid) REFERENCES {tablePrefix}JOBINSTANCEDATA (jobinstanceid) ON DELETE CASCADE,
  CONSTRAINT {tablePrefix}JOBSTATUS_JOBEXEC_FK FOREIGN KEY (latestjobexecid) REFERENCES {tablePrefix}EXECUTIONINSTANCEDATA (jobexecid) ON DELETE CASCADE
) IN JBJSTTS INDEX IN JBJSTTS;

GRANT ALL ON TABLE {tablePrefix}JOBSTATUS TO PUBLIC;

CREATE UNIQUE INDEX JS_INDEX ON
      {tablePrefix}JOBSTATUS (jobinstanceid);
	  
CREATE TABLE {tablePrefix}STEPSTATUS(
  id BIGINT NOT NULL CONSTRAINT {tablePrefix}STEPSTATUS_PK PRIMARY KEY,
  obj		BLOB,
  CONSTRAINT {tablePrefix}STEPSTATUS_STEPEXEC_FK FOREIGN KEY (id) REFERENCES {tablePrefix}STEPEXECUTIONINSTANCEDATA (stepexecid) ON DELETE CASCADE
) IN JBSSTTS;

GRANT ALL ON TABLE {tablePrefix}STEPSTATUS TO PUBLIC;

CREATE UNIQUE INDEX SS_INDEX ON
      {tablePrefix}STEPSTATUS (id);
	  
CREATE TABLE {tablePrefix}CHECKPOINTDATA(
  id		VARCHAR(512) NOT NULL CONSTRAINT {tablePrefix}CHECKPOINTDATA_PK PRIMARY KEY,
  obj		BLOB
)IN JBCPDTS INDEX IN JBCPDTS;

GRANT ALL ON TABLE {tablePrefix}CHECKPOINTDATA TO PUBLIC;

CREATE UNIQUE INDEX CHK_INDEX ON
	  {tablePrefix}CHECKPOINTDATA(id);

COMMIT WORK;
CONNECT RESET;
TERMINATE;


 
  
