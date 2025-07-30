module("luci.controller.ddnstox", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/ddnstox") then
		return
	end

	local page = entry({"admin", "services", "ddnstox"}, cbi("ddnstox"), _("DDNSTOX"))
	page.dependent = true
	page.acl_depends = { "luci-app-ddnstox" }

	entry({"admin", "services", "ddnstox", "status"}, call("act_status")).leaf = true
end

function act_status()
	local e = {}

	local is_running = luci.sys.call("pgrep -f /usr/bin/ddnstox >/dev/null") == 0
	e.running = is_running
	e.version = luci.sys.exec("/usr/bin/ddnstox -v 2>/dev/null"):gsub("\n", "")

	if is_running then
		local user_id = luci.sys.exec("uci get ddnstox.config.user_token"):gsub("\n", "")
		e.device_id = luci.sys.exec("/usr/bin/ddnstox -u " .. user_id .. " -w"):gsub("\n", "")

		e.device_name = luci.sys.exec("uci get ddnstox.config.device_name"):gsub("\n", "")
	end

	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end
