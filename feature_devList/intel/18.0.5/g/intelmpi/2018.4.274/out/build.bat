#!/bin/sh -l
#PBS -N build.bat
#PBS -l walltime=2:00:00
#PBS -q regular
#PBS -A p93300606
#PBS -l select=1:ncpus=36:mpiprocs=36
JOBID="`echo $PBS_JOBID | cut -d. -f1`"

module load cmake/3.22.0
module load intel/18.0.5 impi/2018.4.274
module load netcdf/4.6.3
module load python/3.7.9

set -x
export ESMPY_DATA_DIR="/glade/work/theurich/esmf-test-data/grids"
export ESMF_DIR=/glade/scratch/theurich/ESMF-Nightly-Testing/intel_18.0.5_intelmpi_g_feature_devList/esmf
export ESMF_COMPILER=intel
export ESMF_COMM=intelmpi
export ESMF_NETCDF=nc-config
export ESMF_BOPT='g'
export ESMF_TESTEXHAUSTIVE='ON'
export ESMF_TESTWITHTHREADS='ON'
module list >& /glade/scratch/theurich/ESMF-Nightly-Testing/intel_18.0.5_intelmpi_g_feature_devList/module-build.log
export WORK_ROOT=/glade/scratch/theurich/ESMF-Nightly-Testing/intel_18.0.5_intelmpi_g_feature_devList
export TEMP_ROOT=/glade/scratch/theurich/ESMF-Nightly-Testing/intel_18.0.5_intelmpi_g_feature_devList
cd $TEMP_ROOT/esmf
export ESMF_DIR=`pwd`
set -o pipefail
make info 2>&1| tee $WORK_ROOT/info.log
make -j 36 2>&1| tee $WORK_ROOT/build.log
