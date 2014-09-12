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
  jobinstanceid   BIGINT NOT NULL PRIMARY KEY IDENTITY,
  name    VARCHAR(512), 
  apptag VARCHAR(512),
  appname   VARCHAR(512)
);

CREATE TABLE EXECUTIONINSTANCEDATA(
  jobexecid  BIGINT NOT NULL PRIMARY KEY IDENTITY, 
  jobinstanceid BIGINT,
  createtime  DATETIME,
  starttime   DATETIME,
  endtime   DATETIME,
  updatetime  DATETIME,
  parameters  VARBINARY,
  batchstatus   VARCHAR(512),
  exitstatus    VARCHAR(512),
  serverId VARCHAR(512),
  CONSTRAINT JOBINST_JOBEXEC_FK FOREIGN KEY (jobinstanceid) REFERENCES JOBINSTANCEDATA (jobinstanceid)
);

CREATE TABLE STEPEXECUTIONINSTANCEDATA(
  stepexecid BIGINT NOT NULL PRIMARY KEY IDENTITY, 
  jobexecid BIGINT,
  batchstatus         VARCHAR(512),
    exitstatus      VARCHAR(512),
    stepname      VARCHAR(512),
  readcount       INTEGER,
  writecount      INTEGER,
  commitcount     INTEGER,
  rollbackcount   INTEGER,
  readskipcount   INTEGER,
  processskipcount  INTEGER,
  filtercount       INTEGER,
  writeskipcount    INTEGER,
  startTime           DATETIME,
  endTime             DATETIME,
  persistentData    VARBINARY,
  CONSTRAINT JOBEXEC_STEPEXEC_FK FOREIGN KEY (jobexecid) REFERENCES EXECUTIONINSTANCEDATA (jobexecid)
);  

CREATE TABLE JOBSTATUS (
  id		BIGINT NOT NULL PRIMARY KEY,
  obj		VARBINARY,
  CONSTRAINT JOBSTATUS_JOBINST_FK FOREIGN KEY (id) REFERENCES JOBINSTANCEDATA (jobinstanceid) ON DELETE CASCADE
);

CREATE TABLE STEPSTATUS(
  id		BIGINT NOT NULL PRIMARY KEY,
  obj		VARBINARY,
  CONSTRAINT STEPSTATUS_STEPEXEC_FK FOREIGN KEY (id) REFERENCES STEPEXECUTIONINSTANCEDATA (stepexecid) ON DELETE CASCADE
);

CREATE TABLE CHECKPOINTDATA(
  id		VARCHAR(512) NOT NULL PRIMARY KEY,
  obj		VARBINARY
);

  
