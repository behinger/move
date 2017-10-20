#!/bin/sh

# request "/bin/sh" as shell for job
#$ -S /bin/sh
matlab -nodisplay -nojvm -r "gridParam=$SGE_TASK_ID;amica_grid_v2;"
