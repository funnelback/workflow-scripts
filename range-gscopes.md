# range-gscopes.pl

## Purpose 

Sets up generalised scopes for numeric ranges.  The ranges can then be used for scoping or for faceted navigation categories.

Please note that range facets are supported natively since Funnelback 15.12.

## Configuration

### Step 1: Install range-gscopes.pl

Download the range-gscopes.pl script and copy it to the collection's configuration/@workflow folder (Note: you might need to create the @workflow folder).  Change the ownership and permissions to ensure that it can be executed by the search.  This can normally be done with the following commands.

	# Change the ownership
	chown search:search $SEARCH_HOME/conf/COLLECTION/@workflow/range-gscopes.pl
	# Change the permissions
	chmod 755 $SEARCH_HOME/conf/COLLECTION/@workflow/range-gscopes.pl

### Step 2: Range configuration

Create a ranges.cfg within the collection's configuration folder.

The ranges.cfg details a gscope number and the range boundaries for the numeric metadata field.

The file format of ranges.cfg is as follows:

[gscope number]|[boundary expression 1]|[boundary expression2]

boundary expression 2 is optional.

Lines prefixed with # are treated as comments.

eg.

	# This is a comment
	# Assigns gscope 10 to items with P>=0<100
	10|P>=0|P<100
	# Assigns gscope 11 to items with P>=100<200
	11|P>=100|P<200
	# Assigns gscope 12 to items with P>=200
	12|P>=200

Values where numeric metadata field P>=0, P<100 are assigned a gscope value of 10; P>100, P<200 are assigned gscope 11 and P>200 are assigned gscope 12.

The range expression uses the following format:

[metadata class][operator][value]

Metadata class must be a numeric (type 3) metadata field

Operator must be one of the following >,>=,<,<=,=,!=

Value is the numeric comparison value

Edit the collection's gscopes.cfg file to add placeholders for the gscope numbers that were chosen for the ranges.cfg.  This will ensure that anybody who edits the gscopes.cfg will not reuse those gscope numbers for something else (which will mean that the ranges generated include some items that shouldn't be included).

	10 RESERVEDFORNUMERICFACETS!!
	11 RESERVEDFORNUMERICFACETS!!
	12 RESERVEDFORNUMERICFACETS!!

### Step 3: Workflow command

Add the following command to the collection's workflow

	post_swap_command=$SEARCH_HOME/conf/$COLLECTION_NAME/@workflow/range-gscopes.pl $COLLECTION_NAME && $SEARCH_HOME/bin/padre-gs $SEARCH_HOME/data/$COLLECTION_NAME/live/idx/index $SEARCH_HOME/conf/$COLLECTION_NAME/gscopes-ranges.cfg -docnum

Note: This command must run after the indexes have swapped, but before any index push occurs (if using in a multi-server environment). The queries the search index to find pages that match the configured ranges, and applies this information back into the index for use with faceted navigation.

### Step 4: Run a collection update

Run an update of the collection.  Upon completion of the update there should be gscopes defined for the collection that correspond to the ranges that were configured in step 2.

