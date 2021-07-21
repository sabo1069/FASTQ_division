#!/usr/bin/perl
use strict;
######Discription#################################
#This program for dividing fastq sequence
#date 170223
#----------------------------------------------------


######input file###################################
my $fastq_file=$ARGV[0]; #please input fastq_file
my $read_count=$ARGV[1];#please input read_number
#----------------------------------------------------


open (FILE, "gunzip -c $fastq_file | ") or die "cannot open file";

$fastq_file=~s/\S+\///;
my $count=1;
my $divided_count=1;
my $read_count_div=$read_count*4;


while (my $file = <FILE>) {
    chomp $file;
    
    if ($count==1){
        my $out_put_name=$fastq_file;
        $out_put_name=$divided_count."_".$out_put_name;
        open OUTPUT, "| gzip >$out_put_name\n" or die "cannot open file";
        print "$out_put_name\n";
        $divided_count+=1;
    }
    
    print OUTPUT "$file\n";
    
    $count+=1;
    if ($read_count_div==$count-1){
        $count=1;
    } 
}




