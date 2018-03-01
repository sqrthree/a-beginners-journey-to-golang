# 理解工作区

工作区，字面意思，就是程序工作的地方。但是在 Go 的世界里，要想让程序正常工作，你需要按照一种特别的方式来组织你的代码。这种特别的方式就是你需要将你的程序需要放在“工作区”里。“工作区”之外的程序可能并不会如你的预期那样正常执行。

## GOPATH

这个“工作区”其实就是一个指定的目录。你在开发程序时需要将其放在这个指定的目录下进行开发。这个目录是由一个名为 `GOPATH` 的环境变量所控制，默认为 `$HOME/go`，（Windows 上默认为 `%USERPROFILE%/go`）。

查看当前的“工作区”：

```bash
$ go env GOPATH
```

如果你想要修改“工作区”的位置，那么只需要修改环境变量 `GOPATH` 的值即可。需要注意的是 `GOPATH` 的值不能是 Go 的安装目录。

当你使用 `go get` 来获取第三方的 package 时，程序也会自动将 package 下载到 `GOPATH` 目录中。

`GOPATH` 允许指定为多个目录，当指定为多个目录时，使用冒号作为分隔符（Windows 为分号）。并且默认会将 `go get` 的内容放在第一个目录下。

## 目录结构

“工作区”的目录结构如下：

- `src` - 存放 Go 程序的源代码。
- `pkg` - 编译后的 package 对象文件。
- `bin` - 可执行命令

`src` 目录通常包含多个版本控制仓库用来跟踪一个或多个源码包的开发。这个目录是你开发程序的主目录，所有的源码都是放在这个目录下面进行开发。通常的做法是一个目录为一个独立的项目。例如 `$GOPATH/src/hello` 就表示 `hello` 这个应用/包。

因此，每当开发一个新项目时，都需要在 `$GOPATH/src/` 下新建一个文件夹用作开发。当你在引用其他包的时候，Go 程序也会以 `$GOPATH/src/` 目录作为根目录进行查找。当然了， `src` 目录允许存在多级目录，例如在 `src` 下面新建了目录 `$GOPATH/src/github.com/golang/example/hello`，那么这个包路径就是 `github.com/golang/example/hello`，包名称为最后一个目录 `hello`。

例如

```
bin/
    hello                          # command executable
    outyet                         # command executable
pkg/
    linux_amd64/
        github.com/golang/example/
            stringutil.a           # package object
src/
    github.com/golang/example/
        .git/                      # Git repository metadata
      	hello/
      	    hello.go               # command source
      	outyet/
      	    main.go                # command source
      	    main_test.go           # test source
      	stringutil/
      	    reverse.go             # package source
      	    reverse_test.go        # test source
    golang.org/x/image/
        .git/                      # Git repository metadata
      	bmp/
    	    reader.go              # package source
    	    writer.go              # package source
    ... (many more repositories and packages omitted) ...
```

## 包路径

对于你自己的包，建议设置一个基本路径作为命名空间，来保证它不会与将来添加到标准库或其它扩展库中的包相冲突。

如果你将你的代码放到了某处的源码库中，那就应当使用该源码库的根目录作为你的基本路径。例如，若你在 GitHub 上有账户 github.com/user 那么它就应该是你的基本路径，即新创建项目的路径为 `$GOPATH/src/github.com/user/PACKAGE_NAME`。

注意，在你构建这些代码之前，无需将其公布到远程代码库上。只是如若你某天要发布它，就会发现这会是个好习惯。在实践中，你可以选择任何路径名，只要它对于标准库和更大的 Go 生态系统来说是唯一的就行。

我们将在后续的案例中使用 `github.com/user` 作为基本路径。在你的工作空间里创建一个目录，方便我们将源码存放到其中：

```
$ mkdir -p $GOPATH/src/github.com/user
```
