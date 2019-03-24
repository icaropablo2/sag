function range(a, b, step)
  if not b then
    b = a
    a = 1
  end
  step = step or 1
  local f =
    step > 0 and
      function(_, lastvalue)
        local nextvalue = lastvalue + step
        if nextvalue <= b then return nextvalue end
      end or
    step < 0 and
      function(_, lastvalue)
        local nextvalue = lastvalue + step
        if nextvalue >= b then return nextvalue end
      end or
      function(_, lastvalue) return lastvalue end
  return f, nil, a - step
end


-- function calculateIndexGrid(row, col, maxCol)
--   --[[
--     Calculate the index of any frame
--     For example, I want the second row the thred image
--     so calculateIndexGrid(2, 3)
--   ]]
--     return maxCol * (row - 1) + col
-- end