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
-- >>> ramp >>>
-- Added by ramp. Do not remove or edit this block apart from the ramp.exec
-- list: ramp reads its settings here, and Cmd+A in ramp's prompt needs the
-- binding below. ramp adds the block again whenever it is missing.
ramp = {}
function ramp.exec(commands)
  ramp.commands = commands
end
rex.action{
  name = "ramp_config",
  title = "ramp: Startup Commands",
  run = function() return ramp.commands or {} end,
}
-- Rex binds Cmd+A to Select All in Pane; send it to ramp's prompt instead.
-- Other panes keep Rex's behavior.
rex.action{
  name = "ramp_select_all",
  title = "Select All (ramp aware)",
  run = function(ctx, args)
    local terminal = "com.superlogical.terminal"
    -- Keys run on your app's home server. A pane on a remote host is reached
    -- through that host, which needs the pane's session attached.
    local found, host, target = true, rex, { block_id = ctx.block_id }
    if ctx.server then
      found, host = pcall(rex.server, ctx.server)
      target.session_id = ctx.session_id
      if found then pcall(host.call, "session.attach", { session_id = ctx.session_id }) end
    end
    local ok, process = false, nil
    if found then ok, process = pcall(host.block.call, terminal, "process", target) end
    local foreground = ok and type(process) == "table" and process.foreground or {}
    local script = foreground.script or ""
    if foreground.name == "ramp" or script:match("ramp[%w.]*$") then
      -- Kitty CSI u for super+a, which ramp reads as Cmd+A.
      target.data = "\27[97;9u"
      host.block.call(terminal, "write", target)
    else
      rex.client.queue("pane.select_all", {})
    end
  end,
}
rex.bind("cmd+a", "ramp_select_all")

-- Slash commands each ramp pane runs at startup, in order, as if typed.
-- For example: "/panel timeline left", "/wrap off". Run `rex config reload`
-- after editing; panes opened afterwards use the new list.
ramp.exec({
  "/panel timeline left",
  "/panel subagents right split",
  "/panel context right split",
  "/panel width left 28"
})
-- <<< ramp <<<

-- >>> rex-agent-resume
-- Starts the rex-agent-resume watcher whenever the server loads this file.
dofile(os.getenv("HOME") .. "/.local/share/rex-agent-resume/plugin.lua")
-- <<< rex-agent-resume
