# 二代生活手环 [![Build Status](https://travis-ci.org/bay2/CavyLifeBand2.svg?branch=master) 

## 开发环境

### [Homebrew](http://brew.sh/index_zh-cn.html) (OS X 不可或缺的套件管理器)
**安装命令:**

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
### bundle （确保CocoaPods版本一致）
**安装命令:**
 ```
 gem bundle
 ```

### [CocoaPods](http://guides.cocoapods.org/using/getting-started.html#installation) 0.39.0 (包管理器)

**安装命令:**
```
bundle install
```
### [tailor](https://github.com/sleekbyte/tailor)
**安装命令：**
```
brew install tailor
```
**集成XCode:**
```
tailor --xcode /path/to/demo.xcodeproj/
```

### [SwiftGen](https://github.com/AliSoftware/SwiftGen)(Swift 代码静态扫描工具)

自动生成枚举定义:
- UIImage
- Localizable.strings
- UIStoryboard
- UIColor （定义文件: `{工程目录}/colors.txt`）

**安装命令：**
```
brew install swiftgen
```

**刷新定义:**

已经在工程目录下提供了`generateDefine.sh`脚本。在工程目录下执行：
```
. generateDefine.sh
```

## 开发文档

- [应用框架](doc/md/framework.md)
- [手环绑定/连接流程](doc/md/bandbind.md)
- [UI效果图](doc/md/designsketch.md)
- [UI界面标注](doc/md/mark.md)
- [服务器交互接口文档](http://doc.star7th.com/index.php/home/item/show?item_id=512)
