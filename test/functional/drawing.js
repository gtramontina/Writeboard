var soda = require('soda')
  , assert = require('assert');

var browser = soda.createClient({
    host: 'localhost'
  , port: 4444
  , url: 'http://localhost:9796'
  , browser: 'chrome'
});

browser.on('command', function(cmd, args){
  console.log(' \x1b[33m%s\x1b[0m: %s', cmd, args.join(', '));
});

browser
  .chain
  .session()
  .windowMaximize()
  .open('/')  
  .waitForCondition(
	function() {
		return browser.ElementPresent("//div[class='blue']")
	},"5000")  
  .getTitle(function(title){
    assert.ok(~title.indexOf('Writeboard!'), 'Wrong title!');
  }) 
  .waitForPageToLoad()    
  .mouseDownAt("writeboard","10,10")
  .mouseMoveAt("writeboard","200,200")  
  .mouseUpAt("writeboard","200,200")
  .captureEntirePageScreenshot("/tmp/test.png", "background=#FFFFFF")
  .close()
  .end(function(err){
    if (err) throw err;
    console.log('done');
  });
