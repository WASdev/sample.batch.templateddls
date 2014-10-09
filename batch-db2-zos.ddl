-------------------------------------------------------------
-- COPYRIGHT LICENSE: This information contains sample code provided in source code form. You may copy, modify, and distribute these sample programs in any form without payment to IBM for the purposes of developing, using, marketing or distributing application programs conforming to the application programming interface for the operating platform for which the sample code is written. Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.

-- (C) Copyright IBM Corp. 2014.
-- All Rights Reserved. Licensed Materials - Property of IBM.  
-------------------------------------------------------------

-- Tailor these values for your DB2 environment.
--Variables ... Use global change on these variable names

-- 1. Replace {sqlid} with the appropriate sqlid.
-- 2. Replace {schema} with the schema name. For example: JBATCH
-- 3. Replace {tablePrefix} with table prefix.  For example: PROD_JOBINSTANCEDATA
-- 4. Replace {databaseName} with the actual database name. For example: BATCHDB
-- 5. Replace {storegroup} with the actual storegroup name.  For example: WQ1GSG
-- 6. Replace {bufferpool} with the  buffer pool name to be used for table spaces 
--    created within the database.. For example: BP8
-- 7. Replace {bufferpoolindex} with the buffer pool name to be used for the
--    indexes created within the database. For example: BP9
-- 8. The following are tablespace defined for individual table, replace with a different 
--    value if requires.
-- JBJIDTS : table space for {tablePrefix}JOBINSTANCEDATA table
-- JBEIDTS : table space for {tablePrefix}EXECUTIONINSTANCEDATA table
-- JBSIDTS : table space for {tablePrefix}STEPEXECUTIONINSTANCEDATA table
-- JBJSTTS : table space for {tablePrefix}JOBSTATUS table
-- JBSSTTS : table space for {tablePrefix}STEPSTATUS table
-- JBCPDTS : table space for {tablePrefix}CHECKPOINTDATA
--
-- 9. The following are table space defined for auxilary tables, replace with a different value if required
--
-- JBELOBTS : table space for {tablePrefix}EXECUTIONINSTANCEDATABLOB table 
-- JBXLOBTS : table space for {tablePrefix}STEPEXECUTIONINSTANCEDATABLOB table
-- JBJLOBTS : table space for {tablePrefix}JOBSTATUSBLOB table
-- JBSLOBTS : table space for {tablePrefix}STEPSTATUSBLOB table
-- JBCLOBTS : table space for {tablePrefix}CHECKPOINTDATABLOB table
--
-- 10. The sample GRANT and REVOKE commands are issued to/from PUBLIC.  Customize with desired auth id(s)
-- as necessary.


SET CURRENT SQLID = '{sqlid}';
SET CURRENT SCHEMA = '{schema}';

---------------------------------------
-- Uncomment to drop tables, database and
-- revokes authority to use particular buffer pools,
-- storage groups, or table spaces 
---------------------------------------

-- DROP TABLE {tablePrefix}CHECKPOINTDATA;
-- DROP TABLE {tablePrefix}STEPSTATUS;
-- DROP TABLE {tablePrefix}JOBSTATUS;
-- DROP TABLE {tablePrefix}STEPEXECUTIONINSTANCEDATA;
-- DROP TABLE {tablePrefix}EXECUTIONINSTANCEDATA;
-- DROP TABLE {tablePrefix}JOBINSTANCEDATA;

-- DROP DATABASE {databaseName};

-- REVOKE USE OF STOGROUP {storegroup} FROM PUBLIC;
-- REVOKE USE OF BUFFERPOOL {bufferpool} FROM PUBLIC;
-- REVOKE USE OF BUFFERPOOL {bufferpoolindex} FROM PUBLIC;
-- COMMIT;



CREATE DATABASE {databaseName}
   BUFFERPOOL {bufferpool}
   INDEXBP    {bufferpoolindex}
   STOGROUP   {storegroup}
   CCSID      UNICODE;

CREATE TABLESPACE JBJIDTS IN {databaseName}
   USING STOGROUP {storegroup}
         PRIQTY   1500
         SECQTY   -1
         ERASE    NO
         DEFINE   NO
         SEGSIZE  32
         LOCKSIZE ROW;

