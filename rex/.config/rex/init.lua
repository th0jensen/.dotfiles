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
