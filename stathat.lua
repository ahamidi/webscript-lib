------------------------------------------------------------------------------
-- Stathat Script
--
-- Author: Ali Hamidi
--
-- This is a Webscript port of the Stathat Lua library available here:
-- https://github.com/stathat/shlibs/blob/master/lua/stathat.lua
--
-- Usage:
--	* Setup:
-- 		* Require stathat.lua - local stathat = require ('ahamidi/webscript-lib/stathat.lua')
--		* call one of the methods below
--	* EZ Stats:
-- 		* ez_count - e.g. stathat.ez_count("joebloggs@blogsmail", "User Registered", 1)
--		* ez_value - e.g. stathat.ez_value("joebloggs@blogsmail", "Max Queue", 30)
--	* Regular Stats:
--		* count - e.g. stathat.count("Sw5L2LKJiSBwn9MKunabfa8-bWI2", "NzMxXVWshIETANaMlvO_qVLXbbY~", 1)
--		* value - e.g. stathat.value("Sw5L2LKJiSBwn9MKunabfa8-bWI2", "NzMxXVWshIETANaMlvO_qVLXbbY~", 30)
--
--

local function ez_count(ezkey, stat_name, count)
    local response = http.request {
		url = "http://api.stathat.com/ez",
		method = "GET",
		params = {
			ezkey = ezkey,
			stat = stat_name,
			count = count
		}
	}
	return response
end

local function ez_value(ezkey, stat_name, value)
	local response = http.request {
		url = "http://api.stathat.com/ez",
		method = "GET",
		params = {
			ezkey = ezkey,
			stat = stat_name,
			value = value
		}
	}
	return response
end

local function count(stat_key, user_key, count)
    local response = http.request {
		url = "http://api.stathat.com/c",
		method = "GET",
		params = {
			key = stat_key,
			ukey = user_key,
			count = count
		}
	}
	return response
end

local function value(stat_key, user_key, value)
    local response = http.request {
		url = "http://api.stathat.com/v",
		method = "GET",
		params = {
			key = stat_key,
			ukey = user_key,
			value = value
		}
	}
	return response
end

return {ez_count=ez_count, ez_value=ez_value, count=count, value=value}