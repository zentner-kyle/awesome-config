-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
awful.autofocus = require("awful.autofocus")
local tyrannical = require("tyrannical")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local debug = require("debug")

-- Themes define colours, icons, and wallpapers
beautiful.init(awful.util.getdir("config") .. "/themes/black/theme.lua")



function display(val, title)
  text = repr(val)
  naughty.notify{
    text = text,
    title = title,
  }
end

function repr (val)
  function inner(tbl, indent)
    local sep = ", "
    local indent_text = ""
    local result = "{"
    if indent > 6 then
      local indent_text = string.rep(" ", indent)
      sep = ",\n" .. indent_text
      result = result .. "\n" .. indent_text
    end
    for k, v in pairs(tbl) do
      if type(k) ~= "string" then
        result = result .. v .. sep
      else
        formatting = k .. " = "
        if type(v) == "table" then
          result = result .. formatting .. inner(v, indent + 2)
        else
          result = result .. formatting .. v .. sep
        end
      end
    end
    result = result .. "}"
    return result
  end
  if type(val) == "table" then
    return inner(val, 2)
  end
  if type(val) == "string" then
    return "\"" .. val .. "\""
  end
  return "" .. val
end



-- vicious - widgets
vicious = require("vicious")

--rodentbane
rodentbane = require("rodentbane")


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions


-- Notification library
naughty.config.presets.normal.opacity = 1
naughty.config.presets.low.opacity = 1
naughty.config.presets.critical.opacity = 1


-- This is used later as the default terminal and editor to run.
browser = "firefox"
terminal = "sakura -x tmux"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
modkey_sym = "Super_L"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.max,
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.magnifier,
    awful.layout.suit.max.fullscreen,
}
-- }}}

-- First, set some settings
tyrannical.settings.default_layout =  awful.layout.suit.tile
tyrannical.settings.mwfact = 0.66



function lock_screen()
  --awful.util.spawn("lock-screen.sh")
  --awful.util.spawn("screen-locker.sh")
  --awful.util.spawn("xautolock -locknow")
  awful.util.spawn("mate-screensaver-command --lock")
end

function suspend ()
  lock_screen()
  awful.util.spawn("gksudo pm-suspend")
  --awful.util.spawn("dbus-send --system \
  ----print-reply \
  ----dest='org.freedesktop.UPower' \
  --/org/freedesktop/UPower \
  --org.freedesktop.UPower.Suspend")
end

function hibernate ()
  lock_screen()
  awful.util.spawn("gksudo pm-hibernate")
  --awful.util.spawn("dbus-send --system \
  ----print-reply \
  ----dest='org.freedesktop.UPower' \
  --/org/freedesktop/UPower \
  --org.freedesktop.UPower.Hibernate")
end


local second_screen = 1

if screen.count() ~= 1 then
  second_screen = 2
end

