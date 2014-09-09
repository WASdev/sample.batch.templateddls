-- This script creates the tables on a db2 instance that batch container runtime uses.  
-- First a database must be created
-- Edit this ddl to provide suitable values for place holder ({databaseName},{schema},{tablePrefix}):
-- 1) Replace {databaseName} with the name of database
-- 2) All instances of {schema} and {tablePrefix} should be substituted with values chosen by the user.
-- The default schema name that the runtime will use JBATCH. Replace {schema} with JBATCH to use the default value
-- The default table prefix that the runtime will use is "".  Replace {tablePrefix} with "" (empty string) to use default value.
-- An example of using JBATCH for schema, and no table prefix is
--  	DROP TABLE JBATCH.JOBSTATUS

-- Then the following commands can be issued from DB2 command line processor to create the tables
--             db2 -tf jsr352-db2.ddl

CONNECT TO {databaseName};

--------------------------------------------------
-- Uncomment if need to drop all existing tables.
--------------------------------------------------
-- DROP TABLE {schema}.{tablePrefix}JOBSTATUS;
-- DROP TABLE {schema}.{tablePrefix}STEPSTATUS;
-- DROP TABLE {schema}.{tablePrefix}CHECKPOINTDATA;
-- DROP TABLE {schema}.{tablePrefix}JOBINSTANCEDATA;
-- DROP TABLE {schema}.{tablePrefix}EXECUTIONINSTANCEDATA;
-- DROP TABLE {schema}.{tablePrefix}STEPEXECUTIONINSTANCEDATA;

--------------------------------------------------
-- Create new tables
--------------------------------------------------

CREATE TABLE {schema}.{tablePrefix}JOBINSTANCEDATA(
  jobinstanceid BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1) CONSTRAINT {tablePrefix}JOBINSTANCE_PK PRIMARY KEY,
  name		VARCHAR(512), 
  apptag VARCHAR(512),
  appname   VARCHAR(512)
);

CREATE TABLE {schema}.{tablePrefix}EXECUTIONINSTANCEDATA(
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
  CONSTRAINT {tablePrefix}JOBINST_JOBEXEC_FK FOREIGN KEY (jobinstanceid) REFERENCES {schema}.{tablePrefix}JOBINSTANCEDATA (jobinstanceid)
  );
  
CREATE TABLE {schema}.{tablePrefix}STEPEXECUTIONINSTANCEDATA(
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
	CONSTRAINT {tablePrefix}JOBEXEC_STEPEXEC_FK FOREIGN KEY (jobexecid) REFERENCES {schema}.{tablePrefix}EXECUTIONINSTANCEDATA (jobexecid)
); 

CREATE TABLE {schema}.{tablePrefix}JOBSTATUS (
  id BIGINT NOT NULL CONSTRAINT {tablePrefix}JOBSTATUS_PK PRIMARY KEY,
  obj		BLOB,
  CONSTRAINT {tablePrefix}JOBSTATUS_JOBINST_FK FOREIGN KEY (id) REFERENCES {schema}.{tablePrefix}JOBINSTANCEDATA (jobinstanceid) ON DELETE CASCADE
);

CREATE TABLE {schema}.{tablePrefix}STEPSTATUS(
  id BIGINT NOT NULL CONSTRAINT {tablePrefix}STEPSTATUS_PK PRIMARY KEY,
  obj		BLOB,
  CONSTRAINT {tablePrefix}STEPSTATUS_STEPEXEC_FK FOREIGN KEY (id) REFERENCES {schema}.{tablePrefix}STEPEXECUTIONINSTANCEDATA (stepexecid) ON DELETE CASCADE
);

CREATE TABLE {schema}.{tablePrefix}CHECKPOINTDATA(
  id		VARCHAR(512) NOT NULL CONSTRAINT {tablePrefix}CHECKPOINTDATA_PK PRIMARY KEY,
  obj		BLOB
);

COMMIT WORK;
CONNECT RESET;
TERMINATE;


 
  
