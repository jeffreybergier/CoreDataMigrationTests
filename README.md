# Core Data Experiment

## Does CoreData Lightweight Migration Support Multischema Migration

### Background

CoreData supports a feature called Lightweight migration where if you provide 2 versions
of a model with a subset of supported changes then CoreData will automatically migrate
the database schema on load to the newest version.

In this experiment I explore whether this is possible with more than 2 versions. For this feature
to be useful in the field, your app must be able to include multiple database schemas and
when a user updates to the newest version of your app, even if they last launched with a very
old version of the app, Core Data should be able to handle this and get them to the newest
version.

### TL;DR

Core Data does not support this. If you want to support multiple version migration you need
to implement this yourself using manual CoreData mapping models. I have not found a good,
up-to-date, guide on how to do this. But below are some links with references I used:

- [Core Data Model Versioning and Data Migration Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreDataVersioning/Articles/vmMappingOverview.html#//apple_ref/doc/uid/TP40004399-CH5-SW1) Apple Documentation
- [Step By Step Core Data Migration](https://williamboles.me/step-by-step-core-data-migration/) WILLIAM BOLES
- [Progressive Core Data Migrations](https://williamboles.me/progressive-core-data-migration/) WILLIAM BOLES

## Project File

### Framework

The project contains 5 versions of the schema. Each version has one Entity called `BasicEntity`
and the entity has one property named for the version of the schema `v1_1_0_name` which is
an optional string. Each version of the schema has the `renamingID` specified that matches
the name in the previous version.

### Unit Tests

The test bundle contains 5 versions of the database, each created fresh with each version of
the schema. You can analyze these to verify that this is the case with a tool like 
[DB Browser SQLite](https://sqlitebrowser.org). Each database contains 1 instance of `BasicEntity`
with its `vX_Y_Z_name` property set to `A Known Value`. In the unit tests there are 5 tests. 
Each test copies a specific version of the database from bundle to the temporary location and 
then initializes the Core Data stack with this database and attempts to read the value out of it. 
If CoreData throws an error or the property does not match `A Known Value` then the test fails.

### Playing with the tests

You can see how Core Data behaves by changing the `Model Version:Current Version`
by clicking on one of the versions in the Project Navigator in Xcode. Then in the File Inspector,
near the bottom is a dropdown to the choose the current version. After changing the version you
must also change the String under `Stack.currentDBKey` to match the property of the "Current"
version of the database selected.

By changing the version you can see which tests pass and fail base on your selection.

## Results

### Expectations / Hypothesis

Code Data would also be able to properly load and migrate the current version of the database
and one version back. This seems to make sense with the way migration works. It would support
loading N and N-1.

### Actual Results

This does not appear to be the case. Only when selecting the second version of the database
`v1.1.0` does N and N-1 work. When loading any newer version of the database than that, 
Core Data can ONLY load the exact matching version of the schema and does not appear to
migrate the old one. I can only guess that this might be due to the `renamingID` being set 
in the previous version that throws Core Data off and causes it to not work properly.

## Conclusion

Do not rely on Core Data lightweight migration in production. If your plan it to only change the
schema 1 time ever in the lifetime of your product or perhaps 1 time per year, then perhaps this
built-in system will work. But if a customer may ever have an installation with N-2 version of
the database schema installed (and perhaps skip the update inbetween) then your user will
lose data unless you do the work to prepare Core Data for more complex, more manual migrations.

## Methodology Verification

I am no expert in Core Data. I could very easily be doing something wrong here. If you have time
it would be amazing if I could get more eyeballs on this project. Maybe I did something wrong
and this feature works better than I am showing here. If this is the expected performance of
the feature, then I will file a feedback with Apple. It should probably be improved to prevent
data loss. Or, at the very least, the documentation should be updated to reflect how limited 
this feature is.
