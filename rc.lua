-- Theme handling library
beautiful = require("beautiful")

-- Themes define colours, icons, and wallpapers
beautiful.init(awful.util.getdir("config") .. "/themes/black/theme.lua")

-- Standard awesome library
awful = require("awful")

awful.autofocus = require("awful.autofocus")
awful.rules = require("awful.rules")

-- Notification library
naughty = require("naughty")
naughty.config.presets.normal.opacity = 1
naughty.config.presets.low.opacity = 1
naughty.config.presets.critical.opacity = 1

-- shifty - dynamic tagging library
shifty = require("shifty")

-- vicious - widgets
vicious = require("vicious")

--rodentbane
rodentbane = require("rodentbane")

--menubar
menubar = require("menubar")
menubar.cache_entries = true
menubar.app_folders = { "/usr/share/applications/" }
menubar.show_categories = false   -- Change to false if you want only programs to appear in the menu
menubar.set_icon_theme("oxygen-gtk")

-- useful for debugging, marks the beginning of rc.lua exec
print("Entered rc.lua: " .. os.time())

-- {{{ Variable definitions

-- This is used later as the default terminal and editor to run.
browser = "firefox"
terminal = "myterminal"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key, I suggest you to remap
-- Mod4 to another key using xmodmap or other tools.  However, you can use
-- another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
modkey_sym = "Super_L"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.max,
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.magnifier,
    awful.layout.suit.max.fullscreen,
}
-- }}}

-- Define if we want to use titlebar on all applications.
use_titlebar = false

local second_screen = 1

if screen.count() ~= 1 then
  second_screen = 2
end

-- Shifty configured tags.
shifty.config.tags = {
    ["term"] = {
      position  = 1,
      layout    = awful.layout.suit.tile,
      mwfact    = 0.50,
      exclusive = true,
      init      = true,
    },
    ["web"] = {
      position    = 2,
      screen      = 1,
      layout      = awful.layout.suit.max,
      mwfact      = 0.60,
      exclusive   = true,
      solitary    = true,
      max_clients = 1,
    },
    ["files"] = {
      position  = 3,
      screen    = 1,
      exclusive = true,
      layout    = awful.layout.suit.tile,
    },
    ["docs"] = {
      position  = 4,
      screen    = 1,
      layout    = awful.layout.suit.max,
      exclusive = true,
    },
    ["images"] = {
      position  = 5,
      screen    = 1,
      layout    = awful.layout.suit.max,
      exclusive = true,
      solitary  = true,
    },
    ["chat"] = {
      position  = 6,
      screen    = second_screen,
      layout    = awful.layout.suit.tile,
      exclusive = true,
    },
    ["text"] = {
      position  = 7,
      screen    = 1,
      layout    = awful.layout.suit.tile,
      exclusive = true,
    },
    ["media"] = {
      position  = 8,
      screen    = second_screen,
      layout    = awful.layout.suit.tile,
      exclusive = true,
      solitary  = true,
    },
    ["sys"] = {
      position  = 9,
      screen    = 1,
      layout    = awful.layout.suit.fair.horizontal,
      exclusive = true,
      solitary  = false,
      mwfact    = 0.50,
    },
    ["office"] = {
      persist   = true,
      layout    = awful.layout.suit.max,
      exclusive = true,
    },
    ["p2p"] = {
      exclusive   = true,
    },
    ["mail"] = {
      exclusive   = true,
    },
    ["art"] = {
      layout      = awful.layout.suit.max,
      exclusive   = true,
    },
    ["virtual"] = {
    },
    ["gimp"] = {
      layout = awful.layout.suit.tile,
    },
    ["flash"] = {
      layout      = awful.layout.suit.max.fullscreen,
      exclusive   = true,
      max_clients = 1,
    },
    ["nitrogen"] = {
      layout = awful.layout.suit.floating,
      exclusive   = true,
      max_clients = 1,
    },
    ["games"] = {
      layout = awful.layout.suit.floating,
      exclusive   = true,
      max_clients = 1,
    },
}

