#!/bin/sh -l
#PBS -N test.bat
#PBS -l walltime=2:00:00
#PBS -q regular
#PBS -A p93300606
#PBS -l select=1:ncpus=36:mpiprocs=36
JOBID="`echo $PBS_JOBID | cut -d. -f1`"

module load cmake/3.22.0
module load gnu/13.1.0 mpt/2.25
module load netcdf/4.9.1
module load python/3.7.9

set -x
export ESMPY_DATA_DIR="/glade/work/theurich/esmf-test-data/grids"
export ESMF_DIR=/glade/scratch/theurich/ESMF-Nightly-Testing/gfortran_13.1.0_mpt_g_develop/esmf
export ESMF_COMPILER=gfortran
export ESMF_COMM=mpt
export ESMF_NETCDF=nc-config
export ESMF_BOPT='g'
export ESMF_TESTEXHAUSTIVE='ON'
export ESMF_TESTWITHTHREADS='ON'
module list >& /glade/scratch/theurich/ESMF-Nightly-Testing/gfortran_13.1.0_mpt_g_develop/module-test.log
export WORK_ROOT=/glade/scratch/theurich/ESMF-Nightly-Testing/gfortran_13.1.0_mpt_g_develop
export TEMP_ROOT=/glade/scratch/theurich/ESMF-Nightly-Testing/gfortran_13.1.0_mpt_g_develop
cd $TEMP_ROOT/esmf
export ESMF_DIR=`pwd`
make install 2>&1| tee $WORK_ROOT/install.log
make all_tests 2>&1| tee $WORK_ROOT/test.log
export ESMFMKFILE=`find $PWD/DEFAULTINSTALLDIR -iname esmf.mk`
cd ../nuopc-app-prototypes
./testProtos.sh 2>&1| tee $WORK_ROOT/nuopc.log
ssh cheyenne6 /glade/scratch/theurich/ESMF-Nightly-Testing/gfortran_13.1.0_mpt_g_develop/esmpy_install.bat
cd /glade/scratch/theurich/ESMF-Nightly-Testing/gfortran_13.1.0_mpt_g_develop
. esmpy_venv/bin/activate
cd /glade/scratch/theurich/ESMF-Nightly-Testing/gfortran_13.1.0_mpt_g_develop/esmf/src/addon/esmpy
make test 2>&1| tee /glade/scratch/theurich/ESMF-Nightly-Testing/gfortran_13.1.0_mpt_g_develop/esmpy-test.log
deactivate
