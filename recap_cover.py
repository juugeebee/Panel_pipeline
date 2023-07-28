import pandas
from os import listdir
import subprocess
import numpy


## SAMPLES
files_l = []
samples_l = []

for f in listdir('.') :
    if ('vcf' in f) and ('idx' not in f) and ('stats' not in f) :
        files_l.append(f)
        file = f.split('.')
        sample = file[0]
        samples_l.append(sample)


print('Fichiers :')
files_l.sort()
print(files_l)
print('\n')

print('Echantillons :')
samples_l.sort()
print(samples_l)
print('\n')


## VARIANTS
var_etalons_l = ['166909695', '166909559', '166909544', '166905480', '166905375', '166903445', '166897864', '166896143', '166894230',
                 '166893081', '166892788', '166859070']

print('Variants :')
var_etalons_l.sort()
print(var_etalons_l)
print('\n')


## DATAFRAME VIDE
df = pandas.DataFrame(index = var_etalons_l, columns = samples_l)

# RECUPERER GREP

ord = 0

for file in files_l :

    abs = 0

    for variant in var_etalons_l :

        now = subprocess.Popen('grep -n -e ' + variant + ' ' + file, stdout=subprocess.PIPE, universal_newlines=True, shell=True)
        result = now.communicate()    
        
        df.iloc[abs, ord] = str(result[0])
        
        abs = abs + 1

    ord = ord + 1 


# DATAFRAME FINAL
columns_l = []

for i in samples_l :
    columns_l.append(i + '_ref')
    columns_l.append(i + '_alt')
    columns_l.append(i + '_rate')

df_final = pandas.DataFrame(index = var_etalons_l, columns = columns_l)


## SPLIT


ref1 = df['ETALON1'].str.split(pat='SB\t', n=1, expand=False).str[1]
ref11 = ref1.str.split(pat=':', n=1, expand=False).str[1]
df_final['ETALON1_ref'] = ref11.str.split(pat=',', n=1, expand=False).str[0]
df_final['ETALON1_ref'].fillna(value=0.0001, inplace=True)
ref111 = ref11.str.split(pat=',', n=1, expand=False).str[1]
df_final['ETALON1_alt'] = ref111.str.split(pat=':', n=1, expand=False).str[0]
df_final['ETALON1_ref'].fillna(value=0.0001, inplace=True)
df_final['ETALON1_rate'] = df_final['ETALON1_alt'].astype(int) / df_final['ETALON1_ref'].astype(int)

df_final['ETALON1_ref'].replace(0.0001, 0.0, inplace=True) 
df_final['ETALON1_alt'].replace(0.0001, 0.0, inplace=True)
df_final['ETALON1_rate'].fillna(0.0, inplace=True)



ref2 = df['ETALON2'].str.split(pat='SB\t', n=1, expand=False).str[1]
ref22 = ref2.str.split(pat=':', n=1, expand=False).str[1]
df_final['ETALON2_ref'] = ref22.str.split(pat=',', n=1, expand=False).str[0]
df_final['ETALON2_ref'].fillna(value=0.0001, inplace=True)
ref222 = ref22.str.split(pat=',', n=1, expand=False).str[1]
df_final['ETALON2_alt'] = ref222.str.split(pat=':', n=1, expand=False).str[0]
df_final['ETALON2_ref'].fillna(value=0.0001, inplace=True)
df_final['ETALON2_rate'] = df_final['ETALON2_alt'].astype(int) / df_final['ETALON2_ref'].astype(int)

df_final['ETALON2_ref'].replace(0.0001, 0.0, inplace=True) 
df_final['ETALON2_alt'].replace(0.0001, 0.0, inplace=True)
df_final['ETALON2_rate'].fillna(0.0, inplace=True)


ref3 = df['ETALON3'].str.split(pat='SB\t', n=1, expand=False).str[1]
ref33 = ref3.str.split(pat=':', n=1, expand=False).str[1]
df_final['ETALON3_ref'] = ref33.str.split(pat=',', n=1, expand=False).str[0]
df_final['ETALON3_ref'].fillna(value=0.0001, inplace=True)
ref333 = ref33.str.split(pat=',', n=1, expand=False).str[1]
df_final['ETALON3_alt'] = ref333.str.split(pat=':', n=1, expand=False).str[0]
df_final['ETALON3_alt'].fillna(value=0.0001, inplace=True)
df_final['ETALON3_rate'] = df_final['ETALON3_alt'].astype(int) / df_final['ETALON3_ref'].astype(int)

