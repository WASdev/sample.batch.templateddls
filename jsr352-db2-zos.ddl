-- Tailor these values for your DB2 environment.
--Variables ... Use global change on these variable names

-- 1. Replace {sqlid} with the appropriate sqlid.
-- 2. Replace {schema} with the schema name. For example: JBATCH  
-- 3. Replace {databaseName} with the actual database name. For example: BATCHDB
-- 4. Replace {storegroup} with the actual storegroup name.  For example: {storegroup}
-- 5. Replace {bufferpool} with the  buffer pool name to be used for table spaces 
--    created within the database.. For example: {bufferpool}
-- 6. Replace {bufferpoolindex} with the buffer pool name to be used for the
--    indexes created within the database. For example: {bufferpoolindex}
-- 7. The following are tablespace defined for individual table, replace with a different 
--    value if requires.
-- JBJIDTS : table space for JOBINSTANCEDATA table
-- JBEIDTS : table space for EXECUTIONINSTANCEDATA table
-- JBSIDTS : table space for STEPEXECUTIONINSTANCEDATA table
-- JBJSTTS : table space for JOBSTATUS table
-- JBSSTTS : table space for STEPSTATUS table
-- JBCPDTS : table space for CHECKPOINTDATA
--
-- 8. The following are table space defined for auxilary tables, replace with a different value if required
--
-- JBELOBTS : table space for EXECUTIONINSTANCEDATABLOB table 
-- JBXLOBTS : table space for STEPEXECUTIONINSTANCEDATABLOB table
-- JBJLOBTS : table space for JOBSTATUSBLOB table
-- JBSLOBTS : table space for STEPSTATUSBLOB table
-- JBCLOBTS : table space for CHECKPOINTDATABLOB table


SET CURRENT SQLID = '{sqlid}';
SET CURRENT SCHEMA = '{schema}';

---------------------------------------
-- Uncomment to drop tables, database and
-- revokes authority to use particular buffer pools,
-- storage groups, or table spaces 
---------------------------------------

-- DROP TABLE CHECKPOINTDATA;
-- DROP TABLE STEPSTATUS;
-- DROP TABLE JOBSTATUS;
-- DROP TABLE STEPEXECUTIONINSTANCEDATA;
-- DROP TABLE EXECUTIONINSTANCEDATA;
-- DROP TABLE JOBINSTANCEDATA;

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


CREATE TABLE JOBINSTANCEDATA(
  jobinstanceid BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START
  WITH 1, INCREMENT BY 1) CONSTRAINT JOBINSTANCE_PK PRIMARY KEY,
  name   VARCHAR(512),
  apptag VARCHAR(512),
  appname VARCHAR(512)
) IN {databaseName}.JBJIDTS;

GRANT ALL ON TABLE JOBINSTANCEDATA TO PUBLIC;

CREATE UNIQUE INDEX JBI_INDEX ON
      JOBINSTANCEDATA(jobinstanceid)
      USING STOGROUP {storegroup}
      PRIQTY 720
      SECQTY -1
      BUFFERPOOL {bufferpoolindex};


CREATE TABLE EXECUTIONINSTANCEDATA(
  jobexecid BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1,
  INCREMENT BY 1) CONSTRAINT JOBEXECUTION_PK PRIMARY KEY,
  jobinstanceid BIGINT,
  createtime    TIMESTAMP,
  starttime     TIMESTAMP,
  endtime       TIMESTAMP,
  updatetime    TIMESTAMP,
  parameters    BLOB(1M),
  batchstatus   VARCHAR(512),
  exitstatus    VARCHAR(512),
  serverId      VARCHAR(512),
  CONSTRAINT JOBINST_JOBEXEC_FK FOREIGN KEY (jobinstanceid) REFERENCES
  JOBINSTANCEDATA (jobinstanceid)
) IN {databaseName}.JBEIDTS;

GRANT ALL ON TABLE EXECUTIONINSTANCEDATA TO PUBLIC;

CREATE UNIQUE INDEX EXI_INDEX ON
      EXECUTIONINSTANCEDATA(jobexecid)
      USING STOGROUP {storegroup}
      PRIQTY 720
      SECQTY -1
      BUFFERPOOL {bufferpoolindex};

CREATE AUXILIARY TABLE EXECUTIONINSTANCEDATABLOB
       IN {databaseName}.JBELOBTS
       STORES EXECUTIONINSTANCEDATA COLUMN parameters;

CREATE UNIQUE INDEX JBELINDX ON EXECUTIONINSTANCEDATABLOB
   USING STOGROUP {storegroup}
      PRIQTY 720
      SECQTY -1
      BUFFERPOOL {bufferpoolindex};

