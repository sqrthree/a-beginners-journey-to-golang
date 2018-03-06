# 并发

我们知道，程序是从上到下逐行执行的。只有执行完当前行，才会执行下一行。

如果某一行的操作是一个长耗时的操作，尤其是涉及到网络操作时，就会导致程序长时间的等待，阻塞后续程序的执行。

这个时候如果有一个别的“人”来帮我们执行这个耗时的操作，并在合适的时机将结果告知给我们，从而使我们从这个麻烦中“腾出来”，有精力继续执行后续的操作该多好呀。

这种形式，我们称之为“并发”或“异步”，即“非阻塞”模型。

为了最大化优化程序的执行性能，Go 在语言层面提供了并发编程的支持。

并发，是 Go 语言的核心特性。

而 `goroutine`（Go 程） 是 Go 并行设计的核心。说到底其实就是一种协程。比线程更加轻量级。Go 程的设计隐藏了线程创建和管理的诸多复杂性，使我们可以以一种很简洁的方式来进行并发编程。

`goroutine` 的使用方式也很简单，通过一个 `go` 关键字和普通的函数即可。

在函数或方法前添加 `go` 关键字就可以在新的 `goroutine` 中调用它。当调用完成后， 该 `goroutine` 也会安静地退出。

```go
// 通过在普通函数前加 go 关键字开启一个新的 goroutine
go loadDataFromRemote()

// 执行匿名函数
go func () {
  // do something...
}()
```

多个 `goroutine` 其实在运行在同一个进程之中，多个 `goroutine` 之间会共享内存数据。因此，在 `goroutine` 中直接更改数据会影响到其他的 `goroutine`。这会导致我们的程序数据混乱，出现难以预测的问题。

```go
package main

import (
	"fmt"
	"time"
)

var a string = "Hello"

func update() {
	a = "World"
}

func main() {
	fmt.Println(a) // a 的值为 Hello

	go update()  // 开启一个新 goroutine，并尝试更改 a 的值。

  // 表示当前 goroutine 沉睡 1000 毫秒。Sleep 函数默认接受的单位为纳秒。
	time.Sleep(1000 * time.Millisecond)

	fmt.Println(a) // World
}
```

因此，Go 语言提供了一种在多个 `goroutine` 之间通信的机制 —— `Channel`（通道）。在程序设计上我们要遵循：**不要通过共享来通信，而要通过通信来共享。**

## 通道

`Channel` 是一种用来在多个 `goroutine` 之间进行通信和数据传递的机制。我们可以通过它来发送值或者接收值。

`Channel` 是一种特定的类型，需要通过 `make` 函数创建。并且在定义一个 `Channel` 时，也必须定义发送到该 `Channel` 的值的类型。

```go
var c chan int = make(chan int)

ci := make(chan int)
cs := make(chan string)
cf := make(chan struct{})
```

`Channel` 在定义的时候支持通过 `<-` 指定数据发送的方向。

```go
c1 := make(chan int)	// 可以接收和发送类型为 int 的数据
c2 := make(chan<- int)	// 可以发送类型为 int 的数据
c3 := make(<-chan int)	// 可以接收类型为 int 的数据
```

`Channel` 创建完成之后，我们就可以通过 `<-` 操作符来使用这个通道进行接收和发送数据。

```go
c <- 1				// 将值 1 发送到通道 c 中
value := <-c	// 从通道 c 中取出一个值并赋值给 value
```

例如，我们来看一个简化版的例子：

```go
c := make(chan string)  // 分配一个信道

// 在 goroutine 中启动排序。当它完成后，在信道上发送信号。
go func() {
	result := loadDataFromRemote()

	c <- result  // 发送信号传递数据
}()

doSomethingForAWhile()

data := <-c   // 从 channel 中接收数据
```

向 `Channel` 中发送数据的 `goroutine` 称为发送方，通过 `Channel` 接收数据的 `goroutine` 称为接收方。

```go
package main

import "fmt"

func sum(a []int, c chan int) {
	total := 0

	for _, v := range a {
		total += v
	}

	// 发送方
	c <- total
}

func main() {
	a := []int{7, 2, 8, -9, 4, 0}
	b := []int{2, 4, -5, 6, 9}

	c := make(chan int)

	go sum(a, c)
	go sum(b, c)

	// 当前 goroutine 为接收方
	x := <-c
	y := <-c

	fmt.Println(x)
	fmt.Println(y)
}
```

默认情况下，在另一端准备好之前，发送和接收都会阻塞。这使得 `goroutine` 可以在没有明确的锁或竞态变量的情况下进行同步。

我们来看一个例子来更好的理解这种行为：

```go
package main

import (
	"fmt"
	"time"
)

func do(c chan string) {
	time.Sleep(1000 * time.Millisecond)

	c <- "done"
}

func main() {
	c := make(chan string)

	fmt.Println("1")

	go do(c)

	fmt.Println("2")

	a := <-c

	fmt.Println("3")
	fmt.Println(a)
}
```

