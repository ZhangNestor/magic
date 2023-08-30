#! /usr/bin/perl
$aa=$ARGV[0];
$out1=$ARGV[1];
$out2=$ARGV[2];
open AA,"$aa" or die $!;
open OUT1,">$out1" or die $!;
open OUT2,">$out2" or die $!;
while(<AA>){
  chomp;
  @arraa=split /\s+/,$_;
  for($i=0;$i<=length($arraa[2])-9;$i++){
    $hash{$arraa[0]}{substr($arraa[2],$i,9)}=1;
    $hashfinal{substr($arraa[2],$i,9)}=1;
  }
}
foreach $keyiso(keys %hash){
# print OUT $hash{$keyiso},"\n";
  @aaout=keys (%{$hash{$keyiso}});
#  print OUT "@aaout","\n";
  for($m=0;$m<scalar(@aaout);$m++){
    print OUT1 $keyiso,"\t",$aaout[$m],"\n";
  }
}
foreach $keyaa(keys %hashfinal){
  print OUT2 $keyaa,"\n";
}