-- SHIFTY: application matching rules
-- order here matters, early rules will be applied first
shifty.config.apps = {
    {
        match = {
            "Navigator",
            "Vimperator",
            "Gran Paradiso",
            "Firefox",
            "Pentadactyl",
            "Chromium",
            "dwb",
        },
        tag = "web",
        border_width = 0,
    },
    {
        match = {
            "Shredder",
            "Thunderbird",
            "mutt",
        },
        tag = "mail",
        nopopup = true,
    },
    {
        match = {
            "pcmanfm",
            "Pcmanfm",
            "Dolphin",
            "nautilus",
            "thunar",
        },
        slave = true,
        tag = "files",
        nopopup = true,
    },
    {
        match = {
            "OpenOffice",
            "libreoffice",
            "libreoffice 3.4",
            "office",
            "Abiword",
            "Gnumeric",
        },
        tag = "office",
    },
    {
        match = {
            "Skype",
            "Pidgin",
            "Empathy",
            "XChat",
            "irssi",
						"quassel",
        },
        tag = "chat",
        nopopup = true,
    },
    {
        match = {
            "Gvim",
            "Geany",
            "Emacs",
        },
        honorsizehints = false,
        tag = "text",
    },
    {
        match = {
            "mypaint",
            "Blender",
            "Inkscape",
        },
        tag = "art",
    },
    {
        match = {
            "gimp",
        },
        tag = "gimp",
    },
    {
        match = {
            "gimp%-image%-window",
        },
        slave = true,
    },
    {
        match = {
            "VirtualBox",
        },
        tag = "virtual",
    },
    {
        match = {
            "Mplayer",
            "Miro",
            "vlc",
            "clementine",
            "amarok",
            "aqualung",
            "deadbeef",
            "mplayer",
            "totem",
        },
        tag = "media",
    },
    {
        match = {
            "Mirage",
            "mcomix",
            "comix",
            "geeqie",
            "feh",
        },
        tag = "images",
    },
    {
        match = {
            "Deluge",
            "Transmission",
            "aria",
            "nicotine",
        },
        tag = "p2p",
    },
    {
        match = {
            "htop",
            "pavucontrol",
            "qjackctl",
            "gdmap",
            "wicd",
            "Blueman%-manager",
        },
        tag = "sys",
        nopopup = true,
    },
    {
        match = {
            "Okular",
        },
        tag = "docs",
    },
    {
        match = {
            "MPlayer",
            "Gnuplot",
            "galculator",
        },
        float = true,
    },
    {
        match = {
          "kupfer",
          "avant%-window%-navigator",
          "awn%-applet",
        },
        honorsizehints = false,
        intrusive = true,
        border_width = 0,
    },
    {
        match = {
            terminal,
            "urxvt",
            "rxvt",
            "sakura",
            "terminal",
            "xterm",
            "term",
        },
        honorsizehints = false,
        slave = true,
        tag = "term",
    },
    {
      match = {
        "htop",
        "wicd%-curses",
        "alsamixer",
      },
      tag = "sys",
    },
    {
        match = {
          "plugin%-container",
          "exe",
        },
        fullscreen = true,
        border_width = 0,
        tag = "flash",
    },
    {
        match = {
          "nitrogen",
        },
        tag = "nitrogen",
    },
    {
        match = {
          "python.real",
          "spaz",
        },
        tag = "games",
        border_width = 0,
    },
    {
        match = {""},
        buttons = awful.util.table.join(
            awful.button({}, 1, function (c) client.focus = c; c:raise() end),
            awful.button({modkey}, 1, function(c)
                client.focus = c
                c:raise()
                awful.mouse.client.move(c)
                end),
            awful.button({modkey}, 3, awful.mouse.client.resize)
            )
    },
}

-- SHIFTY: default tag creation rules
-- parameter description
--  * floatBars : if floating clients should always have a titlebar
--  * guess_name : should shifty try and guess tag names when creating
--                 new (unconfigured) tags?
--  * guess_position: as above, but for position parameter
--  * run : function to exec when shifty creates a new tag
--  * all other parameters (e.g. layout, mwfact) follow awesome's tag API
shifty.config.defaults = {
    --run = function(tag) naughty.notify({text = tag.name}) end,
    --layout         = awful.layout.suit.tile.left,
    layout         = awful.layout.suit.max,
    ncol           = 1,
    mwfact         = 0.60,
    floatBars      = true,
    guess_name     = true,
    guess_position = true,
}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
    { "manual", terminal .. " -e 'man awesome'"                   }
   ,{ "edit config",
    editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" }
   ,{ "restart", awesome.restart                                  }
   ,{ "quit", awesome.quit                                        }
}

function lock_screen()
  awful.util.spawn("xscreensaver-command -lock")
end

mymainmenu = awful.menu({ items = {
                                    { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal                        },
                                    { "run startup", "startup.sh"                      },
                                    { "lock screen", lock_screen              },
                                    { "suspend", (function ()
                                      lock_screen()
                                      awful.util.spawn("dbus-send --system \
                                      --print-reply \
                                      --dest='org.freedesktop.UPower' \
                                      /org/freedesktop/UPower \
                                      org.freedesktop.UPower.Suspend")
                                    end)},
                                    { "hibernate", (function ()
                                      lock_screen()
                                      awful.util.spawn("dbus-send --system \
                                      --print-reply \
                                      --dest='org.freedesktop.UPower' \
                                      /org/freedesktop/UPower \
                                      org.freedesktop.UPower.Hibernate")
                                    end)},
                                    { "shutdown", "gksudo halt"},
                                    { "restart", "gksudo reboot"}
                                  }})

