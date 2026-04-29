# AGENT.md

> 该文件用于让 Codex / AI Coding Agent 快速理解项目结构、编码约束与开发规范。
>
> 为确保兼容性，请遵循：
>
> * 使用清晰层级标题（Markdown Heading）
> * 避免自然语言过长段落
> * 所有规则以明确约束形式表达
> * 将「必须」「禁止」「推荐」拆分为独立条目
> * Agent 应优先读取本文件作为项目约束来源

---

# Project

* 项目名称: `jinhan_flutter`
* 项目类型: Flutter 单包应用
* 业务方向: 宠物电商 / 服务 App
* 默认语言: 中文
* 国际化支持: 已接入 `l10n/`
* Flutter SDK: `>=3.5.0 <4.0.0`

---

# Entry Points

主要入口文件：

* `lib/main.dart` → Flutter 启动入口
* `lib/app.dart` → 应用根组件 `JinHanApp`
* `lib/pages/root_page/root_page.dart` → 底部 Tab 主容器

Agent 在理解应用结构时，应优先阅读以上文件。

---

# Platforms

支持平台：

* Android
* iOS
* macOS
* Windows
* Linux
* Web

---

# Tech Stack

## State Management

优先级：

1. `provider`

规则：

* 新状态管理逻辑优先使用 provider
* 避免 Provider 与 Riverpod 混乱混用
* 不允许页面直接持有大量业务状态

---

## Router

使用：

* `go_router`

规则：

* 路由统一由 `go_router` 管理
* 禁止长期混用 `home:` + 路由表
* 新页面优先接入 Router

---

## Network

使用：

* `dio`

请求封装位置：

* `lib/core/services/request.dart`

规则：

* 所有网络请求必须通过统一请求层
* 页面不可直接使用 Dio

---

## Storage

使用：

* `shared_preferences`

---

## UI Dependencies

* `pull_to_refresh`
* `flutter_staggered_grid_view`
* `flutter_swiper_null_safety`

---

## Localization

使用：

* `flutter_localizations`
* `intl`

资源目录：

* `l10n/app_zh.arb`
* `l10n/app_en.arb`

---

# Directory Structure

## lib/core/

基础设施层。

用于放置：

* constants
* theme
* router
* services
* api
* utils
* extensions
* enums
* types
* exceptions

目录说明：

```text
lib/core/
├── api/
├── constants/
├── enums/
├── exceptions/
├── extensions/
├── router/
├── services/
├── theme/
├── types/
└── utils/
```

---

## lib/pages/

页面模块层。

每个业务模块独立目录。

示例：

```text
lib/pages/
├── home/
├── business/
├── message/
├── my/
└── root_page/
```

页面目录推荐结构：

```text
home/
├── home_page.dart
├── widgets/
├── providers/
├── controllers/
├── models/
└── views/
```

规则：

* 页面仅负责 UI + 页面状态
* 页面不可承担 Repository 职责
* 页面避免直接写复杂逻辑

---

## lib/shared/

跨页面共享层。

用于放置：

* 通用组件
* 通用模型
* 通用业务结构
* 公共 UI

目录建议：

```text
lib/shared/
├── models/
├── widgets/
├── mixins/
├── layouts/
└── components/
```

---

## assets/

资源目录。

```text
assets/
├── images/
├── icons/
└── json/
```

规则：

* 新资源必须先确认 `pubspec.yaml` 注册
* 路径大小写必须一致

---

# Architecture Rules

## 模块化开发（必须遵守）

Agent 必须遵循模块化开发原则。

规则：

* 每个业务独立模块目录
* 避免所有逻辑堆积到 Page
* UI、状态、接口、数据模型分离
* 禁止超大单文件
* 页面超过 300 行时优先拆分
* Widget 超过 150 行时优先抽离
* Controller 与 UI 解耦

推荐模块结构：

```text
feature/
├── page/
├── widgets/
├── providers/
├── repository/
├── models/
├── enums/
├── services/
└── utils/
```

