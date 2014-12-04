-------------------------------------------------------------
-- COPYRIGHT LICENSE: This information contains sample code provided in source code form. You may copy, modify, and distribute these sample programs in any form without payment to IBM for the purposes of developing, using, marketing or distributing application programs conforming to the application programming interface for the operating platform for which the sample code is written. Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.

-- (C) Copyright IBM Corp. 2014.
-- All Rights Reserved. Licensed Materials - Property of IBM.  
-------------------------------------------------------------


DROP TABLE JOBSTATUS;

DROP TABLE STEPSTATUS;

DROP TABLE CHECKPOINTDATA;

DROP TABLE JOBINSTANCEDATA;

DROP TABLE EXECUTIONINSTANCEDATA;

DROP TABLE STEPEXECUTIONINSTANCEDATA;

CREATE TABLE JOBINSTANCEDATA(
  jobinstanceid		serial not null PRIMARY KEY,
  name		character varying (512), 
  apptag VARCHAR(512),
  appname   VARCHAR(512),
  jobxmlname VARCHAR(512),
  submitter VARCHAR(512),
  jobxml    BLOB
);

CREATE TABLE EXECUTIONINSTANCEDATA(
  jobexecid		serial not null PRIMARY KEY,
  jobinstanceid	bigint not null REFERENCES JOBINSTANCEDATA (jobinstanceid) ON DELETE CASCADE,
  createtime	timestamp,
  starttime		timestamp,
  endtime		timestamp,
  updatetime	timestamp,
  parameters	bytea,
  batchstatus		character varying (512),
  exitstatus		character varying (512),
  serverId character varying(512),
  logpath           character varying (512)
);
  
CREATE TABLE STEPEXECUTIONINSTANCEDATA(
	stepexecid			serial not null PRIMARY KEY,
	jobexecid			bigint not null REFERENCES EXECUTIONINSTANCEDATA (jobexecid) ON DELETE CASCADE,
	batchstatus         character varying (512),
    exitstatus			character varying (512),
    stepname			character varying (512),
	readcount			integer,
	writecount			integer,
	commitcount         integer,
	rollbackcount		integer,
	readskipcount		integer,
	processskipcount	integer,
	filtercount			integer,
	writeskipcount		integer,
	startTime           timestamp,
	endTime             timestamp,
	persistentData		bytea
); 

CREATE TABLE JOBSTATUS (
  jobinstanceid		bigint not null REFERENCES JOBINSTANCEDATA (jobinstanceid),
  batchstatus  VARCHAR(512),
  exitstatus   VARCHAR(512),
  latestjobexecid BIGINT REFERENCES EXECUTIONINSTANCEDATA (jobexecid),
  currentstepid VARCHAR(512),
  restarton VARCHAR(512),
);

CREATE TABLE STEPSTATUS(
  id		bigint not null REFERENCES STEPEXECUTIONINSTANCEDATA (stepexecid),
  obj		bytea
);

CREATE TABLE CHECKPOINTDATA(
  id		character varying (512) not null PRIMARY KEY,
  obj		bytea
);

 
