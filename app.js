require.paths.unshift(__dirname+'/lib');
require('coffee-script');

webApp = require('server')(
  require('express'),
  require('stylus' ),
  require('nib'    )
);

require('controllers')(webApp)