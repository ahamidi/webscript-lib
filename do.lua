-- IBT VPS Server Management Script

-- Private Functions

-- Check auth token
local function checkAuth(token)
	print("token: "..token)
	if (storage[token] == nil) then
		print("invalid token")
		return 403, json.stringify("Invalid access token")
	else
		return 200, json.stringify("ok")
	end
end

-- API request
local function webrequest(path, params)

	local url = "https://api.digitalocean.com/"..path
	
	-- Make sure there is always a params table
	if (params == nil) then
		params = {}
	end
	
	-- Inject client ID and api key
	params["client_id"] = storage.do_client_id
	params["api_key"] = storage.do_api_key
	
	-- Make the call
	local response = http.request {
		url = url,
		method = "GET",
		params = params,
		headers = {['Content-Type'] = 'application/json'}
	}
	
	return response
end	

-- Public calls

local function init(client_id, api_key)
	storage.do_client_id = client_id
	storage.do_api_key = api_key

	return true
end

local function showAllServers()
	print("show all servers called")
	local path = "droplets/"
	
	return webrequest(path)
end

local function showServer(server_id)
	print("Show server with Server ID: " .. server_id)
	local path = "droplets/" .. server_id

	return webrequest(path)
end

local function newServer(name, size, image, region)
	print("New Server called")
	local path = "droplets/new"
	local params = {
		name = name,
		size_id = size,
		image_id = image,
		region = region
	}

	return webrequest(path, params)
end

local function deleteServer(server_id)
	print("Delete Server with Server ID: " .. server_id)
	local path = "droplets/"..server_id.."/destroy/"
	local params = {scrub_data = true}

	return webrequest(path, params)
end

local function resizeServer(server_id, size)
	-- TODO

	return false
end

local function rebootServer(server_id)
	local path = server_id.."/reboot/"

	return webrequest(path)
end

local function powerCycleServer(server_id)
	local path = server_id.."/power_cycle/"

	return webrequest(path)
end

local function shutdownServer(server_id)
	local path = server_id.."/shutdown/"

	return webrequest(path)
end

local function powerOffServer(server_id)
	local path = server_id.."/power_off/"

	return webrequest(path)
end

local function powerOnServer(server_id)
	local path = server_id.."/power_on/"

	return webrequest(path)
end

local function enableBackups(server_id)
	local path = server_id.."/enable_backups/"

	return webrequest(path)
end

local function disableBackups(server_id)
	local path = server_id.."/disable_backups/"

	return webrequest(path)
end

local function resetServerPassword(server_id)
	local path = server_id.."/password_reset/"

	return webrequest(path)
end

local function snapshotServer(server_id)
	local path = server_id.."/snapshot/"

	return webrequest(path)
end

local function restoreServer(server_id, image_id)
	-- TODO

	return false
end

local function rebuildServer(server_id, image_id)
	-- TODO

	return false
end

local function showImages(global)
	local path = "images/"

	local params = {}
	if (global) then
		params = {filter = global}
	else
		params = {filter = my_images}
	end

	return webrequest(path, params)
end

local function showSizes()
	local path = "sizes/"

	return webrequest(path)
end

return {
	init = init,
	showAllServers = showAllServers,
	showServer = showServer,
	newServer = newServer,
	deleteServer = deleteServer,
	resizeServer = resizeServer,
	rebootServer = rebootServer,
	powerCycleServer = powerCycleServer,
	powerOnServer = powerOnServer,
	powerOffServer = powerOffServer,
	shutdownServer = shutdownServer,
	enableBackups = enableBackups,
	disableBackups = disableBackups,
	snapshotServer = snapshotServer,
	resetServerPassword = resetServerPassword,
	restoreServer = restoreServer,
	rebuildServer = rebuildServer,
	showImages = showImages,
	showSizes = showSizes
}