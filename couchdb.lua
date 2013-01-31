------------------------------------------------------------------------------
-- CouchDB Script
--
-- Author: Ali Hamidi
--
-- In order to use this script you will need to make sure that you have
-- the following storage records:
--	* storage.db_url - The database URL (e.g. http://mydbserver.mydomain.com)
--	* storage.db_name - The name of the database (e.g. mydatabase)
--	* storage.db_key - The user auth key
--	* storage.db_password - The user password
--
-- Note: This has only really been tested with Cloudant.

-- Setup
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