-- Setup some tags
local tag_data = {
    {
        name        = "term",                 -- Call the tag "Term"
        init        = true,                   -- Load the tag on startup
        exclusive   = true,                   -- Refuse any other type of clients (by classes)
        screen      = {1, 2},                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.tile, -- Use the tile layout
        selected    = true,
        class       = { --Accept the following classes, refuse everything else (because of "exclusive=true")
            "xterm" , "urxvt" , "aterm","URxvt","XTerm","konsole","terminator","gnome-terminal", "Sakura", "sakura"
        }
    } ,
    {
        name        = "web",
        init        = false,
        exclusive   = true,
        screen      = 1,
        layout      = awful.layout.suit.max,
        slave = true,
        class = {
            "Opera"         , "Firefox"        , "Rekonq"    , "Dillo"        , "Arora",
            "Chromium"      , "nightly"        , "minefield",
            "Navigator",
            "Vimperator",
            "Gran Paradiso",
            "Pentadactyl",
            "dwb",
          }
    } ,
    {
        name = "files",
        init        = false,
        exclusive   = true,
        layout      = awful.layout.suit.tile,
        exec_once   = {"dolphin"},
        class  = {
            "Thunar", "Konqueror", "Dolphin", "ark", "Nautilus","emelfm",
            "pcmanfm",
            "Pcmanfm",
        }
    } ,
    {
        name        = "docs",
        init        = false,
                             -- client in the "class" section will start. It will be created on
                             -- the client startup screen
        exclusive   = true,
        layout      = awful.layout.suit.max,
        class       = {
            "Okular",
            "zathura",
        }
    } ,
    {
        name        = "images",
        init        = false,
        exclusive   = true,
        --solitary    = true,
        layout      = awful.layout.suit.max,
        class       = {

            "Mirage",
            "mcomix",
            "comix",
            "geeqie",
            "gwenview",
            "ristretto",
        }
    } ,
    {
        name        = "chat",
        init        = false,
        screen      = second_screen,
        layout      = awful.layout.suit.tile,
        class       = {
        
            "Skype",
            "Pidgin",
            "Empathy",
            "XChat",
            "irssi",
            "quassel",
            "chat",
        }
    } ,
    {
        name        = "text",
        init        = false,
        layout      = awful.layout.suit.tile,
        exclusive   = true,
        class       = {
            "Gvim",
            "Geany",
            "Emacs",
        }
    } ,
    {
        name        = "media",
        init        = false,
        screen      = 2,
        layout      = awful.layout.suit.tile,
        class       = {

            "Mplayer",
            "Miro",
            "vlc",
            "clementine",
            "rhythmbox",
            "amarok",
            "aqualung",
            "deadbeef",
            "mplayer",
            "totem",
            "guayadeque",
            "lxmusic",
        }
    } ,
    {
        name        = "sys",
        init        = false,
        layout      = awful.layout.suit.tile,
        exclusive = true,
        nopopup = true,
        --solitary  = false,
        class       = {
            "htop",
            "pavucontrol",
            "qjackctl",
            "gdmap",
            "wicd",
            "Blueman%-manager",
            "Wicd-client.py",
            "wpa_gui",
        }
    } ,
    {
        name        = "office",
        init        = false,
        persist     = true,
        layout      = awful.layout.suit.max,
        --solitary  = false,
        class       = {
            "OpenOffice",
            "libreoffice",
            "libreoffice 3.4",
            "libreoffice 4.0",
            "libreoffice-startcenter",
            "libreoffice-writer",
            "office",
            "Abiword",
            "Gnumeric",
        }
    } ,
    {
        name        = "p2p",
        init        = false,
        exclusive   = true,
        class       = {
            "Deluge",
            "Transmission",
            "Transmission-gtk",
            "Transmission-qt",
            "aria",
            "nicotine",
        }
    } ,
    {
        name        = "mail",
        init        = false,
        exclusive   = true,
        class       = {
            "Shredder",
            "Thunderbird",
            "mutt",
        }
    } ,
    {
        name        = "art",
        init        = false,
        layout      = awful.layout.suit.tile,
        class       = {
            "mypaint",
            "Blender",
            "Inkscape",
            "feh",
            "krita",
        }
    } ,
    {
        name        = "virtual",
        init        = false,
        class       = {
            "VirtualBox",
        
        }
    } ,
    {
        name        = "gimp",
        init        = false,
        layout      = awful.layout.suit.tile,
        class       = {
            "gimp",
        }
    } ,
    {
        name        = "flash",
        init        = false,
        layout      = awful.layout.suit.max.fullscreen,
        --persist     = true,
        --exclusive   = true,
        max_clients = 1,
        fullscreen  = true,
        border_width = 0,
        class       = {
          "plugin%-container",
          "Plugin%-container",
          "plugin-container",
          "Plugin-container",
        }
    } ,
    {
        name        = "nitrogen",
        init        = false,
        layout      = awful.layout.suit.floating,
        class       = {
          "nitrogen",
        }
    } ,
    {
        name        = "games",
        init        = false,
        layout      = awful.layout.suit.floating,
        exclusive   = true,
        max_clients = 1,
        class       = {
          "Steam",
          "python.real",
          "spaz",
        }
    } ,
    {
        name        = "cs-next",
        init        = false,
        layout      = awful.layout.suit.tile,
        class       = {
          "Control System Next IDE",
          "Error Console",
        }
    } ,
}

