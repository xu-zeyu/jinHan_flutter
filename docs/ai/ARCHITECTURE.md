# ARCHITECTURE.md

---

# Layer Responsibility

页面层：

- UI
- 页面状态
- 页面交互

Provider 层：

- 状态管理
- 数据缓存
- 生命周期

Repository 层：

- 数据聚合
- 接口整合

API 层：

- 网络请求

---

# Mandatory Rules

必须遵守：

- 页面不可直接调用 API
- 页面不可直接使用 Dio
- Repository 不允许放 pages
- Controller 不允许承担 UI
- Widget 不允许包含复杂逻辑
- 页面超过 300 行必须拆分
- Widget 超过 150 行必须拆分

---

# Extraction Rules

以下情况必须抽离：

- 重复逻辑
- 重复 Widget
- 多页面复用逻辑
- Toast/Dialog
- Loading
- Formatter