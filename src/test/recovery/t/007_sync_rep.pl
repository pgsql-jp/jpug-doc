# Minimal test testing synchronous replication sync_state transition
use strict;
use warnings;
use PostgresNode;
use TestLib;
use Test::More tests => 8;

# Query checking sync_priority and sync_state of each standby
my $check_sql =
"SELECT application_name, sync_priority, sync_state FROM pg_stat_replication ORDER BY application_name;";

# Check that sync_state of each standby is expected.
# If $setting is given, synchronous_standby_names is set to it and
# the configuration file is reloaded before the test.
sub test_sync_state
{
	my ($self, $expected, $msg, $setting) = @_;

	if (defined($setting))
	{
		$self->psql('postgres',
			"ALTER SYSTEM SET synchronous_standby_names = '$setting';");
		$self->reload;
	}

	my $timeout_max = 30;
	my $timeout     = 0;
	my $result;

	# A reload may take some time to take effect on busy machines,
	# hence use a loop with a timeout to give some room for the test
	# to pass.
	while ($timeout < $timeout_max)
	{
		$result = $self->safe_psql('postgres', $check_sql);

		last if ($result eq $expected);

		$timeout++;
		sleep 1;
	}

	is($result, $expected, $msg);
}

# Initialize master node
my $node_master = get_new_node('master');
$node_master->init(allows_streaming => 1);
$node_master->start;
my $backup_name = 'master_backup';

# Take backup
$node_master->backup($backup_name);

# Create standby1 linking to master
my $node_standby_1 = get_new_node('standby1');
$node_standby_1->init_from_backup($node_master, $backup_name,
	has_streaming => 1);
$node_standby_1->start;

# Create standby2 linking to master
my $node_standby_2 = get_new_node('standby2');
$node_standby_2->init_from_backup($node_master, $backup_name,
	has_streaming => 1);
$node_standby_2->start;

# Create standby3 linking to master
my $node_standby_3 = get_new_node('standby3');
$node_standby_3->init_from_backup($node_master, $backup_name,
	has_streaming => 1);
$node_standby_3->start;

# Check that sync_state is determined correctly when
# synchronous_standby_names is specified in old syntax.
test_sync_state(
	$node_master, qq(standby1|1|sync
standby2|2|potential
standby3|0|async),
	'old syntax of synchronous_standby_names',
	'standby1,standby2');

# Check that all the standbys are considered as either sync or
# potential when * is specified in synchronous_standby_names.
# Note that standby1 is chosen as sync standby because
# it's stored in the head of WalSnd array which manages
# all the standbys though they have the same priority.
test_sync_state(
	$node_master, qq(standby1|1|sync
standby2|1|potential
standby3|1|potential),
	'asterisk in synchronous_standby_names',
	'*');

# Stop and start standbys to rearrange the order of standbys
# in WalSnd array. Now, if standbys have the same priority,
# standby2 is selected preferentially and standby3 is next.
$node_standby_1->stop;
$node_standby_2->stop;
$node_standby_3->stop;

$node_standby_2->start;
$node_standby_3->start;

# Specify 2 as the number of sync standbys.
# Check that two standbys are in 'sync' state.
test_sync_state(
	$node_master, qq(standby2|2|sync
standby3|3|sync),
	'2 synchronous standbys',
	'2(standby1,standby2,standby3)');

# Start standby1
$node_standby_1->start;

# Create standby4 linking to master
my $node_standby_4 = get_new_node('standby4');
$node_standby_4->init_from_backup($node_master, $backup_name,
	has_streaming => 1);
$node_standby_4->start;

# Check that standby1 and standby2 whose names appear earlier in
# synchronous_standby_names are considered as sync. Also check that
# standby3 appearing later represents potential, and standby4 is
# in 'async' state because it's not in the list.
test_sync_state(
	$node_master, qq(standby1|1|sync
standby2|2|sync
standby3|3|potential
standby4|0|async),
	'2 sync, 1 potential, and 1 async');

# Check that sync_state of each standby is determined correctly
# when num_sync exceeds the number of names of potential sync standbys
# specified in synchronous_standby_names.
test_sync_state(
	$node_master, qq(standby1|0|async
standby2|4|sync
standby3|3|sync
standby4|1|sync),
	'num_sync exceeds the num of potential sync standbys',
	'6(standby4,standby0,standby3,standby2)');

# The setting that * comes before another standby name is acceptable
# but does not make sense in most cases. Check that sync_state is
# chosen properly even in case of that setting.
# The priority of standby2 should be 2 because it matches * first.
test_sync_state(
	$node_master, qq(standby1|1|sync
standby2|2|sync
standby3|2|potential
standby4|2|potential),
	'asterisk comes before another standby name',
	'2(standby1,*,standby2)');

# Check that the setting of '2(*)' chooses standby2 and standby3 that are stored
# earlier in WalSnd array as sync standbys.
test_sync_state(
	$node_master, qq(standby1|1|potential
standby2|1|sync
standby3|1|sync
standby4|1|potential),
	'multiple standbys having the same priority are chosen as sync',
	'2(*)');

# Stop Standby3 which is considered in 'sync' state.
$node_standby_3->stop;

# Check that the state of standby1 stored earlier in WalSnd array than
# standby4 is transited from potential to sync.
test_sync_state(
	$node_master, qq(standby1|1|sync
standby2|1|sync
standby4|1|potential),
	'potential standby found earlier in array is promoted to sync');