GRANT USE OF TABLESPACE {databaseName}.JBJIDTS TO PUBLIC;

CREATE TABLESPACE JBEIDTS IN {databaseName}
   USING STOGROUP {storegroup}
         PRIQTY   1500
         SECQTY   -1
         ERASE    NO
         DEFINE   NO
         SEGSIZE  32
         LOCKSIZE ROW;

GRANT USE OF TABLESPACE {databaseName}.JBEIDTS TO PUBLIC;

CREATE TABLESPACE JBSIDTS IN {databaseName}
   USING STOGROUP {storegroup}
         PRIQTY   1500
         SECQTY   -1
         ERASE    NO
         DEFINE   NO
         SEGSIZE  32
         LOCKSIZE ROW;

GRANT USE OF TABLESPACE {databaseName}.JBSIDTS TO PUBLIC;


CREATE TABLESPACE JBJSTTS IN {databaseName}
   USING STOGROUP {storegroup}
         PRIQTY   1500
         SECQTY   -1
         ERASE    NO
         DEFINE   NO
         SEGSIZE  32
         LOCKSIZE ROW;

GRANT USE OF TABLESPACE {databaseName}.JBJSTTS TO PUBLIC;


CREATE TABLESPACE JBSSTTS IN {databaseName}
   USING STOGROUP {storegroup}
         PRIQTY   1500
         SECQTY   -1
         ERASE    NO
         SEGSIZE  32
         DEFINE   NO
         LOCKSIZE ROW;

GRANT USE OF TABLESPACE {databaseName}.JBSSTTS TO PUBLIC;


CREATE TABLESPACE JBCPDTS IN {databaseName}
   USING STOGROUP {storegroup}
         PRIQTY   1500
         SECQTY   -1
         ERASE    NO
         DEFINE   NO
         SEGSIZE  32
         LOCKSIZE ROW;

GRANT USE OF TABLESPACE {databaseName}.JBCPDTS TO PUBLIC;


CREATE LOB TABLESPACE JBELOBTS IN {databaseName}
   USING STOGROUP {storegroup}
         LOCKSIZE LOB;


GRANT USE OF TABLESPACE {databaseName}.JBELOBTS TO PUBLIC;


CREATE LOB TABLESPACE JBXLOBTS IN {databaseName}
   USING STOGROUP {storegroup}
         LOCKSIZE LOB;


GRANT USE OF TABLESPACE {databaseName}.JBXLOBTS TO PUBLIC;


CREATE LOB TABLESPACE JBJLOBTS IN {databaseName}
   USING STOGROUP {storegroup}
         LOCKSIZE LOB;


GRANT USE OF TABLESPACE {databaseName}.JBJLOBTS TO PUBLIC;


CREATE LOB TABLESPACE JBSLOBTS IN {databaseName}
   USING STOGROUP {storegroup}
         LOCKSIZE LOB;


GRANT USE OF TABLESPACE {databaseName}.JBSLOBTS TO PUBLIC;


CREATE LOB TABLESPACE JBCLOBTS IN {databaseName}
   USING STOGROUP {storegroup}
         LOCKSIZE LOB;


GRANT USE OF TABLESPACE {databaseName}.JBCLOBTS TO PUBLIC;


CREATE TABLE {tablePrefix}JOBINSTANCEDATA(
  jobinstanceid BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START
  WITH 1, INCREMENT BY 1) CONSTRAINT {tablePrefix}JOBINSTANCE_PK PRIMARY KEY,
  name   VARCHAR(512),
  apptag VARCHAR(512),
  appname VARCHAR(512)
) IN {databaseName}.JBJIDTS;

GRANT ALL ON TABLE {tablePrefix}JOBINSTANCEDATA TO PUBLIC;

CREATE UNIQUE INDEX JBI_INDEX ON
      {tablePrefix}JOBINSTANCEDATA(jobinstanceid)
      USING STOGROUP {storegroup}
      PRIQTY 720
      SECQTY -1
      BUFFERPOOL {bufferpoolindex};


