require.paths.unshift(__dirname);
require('coffee-script');

require('lib/server')(
    require('express'),
    require('stylus'),
    require('nib'),
    require('now'),

    // Injected Controllers
    require('lib/controllers/writeboard'),
    require('lib/controllers/room')
);