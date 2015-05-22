# Update - 

Old tables (from previous beta versions) will no longer work.  

# Batch DDL templates no longer required

Since the DB tables will now be auto-created on first access, the DDL templates are no longer required. 

It is still possible to generate a DDL based on the server configuration, so that it can be customized and used to create the database tables manually.

We will probably post a DB2 z/OS sample template shortly.


## Instructions for manually creating tables

As an alternative to relying on the default auto-creation of batch persistence database tables, you can also follow these instructions to manually create the tables.

1. Edit your server configuration (**server.xml**) so that your batch persistence references the database you wish to use to store the batch persistence tables within.  
	* This chain of references consists of a ***batchPersistence*** element using a ***jobStoreRef*** attribute to reference a **databaseStore**.   The ***databaseStore*** element provides some configuration options such as ***schema*** and ***tablePrefix*** and also refers to a DataSource with connection info to a specific database of a specific database product type.
2. Run the **ddlGen** script: 

    ```
    $ ddlGen <server name>
    ```

3. Customize the generated DDL (i.e. hand off the DDL to your DBA for customization for your DB installation).

4. **OPTIONAL:** If you wish you can eliminate the possibility that your manually-created tables might not be used while the batch feature fails over to its auto-created tables
unexpectedly.    To turn off table auto-creation (and remove this possibility), on the ***databaseStore*** element you can set the ***createTables*** attribute to "false", e.g.:

    ```
    <databaseStore ... createTables="false">
    ```

## References

### [Getting Started links](GettingStarted.md)

### WLP Beta Knowledge Center links
* [Batch top-level topics list](http://www.ibm.com/support/knowledgecenter/was_beta_liberty/com.ibm.websphere.wlp.nd.multiplatform.doc/ae/twlp_container_batch.html)
* [Batch persistence config article](http://www.ibm.com/support/knowledgecenter/was_beta_liberty/com.ibm.websphere.wlp.nd.multiplatform.doc/ae/rwlp_batch_persistence_config.html)



