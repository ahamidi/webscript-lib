------------------------------------------------------------------------------
-- Orchestrate DB Lib
--
-- Author: Ali Hamidi
-- Date: Feb 06, 2014
--

local function init(apikey)
	-- Get the API Key and save it to local storage
	storage.apikey = apikey
end

local function doRequest(collection, path, params, method)
	-- Core method that actually calls Orchestrate API
	
	-- Set correct HTTP Verb
	if (method == nil) then
		method = "GET"
	end
	
	-- Construct URL
	url = "https://api.orchestrate.io/v0/"
	url = url .. collection .. "/"
	url = url .. path
		
	-- Make HTTP request	
	httpOptions = {
		url = url,
		method = method,
		auth = {storage.apikey,""},
		headers = {['Content-Type'] = "application/json"},
		params = params
	}
	
	local result = http.request(httpOptions)
	
	return result
end

local function getKey(collection, key)
	-- Construct Request
	local request = key
	
	return doRequest(collection, request)
end

local function setKey(collection, key)
	-- Construct Request
	local request = key
	
	return doRequest(collection, request, nil, "PUT")
end

local function deleteKey(collection, key)
	-- Construct Request
	local request = key
	
	return doRequest(collection, request, nil, "DELETE")
end

local function listKeys(collection, limit, afterKey)
	-- Construct Request
	local request = ""
	local params = {}
	
	-- Add Params
	if (limit or afterKey) then
		if (limit) then
			params['limit'] = limit
		end
		if (afterKey) then
			params['afterKey'] = afterKey
		end
	end
		
	
	return doRequest(collection, request, params, "GET")
end

return {
	init=init,
	getKey=getKey, 
	setKey=setKey, 
	deleteKey=deleteKey, 
	listKeys=listKeys
}