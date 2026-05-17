local M = {}

function M.exec(command)
  return hl.dsp.exec_cmd(command)
end

function M.bind_all(bindings)
  for _, binding in ipairs(bindings) do
    hl.bind(binding[1], binding[2], binding[3])
  end
end

function M.when_enabled(enabled, callback)
  if enabled then
    callback()
  end
end

return M
