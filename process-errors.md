# process-errors.groovy

## Purpose 

Processes the `url_errors.log` of a web collection and produces as summary of the errors and a `url_errors.json` log extending the information in the `url_errors.log`.

The summary information is written to stdout, and the `url_errors.json` file is written to the same folder as the `url_errors.log`.

## Configuration

### Step 1: Install `process-errors.groovy`

Download the `process-errors.groovy` script and copy it to the collection's configuration/@workflow folder (Note: you might need to create the `@workflow` folder).  

### Step 2: Run the script

The script can be run on the command line:

`groovy -cp '$SEARCH_HOME/lib/java/all/*' $SEARCH_HOME/conf/$COLLECTION_NAME/@workflow/process-errors.groovy $SEARCH_HOME $COLLECTION_NAME $CURRENT_VIEW`

Parameters are:
* $SEARCH_HOME is the path to the Funnelback install root
* $COLLECTION_NAME is the collection id
* $CURRENT_VIEW is the view to inspect (live or offline)

The report can be added to a collection's workflow by adding the following to the `collection.cfg`.

	post_gather_command=$GROOVY_COMMAND -cp '$SEARCH_HOME/lib/java/all/*' $SEARCH_HOME/conf/$COLLECTION_NAME/@workflow/process-errors.groovy $SEARCH_HOME $COLLECTION_NAME $CURRENT_VIEW
