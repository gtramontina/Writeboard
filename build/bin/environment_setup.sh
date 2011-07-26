source $BUILD_DIR/bin/nodeready.sh

LOGFILE="$LOGS_DIR/environment_setup.log"
echo "# $(date)" > $LOGFILE

say() { echo "# [environment setup] $*" | tee -a $LOGFILE; }

if [ $NODE_VERSION ]
then
  say "$LOG Using node version $NODE_VERSION"
  if nvm use $NODE_VERSION | grep --silent 'not installed yet'; then
    say "$LOG $NODE_VERSION is not installed yet. Installing it..."
    nvm install $NODE_VERSION >>$LOGFILE 2>&1
    nvm alias default $NODE_VERSION >>$LOGFILE 2>&1
  fi
else
  say "$LOG Could not find NODE_VERSION environment variable. Using the latest version - already installed by nodeready."
fi

say "$LOG Node version: `node --version`"
say "$LOG NPM version : `npm --version`"
