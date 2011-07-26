# This is a modified version of Nodeready!
# Please refer to http://agnoster.github.com/nodeready/
# for more information.

# MESSAGING primitives
LOGFILE=".nodeready.log"
echo "# $(date)" > $LOGFILE

say() { echo "# [nodeready] $*" | tee -a $LOGFILE; }
yay() { say "$*"; }
hmm() { say "$*"; }
die() { say "$*"; say "diagnostic information in .nodeready.log"; exit -1; }

run () {
	echo '$' $* >> $LOGFILE
	$* >> $LOGFILE 2>&1
}

echo
say "strap yourself in, this could get bumpy..."
say "hint: if you want more detail, tail -f .nodeready.log"

# BOOTSTRAPINATOR
has() { which $1 >/dev/null 2>&1; }
use() { has $1 || return; export $2="$3" && yay "using '$1' $4"; }
use_curl() { use $1 CURL "$*" "to download files"; }

use_curl curl -L -C - -o

# Start with nvm
# If the NVM_DIR environment variable is set, then use it.
# Otherwise use current directory + .nvm
NVM_DIR=${NVM_DIR-"$PWD/.nvm"}

run mkdir -p "$NVM_DIR"
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
	say "Installing nvm in $NVM_DIR"
	$CURL - 'https://github.com/creationix/nvm/raw/master/nvm.sh' > "$NVM_DIR/nvm.sh" 2>>$LOGFILE || die "could not download nvm.sh"
else
	say "nvm is already installed"
fi

source "$NVM_DIR/nvm.sh" >>$LOGFILE 2>&1
type nvm 2>&1 | grep "function" >>$LOGFILE 2>&1 || {
	head -n1 "$NVM_DIR/nvm.sh" | grep "\<html" >>$LOGFILE 2>&1 && hmm "maybe github is down?"
	die "failed to load nvm"
	}

# Get the latest and greatest node
if nvm sync; then
	VERSION=`nvm version latest`
else
	VERSION=`$CURL - http://nodejs.org/ 2>>$LOGFILE | grep -i -A 1 unstable | tail -n1 | sed -e 's/.*node-//' -e 's/.tar.gz.*//'`
	hmm "couldn't use 'nvm sync' to get latest version"
	if [ "$VERSION" = "" ]; then
		VERSION="v0.4.2"
		hmm "falling back to installing $VERSION"
	else
		yay "the website says latest is $VERSION, so we'll just trust them"
	fi
fi
if nvm use $VERSION | grep --silent 'not installed yet'; then
  say "installing latest node ($VERSION)"
  say "(this could take a while, maybe get a coffee?)"
  nvm install $VERSION >>$LOGFILE 2>&1 || die "crap, node install failed!"
  yay "node $VERSION installed"
  say "setting it as your default..."
  nvm alias default $VERSION >>$LOGFILE 2>&1 || (hmm "your version of nvm doesn't seem to support that..."; hmm "oh well, no biggie. just 'nvm use $VERSION' every time you want node")
  yay "all done!"
  say "to load node, just start a new shell or type:"
  echo "    source $NVM_DIR/nvm.sh"
fi

echo
say "Thank you for using nodeready, still in testing. If everything seemed to work,"
say "I'd appreciate a tweet @nodeready or an email to nodeready@agnoster.net"
say "letting me know what system you installed it on."
echo