---

## 通用方法抽离（必须遵守）

规则：

* 不允许复制重复逻辑
* 公共逻辑必须提取
* 页面之间重复代码必须复用
* 重复 Widget 必须抽取
* 通用格式化方法统一管理

推荐目录：

```text
lib/core/utils/
lib/shared/widgets/
lib/shared/components/
lib/core/extensions/
```

适合抽离内容：

* 时间格式化
* 金额格式化
* Toast
* Dialog
* Loading
* 网络错误处理
* 通用按钮
* 通用卡片
* 通用 Header

---

## Enum 分层（必须遵守）

所有 enum 必须独立管理。

禁止：

* enum 写在 Page 文件中
* enum 写在 Widget 文件中

推荐目录：

```text
lib/core/enums/
```

示例：

```text
lib/core/enums/
├── app_status_enum.dart
├── order_status_enum.dart
├── user_role_enum.dart
└── request_state_enum.dart
```

规则：

* enum 文件单独存在
* 一个文件只管理一个主要 enum
* enum 命名统一 `xxx_enum.dart`

---

## 数据类型分层（必须遵守）

数据模型必须分层。

推荐目录：

```text
lib/shared/models/
lib/core/types/
```

规则：

* DTO 与 UI Model 分离
* Response Model 与业务 Model 分离
* 网络层模型不要直接给 UI 使用
* 分页对象统一封装
* 泛型响应统一定义

推荐结构：

```text
lib/shared/models/
├── dto/
├── response/
├── entity/
├── vo/
└── paging/
```

说明：

* DTO → 接口请求结构
* Response → 接口响应结构
* Entity → 业务对象
* VO → 页面展示对象
* Paging → 分页对象

---

# API Rules

接口代码统一放置：

```text
lib/core/api/
```

推荐结构：

```text
lib/core/api/
├── repositories/
├── clients/
├── parsers/
├── interceptors/
└── responses/
```

规则：

* Repository 不允许放在 pages
* API Client 不允许分散
* 拦截器统一管理

---

# Naming Rules

统一命名规范：

| 类型         | 命名                  |
| ---------- | ------------------- |
| 页面         | `*_page.dart`       |
| Repository | `*_repository.dart` |
| Model      | `*_model.dart`      |
| Enum       | `*_enum.dart`       |
| Service    | `*_service.dart`    |
| Widget     | `*_widget.dart`     |
| Provider   | `*_provider.dart`   |
| Controller | `*_controller.dart` |
| Extension  | `*_extension.dart`  |

---

# UI Rules

当 Agent 编写 UI 时，必须遵循：

* Premium Mobile UI
* Apple-level spacing
* Clean hierarchy
* Modern SaaS style
* Flutter-ready
* Production-ready
* 避免 AI 风格视觉
* 保持组件一致性

必须优先使用：

* `AppColors`
* `AppTheme`
* `AppSpacing`

禁止：

* 页面内出现大量魔法值
* 随意写死颜色
* 随意写死 padding

---

# Internationalization Rules

涉及文案修改时：

必须同步更新：

* `l10n/app_zh.arb`
* `l10n/app_en.arb`

禁止：

* 页面直接硬编码文本

---

# Forbidden Changes

禁止修改：

```text
build/
.dart_tool/
ios/Pods/
.symlinks/
windows/flutter/generated_*
linux/flutter/generated_*
macos/Flutter/GeneratedPluginRegistrant.swift
```

除非明确要求。

---

# Development Checklist

修改代码前检查：

* 是否符合目录分层
* 是否已有公共实现可复用
* 是否存在重复逻辑
* 是否违反命名规范

修改代码后检查：

* 是否影响资源路径
* 是否更新国际化
* 是否遵循模块化结构
* 是否将公共逻辑提取
* 是否保持目录整洁

---

# Agent Priority Rules

Agent 执行任务时优先级：

