# capslock-plus-mini

中文 | [English](README.md)

`capslock-plus-mini` 是从 CapsLock+ 精简出来的 AutoHotkey v2 键盘增强工具。它保留 CapsLock 作为修饰键的核心工作流，暂不迁移原项目中 GUI 依赖较重的模块。

本项目是 [wo52616111/capslock-plus](https://github.com/wo52616111/capslock-plus) 项目的分支。

## 范围

已实现：

- CapsLock 作为修饰键
- 光标移动和文本选中
- 删除辅助
- 独立的 CapsLock 剪贴板槽
- 基础刷新和文档快捷键
- 少量非 GUI 窗口辅助功能
- 从 `CapsLock+settings.ini` 动态加载快捷键覆盖配置

本 mini 版本暂不实现：

- qbar
- 翻译 GUI/API
- Math Board
- CapsLock+Tab 热字符串
- 启动加载动画
- 原版完整的持久化窗口绑定
- AutoHotkey v1 用户脚本兼容

## 运行要求

- Windows
- AutoHotkey v2.0+

如果 `.ahk` 文件仍然关联到 AutoHotkey v1，请显式使用 v2 启动：

```powershell
& 'C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe' 'D:\CS_Tech\AutoHotKey\capslock-plus\CapsLock+.ahk'
```

## 启动

用 AutoHotkey v2 运行 `CapsLock+.ahk`。脚本需要管理员权限时会自动重新以管理员身份启动。

按 `CapsLock+F5` 可重载脚本。

## 默认快捷键

下文中 `CL` 表示 CapsLock，`LAlt` 表示左 Alt。

### 移动光标

| 快捷键 | 功能 |
|---|---|
| `CL+E/S/D/F` | 上/左/下/右移动光标 |
| `CL+A/G` | 按单词向左/向右移动 |
| `CL+P` | 移动到行首 |
| `CL+;` | 移动到行尾 |
| `CL+LAlt+P` | 移动到文档开头 |
| `CL+LAlt+;` | 移动到文档末尾 |

### 选中

| 快捷键 | 功能 |
|---|---|
| `CL+I/J/K/L` | 向上/左/下/右选中 |
| `CL+H` | 向左选中一个单词 |
| `CL+.` | 向右选中一个单词 |
| `CL+,` | 选中当前单词 |
| `CL+LAlt+,` | 选中当前行 |
| `CL+U/O` | 从当前位置选中到行首/行尾 |
| `CL+LAlt+U/O` | 从当前位置选中到文档开头/末尾 |

### 删除

| 快捷键 | 功能 |
|---|---|
| `CL+W` | Backspace |
| `CL+R` | Delete |
| `CL+[` | 删除到行首 |
| `CL+/` | 删除到行尾 |
| `CL+LAlt+[` | 删除到文档开头 |
| `CL+LAlt+/` | 删除到文档末尾 |
| `CL+Backspace` | 删除当前行 |

### 剪贴板

| 快捷键 | 功能 |
|---|---|
| `CL+C/X/V` | 使用第一个 CapsLock 剪贴板槽复制/剪切/粘贴 |
| `CL+LAlt+C/X/V` | 使用第二个 CapsLock 剪贴板槽复制/剪切/粘贴 |
| `Ctrl+V` | 从脚本记录的系统剪贴板槽粘贴 |

没有选中文本时，`CL+C` 和 `CL+X` 会退回为复制或剪切当前行。

### 其他

| 快捷键 | 功能 |
|---|---|
| `CL+Enter` | 在当前行下方插入新行 |
| `CL+F1` | 打开原 CapsLock+ 项目官网 |
| `CL+F5` | 重载脚本 |
| `CL+F6` | 切换当前窗口置顶 |
| `CL+F4` | 切换当前窗口透明度 |

## 配置

运行时配置保存在 `CapsLock+settings.ini`，该文件会自动生成，并被 git 忽略。

在 `[Keys]` 中覆盖快捷键：

```ini
[Keys]
caps_f7=keyFunc_doNothing
caps_lalt_f=keyFunc_moveRight(10)
```

只有以 `keyFunc_` 开头的函数会被接受。

## 开发说明

- 当前分支只面向 AutoHotkey v2。
- 旧 AutoHotkey v1 模块仍保留在仓库中作为参考，但 mini 入口不会加载未迁移模块。
- GUI 模块应保持禁用，直到明确决定重新引入。