-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

calendar2 = require("calendar2")
calendar2.addCalendarToWidget(mytextclock, "<span color='green'>%s</span>")

-- Create a systray
mysystray = widget({ type = "systray", align = "right" })

-- Create a wibox for each screen and add it
mywibox     = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist   = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({        }, 1, awful.tag.viewonly     ),
                    awful.button({ modkey }, 1, awful.client.movetotag ),
                    awful.button({        }, 3, awful.tag.viewtoggle   ),
                    awful.button({ modkey }, 3, awful.client.toggletag )
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
    awful.button({}, 1, function(c)
        if not c:isvisible() then
            awful.tag.viewonly(c:tags()[1])
        end
        client.focus = c
        c:raise()
        end),
    awful.button({}, 3, function()
        if instance then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({width=250})
        end
        end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
        end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
        end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end)
                           ))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    mywibox[s] = awful.wibox({ position = "top", screen = s })
    cpuwidget = widget({ type = "textbox" })
    vicious.register(cpuwidget, vicious.widgets.cpu, "CPU: $1%")
    memimage = widget({type = "imagebox"})
    memimage.image = image(awful.util.getdir("config") .. "/icons/mem.png")

    memwidgettext = widget({ type = "textbox" })
    vicious.register(memwidgettext, vicious.widgets.mem, " $1% ", 13)
    batimage = widget({type = "imagebox"})
    batimage.image = image(awful.util.getdir("config") .. "/icons/bat.png")

    batwidgettext = widget({ type = "textbox"})
    battery_name = "BAT1"
    vicious.register(batwidgettext, vicious.widgets.bat, "$1 $2% ", 61, battery_name)

    batwidget = awful.widget.progressbar()
    batwidget:set_width(8)
    batwidget:set_height(10)
    batwidget:set_vertical(true)
    batwidget:set_background_color("#494B4F")
    batwidget:set_border_color(nil)
    batwidget:set_color("#AECF96")
    batwidget:set_gradient_colors({ "#AECF96", "#88A175", "#FF5656" })
    vicious.register(batwidget, vicious.widgets.bat, "$2", 61, battery_name)
    mywibox[s].widgets = {
        {
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        batwidgettext,
        batimage,
        memwidgettext,
        memimage,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft,
    }
    --mywibox[s].screen = s
end
-- }}}

-- SHIFTY: initialize shifty
-- the assignment of shifty.taglist must always be after its actually
-- initialized with awful.widget.taglist.new()
shifty.taglist = mytaglist
shifty.init()

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

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    --Tags
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
     end)

    -- Shifty: keybindings specific to shifty
    ,awful.key({ modkey, "Shift"   }, "Left",  shifty.send_prev ) 
    ,awful.key({ modkey, "Shift"   }, "Prior", shifty.send_prev ) 
    ,awful.key({ modkey, "Shift"   }, ",", shifty.send_prev     ) 
    ,awful.key({ modkey, "Shift"   }, ".", shifty.send_next     ) 
    ,awful.key({ modkey, "Shift"   }, "s", shifty.send_prev     ) 
    ,awful.key({ modkey, "Shift"   }, "d", shifty.send_next     ) 
    ,awful.key({ modkey, "Shift"   }, "Right", shifty.send_next ) 
    ,awful.key({ modkey, "Shift"   }, "Next",  shifty.send_next ) 
    ,awful.key({ modkey, "Shift"    }, "x",     shifty.del      ) -- delete a tag
    ,awful.key({ modkey, "Shift"   }, "n", 
        function()
            local tag = awful.tag.selected()
            for i=1, #tag:clients() do
              tag:clients()[i].minimized=false
              tag:clients()[i]:redraw()
            end
        end)
    ,awful.key({modkey, "Control" }, "n", function()
        shifty.tagtoscr(awful.util.cycle(screen.count(), mouse.screen + 1))
    end)
    ,awful.key({modkey             }, "a", shifty.add) -- creat a new tag
    ,awful.key({modkey,            }, "r", shifty.rename) -- rename a tag
    ,awful.key({modkey, "Shift"    }, "a", -- nopopup new tag
    function()
        shifty.add({nopopup = true})
    end)

    ,awful.key({ modkey,}, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end)
    ,awful.key({ modkey,}, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end)
    ,awful.key({ modkey,}, "w", function () mymainmenu:toggle()      end)

    -- Layout manipulation
    ,awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end)
    ,awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end)
    ,awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end)
    ,awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end)
    ,awful.key({ modkey,           }, "y", awful.client.urgent.jumpto)
    ,awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end)

    -- Standard program
    ,awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end)
    ,awful.key({ }, "Print", function ()
      awful.util.spawn("scrot -e 'mv $f ~/Pictures/Screenshots/ 2>/dev/null'") end)
    ,awful.key({ modkey, "Control" }, "r", awesome.restart)
    ,awful.key({ modkey, "Shift"   }, "q", awesome.quit)

    ,awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end)
    ,awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end)
    ,awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end)
    ,awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end)
    ,awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end)
    ,awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end)
    ,awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end)
    ,awful.key({ modkey, "Shift"   }, "space", function ()
      awful.layout.inc(layouts, -1) end)
    ,awful.key({ modkey,           }, ";",     function ()
      rodentbane.start() end)
    ,awful.key({ modkey }, "e", function () menubar.show() end)
    -- Prompt
    ,awful.key({ modkey }, "F1",     function () mypromptbox[mouse.screen]:run() end)

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

   ,awful.key({ }, "XF86AudioRaiseVolume", function ()
       awful.util.spawn("amixer set Master 9%+")
       awful.util.spawn_with_shell("notify-send -t 1000 'Volume' \\\"`amixer get Master | tail -n 1 | tr ' ' '\\n' | tail -n 2 | tr '\\n' ' '`\\\"")
       end)
   ,awful.key({ }, "XF86AudioLowerVolume", function ()
       awful.util.spawn("amixer set Master 9%-")
       awful.util.spawn_with_shell("notify-send -t 1000 'Volume' \\\"`amixer get Master | tail -n 1 | tr ' ' '\\n' | tail -n 2 | tr '\\n' ' '`\\\"")
       end)
   ,awful.key({ }, "XF86AudioMute", function ()
       awful.util.spawn("amixer sset Master toggle") end)
   ,awful.key({ }, "XF86Launch1", function ()
       awful.util.spawn("amixer sset Master toggle") end)
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

