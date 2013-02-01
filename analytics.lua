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
		print("Event Stats String: "..storage[event])
		local num = json.parse(storage[event]).count
		storage[event] = json.stringify({type="event", name=event, count=(num + 1)})
	else
		storage[event] = json.stringify({type="event", name=event, count=1})

		-- This is a new event, so we need to add it to the events list
		lease.acquire("events_list")
		local stats = json.parse(storage.stats)

		-- Need to check if the events list exists
		if (stats.events) then
			table.insert(stats.events, event)
		else
			stats["events"] = {event}
		end

		storage.stats = json.stringify(stats)
		lease.release("events_list")
	end
	lease.release(event)
end

local function upload()
	-- TODO:
	-- * Upload events count to DB
	-- * Reset events count

	local docs = {}
	local data = {docs=docs}

	-- Insert current time
	local cur_time = os.time()

	-- Iterate over all stats records in storage and add to docs
	local events = json.parse(storage.stats).events

	for i=1, #events do
		local event = json.parse(storage[events[i]])
		table.insert(docs, {
			event=event.name,
			time=cur_time,
			count=event.count
		})
	end

	-- Unpack stats config string
	local url, key, password
	local stats = json.parse(storage.stats)

	local response = http.request {
		url = stats.url.."/_bulk_docs",
		method = "POST",
		headers = {["Content-Type"]="application/json"},
		auth = {stats.key,stats.password},
		data = data
	}

end

return {track=track, init=init, upload=upload}