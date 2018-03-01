# 安装 Go

Go 环境有三种安装方式：

- 源码编译安装：这是一种标准的软件安装方式。对于经常使用 Unix 类系统的用户，尤其对于开发者来说，从源码安装可以把控安装过程和自行进行定制。
- 标准包安装：Go 提供了方便的安装包，支持 Windows、Linux、Mac 等系统。这种方式适合普通开发者进行快速安装。**推荐这种方式**。
- 使用第三方工具安装：目前各个系统都有很多方便的第三方软件包工具，例如 ubuntu 的 `apt-get`、Mac 的 `homebrew`。

### 从源码安装

请参考[官方文档](https://golang.google.cn/doc/install/source)。

### 标准包安装

Go 为每个平台都提供了一键安装包，这些包默认会安装到如下目录：`/usr/local/go` (Windows 系统为 `C:\Go`)，你可以从 https://golang.google.cn/dl/ 下载安装包。

## 测试安装

安装完成之后，可以通过以下方式检测是否安装成功以及能否执行 Go 程序：

#### 查看 Go 版本号

打开终端（Windows 用户使用命令提示符），并输入 `go version`，如若能正常输出 go 的版本号，即表示环境已经安装成功。

```bash
$ go version
go version go1.10 darwin/amd64
```

#### 执行示例代码

在任意地方创建一个示例文件 `hello.go`，文件内容如下：

```go
package main

import "fmt"

func main() {
    fmt.Printf("hello, world\n")
}
```

然后使用终端，进入到文件所在的目录，并执行如下命令：

```bash
$ go run hello.go
hello, world
```

若程序能正常输出 `hello, world` 即表示环境安装成功。
