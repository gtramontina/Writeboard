require('coffee-script');

require(__dirname+'/lib/server')(
    require('express'),
    require('stylus'),
    require('nib'),
    require('now'),

    // Injected Controllers
    require(__dirname+'/lib/controllers/writeboard'),
    require(__dirname+'/lib/controllers/room')
);