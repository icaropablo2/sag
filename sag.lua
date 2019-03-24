--[[
	SAG - Simple Animation Grid
	Author: Icaro Pablo
	Version: 1.0
	Love2D version: 1.11.0

	Summary: SAG is a lib for Love2D, it's create 
	a easy way to work with animations with few steps
	you can add animation to your game without headaches
]]
local SAG = {}
SAG.__index = SAG

------------------------------------------
-- Auxiliary functions
------------------------------------------
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
------------------------------------------
-- Rectangle functions
------------------------------------------
function SAG:new(image, size)
	--[[
		Build quads from the given image
		Args:
			image (love2d.newImage)
			size (int): Size of each quad (we only work with same width and height)
	]]
	local self = setmetatable({}, SAG)

	self.quads = {}
	self.clips = {}
	self.timer = 0
	self.current_frame = 1

	w, h = image:getDimensions()
	rangX = w / size
	rangY = h / size

	for i in range(rangX) do
		offset = {
			x=(i-1)*size,
			y=0,
		}

		self.quads[i] = love.graphics.newQuad(
			offset.x,
			offset.y,
			size,
			size,
			image:getDimensions()
		)
	end

	return self
end


function SAG:update(dt)
	--[[
		Update frames

		Args:
			dt (float): delta time to calculate frame
	]]
	self.timer = self.timer + dt

	if self.timer > 0.18 then
		self.current_frame = self.current_frame + 1
		self.timer = 0
	end

end

function SAG:play(entity)
	--[[
		Play the current animation

		Args:
			entity (table): table with x,y position to draw

		Returns:
			Nothing
	]]

	local animation_exists = self.anim ~= nil
	local clip_exists = self.clips[self.anim] ~= nil

	if not animation_exists then
		error('No default animation set! Please use setAnim.')
		return
	end

	if not clip_exists then
		error('Clip not found on table!')
		return
	end


	local anim = self.anim
	local clips = self.clips[anim]
	local maxFrames = table.getn(clips)

	if self.current_frame > maxFrames then
		self.current_frame = 1
	end

	love.graphics.draw(
		entity.sprite,
		clips[self.current_frame],
		entity.x,
		entity.y
	)

end

function SAG:setAnim(name)
	--[[
		Update the current animation to the new clip name

		Args:
			name (string): clip's name
	]]
	self.anim = name
end

function SAG:clip(name, frames)
	--[[
	Create a clip: Clips are a collection with quads

	Args:
		name (string): clip's name
		frames: (list): sequence of frames (ex: 1,2,3)
		wished for animation
	]]
	self.clips[name] = {}
	for i, frame in ipairs(frames) do
		self.clips[name][i] = self.quads[frame]
	end
end

return SAG