-- Client awful tagging: this is useful to tag some clients and then do stuff
-- like move to tag on them
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
    ,awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     )
    ,awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end)
    ,awful.key({ modkey,           }, "p",      awful.client.movetoscreen                        )
    ,awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end)
    ,awful.key({ modkey, "Shift"   }, "m",      function (c) c.minimized = not c.minimized    end)
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
)

-- SHIFTY: assign client keys to shifty for use in
-- match() function(manage hook)
shifty.config.clientkeys = clientkeys
shifty.config.modkey     = modkey

function tag_is_open(tagindex, screen_arg)
  local scr = screen_arg or mouse.screen or 1
  for _, t in ipairs(screen[scr]:tags()) do
      if awful.tag.getproperty(t, "position") == tagindex then
        return 1
      end
  end
end

-- Compute the maximum number of digit we need, limited to 9
for i = 1, (shifty.config.maxtags or 9) do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({modkey}, i, function()
              if tag_is_open(i) then
                save_opacity()
                local t =  awful.tag.viewonly(shifty.getpos(i))
                restore_opacity()
              end
            end),
        awful.key({modkey, "Control"}, i, function()
            if tag_is_open(i) then
              local t = shifty.getpos(i)
              t.selected = not t.selected
            end
            end),
        awful.key({modkey, "Control", "Shift"}, i, function()
            if client.focus then
                awful.client.toggletag(shifty.getpos(i))
            end
            end),
        -- move clients to other tags
        awful.key({modkey, "Shift"}, i, function()
            if client.focus then
                save_opacity()
                local t = shifty.getpos(i)
                -- awful.client.movetotag(t)
                -- Below is a workaround for a bug.
                awful.tag.viewonly(t)
                awful.tag.history.restore()
                awful.client.movetotag(t)
                awful.tag.viewonly(t)
                restore_opacity()
            end
        end))
    end

-- Set keys
root.keys(globalkeys)
-- }}}

client.add_signal("focus", function(c)
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
client.add_signal("unfocus", function(c)
        c.border_color = beautiful.border_normal
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

--Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c)
            then
            client.focus = c
        end
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
run_once("xmodmap", ".Xmodmap")
run_once("xsetroot", "-cursor_name left_ptr")
run_once("xscreensaver", "-no-splash")
run_once("skype")
--run_once("pidgin")

run_once("/opt/dropbox/dropbox")
run_once("nvidia-settings", "-l")

run_once("blueman-applet")

run_once("clipit")
-- awful.util.spawn("deluged")

-- Fix keys not working on startup.
--awful.util.spawn(terminal .. " -e sleep 0")
awful.util.spawn(terminal .. " -e exit")

