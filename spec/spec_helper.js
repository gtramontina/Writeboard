require('coffee-script');
require('jessie').sugar();

// More sugar
any      = jasmine.any
stubWith = jasmine.createSpyObj;
n00p     = function() {/* No Op */};
_        = {};

var customMatchers = {
  to_have_attributes: function(expectedAttributes) {
    if (!this.actual) return false;

    for (expectedAttribute in expectedAttributes) {
      if (!expectedAttributes.hasOwnProperty(expectedAttribute)) continue;
      if (!this.actual[expectedAttribute]) return false;

      expectedValue = expectedAttributes[expectedAttribute];
      actualValue = this.actual[expectedAttribute];
      if (expectedValue instanceof RegExp) {
         if (!expectedValue.test(actualValue)) return false;
      } else {
        if (!this.env.equals_(actualValue, expectedValue)) return false;
      }
    }
    return true;
  }
};

beforeEach(function(){ this.addMatchers(customMatchers); });