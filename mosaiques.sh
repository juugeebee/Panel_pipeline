#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh


##hg38
# REF='/media/jbogoin/Data1/References/fa_hg38/hg38_GenDev/hg38_GenDev.fa'
# TARGETS_CALLING='/media/jbogoin/Data1/References/cibles_panels_NG/mosaiques_SCN1A_hg38.bed'
# TARGETS_QC='/media/jbogoin/Data1/References/cibles_panels_NG/mosaiques_SCN1A_hg38.interval_list'
# GRCh = 'GRCh38'


##hg19
REF='/media/jbogoin/Data1/References/fa_hg19/hg19_std_M-rCRS_Y-PAR-mask.fa'
TARGETS_CALLING='/media/jbogoin/Data1/References/cibles_panels_NG/mosaiques_SCN1A_hg19.bed'
TARGETS_QC='/media/jbogoin/Data1/References/cibles_panels_NG/mosaiques_SCN1A_hg19.interval_list'
GRCh='GRCh37'


echo ""
echo "mosaiques.sh start"
echo ""


## GATK 4 ####
echo '**** GATK ****'

conda activate gatk4

############ HAPLOTYPE CALLER ############
for i in *.dedup.bam;
do SAMPLE=${i%%.*};
gatk --java-options "-XX:ConcGCThreads=1" HaplotypeCaller \
    -R $REF -I ${SAMPLE}.dedup.bam -ERC GVCF --do-not-run-physical-phasing \
    --bam-output ${SAMPLE}.HC.bam --sample-ploidy 12 \
    -O ${SAMPLE}.dedup.GATK_HC.g.vcf -L $TARGETS_CALLING ;
done

INPUT="$(echo *.g.vcf.gz | sed 's/ / --variant /g')"

gatk CombineGVCFs -R $REF --variant $INPUT -O run.g.vcf.gz

for i in *.dedup.bam; 
do sample=${i%%.*};
gatk GenotypeGVCFs -R $REF -V run.g.vcf.gz -O raw_variants.vcf.gz
done



############ MUTECT2 ############
# for i in *.dedup.bam;
# do SAMPLE=${i%%.*};
# gatk --java-options "-XX:ConcGCThreads=1" Mutect2 \
#     -R $REF -I ${SAMPLE}.dedup.bam -ERC BP_RESOLUTION --max-mnp-distance 0 \
#     -O ${SAMPLE}.dedup.GATK_M2.g.vcf \
#     -L $TARGETS_CALLING --max-reads-per-alignment-start 0;
# done


# for i in *.dedup.bam;
# do SAMPLE=${i%%.*};
# gatk --java-options "-XX:ConcGCThreads=1" Mutect2 \
#     -R $REF -I ${SAMPLE}.dedup.bam \
#     -O ${SAMPLE}.dedup.GATK_M2.g.vcf \
#     -L $TARGETS_CALLING;
# done


# for i in *.dedup.GATK_M2.g.vcf;
#     do sample=${i%%.*};
#     gatk FilterMutectCalls -R $REF --variant $i -L $TARGETS_CALLING -O ${sample}.filtered.vcf;
# done


#INPUT="$(echo *.g.vcf.gz | sed 's/ / --variant /g')"


conda deactivate


#### QC ####
# echo '**** QC ****'


# #FASTQC 
# conda activate exome

# parallel -j0 -N 252 fastqc {} ::: *.fastq.gz

# conda deactivate


# conda activate gatk4

# #InsertSize
# parallel gatk --java-options "-Xmx2g" CollectInsertSizeMetrics -I {} -O '{= s/.dedup.bam/.dedup.InsertSize.txt/; =}' -H '{= s/.dedup.bam/.dedup.InsertSize.pdf/; =}' ::: *.dedup.bam


# #pertatgetcoverage
# for i in *.dedup.bam;
# do SAMPLE=${i%%.*}; 
#     gatk CollectHsMetrics \
#     -I $i \
#     -O ${SAMPLE}.hsMetrics.txt \
#     -R $REF \
#     --BAIT_INTERVALS $TARGETS_QC \
#     --TARGET_INTERVALS $TARGETS_QC \
#     --PER_TARGET_COVERAGE ${SAMPLE}.pertargetcoverage.txt;
# done

# conda deactivate


# conda activate exome

# #MULTI QC
# multiqc .

# conda deactivate



# #Cover per target
# conda activate rnaseq

# python ~/SCRIPTS/RNA-Seq/cover_per_target.py

# conda deactivate



