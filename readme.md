# Monaxe

Monaxe is a ReactiveX library for Haxe inspired by the Monix Library for Scala (http://www.monix.io).

In General, it aims to implement the following APIs:
- monax.reactive.Observable
- monix.eval.Coeval
- monix.eval.Task
- monix.reactive.Consumer

The public APIs follow Monix closely, with some allowances for special Haxe functions that provide as-elegant or more elegant ways to achieve what Monix uses in Scala to achieve the same effect.

## Abstracts

Instead of `Observable.create`, Monaxe defines `Observable` as an abstract around a Subscribe function.

```haxe
typedef Cancellable = {var cancel: Void -> Void}; //Warning -- This might change in the future!

typedef Subscribe<T> = Observable<T> -> Cancellable;

abstract Observable<T>(Subscribe<T>)
```

This allows the developer to define a custom Observable through implicit casting as such:

```haxe
enum TrafficLight {
    RED;
    AMBER;
    GREEN
}

class Simulation {
    static public function main(){
        var simulation: Observable<TrafficLight> = obs -> {
            var timer = Timer.delay(() -> {
                obs.onStart();
                obs.onData(AMBER);
                obs.onData(RED);
                obs.onData(GREEN);
                obs.onData(AMBER);
                obs.onData(RED);
                obs.onData(GREEN);
                obs.onComplete();
            }, 1000)

            return {cancel: () -> timer.stop()};
        }

        var x = simulation.subscribe(evt -> return switch evt {
            case Start: trace("Lights started");
            case Event(light): trace("Switched to $light");
            case Error(msg): trace("Error");
            case Complete: trace("Simulation Complete");
        });

        Timer.delay(x.cancel, 2000) // Cancels if too long
    }
}
```

`Observer` is also implemented as an abstract, as seen above. This differs from Monix, which implements it as a Scala/Java interface.

In Monaxe, `Observer` is an Abstract declared over a function that takes in an `EventOrState` instance and returns `Void` (at the moment).

(_Note: The `Ack` API is not implemented yet_)

## Functionality implemented in First Implementation

### Generating Observables
```haxe
Observable.fromSingle("hello"); // Generates an Observable from a single item

Observable.fromArray([1,2,3]); // Generates an Observable from an array

Observable.empty<Nothing>; // Generates an empty Observable

```
### Observable operations
- map
- flatMap
- flatten (for nested Observables)

# Supported Platforms

Monaxe is targeted for Java and Javascript (browser + NodeJS). 

However, it is pure-haxe, so theoretically may be used on any of the seven platforms supported by the Haxe Compiler (Neko, Java, JavaScript, C++, HashLink, Lua, ActionScript).

# Haxe Version

Monaxe is built on Haxe 4.2.1.

# TODO
- Implementing Coeval
- Implementing Task
- Implementing the Consumer API

