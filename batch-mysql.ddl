-------------------------------------------------------------
-- COPYRIGHT LICENSE: This information contains sample code provided in source code form. You may copy, modify, and distribute these sample programs in any form without payment to IBM for the purposes of developing, using, marketing or distributing application programs conforming to the application programming interface for the operating platform for which the sample code is written. Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.

-- (C) Copyright IBM Corp. 2014.
-- All Rights Reserved. Licensed Materials - Property of IBM.  
-------------------------------------------------------------


CREATE TABLE IF NOT EXISTS JOBINSTANCEDATA(
  jobinstanceid   BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  name    VARCHAR(512), 
  apptag VARCHAR(512),
  appname   VARCHAR(512),
  jobxmlname VARCHAR(512),
  submitter VARCHAR(512),
  jobxml    BLOB
);

CREATE TABLE IF NOT EXISTS EXECUTIONINSTANCEDATA(
  jobexecid     BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  jobinstanceid BIGINT,
  createtime  TIMESTAMP,
  starttime   TIMESTAMP,
  endtime   TIMESTAMP,
  updatetime  TIMESTAMP,
  parameters  BLOB,
  batchstatus   VARCHAR(512),
  exitstatus    VARCHAR(512),
  serverId VARCHAR(512),
  logpath       VARCHAR(512),
  CONSTRAINT JOBINST_JOBEXEC_FK FOREIGN KEY (jobinstanceid) REFERENCES JOBINSTANCEDATA (jobinstanceid) ON DELETE CASCADE
  );
  
CREATE TABLE IF NOT EXISTS STEPEXECUTIONINSTANCEDATA(
  stepexecid    BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  jobexecid BIGINT,
  batchstatus       VARCHAR(512),
  exitstatus      VARCHAR(512),
  stepname        VARCHAR(512),
  readcount         INT,
  writecount        INT,
  commitcount       INT,
  rollbackcount     INT,
  readskipcount     INT,
  processskipcount  INT,
  filtercount       INT,
  writeskipcount    INT,
  startTime           TIMESTAMP,
  endTime             TIMESTAMP,
  persistentData    BLOB,
  CONSTRAINT JOBEXEC_STEPEXEC_FK FOREIGN KEY (jobexecid) REFERENCES EXECUTIONINSTANCEDATA (jobexecid) ON DELETE CASCADE
);  

CREATE TABLE IF NOT EXISTS JOBSTATUS (
  jobinstanceid		BIGINT NOT NULL PRIMARY KEY,
  batchstatus  VARCHAR(512),
  exitstatus   VARCHAR(512),
  latestjobexecid BIGINT,
  currentstepid VARCHAR(512),
  restarton VARCHAR(512),
  CONSTRAINT JOBSTATUS_JOBINST_FK FOREIGN KEY (jobinstanceid) REFERENCES JOBINSTANCEDATA (jobinstanceid) ON DELETE CASCADE,
  CONSTRAINT JOBSTATUS_JOBEXEC_FK FOREIGN KEY (latestjobexecid) REFERENCES EXECUTIONINSTANCEDATA (jobexecid) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS STEPSTATUS(
  id		BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT, 
  obj   BLOB,
  CONSTRAINT STEPSTATUS_STEPEXEC_FK FOREIGN KEY (id) REFERENCES STEPEXECUTIONINSTANCEDATA (stepexecid) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS CHECKPOINTDATA(
  id		VARCHAR(512) NOT NULL PRIMARY KEY,
  obj		BLOB
);

  
