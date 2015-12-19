# To test successful data directory creation with a additional feature, first
# try to elaborate the "successful creation" test instead of adding a test.
# Successful initdb consumes much time and I/O.

use strict;
use warnings;
use TestLib;
use Test::More tests => 19;

my $tempdir = TestLib::tempdir;
my $xlogdir = "$tempdir/pgxlog";
my $datadir = "$tempdir/data";

program_help_ok('initdb');
program_version_ok('initdb');
program_options_handling_ok('initdb');

command_fails([ 'initdb', '-S', "$tempdir/nonexistent" ],
	'sync missing data directory');
<<<<<<< HEAD
mkdir "$tempdir/data4" or BAIL_OUT($!);
command_ok([ 'initdb', "$tempdir/data4" ], 'existing empty data directory');

system_or_bail "rm -rf '$tempdir'/*";

command_ok([ 'initdb', '-X', "$tempdir/pgxlog", "$tempdir/data" ],
	'separate xlog directory');

system_or_bail "rm -rf '$tempdir'/*";
=======

mkdir $xlogdir;
mkdir "$xlogdir/lost+found";
>>>>>>> FETCH_HEAD
command_fails(
	[ 'initdb', '-X', $xlogdir, $datadir ],
	'existing nonempty xlog directory');
rmdir "$xlogdir/lost+found";
command_fails(
	[ 'initdb', '-X', 'pgxlog', $datadir ],
	'relative xlog directory not allowed');

<<<<<<< HEAD
system_or_bail "rm -rf '$tempdir'/*";
mkdir "$tempdir/pgxlog";
command_ok([ 'initdb', '-X', "$tempdir/pgxlog", "$tempdir/data" ],
	'existing empty xlog directory');

system_or_bail "rm -rf '$tempdir'/*";
mkdir "$tempdir/pgxlog";
mkdir "$tempdir/pgxlog/lost+found";
command_fails([ 'initdb', '-X', "$tempdir/pgxlog", "$tempdir/data" ],
	'existing nonempty xlog directory');

system_or_bail "rm -rf '$tempdir'/*";
command_ok([ 'initdb', '-T', 'german', "$tempdir/data" ],
	'select default dictionary');
=======
mkdir $datadir;
command_ok([ 'initdb', '-N', '-T', 'german', '-X', $xlogdir, $datadir ],
	'successful creation');

command_ok([ 'initdb', '-S', $datadir ], 'sync only');
command_fails([ 'initdb', $datadir ], 'existing data directory');
>>>>>>> FETCH_HEAD
