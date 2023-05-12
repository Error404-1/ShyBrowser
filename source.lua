local ui = require "ui"
local net = require("net")
require("webview")

--Shy Browser V8

local version = 8

local win = ui.Window("Shy Browser", 640, 540)

win.bgcolor = 30

local wv = ui.Webview(win, "https://duckduckgo.com/", 0, 30)
wv.align = "bottom"

local refresh = ui.Button(win,"Refresh",5,2)

local go = ui.Button(win,"GO",56,2)

local current_url = ui.Entry(win,"https://duckduckgo.com/",86,3)

current_url.width = 250

current_url.height = 25

function wv:onLoaded(good, stat)
  if good == true then
   win:status("Loaded "..wv.url.." | Status: "..stat)
  elseif good == false then
   win:status("Failed to load with status: "..stat)
 end
   win.title = "Shy Browser | "..wv.title
 current_url.text = wv.url
  end

function refresh:onClick()
  wv:reload()
end

function go:onClick()
local url_selected = current_url.text
  if string.sub(url_selected, 1,7) == "http://" or string.sub(url_selected, 1,8) == "https://" then
    wv.url = url_selected
  elseif string.sub(url_selected, 1,7) ~= "http://" and string.sub(url_selected, 1,8) ~= "https://" then
    wv.url = "http://"..url_selected
    end
 end

win:center()
win:show()

--UPDATES

local version_url = "https://error404-1.github.io"
local version_client = net.Http(version_url)
local version_response = version_client:get("/ShyBrowser/version.txt")
local latest = tonumber(version_response)

--Checking if current version is out of date

if latest ~= nil then
if version < latest then
 local updatewindow = ui.Window("Shy Browser | Update!", 300, 150)
local updatewv = ui.Webview(updatewindow, "https://error404-1.github.io/ShyBrowser/update", 0, 0)
updatewindow:show()
updatewv.align = "all"
function updatewv:onReady()
	updatewv.contextmenu = false
end
end
elseif latest == nil then
ui.error("Failed to grab update info" , "Error")
end

--Finishing update check

while win.visible do
    ui.update()
end
