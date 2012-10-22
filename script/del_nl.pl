use 5.14.0;

open my $fh, "<", $ARGV[0];
my @lines = <$fh>;
close $fh;

my $src = 0;
my $res = "";

for (@lines) {
	s/\t/    /g;

	if ($src) {
		if (m/^```/) {
			$src = 0;
		}
		$res .= $_;
	} 
	elsif (m/^\s*\* .*[^*]$/ || m/^(#|\d+\. | {4}|>)/) {
		$res .= $_;
	}
	elsif ($_ eq "\n") {
		$res .= "\n$_";
	}
	elsif (m/^```/) {
		$res .= $_;
		$src++;
	}
	else {
		$res .= (s/\n$//r);
	}
}

open $fh, ">", $ARGV[1];
print $fh $res;
close $fh;
