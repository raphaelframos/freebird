
local composer = require( "composer" )
local scene = composer.newScene()
local bird, textScore, score, textBullet, bullets
local widthHero = 10
local heightHero = 20
local physics = require "physics"

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW, halfH = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY




function createBullets()
	local bullet = display.newCircle( halfW, halfH, 3 )
	bullet.name = "bullet"
	bullet.strokeWidth = 2
	bullet:setStrokeColor( 0, 0, 0 , 40)
	physics.addBody( bullet, "dynamic" )
end

function createEnemys()

	local enemy = display.newRect( display.contentCenterX, display.contentCenterY-200, 50, 5 )
	enemy:setFillColor( 0 , 0 , 0 )
	physics.addBody( enemy, "static" )

end

function updateTexts()
	textScore.text = "Score " .. score
	textBullet.text = "Bullets " .. bullets
end

function createTexts()
	textScore = display.newText( "Score: 0 ", display.contentWidth-50, display.contentHeight + 20, native.systemFont, 16 )
	textBullet = display.newText( "Bullets: 0 ", 40, display.contentHeight + 20, native.systemFont, 16 )
	textScore:setFillColor( 0, 0, 0 )
	textBullet:setFillColor( 0, 0, 0 )
end

function shot()

	local newShot = display.newCircle( bird.x, bird.y, 3 )

		newShot:setFillColor( 0, 0, 0 )
    physics.addBody( newShot, "dynamic", { isSensor=true } )
    newShot.isBullet = true
    newShot.myName = "shot"
		newShot.x = bird.x
		newShot.y = bird.y

		transition.to( newShot, { y=-40, time=500,
			onComplete = function() display.remove( newShot )
			end
	} )
end

function scene:create( event )

	local sceneGroup = self.view
	local mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.

	physics.start()
	physics.setGravity( 0, 0.3 )
	physics.pause()


	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0
	background:setFillColor( 1, 1, 1 )

	bird = display.newRect( halfW, halfH + 100, 10, 20)
	bird:setFillColor( 0, 0, 0 )

	function bird:touch( event )
		if event.phase == "began" then
	 		display.getCurrentStage():setFocus( self, event.id )
	 		self.isFocus = true
	 		self.markX = self.x
	 		self.markY = self.y
		elseif self.isFocus then
	 		if event.phase == "moved" then
	  		self.x = event.x - event.xStart + self.markX
	  		self.y = event.y - event.yStart + self.markY
	 		elseif event.phase == "ended" or event.phase == "cancelled" then
			display.getCurrentStage():setFocus( self, nil )
	  	self.isFocus = false
				end
			end
		return true
	end

	createTexts()
	createEnemys()
	createBullets()
  bird:addEventListener( "touch", bird )
	bird:addEventListener( "tap", shot )

	sceneGroup:insert( background )
	sceneGroup:insert( mainGroup )
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
	elseif phase == "did" then
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	if event.phase == "will" then
		physics.stop()
	elseif phase == "did" then
	end

end

function scene:destroy( event )
	local sceneGroup = self.view
	package.loaded[physics] = nil
	physics = nil
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