CREATE TABLE STEPEXECUTIONINSTANCEDATA(
 stepexecid BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1,
 INCREMENT BY 1) CONSTRAINT STEPEXECUTION_PK PRIMARY KEY,
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
 CONSTRAINT JOBEXEC_STEPEXEC_FK FOREIGN KEY (jobexecid) REFERENCES
 EXECUTIONINSTANCEDATA (jobexecid)
) IN {databaseName}.JBSIDTS;

GRANT ALL ON TABLE STEPEXECUTIONINSTANCEDATA TO PUBLIC;

CREATE UNIQUE INDEX STP_INDEX ON
      STEPEXECUTIONINSTANCEDATA (stepexecid)
      USING STOGROUP {storegroup}
      PRIQTY 720
      SECQTY -1
      BUFFERPOOL {bufferpoolindex};

CREATE AUXILIARY TABLE STEPEXECUTIONINSTANCEDATABLOB
       IN {databaseName}.JBXLOBTS
       STORES STEPEXECUTIONINSTANCEDATA COLUMN persistentData;

CREATE UNIQUE INDEX JBXLINDX ON
   STEPEXECUTIONINSTANCEDATABLOB USING STOGROUP {storegroup}
      PRIQTY 720
      SECQTY -1
      BUFFERPOOL {bufferpoolindex};

CREATE TABLE JOBSTATUS (
  id     BIGINT NOT NULL CONSTRAINT JOBSTATUS_PK PRIMARY KEY,
  obj    BLOB(1M),
  CONSTRAINT JOBSTATUS_JOBINST_FK FOREIGN KEY (id) REFERENCES
  JOBINSTANCEDATA
  (jobinstanceid) ON DELETE CASCADE
) IN {databaseName}.JBJSTTS;

GRANT ALL ON TABLE JOBSTATUS TO PUBLIC;

CREATE UNIQUE INDEX JS_INDEX ON
      JOBSTATUS (id)
      USING STOGROUP {storegroup}
      PRIQTY 720
      SECQTY -1
      BUFFERPOOL {bufferpoolindex};

CREATE AUXILIARY TABLE JOBSTATUSBLOB
       IN {databaseName}.JBJLOBTS
       STORES JOBSTATUS COLUMN obj;

CREATE UNIQUE INDEX JBJLINDX ON JOBSTATUSBLOB
   USING STOGROUP {storegroup}
      PRIQTY 720
      SECQTY -1
      BUFFERPOOL {bufferpoolindex};

CREATE TABLE STEPSTATUS (
  id     BIGINT NOT NULL CONSTRAINT STEPSTATUS_PK PRIMARY KEY,
  obj    BLOB(1M),
  CONSTRAINT STEPSTATUS_STEPEXEC_FK FOREIGN KEY (id) REFERENCES
  STEPEXECUTIONINSTANCEDATA (stepexecid) ON DELETE CASCADE
) IN {databaseName}.JBSSTTS;

GRANT ALL ON TABLE STEPSTATUS TO PUBLIC;

CREATE UNIQUE INDEX SS_INDEX ON
      STEPSTATUS (id)
      USING STOGROUP {storegroup}
      PRIQTY 720
      SECQTY -1
      BUFFERPOOL {bufferpoolindex};

CREATE AUXILIARY TABLE STEPSTATUSBLOB
       IN {databaseName}.JBSLOBTS
       STORES STEPSTATUS COLUMN obj;

CREATE UNIQUE INDEX JBSLINDX ON STEPSTATUSBLOB
   USING STOGROUP {storegroup}
      PRIQTY 720
      SECQTY -1
      BUFFERPOOL {bufferpoolindex};


CREATE TABLE CHECKPOINTDATA (
  id     VARCHAR(512) NOT NULL,
  obj    BLOB(1M)
) IN {databaseName}.JBCPDTS;

GRANT ALL ON TABLE CHECKPOINTDATA TO PUBLIC;

CREATE INDEX CHK_INDEX ON CHECKPOINTDATA(id)
      USING STOGROUP {storegroup}
      PRIQTY 720
      SECQTY -1
      BUFFERPOOL {bufferpoolindex};

CREATE AUXILIARY TABLE CHECKPOINTDATABLOB
       IN {databaseName}.JBCLOBTS
       STORES CHECKPOINTDATA COLUMN obj;

CREATE UNIQUE INDEX JBCLINDX ON CHECKPOINTDATABLOB
   USING STOGROUP {storegroup}
      PRIQTY 720
      SECQTY -1
      BUFFERPOOL {bufferpoolindex};
      
COMMIT;
