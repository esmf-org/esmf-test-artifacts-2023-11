#!/bin/sh -l
#PBS -N test.bat
#PBS -l walltime=2:00:00
#PBS -q main
#PBS -A p93300606
#PBS -l select=1:ncpus=128:mpiprocs=128
JOBID="`echo $PBS_JOBID | cut -d. -f1`"

module load cmake
module load intel-classic/2023.0.0 
module load netcdf/4.9.2

set -x
export ESMF_DIR=/glade/derecho/scratch/theurich/ESMF-Nightly-Testing/intel_2023.0.0-classic_mpiuni_O_feature_devList/esmf
export ESMF_COMPILER=intel
export ESMF_COMM=mpiuni
export ESMF_NETCDF=nc-config
export ESMF_BOPT='O'
export ESMF_TESTEXHAUSTIVE='ON'
export ESMF_TESTWITHTHREADS='ON'
export ESMF_MPIRUN=/glade/derecho/scratch/theurich/ESMF-Nightly-Testing/intel_2023.0.0-classic_mpiuni_O_feature_devList/esmf/src/Infrastructure/stubs/mpiuni/mpirun
module list >& /glade/derecho/scratch/theurich/ESMF-Nightly-Testing/intel_2023.0.0-classic_mpiuni_O_feature_devList/module-test.log
export WORK_ROOT=/glade/derecho/scratch/theurich/ESMF-Nightly-Testing/intel_2023.0.0-classic_mpiuni_O_feature_devList
export TEMP_ROOT=/glade/derecho/scratch/theurich/ESMF-Nightly-Testing/intel_2023.0.0-classic_mpiuni_O_feature_devList
cd $TEMP_ROOT/esmf
export ESMF_DIR=`pwd`
make install 2>&1| tee $WORK_ROOT/install.log
make all_tests 2>&1| tee $WORK_ROOT/test.log
export ESMFMKFILE=`find $PWD/DEFAULTINSTALLDIR -iname esmf.mk`
