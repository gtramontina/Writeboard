require.paths.unshift(__dirname+'/lib');
require('coffee-script');

webApp = require('server')(
  require('express'),
  require('stylus' ),
  require('nib'    )
);

nowJs = require('now');

require('controllers/index')(webApp)
require('controllers/room')(webApp)
require('controllers/conference_center')(
  nowJs.initialize(webApp).now,
  require('doorman')(nowJs)
);