#!/bin/sh
#usage: sh 00geneticDistance.sh human_V_genes 

for file in $1/*
do
	str=$(basename $file)
	geneName=${str%%.*}
	
	mkdir 'Cov_'$geneName
	cd 'Cov_'$geneName
	perl ../scripts/Fasta2Phylip.pl ../human_V_genes/${geneName}.fasta ${geneName}.phylip
	sed -n '1p' ${geneName}.phylip > infile
	awk 'NR>1 {printf "%-10s",NR;print $2}' ${geneName}.phylip >> infile
	
	echo -e "#!/bin/bash\n#SBATCH --job-name=geneticDistance"$geneName"	#Job name\n#SBATCH --partition=highmem_p     #Partition (queue) name\n#SBATCH --ntasks=1     #Run a single task\n#SBATCH --cpus-per-task=16  #Number of CPU cores per task\n#SBATCH --mem=10gb       #Job memory request\n#SBATCH --time=2:00:00     #Time limit hrs:min:sec\n#SBATCH --output=highmemtest.%j.out    #Standard output log\n#SBATCH --error=highmemtest.%j.err        #Standard error log\n#SBATCH --mail-type=END,FAIL       #Mail events (NONE, BEGIN, END, FAIL, ALL)\n#SBATCH --mail-user=ll22780@uga.edu #Where to send mail\n" > run.sh
	echo -e 'cd $SLURM_SUBMIT_DIR' >> run.sh
	echo -e "module load PHYLIP/3.697-foss-2019b\ntime cat my_option_file | dnadist > run.log" >> run.sh	
	
	echo "D" > my_option_file
	echo "Y" >> my_option_file
	
	sbatch run.sh
	cd ..		
done
