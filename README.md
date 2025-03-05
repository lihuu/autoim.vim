# autoim.vim

## 功能

实现 Vim 中文输入时，在 normal mode 与 insert mode 之间切换时中英文输入法的自动切换。具体地：

- Insert mode 下处于中文输入法时，按 Esc 键，会进入 normal mode, 并将输入法切换到英文状态。重新回到 normal mode 时，会自动恢复到中文输入法。
- Insert mode 下处于英文输入法时，按 Esc 键，会进入 normal mode, 并且输入法状态保持不变。重新回到 normla mode 时，仍然是英文输入法。

## 安装

### 使用 Vim-Plug 插件

在你的配置文件中（通常是 .vimrc ）加入如下代码片段

```
call plug#begin()
Plug lipingcoding/autoim.vim
call plug#end()
```

## 说明

原插件借助 AppleScript 控制快捷键以自动切换输入法，然而在实际使用过程中，频繁出现无法正常触发切换的状况。鉴于此，我们考虑采用 Hammerspoon 工具来达成这一功能。

其实现原理与原方法大致相同，依旧是借助 AppleScript 触发快捷键以实现输入法切换。不同之处在于，此处的快捷键是通过 Hammerspoon 脚本进行配置的。Hammerspoon 提供了极为便捷且优雅的 API ，极大地助力我们完成输入法的相关设置 。

1. 安装 hammerspoon
   ```lua
   brew install hammerspoon --cask
   ```
   > 如果没有安装 homebrew，可以访问官网下载 https://www.hammerspoon.org/
2. 配置脚本
   在 hammerspoon 的配置文件 `~/.hammerspoon/init.lua`中添加如下内容

   ```lua
   local changeInputMethod = function(config)
   	local layout = config.layout
   	local method = config.method
   	local currentLayout = hs.keycodes.currentLayout()
   	local currentMethod = hs.keycodes.currentMethod()
   	--print("currentLayout: ", currentLayout, "currentMethod: ", currentMethod)
   	if currentLayout == layout and (currentMethod == method) then
   		return
   	end
   	hs.keycodes.setLayout(layout)
   	if method ~= nil then
   		hs.keycodes.setMethod(method)
   	end
   end

   local lastVimInputMethod = nil
   local mods = { "cmd", "alt", "ctrl" }
   hs.hotkey.bind(mods, "A", function()
   	-- change to abc layout
   	local currentLayout = hs.keycodes.currentLayout()
   	local currentMethod = hs.keycodes.currentMethod()
   	if currentLayout == "Pinyin - Simplified" then
   		lastVimInputMethod = { layout = currentLayout, method = currentMethod }
   	else
   		lastVimInputMethod = nil
   	end
   	changeInputMethod({ layout = "ABC", method = nil })
   end)

    hs.hotkey.bind(mods, "S", function()
   if lastVimInputMethod ~= nil then
   changeInputMethod({ layout = "Pinyin - Simplified", method = "Pinyin - Simplified" })
   end
   end)
   ```

## 具有类似功能的插件

- [smartim](https://github.com/ybian/smartim)
  我在使用的过程中，从英文输入法自动切换回中文输入法时，虽然输入法状态是中文，但仍然无法输出中文
- [vim-xkbswitch](https://github.com/lyokha/vim-xkbswitch)
  需要调用 objective-c 编写的动态库，在最新的 MacOs 中，由于系统安全性，会报签名认证错误

## 感谢

思路来源于[涛叔的博客](https://taoshu.in/vim/vim-auto-im.html)。
