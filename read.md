# Simple Animation Grid (SAG) - Love2D Framework

Simple Animation Grid is a lib created for Love2D framework.

The idea it's to create a easy way to handle animation, that will not turn you code into something ugly.

The ideia is very similiar that way unity works with animation, using clips and states.

I also provide a simple example on main.lua, so you can see how this works.

## Getting Started

To getting started all you need is to require SAG's lib and create clips for your spritesheet, then call it on love's update and draw.

```lua
	local sag = require 'sag'
	local player = {
		x=0,
		y=0,
		animation = {},
		facing = 'down'
	}

	function love.load()
		--- load the spritesheet, our grid has 50x50 pixels
		sprite = love.graphics.newImage('player.png')
		player.animation = sag:new(sprite, 50)

		--- creating clips
		player.animation:clip('idle', {1,2,3})
		player.animation:clip('walking', {4,5,6})

		--- set the default animation
		player.animation:setAnim('idle')

	end

	function love.update(dt)
		player.animation:update(dt)
	end

	function love.draw()
		player.animation:play(player)
	end
```

## Authors
Icaro Pablo


## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
