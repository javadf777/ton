fun justTrue(): int { return true; }

fun unary_minus_1(a: int, b: int, c: int): int{return -(a+b) *c;}
fun unary_minus_2(a: int, b: int, c: int): int{return(-(a+b))*c;}
fun unary_minus_3(a: int, b: int, c: int): int{return-((a+b) *c);}


@method_id(101)
fun test1(x: int, y: int, z: int): int {
    return (x > 0) & (y > 0) & (z > 0);
}

@method_id(102)
fun test2(x: int, y: int, z: int): int {
    return x > (0 & (y > 0) & (z > 0));
}

@method_id(103)
fun test3(x: int, y: int, z: int): int {
    if ((x < 0) | (y < 0)) {
        return z < 0;
    }
    return (x > 0) & (y > 0);
}

@method_id(104)
fun test4(x: int, y: int, mode: int): int {
    if (mode == 1) {
        return (x == 10) | (y == 20);
    } if (mode == 2) {
        return (x == 10) | (y == 20);
    } else {
        return x == (10 | (y == 20));
    }
}

@method_id(105)
fun test5(status: int): int {
  return justTrue() & (status == 1) & ((justTrue() & status) == 1);
}

@method_id(106)
fun test6(a: int, b: int, c: int): int {
    return (unary_minus_1(a,b,c) == unary_minus_2(a,b,c)) & (unary_minus_1(a,b,c) == unary_minus_3(a,b,c));
}

@method_id(107)
fun test7(b: int): int {
    var a = b == 3 ? 3 : b == 4 ? 4 : (b == 5) & 1 ? 5 : 100;
    return a;
}

@method_id(108)
fun test8(b: int): int {
    var a = b == 3 ? 3 : b == 4 ? 4 : b = 5 ? 5 : 100;
    return a;
}

fun `_<p`(a: auto, b: auto): int { return true; }

fun main() {
    // ok to parse
    var c = [
        (3 & 3) > 0, 3 & (3 > 0), 3 & (`_<_`(3, 0)),
        3 & `_<p`(3, 0), (1 & 2) ^ (3 | 4),
        1 & ((1) == 1)
    ];
}

/**
@testcase | 101 | 1 2 3 | -1
@testcase | 101 | 1 0 3 | 0
@testcase | 101 | 1 2 -1 | 0
@testcase | 102 | 1 0 0 | -1
@testcase | 103 | -1 -2 -3 | -1
@testcase | 103 | -1 -2 0 | 0
@testcase | 103 | 1 2 0 | -1
@testcase | 103 | 1 0 2 | 0
@testcase | 104 | 10 20 1 | -1
@testcase | 104 | 10 20 2 | -1
@testcase | 104 | 10 20 3 | 0
@testcase | 105 | 1 | -1
@testcase | 105 | 0 | 0
@testcase | 106 | 1 2 3 | -1
@testcase | 107 | 3 | 3
@testcase | 107 | 4 | 4
@testcase | 107 | 5 | 5
@testcase | 107 | 6 | 100
@testcase | 108 | 3 | 3
@testcase | 108 | 4 | 4
@testcase | 108 | 6 | 5

@fif_codegen
"""
  unary_minus_1 PROC:<{
    //  a b c
    -ROT	//  c a b
    ADD	//  c _3
    NEGATE	//  c _4
    SWAP	//  _4 c
    MUL	//  _5
  }>
  unary_minus_2 PROC:<{
    //  a b c
    -ROT	//  c a b
    ADD	//  c _3
    NEGATE	//  c _4
    SWAP	//  _4 c
    MUL	//  _5
  }>
  unary_minus_3 PROC:<{
    //  a b c
    -ROT	//  c a b
    ADD	//  c _3
    SWAP	//  _3 c
    MUL	//  _4
    NEGATE	//  _5
  }>
"""

 */
