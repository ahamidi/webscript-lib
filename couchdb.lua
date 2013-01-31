-- CouchDB Script

local headers = {["Content-Type"]="application/json"}
local auth = {storage.db_key, storage.db_password}

-- GET Request
local get = function(path, params)
	return http.request {
		url = storage.db_url..storage.db_name.."/"..path,
		method = "GET",
		headers = headers,
		auth = auth,
		params = params
	}
end

-- POST Request
local post = function(data)
	return http.request {
		url = storage.db_url..storage.db_name.."/",
		method = "POST",
		headers = headers,
		auth = auth,
		data = data
	}
end

-- PUT Request
local put = function(doc, data)
	return http.request {
		url = storage.db_url..storage.db_name.."/"..doc,
		method = "PUT",
		headers = headers,
		auth = auth,
		data = data
	}
end

-- DELETE Request
local delete = function(doc, rev)
		return http.request {
		url = storage.db_url..storage.db_name.."/"..doc,
		method = "DELETE",
		headers = headers,
		auth = auth,
		params = {rev=rev}
	}
end

return {get=get, post=post, put=put, delete=delete}