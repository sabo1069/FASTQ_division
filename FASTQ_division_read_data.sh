#! /bin/sh
#$ -S /bin/sh
#$ -cwd


FASTQ_directory=/lustre7/home/lustre3/takagi-hiroki/fastq/FASTQ_division_210519/Divided_FASTQ
first_read_name=_1.fq.gz
second_read_name=_2.fq.gz

FASTQ_directory=`echo ${FASTQ_directory}|sed -e "s/\/\$//"`
FASTQ_name=`ls -F ${FASTQ_directory}|grep /|sed -e "s/\///g"`


if [ -e read_data.txt ]; then
  rm read_data.txt
fi
touch read_data.txt

for sample_directory in $FASTQ_name
do

  first_read_data=`ls ${FASTQ_directory}/${sample_directory}/*${first_read_name}`
  for each_first_read_data in $first_read_data
  do

    each_second_read_data=`echo ${each_first_read_data}|sed -e "s/${first_read_name}/${second_read_name}/"`
    echo -e "${sample_directory}\t${each_first_read_data}\t${each_second_read_data}">>read_data.txt

  done

done