程序会先打印出 `1`，然后开启一个新的 `goroutine` 去并行执行 `do()`，而当前 `goroutine` 继续向下执行打印 `2`，之后遇到了 `<-c` 从通道中接收值的操作，但是由于执行 `do()` 的新 `goroutine` 进行了一个比较耗时的操作（程序主动沉睡）导致并未向通道中发送值（即发送方未准备好），此时接收方进入阻塞状态，暂停执行，直至发送方准备好开始发送数据，程序的表现就是在此等待 1 秒钟之后打印 `3` 和 `done`。

同样，如果接收方没有准备好，那么任何发送操作也会被阻塞，直到数据被读出。

## 缓冲通道

使用 `make` 创建通道的时候也可以指定该通道的大小，即通道的缓冲。

缓冲的大小表示该通道能容纳的最多的元素的数量。

设置缓冲大小的方式是：

```go
c := make(chan type, size)
```

如果没有设置容量，或者容量设置为 0, 说明 `Channel` 没有缓存，只有发送方和接收方都准备好了后它们的通讯才会发生。

如果设置了缓存，就有可能不发生阻塞。向缓冲 `Channel` 发送数据的时候，只有在缓冲区满的时候才会阻塞。当缓冲区为空的时候接受方会阻塞。

带缓冲的信道可被用作信号量，例如限制吞吐量。

```go
var MaxOutstanding int = 5 // 设置最大吞吐量
var sem = make(chan bool, MaxOutstanding)

func Serve(queue chan *Request) {
	for req := range queue {
		req := req // 为新 goroutine 创建 req 的新实例，避免多个 goroutine 使用操作一个值。

		// sem 通道的缓冲区大小为 5，
		// 因此当缓冲区未满时，goroutine 会继续向下执行而不会被阻塞，
		// 当超过 5 个，即缓冲区满的时候，该发送操作就会被阻塞，导致 goroutine 暂停。
		sem <- true

		go func() {
			process(req)	// 一个耗时操作，可能需要很长时间。
			<-sem	// 从通道中接收一个值，让出一个位置，使下一个请求可以运行。
		}()
	}
}
```

## Range

我们在读取通道里的多个值的时候，需要连续的进行读取操作，例如：

```go
package main

import "fmt"

func sum(a []int, c chan int) {
	total := 0

	for _, v := range a {
		total += v
	}

	c <- total
}

func main() {
	a := []int{7, 2, 8, -9, 4, 0}
	b := []int{2, 4, -5, 6, 9}

	c := make(chan int)

	go sum(a, c)
	go sum(b, c)

	x := <-c
	y := <-c

	fmt.Println(x)
	fmt.Println(y)
}
```

如果通道的值有很多，那么这样会导致程序非常臃肿。而 `range` 能够让我们以一种更简单的方式来进行连续性读取。

```go
package main

import (
	"fmt"
)

func fibonacci(n int, c chan int) {
	x, y := 1, 2

	for i := 0; i < n; i++ {
		c <- x
		x, y = y, x+y
	}

	close(c)
}

func main() {
	c := make(chan int, 10)

	go fibonacci(cap(c), c)

	for i := range c {
		fmt.Println(i)
	}
}
```

`for i := range c` 能够不断的读取通道里面的数据，直到该通道被显式的关闭。

从上面的函数中我们也看到通道可以通过内置的 `close(chan)` 进行关闭。通道关闭之后，就无法再发送任何数据。

只有发送方才能关闭通道。通常情况下无需关闭它们。只有在需要告诉接收者没有更多的数据的时候才有必要进行关闭，例如中断一个 `range`。

接收方可以通过 `v, ok := <-c` 语法来判断通道是否被关闭。当没有值可以接收并且通道已经被关闭，那么 `ok` 会被设置为 `false`。

## Select

如果在某个 `goroutine` 中存在多个 `channel`，那么我们可以通过 `select` 来监听 `channel` 上的数据流动。

`select` 默认是阻塞的，直到条件分支中的某个可以继续执行，这时就会执行那个条件分支。当多个 `channel` 都准备好的时候，`select` 会随机的选择一个执行。

```go
package main

import "fmt"

// 该函数同时监听两个通道
func fibonacci(c, quit chan int) {
	x, y := 0, 1

	for {
		select {
		case c <- x:	// 新 goroutine 中通道 c 先准备好接收数据，因此该分支先满足继续执行条件，所以先执行。
			x, y = y, x + y
		case <-quit:	// 新 goroutine 中会在循环结束之后才向该通道发送数据，所以后执行。
			fmt.Println("quit")
			return
		}
	}
}

func main() {
	c := make(chan int)
	quit := make(chan int)

	// 开启一个新 goroutine
	go func() {
		for i := 0; i < 10; i++ {
			fmt.Println(<-c)
		}

		quit <- 0
	}()

	fibonacci(c, quit)
}
```

为了非阻塞的发送或者接收，可使用 `default` 分支，当 `select` 中的其他条件分支都没有准备好的时候，`default` 分支会被执行。

```go
select {
case i := <-c:
  // 使用 i
default:
  // 发生阻塞时，该分支会被执行
}
```
