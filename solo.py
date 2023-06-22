import subprocess

file = open('samples.txt', "r")
lines = file.readlines()
file.close()

for line in lines:
    subprocess.run('python ~/SCRIPTS/WES_pipeline/vcf2table_solo_may2021.py -c ' + str(line.strip()), shell=True, executable='/bin/bash')
