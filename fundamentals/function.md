# 函数

函数，就代表着“一件事情”。

函数声明，就表示你告知程序，现在有这样一件事情存在。

函数调用（执行），表示告知程序，现在要做这件事啦。

之前我们见到的 `main` 就是定义的一个函数。

## 函数定义

现在，我们想和世界打个招呼，那么我们就可以先定义一个“打招呼”的函数，然后等需要的时候再进行调用这个函数就行。

```go
package main

import "fmt"

// 定义一个函数
func hello() {
  // 函数的具体“动作”
  fmt.Printf("Hello, World.")
}

func main() {
  // 执行函数
  hello()
}
```

函数可以“一次定义，多次执行”。

```go
func hello() {
  fmt.Printf("Hello, World.")
}

func main() {
  hello()
  hello()
  hello()
  hello()
}
```

没有名字的函数称为“匿名函数”。匿名函数需要将其赋值给一个变量才能进行使用：

```go
func main() {
  hello := func() {
    fmt.Printf("Hello, World.")
  }

  hello()
}
```

## 函数传参

如果我们不仅想要和“世界”打招呼，还想要和任何我们想要的对象打招呼，但是这个对象是我们在函数执行时才确定下来的，那该怎么办呢？

我们可以利用“参数”来向一个函数“动态”地传递一些信息，就上面的需求，我们可以将要打招呼的“对象”通过参数的形式传递给函数，这种行为我们称之为“函数传参”。

我们来改造一下这个函数：

```go
package main

import "fmt"

func hello(name string) {
  fmt.Printf("Hello, ")
  fmt.Println(name)
}

func main() {
  hello("World")  // Hello, World
  hello("China")  // Hello, China
  hello("大美帝")  // Hello, 大美帝
}
```

以上代码 `func hello(name string) {` 中的 `name string` 就表示一个参数，`name` 为参数名，你可以在这个函数中像使用一个变量一样使用这个参数，`string` 标示这个参数的类型。而接下来的 `hello("World")` 就是在函数调用时，将 `"World"` 传递给函数的 `name`。

参数，就类似于一个“用来占位置的东西”，这个“东西”在函数定义的时候只用来“占一个位置”，但值是不确定的。只有当函数调用时传递进去一个值时，参数所代表的值才能够确定下来。

函数的参数个数是不限制的。当一个函数接收多个参数时，使用 `,` 进行分割。函数调用时需要按照参数定义的顺序进行依次传递。

比如，我们需要实现一个 `add` 函数，用来计算两个数字之和，那么我们可以这么做：

```go
package main

import "fmt"

func add(x int, y int) {
  fmt.Println(x + y)
}

func main() {
  add(1, 2)   // 3
  add(8, 10)  // 18
}
```

当两个或多个连续的函数命名参数是同一类型时，除了最后一个类型之外，其他都可以省略。

在这个例子中，`x int, y int` 可以被缩写为 `x, y int`。

### 不定参数

现在我们的 `add` 函数只支持计算两个数字之和，那我们要是想要计算三个数字甚至是不确定个数字之和呢？

这里就要用到由 `...` 表示的“变参”了，`...` 表示接受变参的函数是有着不定数量的参数。

```go
package main

import "fmt"

func add(numbers ...int) {
  fmt.Println(numbers)
}

func main() {
  add(1, 2)
  add(8, 10, 12)
}
```

我们的 `add` 函数终于支持计算不定个数字之和了。

`numbers` 的值就是函数在调用时传入的参数的集合。它是一个 `slice` 类型，不再是之前的 `int` 了。因此也不能用之前的 `+` 进行计算。至于如何操作 `slice` 来进行计算，我们稍后会详细介绍。

### 参数的值传递

函数定义时用来“占位置，走走形式”的参数我们称之为“形参”，函数调用时实际传递进去的参数我们称之为”实参”。

当我们传一个参数值到被调用函数里面时，实际上是传了这个值的一份复制品，当在被调用函数中修改参数值的时候，调用函数时传递的参数不会发生任何变化。

即，对“形参”的任何修改，都不会让“实参”发生变化。

```go
package main

import "fmt"

func add(x, y int) {
  x = 10
}

func main() {
  a := 1
  b := 2

  fmt.Println(a)  // 1
  add(a, b)
  fmt.Println(a)  // 1
}
```

那老子就是想改“实参”的值，怎么办？这就需要我们使用**指针**来完成了。我们稍后会详细介绍指针的概念。

### 返回值

有时候，我们要做的这件事情不仅仅只是一个计算，还想要将计算结果存起来在其他地方进行使用。那么我们就需要在当前函数执行完之后返回一些东西，然后在外面进行接收。这个东西就叫做返回值。

返回值通过 `return` 来完成。返回值的类型需要声明在函数定义时。

