#! /usr/bin/perl
$bed=$ARGV[0];
$a3=$ARGV[1];
$out1=$ARGV[2];
$out2=$ARGV[3];
open BED,"$bed" or die $!;
open A3,"$a3" or die $!;
open OUT1,">$out1" or die $!;
open OUT2,">$out2" or die $!;
while(<BED>){
  chomp;
  @arrtse=split /\s+/,$_;
  @arrts=split /\,/,$arrtse[8];
  @arrte=split /\,/,$arrtse[9];
    $hasht{$arrtse[0]."links".$arrtse[10]}="@arrts";
    $hasht{$arrtse[0]."linke".$arrtse[10]}="@arrte";
}
while(<A3>){
  chomp;
  @arra3=split /\s+/,$_;
  @arrid_withA3=split /\,/,$arra3[3];
  @arrid_wioA3=split /\,/,$arra3[4];
  my %sorter;
  @sorter{ @arrid_withA3 } = ();
  my @arrid_wioA3 = grep ! exists $sorter{$_}, @arrid_wioA3;
  @arrloc=split /\:/,$arra3[2];
  @arrloc1=split /\-/,$arrloc[3];
  $RIstart=$arrloc1[0]+1;
  $RIend=$arrloc1[1]-2;
  $arrts1=$hasht{$arrid_wioA3[0]."links".$arra3[1]};
  $arrts2=$hasht{$arrid_wioA3[0]."linke".$arra3[1]};
  @arrts11=split /\s+/,$arrts1;
  @arrts22=split /\s+/,$arrts2;
#  print OUT $arrid_wioA3[0],"\t",scalar(@arrts11),"\t",scalar(@arrts22),"\n";
  push @arrts11,$RIstart;
  push @arrts22,$RIend;
  my @arrts111 = sort {$a<=>$b} @arrts11;
  my @arrts222 = sort {$a<=>$b} @arrts22;
  for($i=0;$i<scalar(@arrts111);$i++){
    if($arrts111[$i]==$RIstart){
      print OUT1 $arra3[3],"\t",$arrloc[5],"\t",($i+1)."*".$RIstart."-".$RIend,"\t";
    }
  }
  for($i=0;$i<scalar(@arrts111);$i++){
    print OUT1 ($i+1)."*".$arrts111[$i]."-".$arrts222[$i]."#";
  }
  print OUT1 "\n";
  print OUT2 $arra3[3],"\t",$arrloc[1],"\t",$arrloc[5],"\t",scalar(@arrts111),"\t",join(',',@arrts111),"\t",join(',',@arrts222),"\n"; 
}