tyrannical.tags = tag_data

-- Ignore the tag "exclusive" property for the following clients (matched by classes)
tyrannical.properties.intrusive = {
    "ksnapshot"     , "pinentry"       , "gtksu"     , "kcalc"        , "xcalc"               ,
    "feh"           , "Gradient editor", "About KDE" , "Paste Special", "Background color"    ,
    "kcolorchooser" , "plasmoidviewer" , "Xephyr"    , "kruler"       , "plasmaengineexplorer",
    "kupfer"        , "avant%-window%-navigator"     , "awn%-applet"  , "Kupfer.py"
}

-- Ignore the tiled layout for the matching clients
tyrannical.properties.floating = {
    "MPlayer"      , "pinentry"        , "ksnapshot"  , "pinentry"     , "gtksu"          ,
    "xine"         , "feh"             , "kmix"       , "kcalc"        , "xcalc"          ,
    "yakuake"      , "Select Color$"   , "kruler"     , "kcolorchooser", "Paste Special"  ,
    "New Form"     , "Insert Picture"  , "kcharselect", "mythfrontend" , "plasmoidviewer" 
}

-- Make the matching clients (by classes) on top of the default layout
tyrannical.properties.ontop = {
    "Xephyr"       , "ksnapshot"       , "kruler", "kupfer",
}

-- Force the matching clients (by classes) to be centered on the screen on init
tyrannical.properties.centered = {
    "kcalc", "kupfer",
}

-- Do not honor size hints request for those classes
tyrannical.properties.size_hints_honor = { xterm = false, URxvt = false, aterm = false, sauer_client = false, mythfrontend  = false, gvim = false }


-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  },
                          theme = { width = theme.size * 10, height = theme.size },
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

calendar2 = require("calendar2")
calendar2.addCalendarToWidget(mytextclock, "<span color='green'>%s</span>")


-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag))
                    --awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    --awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)),
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                       awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                    theme = { width=theme.size * 25 } })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = theme.size * 2 })


    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    --left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end

    memimage = wibox.widget.imagebox()
    memimage:set_image(awful.util.getdir("config") .. "/icons/mem.png")

    memwidgettext = wibox.widget.textbox()
    vicious.register(memwidgettext, vicious.widgets.mem, " $1% ", theme.size)

    right_layout:add(mytextclock)
    right_layout:add(memimage)
    right_layout:add(memwidgettext)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
    --awful.button({ }, 4, awful.tag.viewnext),
    --awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}


function prev_tag()
  save_opacity()
  awful.tag.viewprev()
  restore_opacity()
end

function next_tag()
  save_opacity()
  awful.tag.viewnext()
  restore_opacity() 
end



