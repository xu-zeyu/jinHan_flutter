# AGENT.md
2. lib/pages/root_page/root_page.dart
3. 当前业务模块
4. docs/ai/DIRECTORY_RULES.md
5. docs/ai/ARCHITECTURE.md

---

# Task Scope Rules

必须遵守：

- 仅修改任务相关模块
- 不允许修改无关代码
- 优先复用已有能力
- 最小改动原则

---

# State Management

使用：

- provider

禁止：

- riverpod
- bloc
- getx

---

# Router

使用：

- go_router

禁止：

- 多套路由混用

---

# Network

统一入口：

lib/core/services/request.dart

禁止：

- 页面直接使用 Dio

---

# Related Rules

详细规则：

- DIRECTORY_RULES.md
- NAMING_RULES.md
- ARCHITECTURE.md
- TASK_RULES.md
- UI_RULES.md
- COMMENT_RULES.md
- EXAMPLES.md
