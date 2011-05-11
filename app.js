require('coffee-script');

require('./server')(
    require('express'),
    require('stylus'),
    require('nib'),
    require('now')
);

