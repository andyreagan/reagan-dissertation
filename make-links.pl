#!/usr/bin/perl
# make links into package directory

$usage = "
usage: makelinks.pl foo-combined.tex
(works for any latex file)

use after make-single-latex-file.pl
which will switch pdf to ps (using .eps)

copies foo-combined.tex to ./package
and replaces figure names by fig01, fig02, etc.

see end of file for localized pieces
";

if ($#ARGV < 0)
{
    print $usage;
    exit;
}

$file = $ARGV[0];

unless (-e $file)
{
    print $usage;
    exit;
}

# clean out the package directory
# `\\rm package/*`;

# find figures

$outfile = "package/$file";
open (FILE,$file) or die "can't open $file: $!\n";
open (OUTFILE,">$outfile") or die "can't open $outfile: $!\n";

$i = 1;
foreach $line (<FILE>)
{
    unless ($line =~ m/\s*%/) {
	if ($line =~ m/\\includegraphics\[.*?\]\{(.*?)\}/) {
	    $figfile = $1;
	    push @fullfigures, $figfile;
	    $fullfigure = $figfile;
	    $figfile =~ s/^.*\///;
	    push @figures, $figfile;
	    if ($i<10) {$fignum = "0$i";} else {$fignum = $i;}
	    $prefix = "fig".$fignum."_";
	    `cp $fullfigure package/$prefix$figfile`;
	    $line =~ s/(\\includegraphics.*?)\{(.*?)\}/$1\{$prefix$figfile\}/;
	    # covert all to EPS
# 	    if ($figfile =~ m/\.pdf/) {
# 		$figfile =~ s/\.pdf//;
# 		`pdf2ps package/$prefix$figfile.{pdf,ps}`;
# 		`ps2eps package/$prefix$figfile.ps`;
# 		`rm package/$prefix$figfile.pdf`;
# 		`rm package/$prefix$figfile.ps`;
# 	    }
# 	    if ($figfile =~ m/\.ps/) {
# 		`ps2eps package/$prefix$figfile`;
# 		`rm package/$prefix$figfile.ps`;
# 	    }
# 	    if ($figfile =~ m/\.jpg/) {
# 		$figfile =~ s/\.jpg//;
# 		`convert package/$prefix$figfile.{jpg,eps}`;
# 		`rm package/$prefix$figfile.jpg`;
# 	    }
# 	    if ($figfile =~ m/\.png/) {
# 		$figfile =~ s/\.png//;
# 		`convert package/$prefix$figfile.{png,eps}`;
# 		`rm package/$prefix$figfile.png`;
# 	    }
# 	    $line =~ s/\.pdf/.eps/;
# 	    $line =~ s/\.ps/.eps/;
# 	    $line =~ s/\.jpg/.eps/;
# 	    $line =~ s/\.png/.eps/;
	    # covert all to PDF
	    if ($figfile =~ m/\.ps/) {
		`ps2eps package/$prefix$figfile`;
		`rm package/$prefix$figfile.ps`;
	    }
	    if ($figfile =~ m/\.jpg/) {
		$figfile =~ s/\.jpg//;
		`convert package/$prefix$figfile.{jpg,pdf}`;
		`rm package/$prefix$figfile.jpg`;
	    }
	    if ($figfile =~ m/\.png/) {
		$figfile =~ s/\.png//;
		`convert package/$prefix$figfile.{png,pdf}`;
		`rm package/$prefix$figfile.png`;
	    }
	    $line =~ s/\.ps/.pdf/;
	    $line =~ s/\.jpg/.pdf/;
	    $line =~ s/\.png/.pdf/;
 	    $i = $i + 1;
	}
    }
    print OUTFILE $line;
}

close FILE;
close OUTFILE;

# foreach $i (0..$#figures)
# {
#     $figure = $figures[$i];
#     $tmp = `find . -follow -name $figure -print 2>/dev/null`;
#     @tmp = split("\n",$tmp);
#     $fullfigures[$i] = $tmp[0];
#     chomp($fullfigures[$i]);
# }

# $i=1;
# foreach $fullfigure (@fullfigures)
# {
#     ($figname = $fullfigure) =~ s/.*\///;
#     $figname =~ s/\.ps/.eps/;
#     if ($i<10) {$fignum = "0$i";} else {$fignum = $i;}
#     $prefix = "fig".$fignum."_";
#     `cp $fullfigure package/$prefix$figname`;
#     `ln -s ../$fullfigure package/.`;
#     $i = $i+1;
# }
