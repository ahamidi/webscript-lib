-- CouchDB Script

local headers = {["Content-Type"]="application/json"}
local auth = {storage.db_key, storage.db_password}

-- GET Request
local get = function(path, params)

	return http.request {
		url = storage.db_url..storage.db_name..path,
		method = "GET",
		headers = headers,
		auth = auth,
		params = params
	}
end

-- POST Request
local post = function()

end

-- PUT Request
local put = function()

end

-- DELETE Request
local delete = function()

end

return {get=get, post=post, put=put, delete=delete}