# Windows / GitHub Actions 自动编译 RootHide `.deb`

这版工作流会使用 RootHide 官方 Theos 安装器，并在编译前强制检查：
- iOS toolchain 是否存在
- Theos SDK 是否存在
- clang 是否可执行

### 使用

1. 用此版本覆盖 GitHub 仓库中的旧文件。
2. 保留 `.github/workflows/build.yml`。
3. 提交到 `main`。
4. 打开 **Actions → Build RootHide deb**。
5. 等待绿色成功。
6. 在运行页面底部 **Artifacts → KeyboardRounded-deb** 下载。
7. 解压 Artifact ZIP，得到 `.deb`。

### 为什么这版修改了 workflow

之前的失败日志是：

`You do not have any SDKs in .../.theos/sdks`

说明构建时 Theos 没有看到 SDK。新版不再把工程自己的 `.theos` 当作 Theos，并在编译前显式检查 `$HOME/theos/sdks` 和 iOS clang toolchain。

RootHide 官方开发文档要求使用 RootHide Theos，并以：
`make package THEOS_PACKAGE_SCHEME=roothide`
构建 RootHide 包。
