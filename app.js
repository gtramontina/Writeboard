require('coffee-script');

webApp = require('./lib/server')(
	require('express')
);