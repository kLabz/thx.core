package thx;

#if macro
import haxe.macro.Expr;
import thx.macro.lambda.SlambdaMacro;
#end

/**
Extension methods for functions with arity 0 (functions that do not take arguments).
**/
class Functions0 {
/**
Returns a function that invokes `callback` after being being invoked `n` times.
**/
  inline public static function after(callback : Void -> Void, n : Int)
    return function()
      if(--n == 0)
        callback();
/**
`join` creates a function that calls the 2 functions passed as arguments in sequence.
**/
  public inline static function join(fa : Void -> Void, fb : Void -> Void)
    return function() {
      fa();
      fb();
    }

/**
`once` wraps and returns the argument function. `once` ensures that `f` will be called
at most once even if the returned function is invoked multiple times.
**/
  public inline static function once(f : Void -> Void)
    return function() {
      var t = f;
      f = Functions.noop;
      t();
    };

/**
Wraps `callback` in a function that negates its results.
**/
  public inline static function negate(callback : Void -> Bool)
    return function()
      return !callback();

/**
Creates a function that calls `callback` `n` times and returns an array of results.
**/
  public inline static function times<T>(n : Int, callback : Void -> T)
    return function()
      return Ints.range(n).map(function(_) return callback());

/**
Creates a function that calls `callback` `n` times and returns an array of results.

Callback takes an additional argument `index`.
**/
  public inline static function timesi<T>(n : Int, callback : Int -> T)
    return function()
      return Ints.range(n).map(function(i) return callback(i));

}

/**
Extension methods for functions with arity 1 (functions that take exactly 1 argument).
**/
class Functions1 {
 /**
`compose` returns a function that calls the first argument function with the result
of the following one.
 **/
  public inline static function compose<TIn, TRet1, TRet2>(fa : TRet2 -> TRet1, fb : TIn -> TRet2): TIn -> TRet1
    return function(v : TIn) return fa(fb(v));

  /**
   * The covariant functor for Function1<A, _>
   */
  public inline static function map<A, B, C>(fab: A -> B, fbc: B -> C): A -> C
    return function(a: A) return fbc(fab(a));

  /**
   * The contravariant functor for Function1<_, B>. Equivalent to compose.
   */
  public inline static function contramap<A, B, C>(fbc: B -> C, fab: A -> B): A -> C
    return function(a: A) return fbc(fab(a));

/**
`join` creates a function that calls the 2 functions passed as arguments in sequence
and passes the same argument value to the both of them.
**/
  public inline static function join<TIn>(fa : TIn -> Void, fb : TIn -> Void)
    return function(v : TIn) {
      fa(v);
      fb(v);
    }

/**
`memoize` wraps `callback` and calls it only once storing the result for future needs.

Computed results are stored in an internal map. The keys to this map are generated by
the resolver function that by default directly converts the first argument into a string.
**/
  public static function memoize<TIn, TOut>(callback : TIn -> TOut, ?resolver : TIn -> String) : TIn -> TOut {
    if(null == resolver)
      resolver = function(v : TIn) return '$v';
    var map = new Map<String, TOut>();
    return function(v : TIn) {
      var key = resolver(v);
      if(map.exists(key))
        return map.get(key);
      var result = callback(v);
      map.set(key, result);
      return result;
    }
  }

/**
Wraps `callback` in a function that negates its results.
**/
  public inline static function negate<T1>(callback : T1 -> Bool)
    return function(v : T1)
      return !callback(v);

/**
`noop` is a function that has no side effects and doesn't return any value.
**/
  public static function noop<T>(_ : T) : Void {}

/**
Creates a function that calls `callback` `n` times and returns an array of results.
**/
  public inline static function times<TIn, TOut>(n : Int, callback : TIn -> TOut)
    return function(value : TIn)
      return Ints.range(n).map(function(_) return callback(value));

/**
Creates a function that calls `callback` `n` times and returns an array of results.

Callback takes an additional argument `index`.
**/
  public inline static function timesi<TIn, TOut>(n : Int, callback : TIn -> Int -> TOut)
    return function(value : TIn)
      return Ints.range(n).map(function(i) return callback(value, i));

/**
Returns a function that behaves the same as `callback` but has its arguments inverted.
**/
  public inline static function swapArguments<T1, T2, TReturn>(callback : T1 -> T2 -> TReturn) : T2 -> T1 -> TReturn
    return function(a2 : T2, a1 : T1)
      return callback(a1, a2);

/**
Lambda expressions
**/
  public macro static function fn<T, T2>(fn : ExprOf<T -> T2>, restArgs : Array<Expr>)
    return SlambdaMacro.f(fn, restArgs);
}

