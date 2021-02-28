#usage: sh 01plot.sh human_V_genes 
# 2021/02/27
mkdir plots
module load R/4.0.0-foss-2019b

for file in $1/*
do
	str=$(basename $file)
        geneName=${str%%.*}
        cd 'Cov_'$geneName
	perl ../scripts/editDM.pl ${geneName}.phylip outfile > ${geneName}.dm
        echo "location date dist" > ${geneName}.list
        awk 'NR>2 {print $1,$2}' ${geneName}.dm | awk -F'[/|]' '{print $2,$NF}' >> ${geneName}.list
	Rscript ../scripts/plot.R ${geneName}.list >> ../clockRate.txt
        cp *.pdf ../plots
        cd ..

done