CREATE TABLE {tablePrefix}EXECUTIONINSTANCEDATA(
  jobexecid BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1,
  INCREMENT BY 1) CONSTRAINT {tablePrefix}JOBEXECUTION_PK PRIMARY KEY,
  jobinstanceid BIGINT,
  createtime    TIMESTAMP,
  starttime     TIMESTAMP,
  endtime       TIMESTAMP,
  updatetime    TIMESTAMP,
  parameters    BLOB(1M),
  batchstatus   VARCHAR(512),
  exitstatus    VARCHAR(512),
  serverId      VARCHAR(512),
  CONSTRAINT {tablePrefix}JOBINST_JOBEXEC_FK FOREIGN KEY (jobinstanceid) REFERENCES
  {tablePrefix}JOBINSTANCEDATA (jobinstanceid)
) IN {databaseName}.JBEIDTS;

GRANT ALL ON TABLE {tablePrefix}EXECUTIONINSTANCEDATA TO PUBLIC;

ALTER TABLE {tablePrefix}EXECUTIONINSTANCEDATA VOLATILE;

CREATE UNIQUE INDEX EXI_INDEX ON
      {tablePrefix}EXECUTIONINSTANCEDATA(jobexecid)
      USING STOGROUP {storegroup}
      PRIQTY 720
      SECQTY -1
      BUFFERPOOL {bufferpoolindex};

CREATE UNIQUE INDEX JBI_EXI_INDEX ON
      {tablePrefix}EXECUTIONINSTANCEDATA(jobinstanceid, jobexecid)
      USING STOGROUP {storegroup}
      PRIQTY 720
      SECQTY -1
      BUFFERPOOL {bufferpoolindex};
      
CREATE AUXILIARY TABLE {tablePrefix}EXECUTIONINSTANCEDATABLOB
       IN {databaseName}.JBELOBTS
       STORES {tablePrefix}EXECUTIONINSTANCEDATA COLUMN parameters;

CREATE UNIQUE INDEX JBELINDX ON {tablePrefix}EXECUTIONINSTANCEDATABLOB
   USING STOGROUP {storegroup}
      PRIQTY 720
      SECQTY -1
      BUFFERPOOL {bufferpoolindex};

CREATE TABLE {tablePrefix}STEPEXECUTIONINSTANCEDATA(
 stepexecid BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1,
 INCREMENT BY 1) CONSTRAINT {tablePrefix}STEPEXECUTION_PK PRIMARY KEY,
 jobexecid        BIGINT,
 batchstatus      VARCHAR(512),
 exitstatus       VARCHAR(512),
 stepname         VARCHAR(512),
 readcount        INTEGER,
 writecount       INTEGER,
 commitcount      INTEGER,
 rollbackcount    INTEGER,
 readskipcount    INTEGER,
 processskipcount INTEGER,
 filtercount      INTEGER,
 writeskipcount   INTEGER,
 startTime        TIMESTAMP,
 endTime          TIMESTAMP,
 persistentData   BLOB(1M),
 CONSTRAINT {tablePrefix}JOBEXEC_STEPEXEC_FK FOREIGN KEY (jobexecid) REFERENCES
 {tablePrefix}EXECUTIONINSTANCEDATA (jobexecid)
) IN {databaseName}.JBSIDTS;

GRANT ALL ON TABLE {tablePrefix}STEPEXECUTIONINSTANCEDATA TO PUBLIC;

ALTER TABLE {tablePrefix}STEPEXECUTIONINSTANCEDATA VOLATILE;

CREATE UNIQUE INDEX STP_INDEX ON
      {tablePrefix}STEPEXECUTIONINSTANCEDATA (stepexecid)
      USING STOGROUP {storegroup}
      PRIQTY 720
      SECQTY -1
      BUFFERPOOL {bufferpoolindex};

CREATE UNIQUE INDEX EXI_STP_INDEX ON
      {tablePrefix}STEPEXECUTIONINSTANCEDATA (jobexecid, stepexecid)
      USING STOGROUP {storegroup}
      PRIQTY 720
      SECQTY -1
      BUFFERPOOL {bufferpoolindex};
      
CREATE AUXILIARY TABLE {tablePrefix}STEPEXECUTIONINSTANCEDATABLOB
       IN {databaseName}.JBXLOBTS
       STORES {tablePrefix}STEPEXECUTIONINSTANCEDATA COLUMN persistentData;