-- {{{ Key bindings
globalkeys = awful.util.table.join(
      awful.key({ modkey,         } , "Left",  prev_tag)
     ,awful.key({ modkey,         } , "Prior", prev_tag)
     ,awful.key({ modkey,         } , "s",     prev_tag)
     ,awful.key({ modkey,         } , ",",     prev_tag)
     ,awful.key({ modkey,         } , "Right", next_tag)
     ,awful.key({ modkey,         } , "Next",  next_tag)
     ,awful.key({ modkey,         } , "d",     next_tag) 
     ,awful.key({ modkey,         } , ".",     next_tag)
     ,awful.key({ modkey,         } , "Escape", function ()
       save_opacity()
       awful.tag.history.restore()
       restore_opacity() 
     end)
     ,awful.key({ modkey, "Shift" } , "Escape", function ()
     save_opacity()
       awful.tag.history.restore()
       local tag = awful.tag.selected()
       awful.tag.history.restore()
       awful.client.movetotag(tag)
       awful.tag.viewonly(tag)
       restore_opacity() 
     end),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    --awful.key({ modkey,           }, "w", function () mymainmenu:toggle() end),

    awful.key({ modkey, }, "x", function () awful.tag.delete() end),
    awful.key({ modkey,           }, "r",
              function ()
                awful.prompt.run({ prompt = "New tag name: " },
                                  mypromptbox[mouse.screen].widget,
                                  function(new_name)
                                    if not new_name or #new_name == 0 then 
                                      return
                                    else
                                      local screen = mouse.screen
                                      local tag = awful.tag.selected(screen) 
                                      if tag then
                                        tag.name = new_name
                                      end
                                    end
                                  end) 
                                end),
      awful.key({ modkey,           }, "a",
        function ()
          awful.prompt.run({ prompt = "New tag name: " },
          mypromptbox[mouse.screen].widget,
          function(new_name)
            if not new_name or #new_name == 0 then
              return
            else
              props = {selected = true}
              if tyrannical.tags_by_name[new_name] then
                props = tyrannical.tags_by_name[new_name]
              end
              t = awful.tag.add(new_name, props)
              awful.tag.viewonly(t)
            end
          end)
        end),

    awful.key({ modkey, "Shift"   }, "n", 
        function()
            local tag = awful.tag.selected()
            for i=1, #tag:clients() do
              tag:clients()[i].minimized = false
              --tag:clients()[i]:redraw()
            end
        end),
    --,awful.key({modkey, "Control" }, "n", function()
        --shifty.tagtoscr(awful.util.cycle(screen.count(), mouse.screen + 1))
    --end),


    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ }, "Print", function ()
      awful.util.spawn("scrot -e 'mv $f ~/Pictures/Screenshots/ 2>/dev/null'") end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    --awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey, "Control" }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey,           }, ";",     function ()
      rodentbane.start() end)
    ,awful.key({ modkey }, "e", function () menubar.show() end)

    ,awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    --awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    --awful.key({ modkey }, "x",
              --function ()
                  --awful.prompt.run({ prompt = "Run Lua code: " },
                  --mypromptbox[mouse.screen].widget,
                  --awful.util.eval, nil,
                  --awful.util.getdir("cache") .. "/history_eval")
              --end),

    awful.key({ modkey }, "F1",     function () mypromptbox[mouse.screen]:run() end)

    ,awful.key({ modkey }, "F2",
              function ()
                  awful.prompt.run({ prompt = "Run command in terminal: " },
                  mypromptbox[mouse.screen].widget,
                  function (text)
                    awful.util.spawn_with_shell(terminal .. " -e " .. text)
                  end,
                  awful.completion.shell,
                  awful.util.getdir("cache") .. "/history_term_commands")
              end)
    ,awful.key({ modkey }, "F3",
              function ()
                  awful.prompt.run({ prompt = "Run calc: " },
                  mypromptbox[mouse.screen].widget,
                  function (text)
                    local s = "notify-send -t 100000" ..
                    " '" .. text .. "' " ..
                    " `calc '" .. text .. "'`"
                    awful.util.spawn_with_shell(s)
                  end, nil,
                  awful.util.getdir("cache") .. "/history_calc")
              end)
    ,awful.key({ modkey }, "F4",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
    ,awful.key({ modkey }, "F5",
              function ()
                  naughty.notify{text=client.focus}
              end)

   --,awful.key({ }, "XF86AudioRaiseVolume", function ()
       --awful.util.spawn("amixer set Master 9%+")
       --awful.util.spawn_with_shell("notify-send -t 1000 'Volume' \\\"`amixer get Master | tail -n 1 | tr ' ' '\\n' | tail -n 2 | tr '\\n' ' '`\\\"")
       --end)
   --,awful.key({ }, "XF86AudioLowerVolume", function ()
       --awful.util.spawn("amixer set Master 9%-")
       --awful.util.spawn_with_shell("notify-send -t 1000 'Volume' \\\"`amixer get Master | tail -n 1 | tr ' ' '\\n' | tail -n 2 | tr '\\n' ' '`\\\"")
       --end)
   --,awful.key({ }, "XF86AudioMute", function ()
       --awful.util.spawn("amixer sset Master toggle") end)
   --,awful.key({ }, "XF86Launch1", function ()
       --awful.util.spawn("amixer sset Master toggle") end)
   ,awful.key({ modkey }, "b", function ()
       mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
   end)
   ,awful.key({ modkey }, "t", function ()
     if unfocused_opacity ~= 1 then
       unfocused_opacity = 1
     else
       unfocused_opacity = 0.8
     end
   end)
   ,awful.key({ modkey }, "u", function ()
     rodentbane.click(1, modkey_sym)
   end)
   ,awful.key({ modkey }, "i", function ()
     rodentbane.click(2, modkey_sym)
   end)
   ,awful.key({ modkey }, "o", function ()
     rodentbane.click(3, modkey_sym)
   end)
   ,awful.key({ modkey, "Control"   }, "s", suspend     ) 
   ,awful.key({ modkey, "Control"   }, "d", lock_screen ),


    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

rodentbane.bind({ }, "h", function()
  rodentbane.cut("left")
end)
rodentbane.bind({ }, "j", function()
  rodentbane.cut("down")
end)
rodentbane.bind({ }, "k", function()
  rodentbane.cut("up")
end)
rodentbane.bind({ }, "l", function()
  rodentbane.cut("right")
end)

rodentbane.bind({ "Shift" }, "h", function()
  rodentbane.move("left")
end)
rodentbane.bind({ "Shift" }, "j", function()
  rodentbane.move("down")
end)
rodentbane.bind({ "Shift" }, "k", function()
  rodentbane.move("up")
end)
rodentbane.bind({ "Shift" }, "l", function()
  rodentbane.move("right")
end)

rodentbane.bind({ }, "y", function()
  rodentbane.undo()
end)
rodentbane.bind({ }, "Space", function()
  rodentbane.warp()
  rodentbane.click(1)
  rodentbane.stop()
end)
rodentbane.bind({ modkey }, "Space", function()
  rodentbane.warp()
  rodentbane.click(1, modkey_sym)
  rodentbane.click(1)
  rodentbane.stop()
end)
rodentbane.bind({ "Control" }, "Space", function()
  rodentbane.warp()
  rodentbane.click(2)
  rodentbane.stop()
end)
rodentbane.bind({ "Shift" }, "Space", function()
  rodentbane.warp()
  rodentbane.click(3)
  rodentbane.stop()
end)

rodentbane.bind({ }, "Return", function()
  rodentbane.warp()
end)


rodentbane.bind({ modkey }, ";", function()
  rodentbane.click(1, modkey_sym)
end)
rodentbane.bind({ }, ";", function()
  rodentbane.click(1)
end)
rodentbane.bind({ }, "u", function()
  rodentbane.click(1)
  rodentbane.stop()
end)
rodentbane.bind({ }, "i", function()
  rodentbane.click(2)
  rodentbane.stop()
end)
rodentbane.bind({ }, "o", function()
  rodentbane.click(3)
  rodentbane.stop()
end)

rodentbane.bind({ }, "Escape", function()
  rodentbane.stop()
end)

special_opacities = {}

function set_special_opacity(client, opacity)
  special_opacities[client] = opacity
  client.opacity = opacity
end

special_border_widths = {}

function set_special_border_width(client, width)
   special_border_widths[client] = width
end

function get_special_border_width(client)
   return special_border_widths[client]
end


function send_next(c)
  next_tag()
  awful.client.movetotag(awful.tag.selected(1), c)
end

function send_prev(c)
  prev_tag()
  awful.client.movetotag(awful.tag.selected(1), c)
end

clientkeys = awful.util.table.join(
     awful.key({ modkey,           }, "f",
               function (c)
                  if not c.fullscreen then
                     if c.border_width ~= 1 then
                        set_special_border_width(c, c.border_with)
                     end
                     c.border_width = 0
                     c.fullscreen = true
                  else
                     if get_special_border_width(c) then
                        c.border_width = get_special_border_width(c)
                     else
                        c.border_width = 1
                     end
                     c.fullscreen = false
                  end
               end)
    ,awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end)
    ,awful.key({ modkey, "Control" }, "space",  function (c)
      awful.client.floating.toggle(c)
      c.above = true
    end)
    ,awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end)
    ,awful.key({ modkey,           }, "p",      awful.client.movetoscreen                        )
    --,awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end)
    ,awful.key({ modkey, "Shift"   }, "m",      function (c)
      --c.hidden = true
      --c.focus = false
      --awful.client.focus.history.delete(c)
      c.minimized = true
      naughty.notify{text=""}
      --client.focus
      --naughty.notify{ text = debug.traceback()}
    end)
    ,awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
    ,awful.key({ modkey,           }, "v",
        function (c)
          if c.border_width == 1 then
            c.border_width = 0
            c.size_hints_honor = 0
          else
            c.border_width = 1
          end
        end)
    ,awful.key({ modkey }, "F10",
        function (c)
          if not special_opacities[c] then
            --c.special_opacity then
            set_special_opacity(c, 0.9)
            --c.special_opacity = 0.9
            --c.opacity = 0.9
          else
            local opacity = math.max(special_opacities[c] - 0.1, 0.1)
            set_special_opacity(c, opacity)
            --c.special_opacity = opacity
            --c.opacity = opacity
          end
        end)
    ,awful.key({ modkey }, "F11",
        function (c)
          if not special_opacities[c] then
          --if not c.special_opacity then
            return
          else
            local opacity = math.min(special_opacities[c] + 0.1, 1.0)
            set_special_opacity(c, opacity)
            --c.special_opacity = opacity
            --c.opacity = opacity
          end
        end)
    ,awful.key({ modkey, "Shift"   }, "Left",  send_prev ) 
    ,awful.key({ modkey, "Shift"   }, "Prior", send_prev ) 
    ,awful.key({ modkey, "Shift"   }, ",", send_prev     ) 
    ,awful.key({ modkey, "Shift"   }, ".", send_next     ) 
    ,awful.key({ modkey, "Shift"   }, "s", send_prev     ) 
    ,awful.key({ modkey, "Shift"   }, "d", send_next     ) 
    ,awful.key({ modkey, "Shift"   }, "Right", send_next ) 
    ,awful.key({ modkey, "Shift"   }, "Next",  send_next ) 
)