/**
Helper class for functions that take 2 arguments
**/
class Functions2 {
/**
`memoize` wraps `callback` and calls it only once storing the result for future needs.

Computed results are stored in an internal map. The keys to this map are generated by
the resolver function that by default directly converts the arguments into a string.
**/
  public static function memoize<T1, T2, TOut>(callback : T1 -> T2 -> TOut, ?resolver : T1 -> T2 -> String) : T1 -> T2 -> TOut {
    if(null == resolver)
      resolver = function(v1 : T1, v2 : T2) return '$v1:$v2';
    var map = new Map<String, TOut>();
    return function(v1 : T1, v2 : T2) {
      var key = resolver(v1, v2);
      if(map.exists(key))
        return map.get(key);
      var result = callback(v1, v2);
      map.set(key, result);
      return result;
    }
  }

  public static function curry<A, B, C>(f: A -> B -> C): A -> (B -> C)
    return function(a: A) { return function(b) { return f(a, b); } };

/**
Wraps `callback` in a function that negates its results.
**/
  public inline static function negate<T1, T2>(callback : T1 -> T2 -> Bool)
    return function(v1 : T1, v2 : T2)
      return !callback(v1, v2);

/**
Lambda expressions
**/
  public macro static function fn<T, T2, T3>(fn : ExprOf<T -> T2 -> T3>, restArgs : Array<Expr>)
    return SlambdaMacro.f(fn, restArgs);
}

/**
Helper class for functions that take 3 arguments
**/
class Functions3 {
/**
`memoize` wraps `callback` and calls it only once storing the result for future needs.

Computed results are stored in an internal map. The keys to this map are generated by
the resolver function that by default directly converts the arguments into a string.
**/
  public static function memoize<T1, T2, T3, TOut>(callback : T1 -> T2 -> T3 -> TOut, ?resolver : T1 -> T2 -> T3 -> String) : T1 -> T2 -> T3 -> TOut {
    if(null == resolver)
      resolver = function(v1 : T1, v2 : T2, v3 : T3) return '$v1:$v2:$v3';
    var map = new Map<String, TOut>();
    return function(v1 : T1, v2 : T2, v3 : T3) {
      var key = resolver(v1, v2, v3);
      if(map.exists(key))
        return map.get(key);
      var result = callback(v1, v2, v3);
      map.set(key, result);
      return result;
    }
  }

/**
Wraps `callback` in a function that negates its results.
**/
  public inline static function negate<T1, T2, T3>(callback : T1 -> T2 -> T3 -> Bool)
    return function(v1 : T1, v2 : T2, v3 : T3)
      return !callback(v1, v2, v3);

  public inline static function curry<A, B, C, D>(f: A -> B -> C -> D): A -> B -> (C -> D)
    return function(a: A, b: B) { return function(c) { return f(a, b, c); } };


/**
Lambda expressions
**/
  public macro static function fn<T, T2, T3, T4>(fn : ExprOf<T -> T2 -> T3 -> T4>, restArgs : Array<Expr>)
    return SlambdaMacro.f(fn, restArgs);
}

class Functions4 {
  public inline static function curry<A, B, C, D, E>(f: A -> B -> C -> D -> E): A -> B -> C -> (D -> E)
    return function(a: A, b: B, c: C) { return function(d) { return f(a, b, c, d); } };
}

class Functions5 {
  public inline static function curry<A, B, C, D, E, F>(f: A -> B -> C -> D -> E -> F): A -> B -> C -> D -> (E -> F)
    return function(a: A, b: B, c: C, d: D) { return function(e) { return f(a, b, c, d, e); } };
}

