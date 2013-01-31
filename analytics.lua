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

local function init(url, key, password)
	if (storage.stats) then
		-- Already initialized
	else
		storage.stats = json.stringify({url=url, key=key, password=password})
	end

end

local function track(event)
	lease.acquire(event)
	if (storage[event]) then
		local num = json.parse(storage[event].count)
		storage[event] = json.stringify({type="event", name=event, count=(num + 1)})
	else
		storage[event] = json.stringify({type="event", name=event, count=1})
	end
	lease.release(event)
end

local function upload(stored)
	-- TODO:
	-- * Upload events count to DB
	-- * Reset events count

	local docs = {}
	local data = {docs=docs}

	-- Insert current time
	local cur_time = os.time()

	-- Iterate over all stats records in storage and add to docs
	for i=1, #stored do
		if (json.parse(stored[i]).type == "event") then
			local event = json.parse(stored[i])
			table.insert(docs, {
				event=event.name,
				time=cur_time,
				count=event.count
			})
		else
			-- Not an event
		end
	end

	-- Unpack stats config string
	local url, key, password
	local stats = json.parse(stored.stats)

	local response = http.request {
		url = stats.url.."/_bulk_docs",
		method = "POST",
		headers = {["Content-Type"]="application/json"},
		auth = {stats.key,stats.password},
		data = data
	}

end

return {track=track, init=init, upload=upload}