# ElectionBuddy Technical Test ("Code Challenge")

Mock-ElectionBuddy voters want to be able to see all changes the election administrator did to the election they are voting. You should create a human-readable election audit page that lists all updates to election settings, as well as any changes to questions, answers and voters for that election.

**Please do not use a third-party gem for audit functionality.**

Your implementation should include a public audit page for every election in the system, as well as any abstraction you deem necessary. There are different value types that can be updated (dates, strings, serialized hashes) and each of those values should be appropriately formatted. You should also show information about who made the change and when the change was made.

No particular effort needs to be made on UI/UX as long as it's functional.

You'll note that most of the basic structure (`Election`, `Question`, `Answer`, `Voter`) is in place, with existing tests passing.

## Running

You can run it the usual way: `bundle install`,`bin/rails db:schema:load`, `bundle exec rails server`, or you can use the provided Dockerfile and scripts:

* `./run.sh`: Build and run, bound to localhost port 3000.
* `./test.sh`: Build and run tests (should pass).

Please fork this repository on Github and push your code up to your own fork on Github when completed. **We value your time &mdash; you do not need to finish; spend 1-1.5 hours tops.**

If you have any questions, email Brady at bradyb@electionbuddy.com.

Good luck!


## Comments on code implementation - Tiago Henrique

In order to create an Audit history and avoid making a database table with previous and current versions of each change, I decided to keep updates changes into a versionable system. 
So for each object type, I changed the table to have the new fields: `identification`, `version` and `status`. 
So on each update, it is created a new register with the new version of the data and status, while the old one is kept in the database with the previous information and new status (inactive). 
It also works for deletion, where the status is changed to `deleted` on the action. 

For the Audit list, I placed it in the main page, in order to show all update information, even deletions on elections. 
It is shown separated by Election > Question > Answer, and ordered from older to newer.

All existing tests are passing.
