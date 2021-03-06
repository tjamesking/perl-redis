#!/usr/bin/perl

use warnings;
use strict;
use Benchmark qw/:all/;
use lib 'lib';
use Redis;
use Redis::Hash;

my $r = Redis->new;

my %hash;
tie %hash, 'Redis::Hash', 'hash';

my $i = 0;

timethese(
  -5,
  { '00_ping'   => sub { $r->ping },
    '10_set'    => sub { $r->set('foo', $i++) },
    '11_set_r'  => sub { $r->set('bench-' . rand(), rand()) },
    '20_get'    => sub { $r->get('foo') },
    '21_get_r'  => sub { $r->get('bench-' . rand()) },
    '30_incr'   => sub { $r->incr('counter') },
    '30_incr_r' => sub { $r->incr('bench-' . rand()) },
    '40_lpush'  => sub { $r->lpush('mylist', 'bar') },
    '40_lpush'  => sub { $r->lpush('mylist', 'bar') },
    '50_lpop'   => sub { $r->lpop('mylist') },
    '90_h_set'  => sub { $hash{ 'test' . rand() } = rand() },
    '90_h_get'  => sub { my $a = $hash{ 'test' . rand() }; },
  }
);
