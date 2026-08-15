# KeyboardRounded 1.1.0

针对 iOS 17 + Relaxin / RootHide 的全局系统键盘圆角 tweak。

## 这版修正了上一版的关键问题

上一版错误地只注入 SpringBoard，而且把 `UIInputSetContainerView` 当成主要圆角目标；该容器可能是全屏尺寸，因此实际很可能不会得到预期效果。

本版改为：

- 不在 Tweak.plist 限制 SpringBoard
- 主要 Hook `UIInputSetHostView`
- `UIInputSetContainerView` 仅作为 fallback
- 圆角应用到真正的键盘 Host，而不是全屏 Container
- 不写死 iPhone 15 Pro Max 尺寸
- arm64 / arm64e 通用源码，RootHide 包按设备架构处理
- 默认圆角 30pt
- 0~60pt 可调
- 可选左右/上下内缩
- Continuous Corners 可开关

## Relaxin / RootHide 编译

Relaxin 使用 RootHide 环境。建议使用 roothide/theos，而不是普通 Theos，然后：

```sh
make package FINALPACKAGE=1 THEOS_PACKAGE_SCHEME=roothide
```

官方 RootHide Developer 文档说明，普通不涉及 jailbreak 文件 API 的 tweak 可以直接使用 `THEOS_PACKAGE_SCHEME=roothide` 构建；roothide/Theos 与普通 Theos 保持兼容。

## 重要：RootHide 的进程注入

RootHide 默认不会向所有第三方 App 自动注入 tweak。要做到“全局键盘”，需要让使用键盘的 App 获得该 tweak 的注入。

如果 Relaxin 的 RootHide 管理器提供 App List / 注入开关，请开启你需要使用键盘的 App；否则 tweak 即使安装成功，也不会在那个 App 进程里运行。

系统键盘通常位于 `UIRemoteKeyboardWindow` 的键盘层级中，常见层级包含 `UIInputSetContainerView -> UIInputSetHostView`。因此本 tweak 选择 HostView 作为圆角目标。

## 推荐参数

为了接近用户提供的“大圆角键盘”效果：

- 圆角：30~36pt
- 左右内缩：0pt
- 上下内缩：0pt
- 连续圆角：开

先不要调内缩。内缩会改变 UIKit 给键盘 Host 的布局尺寸，部分 App/输入法可能重新布局。

## 第三方输入法

本 tweak 主要针对 Apple 系统键盘的 UIKit 键盘 Host。某些第三方输入法如果使用完全不同的键盘 Window / View 层级，可能需要单独适配。
