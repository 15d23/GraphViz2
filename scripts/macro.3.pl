#!/usr/bin/env perl
#
# Note: t/test.t searches for the next line.
# Annotation: Demonstrates cluster subgraphs via a macro.

use strict;
use warnings;

use File::Spec;

use GraphViz2;

use Log::Handler;

# -----------------------------------------------

sub macro
{
	my($graph, $name, $node_1, $node_2) = @_;

	$graph -> push_subgraph
		(
		 name  => $name,
		 graph => {label => $name},
		 node  => {color => 'magenta', shape => 'diamond'},
		);

	$graph -> add_node(name => $node_1, shape => 'hexagon');
	$graph -> add_node(name => $node_2, color => 'orange');

	$graph -> add_edge(from => $node_1, to => $node_2);

	$graph -> pop_subgraph;

} # End of macro.

# -----------------------------------------------

my($logger) = Log::Handler -> new;

$logger -> add
	(
	 screen =>
	 {
		 maxlevel       => 'debug',
		 message_layout => '%m',
		 minlevel       => 'error',
	 }
	);

my($id)    = '3';
my($graph) = GraphViz2 -> new
	(
	 edge   => {color => 'grey'},
	 global => {directed => 1},
	 graph  => {label => "Macro demo $id - Cluster sub-graphs", rankdir => 'TB'},
	 logger => $logger,
	 node   => {shape => 'oval'},
	);

macro($graph, 'cluster 1', 'Chadstone', 'Waverley');
macro($graph, 'cluster 2', 'Hughesdale', 'Notting Hill');

my($format)      = shift || 'svg';
my($output_file) = shift || File::Spec -> catfile('html', "macro.$id.$format");

$graph -> run(format => $format, output_file => $output_file);
