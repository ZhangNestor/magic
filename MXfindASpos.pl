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
#  print OUT $arrtse[0]."link".$arrtse[10],"\t",$Ter,"\n";
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
    @arrloc2=split /\-/,$arrloc[5];    
    $MXfirst=$arrloc1[0];
    $MXsecond=$arrloc2[0];
  
  for($i=0;$i<scalar(@arrid_withA3);$i++){
    foreach $id (keys %hasht) {
      @arrid1=split /link/,$id;
      if($arrid1[0]=~m/$arrid_withA3[$i]/){
        @arrexon=split /\#/,$hasht{$id}; 
        for($m=0;$m<scalar(@arrexon);$m++){
          if($arrexon[$m]=~m/$MXfirst/){
            print OUT "MXfirst","\t",$arrid1[1],"\t",$arrid_withA3[$i],"\t",$arrloc[6],"\t",$arrexon[$m],"\t",$hasht{$id},"\n"; 
          }
        }
      }      
    }
  }
  for($i=0;$i<scalar(@arrid_wioA3);$i++){
    foreach $id (keys %hasht) {
      @arrid1=split /link/,$id;
      if($arrid1[0]=~m/$arrid_wioA3[$i]/){
        @arrexon=split /\#/,$hasht{$id};
        for($m=0;$m<scalar(@arrexon);$m++){
          if($arrexon[$m]=~m/$MXsecond/){
            print OUT "MXsecond","\t",$arrid1[1],"\t",$arrid_wioA3[$i],"\t",$arrloc[6],"\t",$arrexon[$m],"\t",$hasht{$id},"\n";   
          }
        }
      }      
    }
  } 
}
