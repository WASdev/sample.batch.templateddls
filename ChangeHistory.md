# Change History

Note that in delivering the templates separately from the batch feature binaries, and because we are still in beta, there exists a possibility that we introduce a change in the feature code which requires a corresponding change in the persistence tables (which would be described in a newer version of the DDL templates).  

We will try to avoid this when possible, since it is an extra task to have to go create brand new tables, but we expect to make at least one such change in the course of the beta.

## Potentially Breaking Changes

None at this time 

## Other Changes


### 2014-Oct-09 - Commit SHA: 18311fc99dbefdf40c89630d6c907565e6c80e9d

#### batch-db2-zos.ddl

1.  Added index to each 
    * **EXECUTIONINSTANCEDATA**
    * **STEPEXECUTIONINSTANCEDATA**

1.  Added PK constraint and modified index with UNIQUE to table:

    * **CHECKPOINTDATA**


#### batch-db2.ddl

1. Added index to each table
1. Added sample CREATE TABLESPACE commands.  Along with this, included sample GRANT commands required customization 
1. Refactored earlier commands to use a SET CURRENT SCHEMA.