1. 遵守本 AGENT.md
2. 遵守 Flutter 项目结构
3. 遵守模块化开发
4. 保持代码可维护
5. 优先复用已有能力

---

# Important Rules

必须遵守：

* 不进行项目 build
* 不自动运行测试
* 不修改生成文件
* 不擅自重构无关模块
* 不创建重复工具类
* 不重复定义相同模型
* 不直接在页面写复杂逻辑
* 优先复用已有代码
* 优先抽离公共方法
* 遵守分层架构
* 遵守模块化设计
* 新增代码必须包含必要注释
* 修改已有逻辑时，需补充或更新注释
* 公共方法必须添加功能说明
* Provider / Controller 必须说明职责
* 复杂逻辑必须解释实现目的
* 数据模型字段建议补充含义说明
* 自定义 Widget 必须说明用途
* Extension 必须说明扩展能力
* API 方法必须说明接口用途
* 异步逻辑必须说明执行目的
* 状态字段必须说明状态含义
* 枚举值建议添加业务语义说明

---

# Code Comment Rules

Agent 在生成、修改、重构代码时，必须同步编写清晰注释。

## 注释规则（必须遵守）

规则：

* 新增代码必须包含必要注释
* 修改已有逻辑时，需补充或更新注释
* 公共方法必须添加功能说明
* Provider / Controller 必须说明职责
* 复杂逻辑必须解释实现目的
* 数据模型字段建议补充含义说明
* 自定义 Widget 必须说明用途
* Extension 必须说明扩展能力
* API 方法必须说明接口用途
* 异步逻辑必须说明执行目的
* 状态字段必须说明状态含义
* 枚举值建议添加业务语义说明

## 注释位置规范

### 类注释

用于说明类职责。

示例：

```dart
/// 首页推荐商品 Provider
///
/// 负责：
/// - 首页商品列表获取
/// - 下拉刷新
/// - 分页加载
class HomeRecommendProvider extends ChangeNotifier {}
```

### 方法注释

用于说明方法作用。

示例：

```dart
/// 获取首页推荐商品
///
/// [refresh] 是否刷新第一页
Future<void> fetchRecommendProducts({bool refresh = false}) async {}
```

### 字段注释

用于说明变量用途。

示例：

```dart
/// 当前分页页码
int currentPage = 1;

/// 是否正在加载
bool isLoading = false;
```

### Widget 注释

用于说明 Widget 职责。

示例：

```dart
/// 商品卡片组件
///
/// 用于展示商品封面、标题、价格
class ProductCardWidget extends StatelessWidget {}
```

### 复杂逻辑注释

必须解释：

* 为什么这样写
* 逻辑意图
* 特殊边界条件
* 性能优化原因

示例：

```dart
// 避免重复请求：
// 当列表滚动触底时，若仍处于加载状态，则忽略新的请求。
if (isLoading) return;
```

## 禁止

禁止：

* 无意义注释
* 注释与代码不一致
* 大量重复描述代码表面含义
* 使用模糊注释
* 注释缺失导致逻辑不可理解

错误示例：

```dart
// 设置变量
int count = 0;
```

## 推荐注释风格

推荐：

* 使用 Dart Doc (`///`) 注释公共 API
* 使用行注释 (`//`) 解释复杂逻辑
* 注释简洁明确
* 注释关注“为什么”而不是“做了什么”

## Agent 执行要求

Agent 每次生成代码时，必须检查：

* 是否包含必要注释
* 是否为复杂逻辑增加说明
* 是否为公共组件补充文档注释
* 是否避免无意义注释
* 是否保证注释与代码一致

---

# Recommended Reading Order For Agent

Agent 理解项目时优先阅读：

1. `lib/app.dart`
2. `lib/pages/root_page/root_page.dart`
3. `lib/core/services/request.dart`
4. `lib/core/router/`
5. `lib/shared/`
6. 当前业务模块目录

---

# End

该文件为项目统一开发规范。

Agent 必须优先遵守。
