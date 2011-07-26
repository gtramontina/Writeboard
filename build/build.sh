export BUILD_DIR="$WORKSPACE/build"
export LOGS_DIR="$BUILD_DIR/logs"
export NVM_DIR="$BUILD_DIR/.nvm"
export NODE_VERSION="v0.4.9"
#-------------------------------------------------------------------------------
echo "# 1) Setting environment up..."
bash $BUILD_DIR/bin/environment_setup.sh
source $NVM_DIR/nvm.sh
echo "# 1) Done!"
#-------------------------------------------------------------------------------
echo "# 2) Installing npm dependencies..."
npm install
echo "# 2) Done!"
#-------------------------------------------------------------------------------
echo "# 3) Running unit tests..."
$WORKSPACE/node_modules/jessie/bin/jessie -f xunit spec/unit/ | cat > $BUILD_DIR/test_results/$BUILD_NUMBER.xml
echo "# 3) Done! The results are here: $BUILD_DIR/test_results/$BUILD_NUMBER.xml"
