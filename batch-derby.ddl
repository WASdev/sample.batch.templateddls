-------------------------------------------------------------
-- COPYRIGHT LICENSE: This information contains sample code provided in source code form. You may copy, modify, and distribute these sample programs in any form without payment to IBM for the purposes of developing, using, marketing or distributing application programs conforming to the application programming interface for the operating platform for which the sample code is written. Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.

-- (C) Copyright IBM Corp. 2014.
-- All Rights Reserved. Licensed Materials - Property of IBM.  
-------------------------------------------------------------

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
  appname   VARCHAR(512),
  jobxmlname VARCHAR(512),
  submitter VARCHAR(512),
  jobxml    BLOB
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
  logpath       VARCHAR(512),
  CONSTRAINT {schema}.{tablePrefix}JOBINST_JOBEXEC_FK FOREIGN KEY (jobinstanceid) REFERENCES {schema}.{tablePrefix}JOBINSTANCEDATA (jobinstanceid) ON DELETE CASCADE
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
	CONSTRAINT {schema}.{tablePrefix}JOBEXEC_STEPEXEC_FK FOREIGN KEY (jobexecid) REFERENCES {schema}.{tablePrefix}EXECUTIONINSTANCEDATA (jobexecid) ON DELETE CASCADE
); 

CREATE TABLE {schema}.{tablePrefix}JOBSTATUS (
  jobinstanceid BIGINT NOT NULL CONSTRAINT {schema}.{tablePrefix}JOBSTATUS_PK PRIMARY KEY,
  batchstatus  VARCHAR(512),
  exitstatus   VARCHAR(512),
  latestjobexecid BIGINT,
  currentstepid VARCHAR(512),
  restarton VARCHAR(512),
  CONSTRAINT {schema}.{tablePrefix}JOBSTATUS_JOBINST_FK FOREIGN KEY (jobinstanceid) REFERENCES {schema}.{tablePrefix}JOBINSTANCEDATA (jobinstanceid) ON DELETE CASCADE,
  CONSTRAINT {schema}.{tablePrefix}JOBSTATUS_JOBEXEC_FK FOREIGN KEY (latestjobexecid) REFERENCES {schema}.{tablePrefix}EXECUTIONINSTANCEDATA (jobexecid) ON DELETE CASCADE
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
  
