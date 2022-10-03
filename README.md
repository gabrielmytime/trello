# MyTrello API


## TASKS
1. support CRUD operations for boards / columns / stories - Rest APIs => **DONE**
2. support ordering of columns/stories => **DONE**
3. stories have status and due date and want an API endpoint which will allow us to filter by 1 or more statuses and 1 or more dates => **DONE**
4. auth + access control (one user can have no access OR view access OR edit access to a board)
5. fix N+1 - be able to pull all boards with all columns and all stories on a single API endpoint (e.g. /boards?include_columns=true&include_stories=true) => **DONE**
6. archive stories older than 1 year using an asynchronous job (add status to stories and one status should be archived)
7. Audit trail - track changes in DB
8. Soft delete - do not hard delete things, just soft delete them => **DONE**
9. json logs on STDOUT - structured logs => **DONE**

Test everything - rspec-rails: controllers / models / presenters / service objects / policies / etc.