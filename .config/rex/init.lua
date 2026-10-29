-- https://www.superlogical.com/rex/docs/reference/lua

-- Sessions
rex.bind("cmd+n", "session.new")
rex.bind("cmd+o", "session.switch")

-- Tabs
rex.bind("cmd+t", "client.tab.new")
rex.bind("cmd+shift+[", "client.tab.previous")
rex.bind("cmd+shift+]", "client.tab.next")

-- Panes
rex.bind("cmd+s", "pane.split.right")
rex.bind("cmd+i", "pane.split.down")
rex.bind("cmd+w", "pane.close")
rex.bind("cmd+b", "client.sidebar.toggle")
rex.bind("cmd+k", "pane.send_key", { key = "ctrl+l" })

-- Prefix
local prefix = "ctrl+b>"
local function pbind(key, action, args)
  rex.bind(prefix .. key, action, args)
end

pbind("ctrl+b", "pane.send_key", { key = "ctrl+b" })
pbind("r", "client.config.reload")

pbind("s", "session.switch")
pbind("shift+n", "session.new")
pbind("shift+4", "session.rename")

pbind("c", "client.tab.new")
pbind(",", "client.tab.rename")
pbind("p", "client.tab.previous")
pbind("n", "client.tab.next")
for i = 1, 9 do
  pbind(tostring(i), "client.tab.goto", { index = i })
end

pbind("h", "pane.focus.left")
pbind("j", "pane.focus.down")
pbind("k", "pane.focus.up")
pbind("l", "pane.focus.right")
pbind("shift+h", "pane.move.left")
pbind("shift+j", "pane.move.down")
pbind("shift+k", "pane.move.up")
pbind("shift+l", "pane.move.right")
pbind("v", "pane.split.right")
pbind("shift+5", "pane.split.right")
pbind("-", "pane.split.down")
pbind("shift+'", "pane.split.down")
pbind("x", "pane.close")
pbind("z", "pane.zoom")
pbind("shift+1", "pane.move_to_new_tab")

-- Resize
rex.mode("resize", { exclusive = true })
pbind("shift+r", "client.mode.enter", { name = "resize" })
rex.bind("resize/h", "pane.resize", { direction = "left" })
rex.bind("resize/j", "pane.resize", { direction = "down" })
rex.bind("resize/k", "pane.resize", { direction = "up" })
rex.bind("resize/l", "pane.resize", { direction = "right" })
rex.bind("resize/=", "pane.balance")
rex.bind("resize/enter", "client.mode.exit")
