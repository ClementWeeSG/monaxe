# README

Monaxe is a ReactiveX library for Haxe inspired by the Monix Library for Scala (http://www.monix.io)

## Aim

To implement a native Haxe implementation of ReactiveX

## Functionality Targeted For First Iteration

Observable Contract
Observable.Create
Observable.map

## Observable and Observer as Abstracts

Observable is defined as an abstract around a Subscribe function. This allows for implicit casting in Haxe to lift static values into Observable contexts.

```
var arrObs: Observable[Int] = [2,3,4];
var singleObs: Observable[String] = "This is ME!!!";
```