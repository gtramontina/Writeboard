source $BUILD_DIR/lib/nodeready.sh

LOG="# [environment setup]"
if [ $NODE_VERSION ]
then
  echo "$LOG Using node version $NODE_VERSION"
  if nvm use $NODE_VERSION | grep --silent 'not installed yet'; then
    echo "$LOG $NODE_VERSION is not installed yet. Installing it..."
    nvm install $NODE_VERSION
    nvm alias default $NODE_VERSION
  fi
else
  echo "$LOG Could not find NODE_VERSION environment variable. Using the latest version - already installed by nodeready."
fi

echo "$LOG Node version: `node --version`"
echo "$LOG NPM version : `npm --version`"
