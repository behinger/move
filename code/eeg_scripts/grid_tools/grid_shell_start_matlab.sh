#!/bin/sh

# request "/bin/sh" as shell for job
#$ -S /bin/sh
#set
#echo $SGE_TASK_ID
#echo $filename
LD_LIBRARY_PATH=/usr/local/JMF-2.1.1e/lib:/opt/matlab2010a/runtime/glnxa64:/net/store/nbp/eeg_et/tools/libeep-3.3.163/installation/lib
nice -n 7 matlab -nodisplay -nojvm -r "gridParam=$SGE_TASK_ID;mv_grid_runner;"
