# 接口

简单的来说，`interface`（接口）类型是由一组方法定义的集合。它的含义是：“如果某样东西可以完成这个，那么它就可以用在这里”。其定义的方法也很简单：

```go
type Human interface {
  SayHi()
  SayHello()
}
```

`Human` 表示我们定义了一个名为 `Human` 的 `interface` 类型，`{}` 里面则是这个 `interface` 类型所包含的方法。

`interface` 类型只需要声明其包含哪些方法，不需要负责实现。这些方法由实现方自行实现。因此，`interface` 类型只定义方法集合，而不关心其具体实现方式

如果实现方具有（实现）该 `interface` 类型中所定义的所有方法，那么我们就称其实现了这个 `interface` 类型。

如果一个变量是某个 `interface` 类型，那么其值只能可以存放实现了这些方法的值。

```go
package main

import "fmt"

type Human interface {
  SayHi()
  SayHello(obj string)
}

type Man struct {
  name string
  age int
}

func (m Man) SayHi() {
  fmt.Println("Hi, I am", m.name)
}

func (m Man) SayHello(obj string) {
  fmt.Println("Hello,", obj)
}

func main() {
  xiaoming := Man{
    name: "xiaoming",
		age: 18,
  }

  fmt.Println(xiaoming.name)  // xiaoming

  xiaoming.SayHi()  // Hi, I am xiaoming
  xiaoming.SayHello("Struct")  // Hello, Struct

  var a Human // 定义变量 a 为 Human interface 类型

  // 因为 Man struct 类型实现了 Human interface 类型中定义的所有方法，
  // 所以我们可以说 Man struct 类型实现了 Human interface 类型。
  // 因此变量 a 可以保存 Man struct 类型的值 —— xiaoming。
  a = xiaoming

  // 执行 Human interface 类型中定义的方法
  // 这里的 a 实际的值为 xiaoming，因此执行 a.SayHi() 和 xiaoming.SayHi() 的结果一样
  a.SayHi() // Hi, I am xiaoming
  a.SayHello("Interface") // Hello, Interface

  xiaodong := Man{
    name: "xiaodong",
  }

  fmt.Println(xiaodong.name)  // xiaodong

  xiaodong.SayHi()  // Hi, I am xiaodong
  xiaodong.SayHello("Struct")  // Hello, Struct

  // xiaodong 也是 Man struct 类型，因此变量 a 也可以保存 xiaodong。
  a = xiaodong

  // 此时，a 的值改为了 xiaodong，因此执行 a.SayHi() 和 xiaodong.SayHi() 的结果一样
  xiaodong.SayHi()  // Hi, I am xiaodong
  xiaodong.SayHello("Interface")  // Hello, Struct
}
```

`interface` 可以被任何其他类型实现，当然，一个其他类型对象也可以同时实现多个 `interface`。我们再来看一个复杂点的例子：

```go
package main

import "fmt"

type Human interface {
  SayHi()
}

type Man interface {
  SayHi()
  PlayGame()
}

type Woman interface {
  SayHi()
  Sing()
}

type superman struct {
  name string
}

func (s superman) SayHi() {
  fmt.Println("Hi, I am superman.")
}

func (s superman) PlayGame() {
  fmt.Println("Hi, I am superman, I can play game.")
}

func (s superman) Sing() {
  fmt.Println("Hi, I am superman, I can sing.")
}

type student struct {
  name string
  age int
}

func (s student) SayHi() {
  fmt.Println("Hi, I am a student.")
}

func (s student) PlayGame() {
  fmt.Println("Hi, I am a student, I can play game, too.")
}

type employee struct {
  name string
}

func (e employee) SayHi() {
  fmt.Println("Hi, I am a employee.")
}

func (e employee) Sing() {
  fmt.Println("Hi, I am a employee, I can not play game, but I can sing.")
}

func main() {
  xiaoming := student{"xiaoming", 18}
  Tom := employee{"Tom"}
  spiderman := superman{"spiderman"}

  var m Man

  m = xiaoming

  m.SayHi() //
  m.PlayGame()

  m = spiderman

  m.SayHi()
  m.PlayGame()

  var w Woman

  w = Tom

  w.SayHi()
  w.Sing()

  w = spiderman

  w.SayHi()
  w.Sing()

  var h Human

  // h = xiaoming
  // h = Tom
  h = spiderman

  h.SayHi()
}
```

