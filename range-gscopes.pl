#!/opt/funnelback/linbin/ActivePerl/bin/perl -w
#=================================================
# rangegscopes.pl
#
# Generates range values for faceted navigation.
#
# Ranges should be defined in the collections ranges.cfg
#
# Usage range-gscopes.pl collection_id

# gscope|range_boundary1|range_boundary2
# eg. 10|n>=0|n<100
# Note: boundary 2 is optional

use strict;

my $script_name="Range facets";
# Read arguments
if ( ( $#ARGV + 1 ) < 1 ) {
    print "\n$script_name\n";
    print "Usage: $0 <collection>\n\n";
    exit 1;
}

my $collection = $ARGV[0];

# Read SEARCH_HOME from the environment
$ENV{"SEARCH_HOME"} =~ /^(.+)$/; # untaint this variable
my $SEARCH_HOME = $1;

# Open ranges configuration file
my $rangefile = "$SEARCH_HOME/conf/$collection/ranges.cfg";
die "Could not open ranges configuration\n" if(not open(RANGEFILE, '<', $rangefile ));
my @rfile = <RANGEFILE>;
close(RANGEFILE);

# Open output gscopes file
my $gsfile = "$SEARCH_HOME/conf/$collection/gscopes_ranges.cfg";
die "Could not open file to write gscope configuration\n" if(not open(GSFILE, '>', $gsfile ));


# For each configuration line read the target metadata field, label, lowerbound, upperbound, Skip invalid lines
foreach my $rdef (@rfile){

  if ($rdef =~ /^#/ || $rdef =~ /^\s*$/) {
  }
  else {
    my @fields=split(/\|/,$rdef);


    my $metaclass = "";
    my $bound1 =  "";
    my $bound2 =  "";

    $metaclass = $fields[0];
    $bound1 = $fields[1];
    if (exists $fields[2]){
      $bound2 = $fields[2];
    }
    my $querystring = "collection=$collection&query=!showall&res=docnums&fmo=true&".getBound($bound1);
    if (exists $fields[2]) {
      $querystring.="&".getBound($bound2);
    }
    $ENV{'QUERY_STRING'} = $querystring;
    my $padrecmd="$SEARCH_HOME/bin/padre-sw";
    my $results=`$padrecmd`;

    #clean results
    #remove comment lines
    $results =~ s/^<!--.*?$//mg;

    #replace gscope number
    $results =~ s/^1 /$metaclass." "/emg;

    #replace empty lines
    $results =~ s/^\s*\n//mg;

    print GSFILE $results;
  }
}

# Converts boundary expression (eg. p>100) into correct Funnelback CGI variable (eg. gt_p=100)
sub getBound {
    my $bound = $_[0];
    my $cgiparam ="";
    if ($bound =~ m/(.+?)<=(.+?)$/) {
        $cgiparam="le_$1=$2";
    }
    elsif ($bound =~ m/(.+?)>=(.+?)$/) {
        $cgiparam="ge_$1=$2";
    }
    elsif ($bound =~ m/(.+?)<(.+?)$/) {
                $cgiparam="lt_$1=$2";
    }
    elsif ($bound =~ m/(.+?)>(.+?)$/) {
        $cgiparam="gt_$1=$2";
    }
    elsif ($bound =~ m/(.+?)!=(.+?)$/) {
        $cgiparam="ne_$1=$2";
    }
    elsif ($bound =~ m/(.+?)=(.+?)$/) {
        $cgiparam="eq_$1=$2";
    }
    else {
        print "invalid range detected";
    }
        return $cgiparam;

}
