#!/usr/bin/perl

use strict;
use warnings;

use File::Temp qw(tempfile);
use POSIX;
use Scalar::Util qw(openhandle);
use Test::More tests => 11;

use Log::Any qw($log);
use Log::Any::Adapter;

ok( Log::Any::Adapter->set( 'Duperr', log_level => 'info' ), 'Set adapter Duperr' );

ok( openhandle(*STDERR),                             'STDERR is open' );
ok( print( STDERR "# print stderr before close\n" ), 'Print STDERR before close' );

ok( close STDERR, 'close STDERR' );

ok( !openhandle(*STDERR),                            'STDERR is close' );
ok( !print( STDERR "# print stderr after close\n" ), 'NO print stderr after close' );

ok( my $tmp_fh = tempfile(),      'Open tempfile' );
ok( my $tmp_fd = fileno($tmp_fh), 'Get tempfile fd' );
ok( dup2( $tmp_fd, 3 ), 'Duplicate tempfile fd to duperr fd' );

my $message = "# print duperr";

ok( $log->warning($message), 'Print Duperr' );

$tmp_fh->seek( 0, 0 );
my $line = $tmp_fh->getline;

is( $line, "$message\n", 'Duperr message OK' );
