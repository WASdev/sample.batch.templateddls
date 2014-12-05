# Change History

Note that in delivering the templates separately from the batch feature binaries, and because we are still in beta, there exists an ongoing possibility that we introduce a change in the feature code which requires a corresponding change in the persistence tables (which would be described in a newer version of the DDL templates).  

We will try to avoid this when possible, since it is an extra task to have to go create brand new tables, but we expect to continue to make such changes in the course of the beta.

## Breaking Changes

### 2014-December Beta

[Commit 2033fec27ed72492380c5df8c26267326ae93977](https://github.com/WASdev/sample.batch.templateddls/commit/2033fec27ed72492380c5df8c26267326ae93977)

## Potentially Breaking Changes

None at this time 

## Other Changes

### 2014-Nov-11

[Commit 464950b](https://github.com/WASdev/sample.batch.templateddls/commit/464950b558cb8b6303380637994adac5b751b004)

1. All DDLs updated to support cascading deletion on foreign key references.

### 2014-Oct-23

[Commit 5f8d32610](https://github.com/WASdev/sample.batch.templateddls/commit/5f8d3261015e39f3fecc1b1e329312e567154aab)

1.  Reduce length of Oracle trigger name to allow more room for table prefix.

This should be a non-disruptive change.

### 2014-Oct-09 

[Commit 18311fc99](https://github.com/WASdev/sample.batch.templateddls/commit/18311fc99dbefdf40c89630d6c907565e6c80e9d)

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

