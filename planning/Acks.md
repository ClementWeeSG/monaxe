###Ack

Ack is the response telling the Observable to go ahead or stop sending elements

```
enum Ack{
    Continue;
    Stop;
}
```

```
observer.onNext = function(){
    ...
    try {
        ...
        return Continue;
    } catch {
        e -> 
         observer.onError(e);
         return Stop; 
    }
}
```

###Observable Loop

```
fn(observer, lastAck = Continue){
    if (lastAck == Stop){
        observer.onComplete();
    } else {
        fn(observer, observer.onNext(data))
    }
}
```