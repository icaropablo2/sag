--[[
	SAG - Simple Animation Grid
	Author: Icaro Pablo
	Version: 1.0
	Love2D version: 1.11.0

	Summary: SAG is a lib for Love2D, it's create 
	a easy way to work with animations with few steps
	you can add animation to your game without headaches
]]

module(..., package.seeall)

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


------------------------------------------
-- Rectangle functions
------------------------------------------

function sag:new(image, size)
	--[[
		Build quads from the given image
		Args:
			image (love2d.newImage)
			size (int): Size of each quad (we only work with same width and height)
	]]

	local object = {
		quads = {},
		clips = {},
		timer = 0,
		current_frame = 1,
	}

	w, h = image:getDimensions()
	rangX = w / size
	rangY = h / size

	for i in range(rangX) do
		offset = {
			x=(i-1)*size,
			y=0,
		}

		object.quads[i] = love.graphics.newQuad(
			offset.x,
			offset.y,
			size,
			size,
			image:getDimensions()
		)
	end


	function object:update(dt)
		--[[
			Update frames

			Args:
				dt (float): delta time to calculate frame
		]]
		object.timer = object.timer + dt

		if object.timer > 0.18 then
			object.current_frame = object.current_frame + 1
			object.timer = 0
		end

	end

	function object:play(entity)
		--[[
			Play the current animation

			Args:
				entity (table): table with x,y position to draw

			Returns:
				Nothing
		]]

		local animation_exists = object.anim ~= nil
		local clip_exists = object.clips[object.anim] ~= nil

		if not animation_exists then
			error('No default animation set! Please use setAnim.')
			return
		end

		if not clip_exists then
			error('Clip not found on table!')
			return
		end


		local anim = object.anim
		local clips = object.clips[anim]
		local maxFrames = table.getn(clips)

		if object.current_frame > maxFrames then
			object.current_frame = 1
		end

		love.graphics.draw(
			entity.sprite,
			clips[object.current_frame],
			entity.x,
			entity.y
		)

	end

	function object:setAnim(name)
		--[[
			Update the current animation to the new clip name

			Args:
				name (string): clip's name
		]]
		object.anim = name
	end

	function object:clip(name, frames)
		--[[
		Create a clip: Clips are a collection with quads

		Args:
			name (string): clip's name
			frames: (list): sequence of frames (ex: 1,2,3)
			wished for animation
		]]
		object.clips[name] = {}
		for i, frame in ipairs(frames) do
			object.clips[name][i] = object.quads[frame]
		end
	end



	return object
end