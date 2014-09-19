# Getting Started with WebSphere Managed Batch

## Product download links

* [Sept 2014 beta announcement](https://developer.ibm.com/wasdev/2014/09/12/announcing-liberty-profile-september-beta)
* [Download page](https://developer.ibm.com/wasdev/downloads/liberty-profile-beta)

## WLP Beta Knowledge Center links

* [Batch top-level topics list](http://www.ibm.com/support/knowledgecenter/was_beta_liberty/com.ibm.websphere.wlp.nd.multiplatform.doc/ae/twlp_container_batch.html)
* [Known limitations/restrictions] (http://www.ibm.com/support/knowledgecenter/was_beta_liberty/com.ibm.websphere.wlp.nd.multiplatform.doc/ae/rwlp_batch_restrict.html)

## WDT Batch Tools Knowledge Center links
* [Top-level topics list] (http://www.ibm.com/support/knowledgecenter/was_beta_devtools/com.ibm.websphere.wdt.doc/topics/t_container_batch.htm)

## Batch persistence config

* [Batch persistence config article](http://www.ibm.com/support/knowledgecenter/was_beta_liberty/com.ibm.websphere.wlp.nd.multiplatform.doc/ae/rwlp_batch_persistence_config.html)
* [DDL Template README](README.md)

## Samples links

* [sleepybatchlet sample](https://github.com/WASdev/sample.batch.sleepybatchlet) - Our first very simple sample - (Executes a job right within a servlet)
* [bonuspayout sample](https://github.com/WASdev/sample.batch.bonuspayout) - Our first moderately complicated sample -  (Executes a job using our remote dispatch/management interface, with the **jbatch** utility)

# Common problems

## Java 7 prereq

Note that the server will start, with Java 6, but the batch-related features/bundles and applications will not

```
[ERROR   ] CWWKF0001E: A feature definition could not be found for com.ibm.websphere.appserver.javax.interceptor-1.1
[ERROR   ] CWWKF0032E: The com.ibm.websphere.appserver.javax.ejb-3.2 feature requires a minimum Java runtime environment version of JavaSE 1.7.
...
[ERROR   ] CWWKE0702E: Could not resolve module: com.ibm.ws.openwebbeans-impl.1.1.6 [80]
  Unresolved requirement: Import-Package: javax.interceptor; version="[1.1.0,2.0.0)"
...
[AUDIT   ] CWWKZ0012I: The application BonusPayoutControllerEAR was not started.
[AUDIT   ] CWWKF0011I: The server BonusPayout is ready to run a smarter planet.
```