function table_contains(tab, elem)
  for _, other_elem in pairs(tab) do
    if other_elem == elem then
      return true
    end
  end
  return false
end

function get_tag_by_num(screen, num)
  if screen == 1 then
    local props = tag_data[num]
    local selected = awful.tag.selectedlist(screen)
    local valid_indices = {}
    local selected_indices = {}
    local all_tags = awful.tag.gettags(screen)

    for _, tag in pairs(all_tags) do
      if awful.tag.getproperty(tag, "name") == props.name then
        if table_contains(selected, tag) then
          selected_indices[awful.tag.getidx(tag)] = tag
        else
          valid_indices[awful.tag.getidx(tag)] = tag
        end
      end
    end

    local first_selected = nil
    for index, tag in pairs(selected_indices) do
      if first_selected == nil or index < first_selected then
        first_selected = index
      end
    end

    if first_selected == nil then
      first_selected = 0
    end

    local number_of_tags = #all_tags
    for index = first_selected + 1, number_of_tags do
      if valid_indices[index] then
        return index
      end
    end

    for index = 0, first_selected - 1 do
      if valid_indices[index] then
        return index
      end
    end
    --for index, tag in pairs(awful.tag.gettags(screen)) do
      --if awful.tag.getproperty(tag, "name") == props.name then
        --if not table_contains(selected, tag) then
          --return index
        --end
      --end
    --end
  end
  return num
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local index = get_tag_by_num(screen, i)
                        local tag = awful.tag.gettags(screen)[index]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local index = get_tag_by_num(screen, i)
                      local tag = awful.tag.gettags(screen)[index]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      local index = get_tag_by_num(screen, i)
                      local tag = awful.tag.gettags(client.focus.screen)[index]

            --if client.focus then
                --save_opacity()
                --local t = shifty.getpos(i)
                ---- awful.client.movetotag(t)
                ---- Below is a workaround for a bug.
                --awful.tag.viewonly(t)
                --awful.tag.history.restore()
                --awful.client.movetotag(t)
                --awful.tag.viewonly(t)
                --restore_opacity()
            --end
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.toggletag(tag)
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c)
  c.border_color = beautiful.border_focus
  if not special_opacities[c] then
    c.opacity = 1
  end
