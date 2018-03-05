# 导入导出

我们在一开始就说过，Go 程序是以 package 来组织代码的。

通过将代码按照其功能或是业务逻辑进行划分，分别组织到不同的 package，可以有效提高我们代码的可读性以及可维护性。

定义一个 package 我们可以在文件顶部使用 `package PACKAGE_NAME` 语法。

多个文件可以有同样的 `PACKAGE_NAME`，表示它们属于同一个 package。

如果一个 package 由多个文件组成，通常会以当前 package 名创建一个文件夹，然后将属于该 package 的所有文件均放置在这一个目录下，以提高代码的可维护性。

定义了 package 之后，各个 package 之间如何相互使用呢？

我们可以 `import` 关键字来向一个 package 中导入一个或多个其他的 `package`。

## 导入标准库

`import PAKCAGE_NAME` 即可导入一个标准库。例如我们一直在使用的 `import "fmt"`。

我们也可以一次批量导入多个库：

```
import (
  "fmt"
  "math"
  "net/http"
)
```

## 导入自定义 package

除了标准库之外，我们也可以导入自定义的 package。

使用 `import` 导入自定义 package 时，需要指明要导入的 package 的路径。

- 相对路径 - `import "./p"`
- 绝对路径 - `import "myapp/p"`，本质上程序加载的路径为 `$GOPATH/src/myapp/p`。

除了以上最常见的两种形式之外，还有几种骚操作：

### 第一种：`.`

普通方式导入一个 package 之后，在使用其 package 中提供的一些函数或变量时，需要加上 package 名。例如一直在使用的 `fmt.Printf`，但是通过 `.` 方式导入的 package，在使用其函数或变量时，不需要加上前缀，可以直接使用。

```go
package main

import (
  . "fmt"
)

func main() {
  Printf("Hello, World.")
}
```
### 第二种：别名

这种方式就是给我们导入的 package 起一个别名，使用的时候使用别名作为前缀：

```go
package main

import (
  f "fmt"
)

func main() {
  f.Printf("Hello, World.")
}
```

### 第三种：`_`

`_` 操作表示只是引入该 package，而不直接使用 package 里面的函数，只是调用了该 package 里面的 `init` 函数。

```go
package main

import (
	"database/sql"
	"fmt"
	_ "github.com/ziutek/mymysql/godrv"
)

func main() {
	fmt.Printf("Hello, World.")
}
```

## 导出

我们在导入一个 package 之后，只能使用其导出的函数或变量。

而想要导出一个函数或变量，需要遵循的规则是：

> 以首字母大写的名称的函数或变量会被导出。

例如，`Foo` 和 `FOO` 都是被导出的名称。名称 `foo` 是不会被导出的。
