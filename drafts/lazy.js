function lazyEvalMemo (fn) {
  var args = arguments;
  var result;
  var lazyEval = fn.bind.apply(fn, args);
  return function () {
    if (result) {
      return result
    }
    result = lazyEval()
    return result;
  }
}


function add1 (number) {
    return number + 1;
}

lazyEvalMemo(add1, 5)

function betterMem (fn) {

    var results = {};

    return function () {
        var args = Array.prototype.slice.call(arguments);
        var stringArgs = JSON.stringify(args);
        if (results[stringArgs]) {
            console.log("memo!");
            return results[stringArgs];
        }
        console.log("working!");
        results[stringArgs] = fn.apply(null, args);
        return(results[stringArgs]);
    }
}

const add1Mem = betterMem(add1);

console.log(add1Mem(5));
console.log(add1Mem(5));
console.log(add1Mem(7));
console.log(add1Mem(7));
console.log(add1Mem(9));
console.log(add1Mem(9));