end)

unfocused_opacity = 1
temp_unfocused_opacity = 0.7
function save_opacity()
  temp_unfocused_opacity = unfocused_opacity
  unfocused_opacity = 1
end
function restore_opacity()
  unfocused_opacity = temp_unfocused_opacity
end
client.connect_signal("unfocus", function(c)
  if not c.above then
    c.border_color = beautiful.border_normal
  end
  if not special_opacities[c] then
    c.opacity = unfocused_opacity
  end
end)

function run_once(prg, args)
  -- Magic workaround because pgrep is apparently detecting the process awesome spawns to run it.
  -- Replacing awful.util.spawn_with_shell with awful.util.spawn does not work since the || is needed.
  if args then
    awful.util.spawn_with_shell("[ 1 != $(pgrep -u $USER -cf " .. prg .. ") ] || (" .. prg .. " " .. args .. ")")
  else
    awful.util.spawn_with_shell("[ 1 != $(pgrep -u $USER -cf " .. prg .. ") ] || (" .. prg .. ")")
  end
end

--Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        --naughty.notify{text="mouse_enter"}
        --if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            --and awful.client.focus.filter(c)
            --then
            --client.focus = c
        --end
    end)
    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        awful.client.setslave(c)
        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
     end
end) 

run_once("xcompmgr")
--run_once("xmodmap", ".Xmodmap")

