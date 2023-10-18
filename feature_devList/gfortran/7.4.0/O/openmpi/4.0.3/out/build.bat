#!/bin/sh -l
#PBS -N build.bat
#PBS -l walltime=1:00:00
#PBS -q regular
#PBS -A p93300606
#PBS -l select=1:ncpus=36:mpiprocs=36
JOBID="`echo $PBS_JOBID | cut -d. -f1`"

module load python/3.7.9 cmake/3.22.0
module load gnu/7.4.0 openmpi/4.0.3
module load netcdf/4.7.3

set -x
export ESMF_DIR=/glade/scratch/theurich/ESMF-Nightly-Testing/gfortran_7.4.0_openmpi_O_feature_devList/esmf
export ESMF_COMPILER=gfortran
export ESMF_COMM=openmpi
export ESMF_NETCDF=nc-config
export ESMF_BOPT='O'
export ESMF_TESTEXHAUSTIVE='ON'
export ESMF_TESTWITHTHREADS='ON'
module list >& /glade/scratch/theurich/ESMF-Nightly-Testing/gfortran_7.4.0_openmpi_O_feature_devList/module-build.log
export WORK_ROOT=/glade/scratch/theurich/ESMF-Nightly-Testing/gfortran_7.4.0_openmpi_O_feature_devList
export TEMP_ROOT=/glade/scratch/theurich/ESMF-Nightly-Testing/gfortran_7.4.0_openmpi_O_feature_devList
cd $TEMP_ROOT/esmf
export ESMF_DIR=`pwd`
set -o pipefail
make info 2>&1| tee $WORK_ROOT/info.log
make -j 36 2>&1| tee $WORK_ROOT/build.log
