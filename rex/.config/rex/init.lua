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













-- >>> amp-rex
-- Cmd+A goes to Ramp (or legacy amp-rex), whose composer selects only its own text.
-- Every other pane keeps Rex's Select All in Pane.
rex.action{
  name = "amp_rex_select_all",
  title = "Select All (amp-rex aware)",
  run = function(ctx, args)
    local ok, process = pcall(rex.block.call, "com.superlogical.terminal", "process", { block_id = ctx.block_id })
    local foreground = ok and type(process) == "table" and process.foreground or {}
    local script = foreground.script or ""
    if foreground.name == "ramp" or foreground.name == "amp-rex" or script:match("amp%-rex[%w.]*$") then
      -- Kitty CSI u for super+a, which Ramp and legacy amp-rex read as Cmd+A.
      rex.block.call("com.superlogical.terminal", "write", { block_id = ctx.block_id, data = "\27[97;9u" })
    else
      rex.client.queue("pane.select_all", {})
    end
  end,
}
rex.bind("cmd+a", "amp_rex_select_all")
-- <<< amp-rex