--run_once("xsetroot", "-cursor_name left_ptr")
--awful.util.spawn("start-pulseaudio-x11")
--run_once("nm-applet")
--run_once("skype")
--run_once("pidgin")

--run_once("/opt/dropbox/dropbox")
--run_once("nvidia-settings", "-l")

run_once("blueman-applet")
--run_once("bluedevil-monolithic")

run_once("nm-applet")
run_once("clipit")
run_once("mate-power-manager")
--run_once("syndaemon", "-t -k -i 2")
run_once("ibus-daemon")
-- run_once("udiskie")
-- awful.util.spawn("deluged")
--run_once("start-volumeicon.sh")

-- Fix keys not working on startup.
--awful.util.spawn(terminal .. " -e exit")
--awful.util.spawn("konsole")

--awful.util.spawn("screensaver.sh")
run_once("mate-screensaver")

--awful.util.spawn("/usr/bin/gnome-keyring-daemon --start --components=pkcs11 &")
--awful.util.spawn("/usr/bin/gnome-keyring-daemon --start --components=ssh &")
--awful.util.spawn("/usr/bin/gnome-keyring-daemon --start --components=secrets &")
--awful.util.spawn("/usr/lib/gnome-user-share/gnome-user-share &")

--awful.util.spawn("start_gnome_keyring.sh")

--awful.util.spawn("thunderbird")

--display(beautiful.wallpaper_cmd)
awful.util.spawn(beautiful.wallpaper_cmd[1])


-- }}}
