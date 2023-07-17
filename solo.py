import subprocess

file = open('samples.txt', "r")
lines = file.readlines()
file.close()

for line in lines:
    var = line.split('.')
    print(var[0])
    subprocess.run('python ~/SCRIPTS/WES_pipeline/vcf2table_solo_may2021.py -c ' + str(var[0]), shell=True, executable='/bin/bash')
