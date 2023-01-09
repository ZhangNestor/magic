#! /usr/bin/perl
$bed=$ARGV[0];
$a3=$ARGV[1];
$out=$ARGV[2];
open BED,"$bed" or die $!;
open A3,"$a3" or die $!;
open OUT,">$out" or die $!;
while(<BED>){
  chomp;
  @arrtse=split /\s+/,$_;
  @arrts=split /\,/,$arrtse[8];
  @arrte=split /\,/,$arrtse[9];
  if($arrtse[2]=~/\+/){
    $Ter="1*A-".$arrte[0]."#";
    $hashtexse{$arrtse[11]}{"A-".$arrte[0]}=1;
    for($m=1;$m<scalar(@arrts)-1;$m++){
      $ter=($m+1)."*".$arrts[$m]."-".$arrte[$m]."#";
      $Ter=$Ter.$ter;
      $hashtexse{$arrtse[11]}{$arrts[$m]."-".$arrte[$m]}=1;
    }
    $Ter=$Ter.($m+1)."*".$arrts[$m]."-B";
    $hashtexse{$arrtse[11]}{$arrts[$m]."-B"}; 
    $hasht{$arrtse[0]."link".$arrtse[10]}=$Ter;
  }
  if($arrtse[2]=~/\-/){
    @rarrts=reverse(@arrts);
    @rarrte=reverse(@arrte);
    $Ter="1*".$rarrts[0]."-A#";
    $hashtexse{$arrtse[11]}{$rarrts[0]."-A"}=1;
    for($m=1;$m<scalar(@arrts)-1;$m++){
      $ter=($m+1)."*".$rarrts[$m]."-".$rarrte[$m]."#";
      $Ter=$Ter.$ter;
      $hashtexse{$arrtse[11]}{$rarrts[$m]."-".$rarrte[$m]}=1;
    }
    $Ter=$Ter.($m+1)."*B-".$rarrte[$m]."#";
    $hashtexse{$arrtse[11]}{"B-".$rarrte[$m]};
    $hasht{$arrtse[0]."link".$arrtse[10]}=$Ter;
  }
#  print OUT "TEST","\t",$arrtse[0],"\t",$Ter,"\n";
}
while(<A3>){
  chomp;
  @arra3=split /\s+/,$_;
  @arrid_withexon=split /\,/,$arra3[3];
  @arrid_skipexon=split /\,/,$arra3[4];
  my %sorter;
  @sorter{ @arrid_withexon } = ();
  my @arrid_skipexon = grep ! exists $sorter{$_}, @arrid_skipexon;
  @arrloc=split /\:/,$arra3[2];
  @arrloc1=split /\-/,$arrloc[2];
 
  for($i=0;$i<scalar(@arrid_withexon);$i++){
    foreach $id (keys %hasht) {
      @arrid1=split /link/,$id;
      if($arrid1[0]=~m/$arrid_withexon[$i]/){
        @arrexon=split /\#/,$hasht{$id};
        for($m=0;$m<scalar(@arrexon);$m++){
          if($arrexon[$m]=~m/$arrloc1[0]/ && $arrloc[4]=~m/\-/){
            print OUT "Withexon","\t",$arrid1[1],"\t",$arrid_withexon[$i],"\t",$arrloc[4],"\t",$arrexon[$m-1],"\t",$hasht{$id},"\n";
          }
          if($arrexon[$m]=~m/$arrloc1[0]/ && $arrloc[4]=~m/\+/){
            print OUT "Withexon","\t",$arrid1[1],"\t",$arrid_withexon[$i],"\t",$arrloc[4],"\t",$arrexon[$m+1],"\t",$hasht{$id},"\n";
          }
        }
      }
    }
  }

  for($i=0;$i<scalar(@arrid_skipexon);$i++){
    foreach $id (keys %hasht) {
      @arrid1=split /link/,$id;
      if($arrid1[0]=~m/$arrid_skipexon[$i]/){
        @arrexon=split /\#/,$hasht{$id}; 
        for($m=0;$m<scalar(@arrexon);$m++){
          if($arrexon[$m]=~m/$arrloc1[0]/ && $arrloc[4]=~m/\-/){
            print OUT "Skipexon","\t",$arrid1[1],"\t",$arrid_skipexon[$i],"\t",$arrloc[4],"\t",$arrexon[$m],"\t",$hasht{$id},"\n"; 
          }
          if($arrexon[$m]=~m/$arrloc1[0]/ && $arrloc[4]=~m/\+/){
            print OUT "Skipexon","\t",$arrid1[1],"\t",$arrid_skipexon[$i],"\t",$arrloc[4],"\t",$arrexon[$m],"\t",$hasht{$id},"\n"; 
          }
        }
      }    
    }
  }

}

