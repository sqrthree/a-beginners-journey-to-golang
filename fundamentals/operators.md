# 操作符

## 数学操作符

我们在学校的时候学过很多数学操作，例如加法 `+`、减法 `-` 等。

这一章中我们来学习一下如何在 Go 语言中进行这些操作。

在开始之前，我们先来复习一些术语：

操作数，指的是操作符作用于的对象。例如在加法运算 `1 + 2` 中，加法操作符作用于 `1` 和 `2` 两个数字，那么这两个数字就称之为操作数。

一元操作，如果在一个运算操作中，只存在一个操作数，那么这个操作就称之为一元操作。例如对数字进行取反的 `-`。

二元操作，如果在一个运算操作中，存在两个操作数，那么这个操作就称之为二元操作，例如 `1 + 2`。

### 不一般的 `+`

`+` 操作在我们所知道的数学中用来计算两个数字之和，但是在 Go 中除了能计算两个数字之和之外，还具有一个非常特殊的功能 —— 拼接字符串。

如果 `+` 操作所作用的操作数为两个数字，那么就计算两个数字之和。

```go
1 + 2 // 3
```

如果 `+` 操作所作用的操作数为两个字符串，那么就将两个字符串进行首位拼接作为其结果。

```go
package main

import "fmt"

func main() {
  a := "hello"
  b := "World"

  c := a + b

  fmt.Printf(c) // helloWorld
}
```

### 多样的 `-`

`-` 操作符在一元运算中的作用是取反，在二元运算中的作用是减法运算。

```go
package main

import "fmt"

func main() {
  a := 1
  b := -a

  fmt.Println(b)  // -1

  c := 10 - a

  fmt.Println(c)  // 9
}
```

### 操作符优先级

如果一个操作中同时计算多个操作，程序会按照运算符的优先级进行先后计算。

```go
package main

import "fmt"

func main() {
  a := 2
  b := 10 - a * 2

  fmt.Println(b)  // 6
}
```

正如我们所知道的那样，`10 - a * 2` 中会进行乘法运算，再进行减法运算。

如果我们想自己控制运算的顺序，需要通过 `()` 来完成。

```go
package main

import "fmt"

func main() {
  a := 2
  b := (10 - a) * 2

  fmt.Println(b) // 16
}
```

### 赋值运算

和我们已知的不一样的是，`=` 在 Go 中并不代表相等的判断，而是代表着赋值操作。

`=` 表示将操作符右边的值赋值给左边。例如 `var a int = 1`

`a = a + 1` 表示将 `a + 1` 的计算结果重新赋值给变量 `a`。

### 求余

`%` 操作符用来执行求余数运算，而不代表百分比操作。

`a % b` 的结果是 a 除以 b 得到的余数。

```go
func main() {
  a := 8
  b := 3

  c := a % b

  fmt.Println(c)  // 2
}
```

### 递增、递减

递增或递减一个数字是最常用的操作之一。除了使用 `a = a + 1` 来完成以外，Go 还提供了一个简洁的语法来完成：

- `++` - 递增一个变量，等同于 `a = a + 1`
- `--` - 递减一个变量，等同于 `a = a - 1`

递增 / 递减只能应用于一个变量。`5 ++` 这样的使用方式会导致编译错误。

```go
package main

import "fmt"

func main() {
  a := 8

  a++

  fmt.Println(a) // 9

  a--

  fmt.Println(a) // 8
}
```

### 直接修改

对一个变量进行数学计算并重新赋值也是编程中经常遇到的一个需求。除了 `a = a + 3` 之外，我们还可以这样：

```go
package main

import "fmt"

func main() {
	a := 3

	a += 3
	fmt.Println(a) // 6
}
```

这里的 `a += 3` 等同于 `a = a + 3`。

当然，你还可以进行 `-=`、`*=`、`/=`、`%=`操作。

## 关系运算符

关系运算符是二元运算中的运算符，用来做关系判断，其结果会根据操作返回 `true` 或 `false`。

- `==` - 检查两个值是否相等，如果相等返回 `true` 否则返回 `false`。
- `!=` - 检查两个值是否不相等，如果不相等返回 `true` 否则返回 `false`。
- `>` - 检查左边值是否大于右边值，如果是返回 `true` 否则返回 `false`。
- `<` - 检查左边值是否小于右边值，如果是返回 `true` 否则返回 `false`。
- `>=` - 检查左边值是否大于等于右边值，如果是返回 `true` 否则返回 `false`。
- `<=` - 检查左边值是否小于等于右边值，如果是返回 `true` 否则返回 `false`。

## 逻辑运算符

### `&&`

`&&` 运算符用来表示多个条件同时成立，如果两边的操作数都是 `true`，则条件的运算结果为 `true`，否则为 `false`。其语法为 `A && B`。

### `||`

`||` 运算符用来表示多个条件中至少有一个成立，如果两边的操作数中任意一个为 `true`，则条件的运算结果为 `true`，否则为 `false`。其语法为 `A || B`。

### `!`

`!` 运算符用来对条件结果进行取反操作，如果条件为 `true`，则运算结果为 `false`，否则为 `true`。其语法为 `!A`。

```go
package main

import "fmt"

func main() {
	a := true
	b := !a

	fmt.Println(b) // false
}
```