在这个例子中，`superman` 和 `student` 类型都实现了  `Man interface`，`superman` 和 `employee` 类型都实现了 `Woman interface`。同时，这三个 `struct` 类型又都同时实现了 `Human interface`。

因此，在上面的代码中，`m` 可以保存 `xiaoming` 和 `spiderman` 的值，`w` 可以保存 `Tom` 和 `spiderman` 的值，而 `h` 可以保存这三个的值。

## 接口的真正含义

主要注意的是，`interface` 类型的值只能调用该 `interface` 类型规定的方法。这也是我们使用 `interface` 类型的一大好处 —— 屏蔽内部方法。

我们来看一个例子：

```go
package main

import "fmt"

type superman struct {
  name string
}

func (s superman) SayHi() {
  fmt.Println("Hi, I am", s.name)
}

func (s *superman) SetName(name string) {
  s.name = name
  fmt.Println("Hi, I got a new name,", s.name)
}

func beBorn() superman {
  spiderman := superman{}

  spiderman.SetName("spiderman")  // 给这个超人一个名字
  spiderman.SayHi() // Hi, I am spiderman

  fmt.Println("Great, My name is", spiderman.name)  // Great, My name is spiderman

  return spiderman
}

func main() {
  man := beBorn()

  man.SayHi() // Hi, I am spiderman
  fmt.Println(man.name) // spiderman

  man.SetName("Batman") // 注意！这里重新给这位超人设置了一个新名字

  fmt.Println(man.name) // Batman

  man.SayHi() // Hi, I am Batman
}
```

假如没有 `interface`，那么我们通过 `beBorn()` 函数创建一个 `superman struct` 类型的值，在该函数外也能够使用 `superman struct` 下的所有方法。

在上面的例子中，我们就通过在 `beBorn()` 函数外使用 `man.SetName("Batman")` 给我们心爱的超人换了一个名字。从此 “spiderman” “Batman” 傻傻分不清楚。

超人怎么能随便乱换名字呢，这不就乱套了吗？

要想解决这个问题，我们就需要在超人有了名字之后禁止他再换名字，即在 `beBorn()` 函数外不能再执行 `SetName()` 方法。`interface` 就可以帮我们来达到这个目的。

```go
package main

import "fmt"

type Hero interface {
  SayHi()
}

type superman struct {
  name string
}

func (s superman) SayHi() {
  fmt.Println("Hi, I am", s.name)
}

func (s *superman) SetName(name string) {
  s.name = name
  fmt.Println("Hi, I got a new name,", s.name)
}

func beBorn() Hero {
  spiderman := superman{}

  spiderman.SetName("spiderman")
  spiderman.SayHi()

  fmt.Println("Great, My name is", spiderman.name)

  var h Hero

  h = spiderman

  // 返回一个接口值而非实现的类型。
  // 这里返回 Hero interface 类型。
  return h
}

func main() {
  // man 为 Hero interface 类型
  man := beBorn()

  man.SayHi()

  // Hero interface 类型中没有 SetName 方法，因此无法调用。
  // man.SetName("Batman")
}
```

## 接口实现和指针

当我们在实现某个 `interface` 时，如果方法的接收者为一个指针，那么我们需要特别注意了。例如下面这个例子：

```go
package main

import "fmt"

type Hero interface {
  getName() string
  setName(name string)
}

type superman struct {
  name string
}

func (s superman) getName() string {
  return s.name
}

// 该方法的接收者为指针。
func (s *superman) setName(name string) {
  fmt.Println("通过指针的形式设置 name")

  s.name = name
}

func main() {
  man := superman{}

  var h Hero

  // 因为 setName 方法的接收者为指针，而这里 man 不是指针类型，因此我们就不能说 man 的值实现了 Human interface，程序在编译时会抛出一个错误。
  // h = man

  // 正确的方式是 h 应该存储其对应的指针
  h = &man

  h.setName("spiderman")
}
```

## 鸭子类型

我们之前说过，`interface` 可以被任何其他类型实现。例如，在这个例子中：

