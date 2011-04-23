#!/bin/bash
# https://github.com/gtramontina/cloudbees-node

NODE_SOURCE_DIR='build/node'
NODE_INSTALL_DIR=$NODE_SOURCE_DIR'/installed'

# Plumbing...
exist_directory() {
    [ -d $1 ];
}
clone_node_from_github() {
    git clone https://github.com/joyent/node.git $NODE_SOURCE_DIR
}
install_node() {
    mkdir $NODE_INSTALL_DIR
    export PREFIX=$PWD/$NODE_INSTALL_DIR
    pushd $NODE_SOURCE_DIR; ./configure
    make install
    popd
}
is_command_in_path() {
    command -v $1 > /dev/null;
}
add_node_to_path() {
    export PATH=$PWD/$NODE_INSTALL_DIR/bin:${PATH}
}
install_npm() {
    curl http://npmjs.org/install.sh | sh
}

# [ Start! ]
# Checking Node.js
exist_directory $NODE_SOURCE_DIR || clone_node_from_github
exist_directory $NODE_INSTALL_DIR || install_node
is_command_in_path 'node' || add_node_to_path
node --version

#Checking NPM
is_command_in_path 'npm' || install_npm
npm --version

