require('coffee-script');
require('jessie').sugar();

// More sugar ==================================================================
any      = jasmine.any;
match    = function(regexp) { return new Match(regexp) };
stub     = jasmine.createSpy;
stubWith = jasmine.createSpyObj;
n00p     = function() {/* No Op */};
_        = {};

// Equality testers ============================================================
var Match = function(regexp) { this.regexp = regexp };
var equalityTesters = [
  /* RegEx */
  function(a, b) {
    if (b instanceof Match) return b.regexp.test(a);
  }
];

// -----------------------------------------------------------------------------
beforeEach(function(){
  for (var i=0; i<equalityTesters.length; i++) { this.env.addEqualityTester(equalityTesters[i]); }
});