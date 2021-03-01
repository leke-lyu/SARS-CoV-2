#usage: sh 01plot.sh human_V_genes 

mkdir plots
mkdir tables
module load R/4.0.0-foss-2019b

for file in $1/*
do
	str=$(basename $file)
        geneName=${str%%.*}
        cd 'Cov_'$geneName
	perl ../scripts/editDM.pl ${geneName}.phylip outfile > ${geneName}.dm
        echo "location date dist" > ${geneName}.list
        awk 'NR>2 {print $1,$2}' ${geneName}.dm | awk -F'[/|]' '{print $2,$NF}' >> ${geneName}.list
	Rscript ../scripts/plot1.R ${geneName}.list
	cp ${geneName}.table ../tables
        cp *.pdf ../plots
        cd ..
done

cd tables
Rscript ../scripts/plot2.R
cd ..
