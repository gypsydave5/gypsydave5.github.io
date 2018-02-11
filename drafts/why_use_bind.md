generic function that returns its environment:

```javascript
function myFunction () {
  return this
}
```

add it to an object:

```javascript
var bob = {
  fun: myFunction
}
```

call it:

```javascript
bob.fun() //=> global namespace object
```

We want the object it's being called in - not the object it was created in...

```javascript
var bob = {
  fun: myFunction.bind(this)
}
```


```javascript
bob.fun() //=> bob
```