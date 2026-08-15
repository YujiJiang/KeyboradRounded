# GitHub Actions 自动编译

本工程针对 RootHide / Relaxin 使用 RootHide Theos 构建。

Workflow 会：
1. 安装系统 make/build-essential
2. 使用 RootHide 官方 install-theos 脚本安装 Theos、Linux iOS toolchain 和 SDK
3. 使用系统 `make` 调用 Theos（Theos 不要求 `$THEOS/bin/make` 存在）
4. `make package FINALPACKAGE=1 THEOS_PACKAGE_SCHEME=roothide`
5. 将生成的 `.deb` 上传为 Artifact

如果 Actions 失败，请把失败步骤展开后的最后 30-50 行日志发给我。
