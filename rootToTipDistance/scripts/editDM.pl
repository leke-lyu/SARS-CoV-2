use strict;
use warnings;

my $file_0 = $ARGV[0];
open IN,$file_0;
my @tagID;
while(<IN>){
	chomp;
	my @line = split/\s+/,$_;
	push @tagID,$line[0];
}
close IN;
shift(@tagID);

my $file_1 = $ARGV[1];
open IN,$file_1;
my @dist;
while(<IN>){
	chomp;
	if($_ =~ /^\d/){
		print "@dist\n";
		my $tag = shift(@tagID);
		print "$tag	";
		@dist = ();
		my @line = split/\s+/,$_;
		shift(@line);
		push @dist,@line
	}else{
		$_ =~ s/^\s//;
		my @line = split/\s+/,$_;
		push @dist,@line;
	}
}
print "@dist\n";
close IN;