# ### CLEAN ####
# echo '**** CLEAN ****'

# if [ ! -d BAM ]; then mkdir BAM; fi
# mv *.dedup.ba* BAM/
# rm -f *.bam
# if [ ! -d FASTQ ]; then mkdir FASTQ; fi
# mv *.fastq.gz FASTQ/
# if [ ! -d gVCF ]; then mkdir gVCF; fi
# mv *.g.vcf.g* gVCF/
# if [ ! -d VCF ]; then mkdir VCF; fi
# mv *vcf.g* VCF/
# if [ ! -d EXCEL ]; then mkdir EXCEL; fi
# if [ ! -d QC ]; then mkdir QC; fi
# if [ ! -d QC/fastqc_data ]; then mkdir QC/fastqc_data; fi
# if [ ! -d QC/illumina_data ]; then mkdir QC/illumina_data; fi
# if [ ! -d QC/picardtools_data ]; then mkdir QC/picardtools_data; fi
# if [ ! -d QC/cover_per_target ]; then mkdir QC/cover_per_target; fi

# mv multiqc* QC/
# mv Reports/ QC/illumina_data
# mv Stats/ QC/illumina_data
# mv *HSMetrics* QC/picardtools_data
# mv *pertargetcoverage.txt QC/picardtools_data
# mv *MarkDupMetrics* QC/picardtools_data
# mv *InsertSize* QC/picardtools_data
# mv *fastqc.* QC/fastqc_data


# ### VCF NORM ####
# echo '**** VCF NORM ****'


# conda activate exome

# cd VCF/

# vt decompose_blocksub raw_variants.vcf.gz -o raw_variants.vtblocksub.vcf.gz
# vt decompose -s raw_variants.vtblocksub.vcf.gz -o raw_variants.vtblocksub.vtdec.vcf.gz
# vt normalize -r $REF -o raw_variants.vtblocksub.vtdec.vtnorm.vcf.gz raw_variants.vtblocksub.vtdec.vcf.gz

# zcat raw_variants.vtblocksub.vtdec.vtnorm.vcf.gz | awk -F "\t" '{if ($5 != "*") print $0}' | bgzip > raw_variants.norm.vcf.gz

# tabix raw_variants.norm.vcf.gz

# rm -f raw_variants.vtblocksub.vcf.gz raw_variants.vtblocksub.vtdec.vcf.gz raw_variants.vtblocksub.vtdec.vtnorm.vcf.gz

# conda deactivate


# ### ANNOTATIONS ###
# echo '**** ANNOTATIONS ****'


# conda activate vep

# vep --cache --offline --fork 12 --species homo_sapiens --refseq \
# --assembly GRCh37 -i raw_variants.norm.vcf.gz -o vep_local_output.vcf \
# --fasta $REF --use_given_ref --format vcf --vcf \
# --sift b --polyphen b --shift_hgvs=1 \
# --ccds --domains --hgvs --hgvsg --symbol --numbers --regulatory --canonical \
# --biotype --tsl --appris --pubmed --variant_class --mane \
# --pick --pick_order rank,mane,biotype,canonical

# conda deactivate


# # remplacement des %3D par des "=" dans les p.

# conda activate exome

# sed -i 's/%3D/=/' vep_local_output.vcf
# bgzip vep_local_output.vcf
# tabix vep_local_output.vcf.gz

# conda deactivate

# conda activate py27

# python ~/SCRIPTS/WES_pipeline/pickle_before_annotation_vep_python2.py
# python ~/SCRIPTS/WES_pipeline/annotation_vep_local.py

# grep -v "^#" vep_and_custom_annotations.vcf > tmp
# cat header.vcf tmp | bgzip > annotated_variants.vcf.gz

# for i in {1..22} X Y; 
# do raw=$(zgrep -c "chr${i}"$'\t' \
#     raw_variants.norm.vcf.gz); annot=$(zgrep -c "chr${i}"$'\t' \
#     annotated_variants.vcf.gz); echo "> chr${i} raw_norm VS annotated: \
#     $raw | $annot" >> compare.log; 
# done

# conda deactivate


# ## Fichiers excel sortie
# cd ../BAM

# for i in *.dedup.bam; 
# do sample=${i%%.*};
# echo $i >> ../VCF/samples.txt;
# done

# cd ../VCF


# conda activate exome

# python ~/SCRIPTS/Panels/solo.py

# mv *.txt ../EXCEL

# conda deactivate


echo ""
echo "mosaiques.sh job done!"
echo ""