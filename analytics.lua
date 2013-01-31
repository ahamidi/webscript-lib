------------------------------------------------------------------------------
-- Stats Script
--
-- Author: Ali Hamidi
--
-- This script simply counts API requests and stores the number in Webscript
-- storage named <script_path>
--
-- Usage:
--
--	* Tracking
-- 		* Require analytics.lua - local stats = require ('ahamidi/webscript-lib/analytics.lua')
--		* call stats.track()
--	* Submit stats to db
--		* Create script (e.g mysubdomain.webscript.io/upload)
--		* Require analytics.lua - local stats = require ('ahamidi/webscript-lib/analytics.lua')
--		* call stat.upload()
--		* Setup Cron Job to call above script every 5 minutes

-- Setup
local headers = {["Content-Type"]="application/json"}
local url = ""
local auth = {}

local function init(url, key, password)

	url = url
	auth = {key, password}

end

local function track(event)
	lease.acquire(event)
	if (storage[event]) then
		storage[event] = storage[event] + 1
	else
		storage[event] = 1
	end
	lease.release(event)
end

return {track=track, init=init}