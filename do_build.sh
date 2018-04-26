# Parameters: ANA_USER, ANA_TOKEN

SRC=$PWD

echo "SRC=$SRC"

#echo "ANA_USER=$1"
#echo "ANA_TOKEN=$2"
#echo $2|rev

if [ -f $SRC/reschedule_required ] ; then
    echo "Reschedule required. Abandoning build"
    exit 0
fi

export CXX=g++-4.9

mkdir -p /app/mybuild
cd /app/mybuild

cmake -G "Ninja" \
    -DCMAKE_BUILD_TYPE="Release" \
    -DENABLE_SMESH=OFF \
    -DENABLE_NETGEN=OFF \
    -DENABLE_BLSURF=OFF \
    -DENABLE_FORCE=OFF \
    -DENABLE_WARNINGS=OFF \
    -DTEST_BUILD=OFF \
    $SRC

export NINJA_STATUS="[%f/%t(%r)] "

#timeout 40m ninja -d explain install
timeout 40m ninja install
err=$?
echo "timeout return value: $err"
if [ $err = 124 ] ; then
    touch $SRC/reschedule_required
    exit 0
fi

if [[ $err -ne 0 ]] ; then
    exit $err
fi

cd $SRC

conda-build --user $1 --token $2 ci/conda
