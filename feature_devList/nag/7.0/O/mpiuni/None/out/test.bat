#!/bin/bash -l
export JOBID=NO_BATCH
module load CMake/3.24.3
module load compiler/nag/7.0 
module load tool/netcdf/4.6.1/nag

set -x
export ESMF_DIR=/project/esmf/theurich/ESMF-Nightly-Testing/nag_7.0_mpiuni_O_feature_devList/esmf
export ESMF_COMPILER=nag
export ESMF_COMM=mpiuni
export ESMF_NETCDF=nc-config
export ESMF_BOPT='O'
export ESMF_TESTEXHAUSTIVE='ON'
export ESMF_TESTWITHTHREADS='ON'
export ESMF_MPIRUN=/project/esmf/theurich/ESMF-Nightly-Testing/nag_7.0_mpiuni_O_feature_devList/esmf/src/Infrastructure/stubs/mpiuni/mpirun
module list >& /project/esmf/theurich/ESMF-Nightly-Testing/nag_7.0_mpiuni_O_feature_devList/module-test.log
export WORK_ROOT=/project/esmf/theurich/ESMF-Nightly-Testing/nag_7.0_mpiuni_O_feature_devList
export TEMP_ROOT=/project/esmf/theurich/ESMF-Nightly-Testing/nag_7.0_mpiuni_O_feature_devList
cd $TEMP_ROOT/esmf
export ESMF_DIR=`pwd`
make install 2>&1| tee $WORK_ROOT/install.log
make all_tests 2>&1| tee $WORK_ROOT/test.log
export ESMFMKFILE=`find $PWD/DEFAULTINSTALLDIR -iname esmf.mk`
