# 流程控制

所谓流程控制，就是控制我们的程序按照怎样的一种逻辑进行执行。

## if

有时，我们需要条件的不同来运行不同的操作，这就是 `if` 语句来帮我们做的事情。

`if` 语句的语法是：

```
if 条件 {
  做一些事情
}
```

`if` 语句的作用是，先判断条件是否成立，如果条件成立，那么就执行内部的操作，如果条件不成立，就跳过内部的语句，继续向下执行。

条件是否成立的本质是其条件的判断结果是否为“真值”，例如 `true`。

```go
package main

import "fmt"

func main() {
	a := true

	if a {
		fmt.Println("条件成立")
	}

	b := false

	if b {
		fmt.Println("因为 b 的值为“假值”，所以条件不成立，因此该行不会被执行")
	}
}
```

条件除了直接使用 `bool` 类型的值之外，还可以使用关系运算符和逻辑运算符。

`if` 语句可以在条件之前执行一个简单的语句 —— 便捷语句，由这个语句定义的变量的作用域仅在 `if` 范围之内。语句和条件直接使用 `;` 进行分隔。

```go
package main

import "fmt"

func main() {
	a := 1
	b := 2

	if c := a + b; c > a {
		fmt.Println(c)  // 3
	}
}
```

如果条件不成立的时候也需要做一些操作，那么可以使用 `else` 关键字来表示：

```go
if 条件成立 {
  // do something
} else {
  // do other something
}
```

在 `if` 的便捷语句定义的变量同样可以在任何对应的 `else` 块中使用。

如果存在多个条件时，可以使用 `else if` 语法：

```go
package main

import "fmt"

func main() {
	a := 1

	if a > 0 {
		fmt.Println("a 的值是正整数")
	} else if a < 0 {
		fmt.Println("a 的值是负整数")
	} else {
		fmt.Println("a 的值是 0")
	}
}
```

## switch

`if ... else if ...` 语法自然是方便，但是如果条件过多，那么程序的可读性就会大大降低，这个时候 `switch` 就派上用场啦。

`switch` 的条件会从上到下的执行，当匹配成功的时候执行对应的操作，并停止后续的匹配。

```go
package main

import "fmt"

func main() {
	favoriteFruit := "apple"

	switch favoriteFruit {
		case "apple":
			fmt.Println("我最爱吃 🍎")
		case "banana":
			fmt.Println("我最爱吃 🍌")
		case "pear":
			fmt.Println("我最爱吃 🍐")
		default:
			fmt.Println("没有匹配到以上任一条件，默认操作会被执行。")
	}
}
```

`switch` 语句也支持和 `if` 类似的“便捷语句”声明：`switch 语句; 变量 { ... }`

## for

`for` 用来执行循环操作。

表示当满足一定的条件时，重复的执行某些操作。其语法是：

```go
for 初始语句; 条件语句; 条件因子处理语句 {
  循环体
}
```

`for` 在开始之前，会先执行“初始语句”，“初始语句”只会执行一次，然后执行“条件语句”进行判定，如果条件成立，那么执行“循环体”，待“循环体”执行完执行，会执行“条件因子处理语句”，只会重新按照“条件语句”进行条件判定，如果条件成立，继续执行“循环体”，以此循环，直至条件不成立。

```go
package main

import "fmt"

func main() {
	for i := 0; i < 5; i++ {
		fmt.Println(i)  // 0, 1, 2, 3, 4
	}
}
```

其中，“初始语句”和“条件因子处理语句”可以为空:

```go
package main

import "fmt"

func main() {
	count := 0

	for count < 5 {
		count++
		fmt.Println(count)  // 1, 2, 3, 4, 5
	}
}
```

死循环，即为循环条件始终成立，导致无法停止，一直持续执行直到程序崩溃。

```go
package main

import "fmt"

func main() {
	count := 0

	for count > 0 {
		count++
		fmt.Println(count)
	}
}
```
