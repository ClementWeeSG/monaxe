###Observable contract

Observable subscribes a source to an observer

```
typedef Observer = {
    onStart: Void -> Void,
    onData: Data -> Void,
    onError: error -> Void,
    onComplete: Void -> Void
}
```

Observer -> contains _start_, _data_ and _complete_ callbacks

Subscription may be cancelled

###link

```
var obs: Observer<T> = {
    onStart = next.onStart
    onData = next.onData
    onComplete = next.onComplete
    onError = next.onError
} 
```

###subscription

```
enum Command {
    Data(num_items)
    Stop
}

typedef Request = Command -> Void

abstract Subscription(Request){
    function requestOne()
    function requestAll()
    function cancel();
}
```


