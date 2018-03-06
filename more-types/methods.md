# 方法

通过 `struct`，我们可以很方便的定义一个属于自己的独一无二的类型，比如说我们定义一个“人”和一个“物品”：

```go
package main

import "fmt"

type person struct {
  name string
  age int
  gender string
}

type stuff struct {
  name string
  class string
}

func main() {
  xiaoming := person{
    name: "xiaoming",
		age: 18,
		gender: "male",
  }

  table := stuff{
    name: "桌子",
    class: "家具",
  }

  fmt.Println(xiaoming.name)
	fmt.Println(table.name)
}
```

但是，我们所知道的“人”，除了有一些自己的信息属性之外，还能做一些事情，比如说“打招呼”，但是这个动作是“人”所独有的，跟“物品”没有关系，那该怎么办呢？

我们之前学过函数，知道函数就是来代表一件事情，那这里自然是离不开函数咯。但是这里我们需要将“打招呼”这个函数和“人”这个结构体怎么进行关联呢？

我们在定义函数的时候除了设置函数名、参数、返回值之外，还可以给这个函数定义一个“接收者”，使其和指定的结构体关联起来。这个拥有“接收者”的函数我们称之为该结构体的“方法”，这个“接收者”称之为“方法的接收者”。

“方法接收者”出现在 `func` 关键字和方法名之间。

```go
package main

import "fmt"

type person struct {
  name string
  age int
  gender string
}

type stuff struct {
  name string
  class string
}

func (p person) hello() {
  fmt.Println("你好，我的名字是", p.name)
}

func main() {
  xiaoming := person{
    name: "xiaoming",
		age: 18,
		gender: "male",
  }

  xiaohong := person{
    name: "xiaohong",
		age: 18,
		gender: "female",
  }

  table := stuff{
    name: "桌子",
    class: "家具",
  }

  xiaoming.hello()
  xiaohong.hello()

  fmt.Println(xiaoming.name)
	fmt.Println(table.name)
}
```

我们实现了一个 `hello` 方法，并将其“接收者”设置为 `person` 结构题，因此所有该结构体类型的变量都可以通过 `.hello()` 的形式使用这个方法。

“接收者”中所定义的变量就代表当前方法调用者的值，可以在当前函数中被访问和使用。

除了 `struct` 之外，你还可以对当前 package 中的**任意类型**定义任意方法，而不仅仅是针对 `struct`。

但是，不能对来自其他 package 的类型或基础类型定义方法。

## 接收者为指针的方法

我们知道，“人”总会长大的。现在，我们来继续完善这个程序，添加一个“长大”的方法吧。

```go
package main

import "fmt"

type person struct {
  name string
  age int
  gender string
}

func (p person) hello() {
  fmt.Println("你好，我的名字是", p.name)
}

func (p person) grow(age int) {
  p.age += age
}

func main() {
  xiaoming := person{
    name: "xiaoming",
		age: 18,
		gender: "male",
  }

  fmt.Println(xiaoming.name)  // xiaoming
  fmt.Println(xiaoming.age)   // 18

  xiaoming.grow(2)  // 长大 2 岁

  fmt.Println(xiaoming.age)   // 这里我们期望的是年龄变为 20，然而实际运行结果却是 18
}
```

上面的程序看似没有任何问题，然而运行结果却不符合我们的预期，这是怎么回事呢？

首先，我们要知道的是，函数在参数传递的过程中，传递的并不是当前实际的值（实参），而是将实参复制一个版本，然后将这个“复制品”传递到函数里进行使用。那自然你在函数中的任何操作对外面的实参都是没有任何影响的咯。

还记得我们学过的指针吗？指针就是专门来解决这个问题的。

我们需要将方法的接收者改为指针，然后在方法执行的时候，使用指针来调用方法。

```go
package main

import "fmt"

type person struct {
  name string
  age int
  gender string
}

func (p person) hello() {
  fmt.Println("你好，我的名字是", p.name)
}

// 设置接收者为指针
func (p *person) grow(age int) {
  p.age += age
}

func main() {
  // 保存该值的指针，而不是值本身。
  xiaoming := &person{
    name: "xiaoming",
		age: 18,
		gender: "male",
  }

  fmt.Println(xiaoming.name)
  fmt.Println(xiaoming.age)

  xiaoming.grow(2)

  fmt.Println(xiaoming.age)
}
```

使用指针接收者通常有两个原因：

- 方法可以修改接收者指向的值。
- 避免在每个方法调用中拷贝值，提高程序的性能。
