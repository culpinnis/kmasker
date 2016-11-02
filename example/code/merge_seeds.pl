#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;
use kmasker::occ;
my $tab;
my $percent;

 GetOptions ("tab=s"   => \$tab,  
             "percent=i" => \$percent) 
 or die("Error in command line arguments\n");

kmasker::occ::merge_seeds($tab, $percent);