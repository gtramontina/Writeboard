export BUILD_DIR="$WORKSPACE/build"
export NVM_DIR="$BUILD_DIR/.nvm"
export NODE_VERSION="v0.4.9"

# 1) SETUP ENVIRONMENT
bash $BUILD_DIR/bin/environment_setup.sh
source $NVM_DIR/nvm.sh

# 2) INSTALL DEPENDENCIES
npm install

# 3) RUN TESTS
$WORKSPACE/node_modules/jessie/bin/jessie -f xunit spec/unit/ | cat > $BUILD_DIR/test_results/$BUILD_NUMBER.xml
