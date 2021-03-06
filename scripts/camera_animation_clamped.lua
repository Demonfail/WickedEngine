-- This script will play a camera animation chain from "cam0" -to "camN" named camera proxies in the scene
--  To use this, first place four cameras into the scene and name them cam0, cam1, cam2 and cam3, then press F8 to start
--	The animation will repeat infinitely, but it will cut from last to first proxy at the end

-- If no name is provided, this will return the main camera:
local cam = GetCamera()

-- Camera speed overridable from outer scope too:
scriptableCameraSpeed = 0.4

-- Animation state:
local tt = 0.0
local play = false
local rot = 0

-- Gather camera proxies in the scene from "cam0" to "cam1", "cam2", ... "camN":
local proxies={}
local it = 0
while true do
	local cam = GetCamera("cam" .. it)
	if(cam == nil) then
		break
	end
	it = it + 1
	proxies[it] = cam
end

runProcess(function()
	while true do

		if(input.Press(VK_F8)) then
			-- Reset animation:
			tt = 0.0
			play = not play
			rot = 0
		end
		if(play) then
			-- Play animation:
			--local proxies = { GetCamera("cam0"), GetCamera("cam1"), GetCamera("cam2"), GetCamera("cam3") }
			local count = len(proxies)
			
			-- Place main camera on spline:
			cam.CatmullRom(proxies[math.clamp(rot - 1, 0, count - 1) + 1], proxies[math.clamp(rot, 0, count - 1) + 1], proxies[math.clamp(rot + 1, 0, count - 1) + 1], proxies[math.clamp(rot + 2, 0, count - 1) + 1], tt)

			-- Advance animation state:
			tt = tt + scriptableCameraSpeed * getDeltaTime()
			if(tt >= 1.0) then
				tt = 0.0
				rot = rot + 1
			end
			if(rot >= count - 1) then
				rot = 0
			end

		end
		
		-- Wait for update() tick from Engine
		update()
		
	end
end)