#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 7;

use Log::Any::Adapter;

ok(my @stderr_stat = STDERR->stat, 'Get stat for STDERR');

ok( Log::Any::Adapter->set( 'Duperr', log_level => 'info' ), 'Set adapter Duperr' );

ok(my @duperr_stat_1 = $Log::Any::Adapter::Duperr::duperr->stat, 'Get stat for Duperr');

is_deeply(\@stderr_stat, \@duperr_stat_1, 'Stat for STDERR eq Duperr after set adapter Duperr');

ok( close STDERR, 'Close STDERR' );

ok(my @duperr_stat_2 = $Log::Any::Adapter::Duperr::duperr->stat, 'Get stat for Duperr');

is_deeply(\@stderr_stat, \@duperr_stat_2, 'Stat for STDERR eq Duperr after close STDERR');
