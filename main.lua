--[[
	Simple Animation Grid (SAG)
	Sample
]] 
local sag = require 'sag'
local player = {
	x=0,
	y=0,
	animation = {},
	facing = 'down'
}

function love.load()

	sprite = love.graphics.newImage('player.png')
	player.animation = sag:new(sprite, 50)

	--- creating clips
	player.animation:clip('idle_down', {1})
	player.animation:clip('idle_up', {10})
	player.animation:clip('idle_left', {4})
	player.animation:clip('idle_right', {7})

	--- walking
	player.animation:clip('walk_down', {1,2,3})
	player.animation:clip('walk_left', {4,5,6})
	player.animation:clip('walk_right', {7,8,9})
	player.animation:clip('walk_up', {10,11,12})

	--- set default animation
	player.animation:setAnim('idle_down')

end

function love.update(dt)
	player.animation:update(dt)
	move_player(dt)
end

function love.draw()
	player.animation:play(player)
end

--- extra stuffs
function move_player(dt)
	local speed = 250
	local speed_fixed = speed * dt

	if love.keyboard.isDown('left', 'a') then
		player.animation:setAnim('walk_left')
		player.x = player.x - speed_fixed
		player.facing = 'left'
	end

	if love.keyboard.isDown('right', 'd') then
		player.animation:setAnim('walk_right')
		player.x = player.x + speed_fixed
		player.facing = 'right'
	end

	if love.keyboard.isDown('up', 'w') then
		player.animation:setAnim('walk_up')
		player.y = player.y - speed_fixed
		player.facing = 'up'
	end

	if love.keyboard.isDown('down', 's') then
		player.animation:setAnim('walk_down')
		player.y = player.y + speed_fixed
		player.facing = 'down'
	end

	is_not_pressing = not love.keyboard.isDown(
		'left', 'right', 'down', 'up',
		'a', 's', 'd', 'w'
	)

	if is_not_pressing then
		local facing = 'idle_'..player.facing
		player.animation:setAnim(facing)
	end

end