```go
package main

import "fmt"

type Human interface {
  SayHello()
}

type Man struct {
  name string
}

func (s Man) SayHello() {
  fmt.Println("Hello, I am", s.name)
}

type Monkey struct {
  name string
}

func (m Monkey) SayHello() {
  fmt.Println("Hello, I am", m.name)
}

func main() {
  p := Man{"xiaoming"}
  m := Monkey{"monkey"}

  var h Human

  h = p

  h.SayHello()

  h = m

  m.SayHello()
}
```

尽管 `Man` 和 `Monkey` 不是同一个类型，但是由于其都实现了 `SayHello()` 方法，因此用起来是一样的。在编程的世界里，我们成这种为“鸭子类型”。

> “鸭子类型”即当看到一只鸟走起来像鸭子、游泳起来像鸭子、叫起来也像鸭子，那么这只鸟就可以被称为鸭子。

Go 语言通过 `interface` 实现了“鸭子类型”。

## `interface` 参数

`interface` 也可以作为一个函数的参数进行传递，从而达到函数接受任何类型的值作为参数的目的。

```go
package main

import "fmt"

type Stringer interface {
  String() string
}

// 接受 interface 类型，任何实现了该 interface 的类型的值都可以作为参数传递给 log 函数
func log(s Stringer) {
  fmt.Println(s.String())
}

type Human struct {
  name string
}

func (h Human) String() string {
  return "哈哈哈，我是 Human"
}

// 自定义一个 myInt 类型，本质上还是一个 int 类型
type myInt int

func (i myInt) String() string {
  return "哈哈哈，我是 myInt"
}

func main() {
  h := Human{"human"}
  i := myInt(1) // 这里的 myInt(1) 是将 int 类型的值 1 转换为 myInt 类型。类型转换的语法是：T(value)

  log(h)
  log(i)
}
```

## `Comma-ok` 断言

我们知道 `interface` 的变量里面可以存储任意实现了该 `interface` 的类型的值。那么我们怎么知道这个变量里面实际保存了的是哪个类型的对象呢？

Go 语言里面有一个语法，可以用来直接判断是否是该类型的变量：`value, ok = element.(T)`。

`element` 是 `interface` 变量，`T` 是被断言的类型。

如果判断成功，这里 `value` 就是 `element` 变量的实际值，`ok` 为 `true bool`， 如果失败，`value` 为类型 `T` 的“零值”，`ok` 为 `false bool`。

```go
package main

import "fmt"

type Human interface {
  SayHi()
}

type Man struct {
  name string
}

func (m Man) SayHi() {
  fmt.Println("Hi, I am a Man")
}

type Woman struct {
  name string
}

func (w Woman) SayHi() {
  fmt.Println("Hi, I am a Woman")
}

func main() {
  m := Man{"man"}
  w := Woman{"woman"}

  var h Human

  h = m

  // 条件成立
  if value, ok := h.(Man); ok {
    fmt.Println("1. h 的值是 Man 类型")
    fmt.Println(value)
  }

  // 条件不成立
  if value, ok := h.(Woman); ok {
    fmt.Println("1. h 的值是 WoMan 类型")
    fmt.Println(value)
  }

  h = w

  // 条件不成立
  if value, ok := h.(Man); ok {
    fmt.Println("2. h 的值是 Man 类型")
    fmt.Println(value)
  }

  // 条件成立
  if value, ok := h.(Woman); ok {
    fmt.Println("2. h 的值是 WoMan 类型")
    fmt.Println(value)
    fmt.Println(value == WoMan)
  }
}
```

##

要判断一个 `interface` 的值的类型，除了使用 `Comma-ok` 之外，还可以使用 `switch` 语法：

```go
package main

import "fmt"

type Human interface {
	SayHi()
}

type Man struct {
	name string
}

func (m Man) SayHi() {
	fmt.Println("Hi, I am a Man")
}

type Woman struct {
	name string
}

func (w Woman) SayHi() {
	fmt.Println("Hi, I am a Woman")
}

func main() {
	m := Man{"man"}
	var h Human

	h = m

	// 这里使用的是 value := element.(type) 语法
	switch value := h.(type) {
	case Man:
		// 条件成立
		fmt.Println("Man 类型", value)
	case Woman:
		fmt.Println("Woman 类型", value)
	}
}
```

需要强调的是，`element.(type)` 语法不能在 `switch` 以外的任何逻辑里面使用，如果你要在 `switch` 外面判断一个类型就使用 `comma-ok`。