CREATE UNIQUE INDEX JBXLINDX ON
   {tablePrefix}STEPEXECUTIONINSTANCEDATABLOB USING STOGROUP {storegroup}
      PRIQTY 720
      SECQTY -1
      BUFFERPOOL {bufferpoolindex};

CREATE TABLE {tablePrefix}JOBSTATUS (
  id     BIGINT NOT NULL CONSTRAINT {tablePrefix}JOBSTATUS_PK PRIMARY KEY,
  obj    BLOB(1M),
  CONSTRAINT {tablePrefix}JOBSTATUS_JOBINST_FK FOREIGN KEY (id) REFERENCES
  {tablePrefix}JOBINSTANCEDATA
  (jobinstanceid) ON DELETE CASCADE
) IN {databaseName}.JBJSTTS;

GRANT ALL ON TABLE {tablePrefix}JOBSTATUS TO PUBLIC;

CREATE UNIQUE INDEX JS_INDEX ON
      {tablePrefix}JOBSTATUS (id)
      USING STOGROUP {storegroup}
      PRIQTY 720
      SECQTY -1
      BUFFERPOOL {bufferpoolindex};

CREATE AUXILIARY TABLE {tablePrefix}JOBSTATUSBLOB
       IN {databaseName}.JBJLOBTS
       STORES {tablePrefix}JOBSTATUS COLUMN obj;

CREATE UNIQUE INDEX JBJLINDX ON {tablePrefix}JOBSTATUSBLOB
   USING STOGROUP {storegroup}
      PRIQTY 720
      SECQTY -1
      BUFFERPOOL {bufferpoolindex};

CREATE TABLE {tablePrefix}STEPSTATUS (
  id     BIGINT NOT NULL CONSTRAINT {tablePrefix}STEPSTATUS_PK PRIMARY KEY,
  obj    BLOB(1M),
  CONSTRAINT {tablePrefix}STEPSTATUS_STEPEXEC_FK FOREIGN KEY (id) REFERENCES
  {tablePrefix}STEPEXECUTIONINSTANCEDATA (stepexecid) ON DELETE CASCADE
) IN {databaseName}.JBSSTTS;

GRANT ALL ON TABLE {tablePrefix}STEPSTATUS TO PUBLIC;

CREATE UNIQUE INDEX SS_INDEX ON
      {tablePrefix}STEPSTATUS (id)
      USING STOGROUP {storegroup}
      PRIQTY 720
      SECQTY -1
      BUFFERPOOL {bufferpoolindex};

CREATE AUXILIARY TABLE {tablePrefix}STEPSTATUSBLOB
       IN {databaseName}.JBSLOBTS
       STORES {tablePrefix}STEPSTATUS COLUMN obj;

CREATE UNIQUE INDEX JBSLINDX ON {tablePrefix}STEPSTATUSBLOB
   USING STOGROUP {storegroup}
      PRIQTY 720
      SECQTY -1
      BUFFERPOOL {bufferpoolindex};


CREATE TABLE {tablePrefix}CHECKPOINTDATA (
  id     VARCHAR(512) NOT NULL CONSTRAINT {tablePrefix}CHECKPOINTDATA_PK PRIMARY KEY,
  obj    BLOB(1M)
) IN {databaseName}.JBCPDTS;

GRANT ALL ON TABLE {tablePrefix}CHECKPOINTDATA TO PUBLIC;

CREATE UNIQUE INDEX CHK_INDEX ON
	  {tablePrefix}CHECKPOINTDATA(id)
      USING STOGROUP {storegroup}
      PRIQTY 720
      SECQTY -1
      BUFFERPOOL {bufferpoolindex};

CREATE AUXILIARY TABLE {tablePrefix}CHECKPOINTDATABLOB
       IN {databaseName}.JBCLOBTS
       STORES {tablePrefix}CHECKPOINTDATA COLUMN obj;

CREATE UNIQUE INDEX JBCLINDX ON {tablePrefix}CHECKPOINTDATABLOB
   USING STOGROUP {storegroup}
      PRIQTY 720
      SECQTY -1
      BUFFERPOOL {bufferpoolindex};
      
COMMIT;
