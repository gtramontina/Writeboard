require.paths.unshift(__dirname+'/lib');
require('coffee-script');

// Setup the web app...
webApp = require('server')(
  require('express'),
  require('stylus' ),
  require('nib'    )
);

// .. and initialize controllers.
require('controllers')(webApp)