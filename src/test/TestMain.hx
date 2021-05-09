package src.test;

import monaxe.reactive.Observable;

class TestMain {
    static public function main(){
        var ints = Observable.fromArray([1,2,3]);
        var doubles = ints.map(i -> i*2);
    }
}