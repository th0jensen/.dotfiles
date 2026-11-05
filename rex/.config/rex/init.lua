-- Rex configuration: Lua 5.1. Runs top to bottom on each load.

local terminal = "com.superlogical.terminal.shell"

local function float_term(cmd)
  local result, err = rex.session.new_layer{
    bounds = { 0.15, 0.1, 0.7, 0.8 },
    layout = rex.layout.block{
      flavor = terminal,
      options = { command = cmd },
    },
    focus = true,
  }
  if err ~= nil then error(err, 0) end
  return result
end

rex.action{
  name = "float_lazydocker",
  title = "Open Lazydocker",
  description = "Floating lazydocker pane",
  run = function(ctx, args)
    return float_term{ "lazydocker" }
  end,
}

rex.action{
  name = "float_btop",
  title = "Open btop",
  description = "Floating btop pane",
  run = function(ctx, args)
    return float_term{ "btop" }
  end,
}

-- convenience: bind custom actions
rex.bind("cmd+alt+ctrl+d", "float_lazydocker")
rex.bind("cmd+alt+ctrl+b", "float_btop")

-- split config across files (optional):
-- require("keys")

-- >>> rex-agent-resume
-- Starts the rex-agent-resume watcher whenever the server loads this file.
dofile("/Users/thomas/.local/share/rex-agent-resume/plugin.lua")
-- <<< rex-agent-resume



-- >>> rexmod (managed by install.sh; edits inside are replaced)
-- Cmd+P: fuzzy file picker over the repo this tab's Claude works in.
rex.bind("cmd+p", function(ctx)
  rex.call("session.new_layer", {
    session_id = ctx.session_id,
    bounds = { 0.15, 0.1, 0.7, 0.75 },
    focus = true,
    layout = { block = { flavor = "com.superlogical.terminal.shell", label = "files", options = {
      shell = "none",
      command = { "/Users/thomas/Library/Application Support/rexmod/bin/rexmod", "pick", "--here", "--session", ctx.session_id },
    } } },
  })
  return true
end)

-- Ctrl+h/j/k/l move between panes; inside Neovim they move between its
-- windows first (the editor config hands over at its edge).
local function runs_vim(ctx)
  local ok, process = pcall(rex.call, "block.method", { session_id = ctx.session_id, block_id = ctx.block_id, method = "process" })
  local name = ok and process and process.foreground and process.foreground.name
  return name == "nvim" or name == "vim"
end
for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  rex.bind("ctrl+" .. key, function(ctx)
    if runs_vim(ctx) then
      return false
    end
    rex.call("session.focus_direction", { session_id = ctx.session_id, direction = direction })
    return true
  end)
end
-- <<< rexmod
