# Breaking change with December 2014 beta update

Old tables (from previous beta versions) will no longer work.  These should be dropped, if necessary, and new tables should be created from the new DDL templates. 

# Java Batch persistence DDL templates

Persistence templates which are **REQUIRED** for using the Java batch function

## Instructions
1. Download appropriate DDL template for your database type
2. Customize schema, table prefix, and anything else using find/replace
3. Create database tables based on customized DDL.
4. In your server config, define a DataSource pointing to your database (and a JDBC driver def. if necessary)
5. Configure your server's batch persistence by pointing to this DataSource

## Tested Databases

**Note:** This list is intended to capture which DDLs have been used in testing, and not to give a complete test statement regarding database product versions, JDBC driver versions, etc.

- DB2 LUW [batch-db2.ddl](batch-db2.ddl)
- DB2 z/OS [batch-db2-zos.ddl](batch-db2-zos.ddl)
- Apache Derby [batch-derby.ddl](batch-derby.ddl)
- Oracle [batch-oracle.ddl](batch-oracle.ddl)

## Change History

See [ChangeHistory.md](ChangeHistory.md) for details on breaking and non-breaking changes across the various beta levels.

## References

### Getting Started links
[Links here](GettingStarted.md)

### WLP Beta Knowledge Center links
* [Batch top-level topics list](http://www.ibm.com/support/knowledgecenter/was_beta_liberty/com.ibm.websphere.wlp.nd.multiplatform.doc/ae/twlp_container_batch.html)
* [Batch persistence config article](http://www.ibm.com/support/knowledgecenter/was_beta_liberty/com.ibm.websphere.wlp.nd.multiplatform.doc/ae/rwlp_batch_persistence_config.html)


