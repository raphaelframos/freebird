
local composer = require( "composer" )
local scene = composer.newScene()
local bird
local physics = require "physics"

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW, halfH = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY



function scene:create( event )

	local sceneGroup = self.view
	physics.start()
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

  bird:addEventListener( "touch", bird )
	sceneGroup:insert( background )
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		--
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view

	local phase = event.phase

	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end

end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	--
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view

	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
