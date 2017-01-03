--------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------- Script written in LUA for Taranis by Valentin Rudloff -----------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------

-- Use this code as you want but mention my name: Valentin Rudloff
-- Utilisez ce code comme vous le souhaitez mais citez moi: Valentin Rudloff
-- written in 08/12/16


local snow = {}
local posSanta = {x = 10, y = 0, numberOfPixelY = 0, current = 0, revere = false}
local startTicks = 0
local elapsedTime = 0
local limitScreenX = 210
local limitScreenY = 64


-- Draws a circle on the screen (snow is made by a 2 by 2 circle)
local function circle(xCenter, yCenter, radius)
	local y, x
	for y=-radius, radius do
		for x=-radius, radius do
			if(x*x+y*y <= radius*radius) then
				lcd.drawPoint(xCenter+x, yCenter+y)
			end
		end
	end
end


-- updates the screen drawing
local function update()
	if elapsedTime >= 1 then
		startTicks = getTime() --reset counter
		elapsedTime = 0
		

		------------------------ SNOW -----------------------
		for i = 1, 70 do
			snow[i].current = snow[i].current + 1

			snow[i].X = snow[i].X - snow[i].velX
			if snow[i].X <= 0 then
				snow[i].X = snow[i].initX
			end

			if snow[i].current >= snow[i].velY then --then move the snow
				snow[i].Y = snow[i].Y + 1
				if snow[i].Y >= limitScreenY then
					snow[i].Y = 0
				end
				snow[i].current = 0 --reset
			end

			--Display
			circle(snow[i].X, snow[i].Y, 1)
		end	



		------------------------ SANTA -----------------------
		posSanta.current = posSanta.current + 1

		posSanta.current = posSanta.current + 1
		if posSanta.current >= posSanta.numberOfPixelY then
			posSanta.revere = not posSanta.revere
			posSanta.current = 0
		end
		if posSanta.revere then
			posSanta.y = posSanta.y + 1
		else
			posSanta.y = posSanta.y - 1
		end

		lcd.drawPixmap(posSanta.x, posSanta.y, "/BMP/santa.bmp")
	end
end


-- initialize the variables
local function init()
	startTicks = getTime() / 100.0

	for i = 1, 70 do
		local x = math.random(30, 400)
		snow[i] = {initX = x, X=x, velX = 1, Y=math.random(0, limitScreenY), velY = math.random(1, 3), current = 0}
	end

	posSanta.x = 10
	posSanta.y = math.random(0, limitScreenY)
	posSanta.numberOfPixelY = math.random(10,30)
	
end


-- Background calculation (time)
local function bg()
	elapsedTime =  getTime() - startTicks
end

-- Loop function
local function run(event)
	lcd.clear()
	update()
end

return { run=run, background=bg, init=init }