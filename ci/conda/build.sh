# Conda build file
# Run from Docker container

echo "Conda build"
echo "PREFIX = $PREFIX"
echo "SP_DIR = $SP_DIR"
echo "SRC_DIR = $SRC_DIR"

echo "copying"
cp -r $SRC_DIR/OCCT $SP_DIR/OCCT
echo "done"