class Functions6 {
  public inline static function curry<A, B, C, D, E, F, G>(f: A -> B -> C -> D -> E -> F -> G): A -> B -> C -> D -> E -> (F -> G)
    return function(a: A, b: B, c: C, d: D, e: E) { return function(f0) { return f(a, b, c, d, e, f0); } };
}

class Functions7 {
  public inline static function curry<A, B, C, D, E, F, G, H>(f: A -> B -> C -> D -> E -> F -> G -> H): A -> B -> C -> D -> E -> F -> (G -> H)
    return function(a: A, b: B, c: C, d: D, e: E, f0: F) { return function(g) { return f(a, b, c, d, e, f0, g); } };
}

class Functions8 {
  public inline static function curry<A, B, C, D, E, F, G, H, I>(f: A -> B -> C -> D -> E -> F -> G -> H -> I): A -> B -> C -> D -> E -> F -> G -> (H -> I)
    return function(a: A, b: B, c: C, d: D, e: E, f0: F, g: G) { return function(h) { return f(a, b, c, d, e, f0, g, h); } };
}

class Functions9 {
  public inline static function curry<A, B, C, D, E, F, G, H, I, J>(f: A -> B -> C -> D -> E -> F -> G -> H -> I -> J): A -> B -> C -> D -> E -> F -> G -> H -> (I -> J)
    return function(a: A, b: B, c: C, d: D, e: E, f0: F, g: G, h: H) { return function(i) { return f(a, b, c, d, e, f0, g, h, i); } };
}

class Functions10 {
  public inline static function curry<A, B, C, D, E, F, G, H, I, J, K>(f: A -> B -> C -> D -> E -> F -> G -> H -> I -> J -> K): A -> B -> C -> D -> E -> F -> G -> H -> I -> (J -> K)
    return function(a: A, b: B, c: C, d: D, e: E, f0: F, g: G, h: H, i: I) { return function(j) { return f(a, b, c, d, e, f0, g, h, i, j); } };
}

class Functions11 {
  public inline static function curry<A, B, C, D, E, F, G, H, I, J, K, L>(f: A -> B -> C -> D -> E -> F -> G -> H -> I -> J -> K -> L): A -> B -> C -> D -> E -> F -> G -> H -> I -> J -> (K -> L)
    return function(a: A, b: B, c: C, d: D, e: E, f0: F, g: G, h: H, i: I, j: J) { return function(k) { return f(a, b, c, d, e, f0, g, h, i, j, k); } };
}

abstract Reader<A, B> (A -> B) from A -> B to A -> B {
  public function flatMap<C>(f : B -> (A -> C)) : A -> C
    return function(a : A) : C {
      return f(this(a))(a);
    };
}


/**
Generic helper for functions.
**/
class Functions {
/**
It provides strict equality between the two arguments `a` and `b`.
**/
  public static function equality<T>(a : T, b : T) : Bool
    return a == b;

/**
The `identity` function returns the value of its argument.
**/
  public static function identity<T>(value : T) : T
    return value;

/**
`noop` is a function that has no side effects and doesn't return any value.
**/
  public static function noop() : Void {}

  public macro static function with(context:Expr,body:Expr) {
    var new_body = thx.macro.Macros.replaceSymbol(body,"_",macro $context);
    return macro $new_body;
  }

/**
Lambda expressions
**/
  public macro static function fn<T>(fn : ExprOf<Void -> T>, restArgs : Array<Expr>)
    return SlambdaMacro.f(fn, restArgs);

/**
Converts an instance of type `T` to an instance of type `U`.

Useful as an extension methods for converting a value to another type inside a chain of function calls.

E.g.

```
using thx.Functions;
import thx.Options;

var arr: Array<Int> = [1, 2, 3];
var opt : Option<Array<Int>> = myArray.lift(Options.ofValue);
Assert.same(Some(arr), opt); // true
```
**/
  public static inline function lift<T, U>(t : T, f: T -> U) : U
    return f(t);
}