df_final['ETALON3_ref'].replace(0.0001, 0.0, inplace=True) 
df_final['ETALON3_alt'].replace(0.0001, 0.0, inplace=True)
df_final['ETALON3_rate'].fillna(0.0, inplace=True)


ref4 = df['ETALON4'].str.split(pat='SB\t', n=1, expand=False).str[1]
ref44 = ref4.str.split(pat=':', n=1, expand=False).str[1]
df_final['ETALON4_ref'] = ref44.str.split(pat=',', n=1, expand=False).str[0]
df_final['ETALON4_ref'].fillna(value=0.0001, inplace=True)
ref444 = ref44.str.split(pat=',', n=1, expand=False).str[1]
df_final['ETALON4_alt'] = ref444.str.split(pat=':', n=1, expand=False).str[0]
df_final['ETALON4_alt'].fillna(value=0.0001, inplace=True)
df_final['ETALON4_rate'] = df_final['ETALON4_alt'].astype(int) / df_final['ETALON4_ref'].astype(int)

df_final['ETALON4_ref'].replace(0.0001, 0.0, inplace=True) 
df_final['ETALON4_alt'].replace(0.0001, 0.0, inplace=True)
df_final['ETALON4_rate'].fillna(0.0, inplace=True)


ref5 = df['ETALON5'].str.split(pat='SB\t', n=1, expand=False).str[1]
ref5.fillna(value='vide', inplace=True)
ref55 = ref5.str.split(pat=':', n=1, expand=False).str[1]
ref55.fillna(value='vide', inplace=True)
df_final['ETALON5_ref'] = ref55.str.split(pat=',', n=1, expand=False).str[0]
df_final['ETALON5_ref'].fillna(value=0.0001, inplace=True)
ref555 = ref55.str.split(pat=',', n=1, expand=False).str[1]
df_final['ETALON5_ref'].replace('vide', 0.0001, inplace=True)
ref555.fillna(value='vide', inplace=True)
df_final['ETALON5_alt'] = ref555.str.split(pat=':', n=1, expand=False).str[0]
df_final['ETALON5_alt'].replace('vide', 0.0001, inplace=True)
df_final['ETALON5_alt'].fillna(value=0.0001, inplace=True)
df_final['ETALON5_rate'] = df_final['ETALON5_alt'].astype(int) / df_final['ETALON5_ref'].astype(int)


df_final['ETALON5_ref'].replace(0.0001, 0.0, inplace=True) 
df_final['ETALON5_alt'].replace(0.0001, 0.0, inplace=True)
df_final['ETALON5_rate'].fillna(0.0, inplace=True)


ref6 = df['ETALON6'].str.split(pat='SB\t', n=1, expand=False).str[1]
ref6.fillna(value='vide', inplace=True)
ref66 = ref6.str.split(pat=':', n=1, expand=False).str[1]
ref66.fillna(value='vide', inplace=True)
df_final['ETALON6_ref'] = ref66.str.split(pat=',', n=1, expand=False).str[0]
df_final['ETALON6_ref'].fillna(value=0.0001, inplace=True)
ref666 = ref66.str.split(pat=',', n=1, expand=False).str[1]
df_final['ETALON6_ref'].replace('vide', 0.0001, inplace=True)
ref666.fillna(value='vide', inplace=True)
df_final['ETALON6_alt'] = ref666.str.split(pat=':', n=1, expand=False).str[0]
df_final['ETALON6_alt'].replace('vide', 0.0001, inplace=True)
df_final['ETALON6_alt'].fillna(value=0.0001, inplace=True)
df_final['ETALON6_rate'] = df_final['ETALON6_alt'].astype(int) / df_final['ETALON6_ref'].astype(int)


df_final['ETALON6_ref'].replace(0.0001, 0.0, inplace=True) 
df_final['ETALON6_alt'].replace(0.0001, 0.0, inplace=True)
df_final['ETALON6_rate'].fillna(0.0, inplace=True)


df_final.to_csv('etalons.txt', '\t')


print('JOB DONE !')