#! /usr/bin/perl -w

use strict;
use warnings FATAL => 'all';
use File::Basename;
use File::Path;

$| = 1;
my ( $filename, $directories, $suffix ) = fileparse($0);
my $basedir  = $directories . "../..";
my $fmtdir   = $basedir . "/formats";
my $srcdir   = $basedir . "/src";
my $pngdir   = $srcdir . "/png";
my $txtdir   = $srcdir . "/txt";
my $ifl      = "identify_format_list_";
my @variants = ( "Black", "White", "No" );

chdir("$txtdir");

if (
    system(
            "paste "
          . $ifl
          . "{Format_lc,Description}.txt | tee "
          . $ifl
          . "Format_and_Description.txt"
    )
  )
{
    die "Cannot create file " . $ifl . "Format_and_Description.txt: $!\n";
} ## end if ( system( "paste " ...))

if ( system( "git add " . $ifl . "Format_and_Description.txt" ) ) {
    die "Cannot git add " . $ifl . "Format_and_Description.txt: $!\n";
}

unless (
    system(
            "git commit --dry-run -m \"New Format and Description List.\" "
          . $ifl
          . "Format_and_Description.txt"
    )
  )
{
    if (
        system(
                "git commit -m \"New Format and Description List.\" "
              . $ifl
              . "Format_and_Description.txt"
        )
      )
    {
        die "Cannot git commit " . $ifl . "Format_and_Description.txt: $!\n";
    } ## end if ( system( "git commit -m \"New Format and Description List.\" "...))
} ## end unless ( system( ...))

unless ( open( IFL, $ifl . "Format_and_Description.txt" ) ) {
    die "Cannot open file " . $ifl
      . "Format_and_Description.txt for reading: $!\n";
}

while (<IFL>) {
    chomp $_;
    my ( $frmt, $dscrptn ) = split( /\t/, $_ );

    #print $frmt . " -- " . $dscrptn . "\n";

    my $frmtdir = $fmtdir . "/" . $frmt;
    if ( !-d $frmtdir ) {
        unless ( mkdir($frmtdir) ) {
            die "Cannot create directory " . $frmtdir . ": $!\n";
        }
    }

    foreach my $variant (@variants) {
        my $srcfile = $pngdir . "/Surge-Logo-" . $variant . "-Outline.png";
        my $frmtfile =
          $frmtdir . "/Surge-Logo-" . $variant . "-Outline." . $frmt;
        my $cmd = "convert " . $srcfile . " " . $frmtfile;
        print "Running: \"$cmd\"...";
        if ( system($cmd ) ) {
            die "Command \"" . $cmd . "\" failed: $!\n";
        }
        print "done.\n";

        unless ( -f $frmtfile ) {
            die "Did not create file " . $frmtfile . ": $!\n";
        }

        if ( system( "git add " . $frmtdir ) ) {
            die "Cannot git add " . $frmtdir . ": $!\n";
        }

        unless (
            system(
                "git commit --dry-run -m \"" . $dscrptn . "\" " . $frmtdir
            )
          )
        {
            if ( system( "git commit -m \"" . $dscrptn . "\" " . $frmtdir ) ) {
                die "Cannot git commit " . $frmtdir . ": $!\n";
            }
        } ## end unless ( system( "git commit --dry-run -m \""...))

        unless ( system("git status | grep 'Surge-Logo-'") ) {
            die "Extra files found!\n";
        }

    } ## end foreach my $variant (@variants)
} ## end while (<IFL>)

close(IFL);
