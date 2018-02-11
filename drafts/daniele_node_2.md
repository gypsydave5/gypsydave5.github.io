# Node with Daniele Part 2 #

## Testing ##

### Jasmine vs. Mocha ###

testing promises...

pass a method in to the test, and then call it -- the `done()` method. Not in
Jasmine 1.x

Mocha has support for promises.

```javascript
it('should pass', function () {
  return longAsyncTask().then(function () {
    // assert here
  }
});
```

OR

```javascript
it('should pass', function () {
  longAsyncTask().then(function () {
    // assert here
    done();
  }
});
```

## Functional Programming

The problem with 'impure' modules and functions is that they're hard to test - the inputs are not explicitly declared. So pass them to the function as parameters.

Constants... are a little safer (they don't change).

Abstracting out

```javascript
selectEdition = function (allEditions) {
  return fucetion (editonName) {
    allEditions[editionName];
  };
}

select = selectEdition(allEditions)('DEW')

```

## Dependency Injection

```javascript
function Class (otherClass) {
  this.otherClass = otherClass;
}

Class.prototype.method - function () {
  this.otherClass.doit();
};
```
But if maybe you can't inject the dependency - `amqp` lib say.
Fake a require - `npm really-need` - fake out `require`.
This may not be a GOOD IDEA

```javascript
function API () {
  $.ajax
}
```

### Nock and Node-mitm
Like a Betamax but less crappy...
Both can set up mocking objects
Nock for node.
node-mitm more generally.

### mocha
done in a promise...

(...).then(done, done);

rolls out as:

```javascript
.then(function (value) {
  done()
})
.catch(function value) {
  done()
});
```

## Reconnect
```javascript
var connectToDB = (function () {
  var i = 0;

  return function () {
    i < 5 ? return Promise.resolve() : return Promise. //??
  }
})();

function connectAndRetry () {
  return connectToDB().catch(function () {
    console.log('message: ', message);
    return Promise.delay(500).then(connectAndRetry);
  });
};
```

// promises ... take a function to execute... just the name of the function is
OK.

Recursive promising - promises will always resolve as a part of a promise
chain.

```javascript
Promise.resolve(Promise.resolve(4)).then(function (???) {});
//??? is 4 !!!
```

## Code Review Tools
Plato - shows the complexity of the codebase with nice graphs and stuff.

## NPM paths and binaries
so... consider adding `./node_modules/.bin` to `$PATH` - makes all the local
node binaries

Have a look at `npm run env` to see what the node command run does.
can wrap npm tools up in the `package.json` tasks. They'se really clever.

### More fun with promises

```javascript
var Promise = require('bluebird');

function doit  {
  return new Promise(function (resolve, reject) {
    reject('oops');
  });
}

Promise.resolve()
.then(function () {
  return doit();
})
.then(function (value) {
  console.log('value: ', value);
})
.catch(function (value) {
  console.log('fail: ', value);
});
```
