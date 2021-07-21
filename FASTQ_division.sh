#! /bin/sh
#$ -S /bin/sh
#$ -cwd

How_many_reads=4000000
FASTQ_directory=/lustre7/home/lustre3/takagi-hiroki/fastq/FASTQ_row_data
thred_num=4
extension_name=fq.gz


FASTQ_directory=`echo ${FASTQ_directory}|sed -e "s/\/\$//"`
FASTQ_name=`ls -F ${FASTQ_directory}|grep /|sed -e "s/\///g"`

mkdir Divided_FASTQ
cd Divided_FASTQ

for sample_directory in $FASTQ_name
do
  mkdir ${sample_directory}

  if [ -e ${sample_directory}_fastq_list.txt ]; then
    rm ${sample_directory}_fastq_list.txt
  fi
  touch ${sample_directory}_fastq_list.txt

  if [ -e ${sample_directory}_rm_fastq_list.txt ]; then
    rm ${sample_directory}_rm_fastq_list.txt
  fi
  touch ${sample_directory}_rm_fastq_list.txt

  if [ -e ${sample_directory}_mv_fastq_list.txt ]; then
    rm ${sample_directory}_mv_fastq_list.txt
  fi
  touch ${sample_directory}_mv_fastq_list.txt

  each_sample_directory=`ls ${FASTQ_directory}/${sample_directory}/*${extension_name}`
  ls  ${each_sample_directory}|xargs -n1 -P${thred_num} -I % echo "perl ../script/170223_fastq_divistion.pl % ${How_many_reads}">>${sample_directory}_fastq_list.txt
  ls  ${each_sample_directory}|xargs -n1 -P${thred_num} -I % echo "rm %">>${sample_directory}_rm_fastq_list.txt
  ls  ${each_sample_directory}|sed -e "s/.*\\///"|xargs -n1 -P${thred_num} -I % echo "mv *% ${sample_directory}">>${sample_directory}_mv_fastq_list.txt

done

mkdir xargs_files
for sample_directory in $FASTQ_name
do
  cat ${sample_directory}_fastq_list.txt |xargs -n1 -P${thred_num} -I % sh -c %
  cat ${sample_directory}_mv_fastq_list.txt |xargs -n1 -P${thred_num} -I % sh -c %
  cat ${sample_directory}_rm_fastq_list.txt |xargs -n1 -P${thred_num} -I % sh -c %
  mv ${sample_directory}*_fastq_list.txt xargs_files
done
