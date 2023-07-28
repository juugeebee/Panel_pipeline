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
# for i in *.dedup.bam;
# do SAMPLE=${i%%.*};
# gatk --java-options "-XX:ConcGCThreads=1" HaplotypeCaller \
#     -R $REF -I ${SAMPLE}.dedup.bam -ERC GVCF --do-not-run-physical-phasing \
#     --bam-output ${SAMPLE}.HC.bam --sample-ploidy 12 \
#     -O ${SAMPLE}.dedup.GATK_HC.g.vcf -L $TARGETS_CALLING ;
# done


############ MUTECT2 ############
for i in *.dedup.bam;
do SAMPLE=${i%%.*};
gatk --java-options "-XX:ConcGCThreads=1" Mutect2 \
    -R $REF -I ${SAMPLE}.dedup.bam -ERC BP_RESOLUTION --max-mnp-distance 0 \
    -O ${SAMPLE}.dedup.GATK_M2.g.vcf \
    -L $TARGETS_CALLING --max-reads-per-alignment-start 0;
done

conda deactivate


############ FREEBAYES ############
# conda activate freebayes

# for i in *.dedup.bam;
# do SAMPLE=${i%%.*};
# freebayes -f $REF $i --gvcf > ${SAMPLE}.var.vcf;
# done

# conda deactivate

############ QC ############
# echo '**** QC ****'


# #FASTQC 

# conda activate exome
# parallel -j0 -N 252 fastqc {} ::: *.fastq.gz
# conda deactivate

# conda activate gatk4


# #InsertSize

# parallel gatk --java-options "-Xmx2g" CollectInsertSizeMetrics \
#     -I {} -O '{= s/.dedup.bam/.dedup.InsertSize.txt/; =}' \
#     -H '{= s/.dedup.bam/.dedup.InsertSize.pdf/; =}' ::: *.dedup.bam


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


# #Cover per target

# conda activate rnaseq
# python ~/SCRIPTS/RNA-Seq/cover_per_target.py
# conda deactivate


# #MULTI QC

# conda activate exome
# multiqc .
# conda deactivate


echo ""
echo "mosaiques.sh job done!"
echo ""