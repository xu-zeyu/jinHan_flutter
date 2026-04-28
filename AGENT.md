# AGENT.md

## 项目概览

- 项目类型: 单包 Flutter 应用，项目名 `jinhan_flutter`
- 业务主题: 宠物电商/服务 App，当前默认中文文案，已接入 `l10n/` 国际化资源
- 主要入口:
  - `lib/main.dart`: Flutter 启动入口
  - `lib/app.dart`: 应用根组件 `JinHanApp`
  - `lib/pages/root_page/root_page.dart`: 底部 Tab 容器与首页骨架
- 支持平台:
  - Flutter: `android/`, `ios/`, `macos/`, `linux/`, `windows/`, `web/`

## 关键技术栈

- Flutter SDK: `>=3.5.0 <4.0.0`
- 状态/依赖:
  - `flutter_riverpod`
  - `provider`
- 路由:
  -  `go_router`
- 网络:
  - `dio`
  - `lib/core/services/request.dart` 中有基础请求封装
- 本地存储:
  - `shared_preferences`
- UI/交互:
  - `pull_to_refresh`
  - `flutter_staggered_grid_view`
  - `flutter_swiper_null_safety`
- 国际化:
  - `flutter_localizations`
  - `intl`
  - 资源位于 `l10n/app_zh.arb`、`l10n/app_en.arb`

## 目录职责

- `lib/core/`: 基础设施与公共能力
  - `constants/`: 颜色、间距、文案等常量
  - `theme/`: 主题定义
  - `services/`: 服务层，当前包含请求封装
  - `api/`: 接口访问层，页面对应 repository、api client、response parser 优先放这里
  - `router/`, `utils/`: 路由与工具能力
- `lib/pages/`: 页面级模块
  - `home/`
  - `category/`
  - `cart/`
  - `my/`
  - `root_page/`: 主容器、底部导航、帧动画
- `lib/shared/`: 跨页面复用模型与组件
  - `models/`: 业务模型、DTO、分页对象、接口返回模型
  - `widgets/`
- `assets/`: 静态资源
  - `images/`: 包含普通图片与四个 Tab 的逐帧动画素材
  - `icons/`
  - `json/`
- `l10n/`: 国际化文案
- `test/`: Flutter 测试，当前已有基础 widget test


## 配置与资源约定

- `pubspec.yaml` 已声明以下资源目录:
  - `.env.dev`
  - `.env.prod`
  - `assets/images/`
  - `assets/images/home_frames/`
  - `assets/images/category_frames/`
  - `assets/images/cart_frames/`
  - `assets/images/mine_frames/`
  - `assets/icons/`
  - `assets/json/`
- 若新增资源，先确认路径已在 `pubspec.yaml` 注册，再在代码中引用

## 代码协作约定
- 优先在现有分层内扩展:
  - 页面逻辑放 `lib/pages/...`
  - 通用 UI 放 `lib/shared/widgets`
  - 常量放 `lib/core/constants`
  - 服务/网络能力放 `lib/core/services` 或 `lib/core/api`
- 新增接口相关代码的放置约定:
  - 页面或业务对应的 repository 放 `lib/core/api/`
  - 通用请求封装、拦截器、鉴权、环境配置放 `lib/core/services/` 或 `lib/core/api/interceptors/`
  - 不要把 `repository` 直接放在 `lib/pages/...`
- 新增 model 的放置约定:
  - 可跨页面复用的业务模型、分页模型、接口 DTO 放 `lib/shared/models/`
  - 页面私有的临时 view model 放 `lib/core/models/`
- 生成代码文件的放置约定:
  - 接口生成代码、client、service、repository 生成产物放在 `lib/core/api/` 对应子目录
  - `json_serializable` / `freezed` 生成的 `*.g.dart`、`*.freezed.dart` 与源文件同目录
  - OpenAPI 或 Swagger 生成文件不要散落到 `lib/pages/`
- 保持现有命名风格:
  - 页面文件使用 `*_page.dart`
  - 主题/常量文件使用 `app_*` 前缀
  - repository 文件使用 `*_repository.dart`
  - model 文件使用 `*_model.dart` 或 `*_models.dart`
- 修改 UI 时，优先复用 `AppColors`、`AppTheme`、`AppSpacing`，避免页面内散落魔法值
- 若引入状态管理新代码，优先明确选择一种模式；仓库中同时存在 `provider` 与 `flutter_riverpod` 依赖，新增代码不要混用得更重
- 若引入路由体系，需先确认是否正式迁移到 `go_router`，避免 `home:` 和集中式路由长期并存

## 修改前后的检查项
- 代码修改后不执行:
  - `flutter analyze`
  - `flutter test`
- 影响资源加载时，检查:
  - `pubspec.yaml` 资源声明是否完整
  - 资源路径大小写是否与实际文件一致
- 涉及国际化文案时，同步更新 `l10n/app_zh.arb` 和 `l10n/app_en.arb`

## 不建议直接改动的内容

- `build/`, `.dart_tool/`: 构建产物
- `ios/Pods/`, `.symlinks/`: 依赖生成目录
- `windows/flutter/generated_*`, `linux/flutter/generated_*`, `macos/Flutter/GeneratedPluginRegistrant.swift`: 平台生成文件
- 若非平台配置需求，尽量不要顺手改动各平台工程模板文件

## 给后续 Agent 的建议

- 先从 `lib/app.dart` 和 `lib/pages/root_page/root_page.dart` 建立应用入口认知，再深入具体页面
- 若任务涉及接口联调，先梳理 `RequestManager`，再决定是否补充拦截器、错误处理、鉴权和环境切换
- 若任务涉及结构性重构，先确认 `provider` / `riverpod` / `go_router` 的最终选型，再动主干
- 编写完代码后不进行项目构建和检测