```go
package main

import "fmt"

func add(x, y int) int {  // ") int {" 这里的 "int" 就是标识返回值的类型为 int。
  sum := x + y

  return sum
}

func main() {
  result := add(1, 2) // result 的值就是函数 add 执行完之后返回的结果，这里为 3

  fmt.Println(result) // 3
}
```

函数可以返回任意数量的返回值，我们可以使用这个特性来完成“变量值互换”的操作：

```go
package main

import "fmt"

func toggle(x, y int) (int, int) {
  return y, x
}

func main() {
  a := 1
  b := 2

  fmt.Println(a, b) // a = 1, b = 2

  a, b = toggle(a, b)

  fmt.Println(a, b) // a = 2, b = 1
}
```

### 命名返回值

Go 的返回值可以被命名，并且像变量一样使用。

```go
package main

import "fmt"

func add(x, y int) (sum int) {
	sum = x + y  // sum 为已经命名过的返回值，这里不需要重新定义该变量。

	return // 不接收参数，直接返回 sum 的值。
}

func main() {
	result := add(1, 2)

	fmt.Println(result)
}
```

命名返回值仅应当用在较短的函数中。在长的函数中它们会影响代码的可读性。

### defer

我们之前说过，代码是按顺序逐行执行的。但是 Go 中提供了一种调整代码行顺序的机制 —— `defer`。

我们可以在函数中添加多个 `defer` 语句。当函数正常执行到 `defer` 语句时，会暂时跳过。待函数的最后一行执行完之后，这些 `defer` 语句会按照**逆序**执行，最后该函数返回。

`defer` 语句由关键字 `defer` 表示：

```go
func main() {
  hello()

  defer hi()

  hello()
}
```

例如，当我们在进行一些打开资源的操作时，遇到错误需要将函数提前返回，但是在返回前我们需要关闭相应的资源，不然很容易造成资源泄露等问题。我们一般是这样操作的：

```go
func readFile() {
  file.Open("example")

  // 如果打开失败了，我们需要关闭资源
  如果出现错误 1，执行 file.Close() 关闭资源

  // 做一些操作

  // 如果权限不足，我们需要关闭资源
  如果出现错误 2，执行 file.Close() 关闭资源

  // 操作完成，关闭资源
  file.Close()
  return true
}
```

有了 `defer`，上面的代码就不需要这么啰嗦：

```go
func readFile() {
  file.Open("example")

  // 在 defer 后指定的函数会在函数退出前调用。
  defer file.Close()

  // 如果打开失败了，程序会在返回前执行 defer 语句。
  如果出现错误 1，return false

  // 做一些操作

  // 如果权限不足，，程序会在返回前执行 defer 语句。
  如果出现错误 2，return false

  // 操作完成，关闭资源
  return true
}
```

### 传递函数

函数也可以作为一个特殊的变量来对待，我们可以使用 `type` 关键字来自定义一个函数类型，表示所有拥有相同的参数、相同的返回值的一种类型。

```go
type typeName func(inputType1, inputType2) (outputType1, outputType2)
```

有了这个特性，函数也就可以当做另外一个函数的“实参”进行传递。

比如，我们想要对 `a,b` 两个值进行加减乘除的操作，我们就可以将运算函数作为一个参数进行传递：

```go
package main

import "fmt"

// 自定义类型
type operation func(int, int) int

func add(x, y int) int {
	return x + y
}

func subtrace(x, y int) int {
	return x - y
}

func multiply(x, y int) int {
	return x * y
}

func division(x, y int) int {
	return x / y
}

// 接收 operation 类型的函数作为参数
func doIt(x, y int, f operation) int {
	return f(x, y)
}

func main() {
	sum := doIt(1, 2, add)
	diff := doIt(10, 2, subtrace)
	product := doIt(2, 3, multiply)
	quotient := doIt(9, 3, division)

	fmt.Println(sum)       // 3
	fmt.Println(diff)      // 8
	fmt.Println(product)   // 6
	fmt.Println(quotient)  // 3
}
```

`doIt` 这种能够接收一个函数作为参数的函数，我们称之为“高阶函数”。

### 保留函数

Go 里面有两个函数作为语言层面使用的的保留函数：

- `main` 函数（只能应用于 `package main` 中）
- `init` 函数（能够应用于所有的 package）

这两个函数在定义时不能有任何的参数和返回值。

Go 程序会自动调用 `init()` 和 `main()`，所以我们不需要在任何地方调用这两个函数。

每个 package 中的 `init` 函数都是可选的，但 `package main` 必须包含一个 `main` 函数。

原则上，`main()` 在整个程序中只能出现一次，而 `init` 函数在同一个 package 中可以出现多次。但为了程序的可读性和可维护性，强烈建议在一个 package 中的每个文件只定义一个 `init` 函数。
