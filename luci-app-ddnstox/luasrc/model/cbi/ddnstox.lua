local i = require 'luci.sys'
local m, s

m = Map('ddnstox', translate('DDNSTOX'))
m.description = translate('DDNSTO is a stable, fast, and user-friendly intranet penetration tool.')

m:section(SimpleSection).template = 'ddnstox/ddnstox_status'

s = m:section(TypedSection, 'ddnstox', translate("Basic Setting"))
s.addremove = false
s.anonymous = true

o = s:option(Flag, 'enabled', translate('Enabled'))
o.rmempty = false

o = s:option(Value,"device_name", translate("Device Name"), translate("Device name should contain only alphanumeric characters (maximum 20 characters)"))
o.rmempty = false

o = s:option(Value,"user_token", translate("Token"), translate("Please enter a valid Token (Apply at the <a href=\"https://web.ddnsto.com/app\" target=\"_blank\">DDNSTO Console</a>)."))
o.password = true

return m
