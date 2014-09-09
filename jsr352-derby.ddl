-- This script creates a Derby database for batch container runtime.
-- First edit this ddl to provide suitable values for place holder ({databaseName},{schema},{tablePrefix}):
--
-- 1) Replace {databaseName} with the name of database
-- 2) All instances of {schema} and {tablePrefix} should be substituted with values chosen by the user.
-- The default schema name that the runtime will use JBATCH. Replace {schema} with JBATCH to use the default value
-- The default table prefix that the runtime will use is "".  Replace {tablePrefix} with "" (empty string) to use default value.
-- An example of using JBATCH for schema, and no table prefix is
--  	DROP TABLE JBATCH.JOBSTATUS 
--
-- Then the following commands can be issued from ij command line processor.
-- java -Djava.ext.dirs=C:/WebSPhere/AppServer/derby/lib -Dij.protocol=jdbc:derby: org.apache.derby.tools.ij batch-derby.ddl

-- A Derby database will be created in the directory from which it is invoked

CONNECT 'jdbc:derby:{databaseName};create=true';

CREATE TABLE {schema}.{tablePrefix}JOBINSTANCEDATA(
  jobinstanceid BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1) CONSTRAINT {schema}.{tablePrefix}JOBINSTANCE_PK PRIMARY KEY,
  name		VARCHAR(512),
  apptag    VARCHAR(512),
  appname   VARCHAR(512)
);

CREATE TABLE {schema}.{tablePrefix}EXECUTIONINSTANCEDATA(
  jobexecid BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1) CONSTRAINT {schema}.{tablePrefix}JOBEXECUTION_PK PRIMARY KEY,
  jobinstanceid BIGINT,
  createtime	TIMESTAMP,
  starttime		TIMESTAMP,
  endtime		TIMESTAMP,
  updatetime	TIMESTAMP,
  parameters	BLOB,
  batchstatus	VARCHAR(512),
  exitstatus	VARCHAR(512),
  serverId 		VARCHAR(512),
  CONSTRAINT {schema}.{tablePrefix}JOBINST_JOBEXEC_FK FOREIGN KEY (jobinstanceid) REFERENCES {schema}.{tablePrefix}JOBINSTANCEDATA (jobinstanceid)
  );
  
CREATE TABLE {schema}.{tablePrefix}STEPEXECUTIONINSTANCEDATA(
	stepexecid BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1) CONSTRAINT {schema}.{tablePrefix}STEPEXECUTION_PK PRIMARY KEY,
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
	CONSTRAINT {schema}.{tablePrefix}JOBEXEC_STEPEXEC_FK FOREIGN KEY (jobexecid) REFERENCES {schema}.{tablePrefix}EXECUTIONINSTANCEDATA (jobexecid)
); 

CREATE TABLE {schema}.{tablePrefix}JOBSTATUS (
  id BIGINT NOT NULL CONSTRAINT {schema}.{tablePrefix}JOBSTATUS_PK PRIMARY KEY,
  obj		BLOB,
  CONSTRAINT {schema}.{tablePrefix}JOBSTATUS_JOBINST_FK FOREIGN KEY (id) REFERENCES {schema}.{tablePrefix}JOBINSTANCEDATA (jobinstanceid) ON DELETE CASCADE
);

CREATE TABLE {schema}.{tablePrefix}STEPSTATUS(
  id BIGINT NOT NULL CONSTRAINT {schema}.{tablePrefix}STEPSTATUS_PK PRIMARY KEY,
  obj		BLOB,
  CONSTRAINT {schema}.{tablePrefix}STEPSTATUS_STEPEXEC_FK FOREIGN KEY (id) REFERENCES {schema}.{tablePrefix}STEPEXECUTIONINSTANCEDATA (stepexecid) ON DELETE CASCADE
);

CREATE TABLE {schema}.{tablePrefix}CHECKPOINTDATA(
  id		VARCHAR(512) NOT NULL CONSTRAINT {schema}.{tablePrefix}CHECKPOINTDATA_PK PRIMARY KEY,
  obj		BLOB
);

COMMIT WORK;
DISCONNECT;
  
