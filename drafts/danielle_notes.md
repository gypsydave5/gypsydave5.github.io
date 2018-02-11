Express Routes
--------------

instantiate routes in a seperate file, export them and then 'mount' them to the app using app.use()


Json Responses
--------------

res.json(obj)

equiv

res.setHeaders('content-type', 'application/json')
res.send(JSON.stringify(obj))

Express Static
--------------

express.static() supplies static resources.

Environment Variables
---------------------

don't rely on truth


Rule Engine
-----------

```javascript
case = {
    a: "1"
    b: "2"
    default: "nope"
}

response = case[code] || case['default']
```

Tilde
-----

Want an int
~~ num
double bitwise not!

Recursive Promising
-------------------

```javascript
$.ajax().then(function(data) {
    return someMethod(data)
})
.then(function() {
    console.log()
})
.catch()
```

