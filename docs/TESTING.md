# 验证记录

日期：2026-11-08（Asia/Tokyo）。

Android 预览包已安装并启动，模拟器分辨率与密度已恢复。最终保留包位于 `delivery/taskflow-preview.apk`；通过 Flutter/Gradle 自带清理功能移除大型构建中间文件。

## 环境

- Windows 11，Flutter 3.47.7，Dart 3.13.5。
- 复用现有 `emulator-5554`，设备报告为 SM S908E、Android 11 / API 30、x86_64。
- 未新建 AVD，未下载系统镜像。为匹配设计稿，截图期间临时使用 856 × 1852、density 320（428 × 926 逻辑像素）；测试完成后恢复模拟器原始显示配置。
- Android 使用本机已有的 Gradle 8.14、AGP 8.11.1、Kotlin 2.2.20、NDK 28.2.13676358。

## 已完成的检查

| 检查 | 结果 |
| --- | --- |
| Flutter 静态检查 | `flutter analyze` 通过，无问题 |
| 本地数据恢复 | 项目、消息、主题重新加载后保持 |
| 任务状态隔离 | 一个任务的子任务与日期不会改变另一个任务；重载后保持 |
| 表单流程 | 项目名称为空显示校验信息；填写后创建并显示到列表 |
| Android 全页面 | 40 个页面及状态 × 2 种主题，页面与弹层渲染均无 Flutter 布局异常 |
| Android 主要操作 | 创建项目、创建任务、完成子任务、编辑任务、发送本地消息、数据重载、退出确认通过 |
| 截图 | 80 张 PNG，均为 856 × 1852；逐张检查可解码与非空白，并人工复核主要页面 |
| Release 安装 | arm64 + x86_64 APK 构建成功；在现有模拟器安装并启动确认 |
| 文档链接 | 项目说明、截图索引和设计稿对应表中的本地图片及文件链接已检查 |

## 复现命令

```powershell
flutter pub get
flutter analyze
flutter test
flutter drive --driver test_driver/integration_test.dart --target integration_test/app_test.dart -d emulator-5554 --no-enable-impeller
flutter build apk --release --target-platform android-arm64,android-x64
```

Windows 端保留三个聚焦的测试：数据恢复、任务隔离与表单创建。全部页面及主题的遍历放在 Android 集成测试中，避免重复维护同一组页面测试。

系统层截图在本机模拟器上偶发黑帧，因此最终截图使用模拟器内实际 Flutter 组件的 `RenderRepaintBoundary.toImage` 导出，再由测试驱动写入 PNG。测试通过后额外检查所有图片的尺寸和像素分布，最终无黑帧或纯色空白图。`docs/screenshots/manifest.json` 记录逐张文件尺寸和大小。

项目的本地数据由 SharedPreferences 保存；集成测试开始会清除该应用自身的演示快照，最后恢复默认示例，不适合在需要保留个人录入数据时直接运行。

## 交付边界

Android 已实际运行测试；Web 工程可用于开发预览，但未做完整浏览器端操作验收；iOS 未配置或测试。服务端、第三方身份认证、邮件短信、推送、真实音视频及完整多语言不在本次本地 UI 实现中。安装包使用开发签名，非商店发布包。
