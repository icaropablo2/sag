require 'sag'

function love.load()
	enemy = {x=0, y=0}
	player = {x=50, y=0}

	enemy.sprite = love.graphics.newImage('player.png')
	enemy.animation = sag:new(enemy.sprite, 50)
	enemy.animation:clip('idle', {1})
	enemy.animation:setAnim('idle')

	player.sprite = love.graphics.newImage('enemy.png')
	player.animation = sag:new(player.sprite, 50)
	player.animation:clip('idle', {3})
	player.animation:setAnim('idle')

end

function love.update(dt)
	player.animation:update(dt)
	enemy.animation:update(dt)
end

function love.draw()
	player.animation:play(player)
	enemy.animation:play(enemy)
end