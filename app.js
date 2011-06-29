require.paths.unshift('./lib');
require('coffee-script');

require('server')(
    require('express'),
    require('stylus'),
    require('nib'),
    require('now'),

    // Injected Controllers
    require('controllers/writeboard'),
    require('controllers/room')
);

