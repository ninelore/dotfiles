--[[
                    __      __   __   __
     |\  | | |\  | |   |   |  | |  | |
     | \ | | | \ | |-- |   |  | |__| |--
     |  \| | |  \| |__ |__ |__| |  \ |__

ninelore's awesomerc
tested on version: v4.3 (Lua 5.3)

]]
   --

-- Librarys
pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local menubar       = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")
local lain = require("lain")

-- Theme
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")
-- Librarys depending on theme
local bling = require("bling")

-- Error Handling
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true
        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end

-- Variables
terminal = "alacritty"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

-- Layouts
awful.layout.layouts = {
    awful.layout.suit.tile,
    bling.layout.mstab,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair,
    awful.layout.suit.spiral,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    bling.layout.centered,
    --bling.layout.vertical,
    --bling.layout.horizontal,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.floating,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
}

-- Menu
myawesomemenu = {
    { "hotkeys",        function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "reload awesome", awesome.restart },
    { "quit to tty/dm", function() awesome.quit() end },
}
mymainmenu = awful.menu({
    items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "open terminal", terminal },
        { "open launcher", "rofi -show combi" }
    }
})
mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Keyboard layout
mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)
local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                { raise = true }
            )
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))

-- Wallpaper function
local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
    if gears.filesystem.file_executable("$HOME/.fehbg") then
        awful.spawn("$HOME/.fehbg")
    end
end

-- Re-set wallpaper when a screen's geometry changes
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Set wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Imagebox widget for each screen
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)))

    -- Taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }
    -- Tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.minimizedcurrenttags,
        buttons = tasklist_buttons,
        layout = { spacing = 10, layout = wibox.layout.fixed.horizontal } -- ,
    }
    -- Systray widget
    mysystray = wibox.widget.systray()
    mysystray:set_base_size(nil)

    -- Textclock widget
    mytextclock = wibox.widget.textclock()

    -- Lain Widgets
    -- Battery widget
    mybattery = lain.widget.bat {
        notify = "off",
        timeout = 4,
        settings = function()
            widget:set_markup(" " .. bat_now.perc .. "% ");
        end
    }
    -- Volume Widget
    myvolume = awful.widget.watch("pamixer --get-volume", 2,
        function(widget, stdout)
            local perc = tonumber(stdout)
            if perc == nil then perc = 0 end
            widget:set_markup(" " .. perc .. "% ")
            return
        end
    )
    -- Backlight widget
    mybacklight = awful.widget.watch("light", 2,
        function(widget, stdout)
            local perc = tonumber(stdout:match("(%d+).%d"))
            widget:set_markup(" " .. perc .. "% ")
        end
    )
    -- Spotify widget
    myspotify = awful.widget.watch(
        'bash -c "echo $(playerctl -p spotify metadata xesam:artist) - $(playerctl -p spotify metadata xesam:title)"', 2,
        function(widget, stdout)
            widget:set_markup(' ' .. stdout)
            return
        end
    )

    space_seperator = wibox.widget.textbox("  ")
    space_seperator2 = wibox.widget.textbox(" ")
    line_seperator = wibox.widget.textbox("  |  ")

    -- Wibar
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibar
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        {
          -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            --mylauncher,
            space_seperator,
            s.mytaglist,
            space_seperator,
            s.mypromptbox,
            space_seperator,
        },
        s.mytasklist, -- Middle widget
        {
                      -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            space_seperator,
            mysystray,
            line_seperator,
            myspoicon,
            myspotify,
            space_seperator2,
            line_seperator,
            mybcklicon,
            mybacklight,
            line_seperator,
            mybaticon,
            mybattery.widget,
            line_seperator,
            myvolicon,
            myvolume,
            line_seperator,
            mytextclock,
            space_seperator,
            s.mylayoutbox,
        },
    }
end)

-- Mouse bindings
root.buttons(gears.table.join(
    awful.button({}, 3, function() mymainmenu:toggle() end)
))

-- global key bindings
globalkeys = gears.table.join(
-- generals
    awful.key({ modkey, "Control" }, "w", hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }),
    awful.key({ modkey, }, "w", function() mymainmenu:show() end,
        { description = "show main menu", group = "awesome" }),
    awful.key({ modkey }, "b",
        function()
            myscreen = awful.screen.focused()
            myscreen.mywibox.visible = not myscreen.mywibox.visible
        end,
        { description = "toggle wibar visibility", group = "awesome" }),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }),

    -- layout movement
    awful.key({ modkey, }, "j", function() awful.client.focus.byidx(1) end,
        { description = "focus next by index", group = "clients" }),
    awful.key({ modkey, }, "k", function() awful.client.focus.byidx(-1) end,
        { description = "focus previous by index", group = "clients" }),
    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "clients" }),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "clients" }),
    awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }),
    awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }),
    awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
        { description = "increase the number of master clients", group = "layout" }),
    awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }),
    awful.key({ modkey, }, "q", function() awful.layout.inc(1) end,
        { description = "next layout", group = "layouts" }),
    awful.key({ modkey, "Control" }, "q", function() awful.layout.inc(-1) end,
        { description = "previous layout", group = "layouts" }),
    awful.key({ modkey, "Shift" }, "a", function() lain.util.useless_gaps_resize(4) end,
        { description = "increase useless gap", group = "gaps" }),
    awful.key({ modkey, "Control" }, "a", function() lain.util.useless_gaps_resize(-4) end,
        { description = "decrease useless gap", group = "gaps" }),
    awful.key({ modkey, "Control" }, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal(
                    "request::activate", "key.unminimize", { raise = true }
                )
            end
        end,
        { description = "restore minimized", group = "client" }),

    -- Important applications
    awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey }, "d", function() awful.spawn("rofi -show combi") end,
        { description = "open rofi menu", group = "launcher" }),
    awful.key({ modkey, "Control" }, "d", function() awful.spawn("networkmanager_dmenu") end,
        { description = "open networkmanager menu", group = "launcher" }),
    awful.key({ modkey, "Shift" }, "d", function() awful.spawn("rofi -show calc") end,
        { description = "open rofi menu", group = "launcher" }),
    awful.key({ modkey, }, "c", function() awful.spawn("btmenu") end,
        { description = "open bluetooth dmenu", group = "launcher" }),
    awful.key({ modkey, "Shift" }, "c", function() awful.spawn("blueman-manager") end,
        { description = "open bluetooth settings", group = "launcher" }),

    -- some frequently used applications
    awful.key({ modkey, }, "Escape", function() awful.spawn("xkill") end,
        { description = "launch xkill", group = "applications" }),
    awful.key({ modkey, }, "a", function() awful.spawn("pavucontrol") end,
        { description = "launch pavucontrol", group = "applications" }),
    awful.key({ modkey, "Shift" }, "w", function() awful.spawn("lxrandr") end,
        { description = "launch lxrandr", group = "applications" }),
    awful.key({ modkey, }, "s", function() awful.spawn("gpaste-client ui") end,
        { description = "launch clipboard ui", group = "applications" }),

    -- system controls
    awful.key({ modkey, "Shift" }, "o", function() awful.spawn.with_shell("$HOME/.config/picom.sh") end,
        { description = "toggle picom", group = "system" }),
    awful.key({ modkey }, "-", function() awful.spawn.with_shell("xlayoutdisplay && $HOME/.fehbg") end,
        { description = "run xlayoutdisplay", group = "system" }),
    awful.key({ modkey, "Shift" }, "s", function() awful.spawn("flameshot gui") end,
        { description = "Screenshot GUI", group = "system" }),
    awful.key({}, "Print",
        function() awful.spawn.with_shell("notify-send 'Screenshot in 2 Seconds!' && flameshot gui -d 2000") end,
        { description = "Screenshot GUI (2s delay)", group = "system" }),
    awful.key({ modkey, }, "x", function() awful.spawn("xset s activate") end,
        { description = "Lock Screen", group = "system" }),
    awful.key({ modkey, "Control" }, "x", function() awful.spawn("systemctl suspend") end,
        { description = "suspend", group = "system" }),
    awful.key({}, "XF86AudioMute", function() awful.spawn.with_shell("pamixer -t") end,
        { description = "mute volume", group = "system" }),
    awful.key({}, "XF86AudioRaiseVolume", function() awful.spawn.with_shell("pamixer -i 5") end,
        { description = "increase volume", group = "system" }),
    awful.key({}, "XF86AudioLowerVolume", function() awful.spawn.with_shell("pamixer -d 5") end,
        { description = "decrease volume", group = "system" }),
    awful.key({}, "XF86MonBrightnessUp", function() awful.spawn("light -A 5") end,
        { description = "increase brightness", group = "system" }),
    awful.key({}, "XF86MonBrightnessDown", function() awful.spawn("light -U 5") end,
        { description = "decrease brightness", group = "system" }),
    --[[awful.key({ 		  }, "XF86AudioMicMute", function () awful.spawn("") end,
    	      {description = "decrease brightness", group = "system"}), --]]

    -- bling controls
    awful.key({ modkey, "Shift" }, "Tab", function() bling.module.tabbed.pick_with_dmenu() end,
        { description = "pick app for tabbing group", group = "bling" }),
    awful.key({ modkey, }, "Tab", function() bling.module.tabbed.iter() end,
        { description = "iterate through tabbing group", group = "bling" }),
    awful.key({ modkey, "Control" }, "Tab", function() bling.module.tabbed.pop() end,
        { description = "remove focus from tabbing group", group = "bling" }),

    -- Prompt
    awful.key({ modkey }, "r", function() awful.screen.focused().mypromptbox:run() end,
        { description = "run prompt", group = "launcher" }),
    awful.key({ modkey, "Shift" }, "r",
        function()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        { description = "lua execute prompt", group = "awesome" }),
    awful.key({ modkey }, "p", function() menubar.show() end,
        { description = "show the menubar", group = "launcher" })
)

-- client key bindings
clientkeys = gears.table.join(
    awful.key({ modkey, }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey, "Shift" }, "q", function(c) c:kill() end,
        { description = "close", group = "client" }),
    awful.key({ modkey, "Shift" }, "space", awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }),
    awful.key({ modkey, "Shift" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "client" }),
    awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
        { description = "move to screen", group = "client" }),
    awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "client" }),
    awful.key({ modkey, }, "n",
        function(c)
            c.minimized = true
        end,
        { description = "minimize", group = "client" }),
    awful.key({ modkey, }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "(un)maximize", group = "client" }),
    awful.key({ modkey, "Control" }, "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        { description = "(un)maximize vertically", group = "client" }),
    awful.key({ modkey, "Shift" }, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)
-- Set keys
root.keys(globalkeys)

-- Rules
awful.rules.rules = {
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA", -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin", -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer",
                -- below added by 9L
                "feh",
                "Gnome-calculator",
                "nitrogen",
                "pavucontrol",
                "Bitwarden",
                "Calls",
                "MEGAsync"
            },
            name = {
                "Event Tester", -- xev.
                "Volume Control"
            },
            role = {
                "AlarmWindow", -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up",  -- e.g. Google Chrome's (detached) Developer Tools.
                "task_dialog"
            }
        },
        properties = { floating = true }
    },

    -- (Dont) Add titlebars to normal clients and dialogs
    {
        rule_any = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = false }
    }
}


-- Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )
    awful.titlebar(c):setup {
        {
          -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        {
              -- Middle
            {
              -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        {
          -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

--[[ Window shape
local function apply_shape(draw, shape, outer_shape_args, inner_shape_args)

  local geo = draw:geometry()

  local border = beautiful.base_border_width
  local titlebar_height = border
  --local titlebar_height = titlebar.is_enabled(draw) and beautiful.titlebar_height or border

  local img = cairo.ImageSurface(cairo.Format.A1, geo.width, geo.height)
  local cr = cairo.Context(img)

  cr:set_operator(cairo.Operator.CLEAR)
  cr:set_source_rgba(0,0,0,1)
  cr:paint()
  cr:set_operator(cairo.Operator.SOURCE)
  cr:set_source_rgba(1,1,1,1)

  shape(cr, geo.width, geo.height, outer_shape_args)
  cr:fill()
  draw.shape_bounding = img._native

  cr:set_operator(cairo.Operator.CLEAR)
  cr:set_source_rgba(0,0,0,1)
  cr:paint()
  cr:set_operator(cairo.Operator.SOURCE)
  cr:set_source_rgba(1,1,1,1)

  gears.shape.transform(shape):translate(
    border, titlebar_height
  )(
    cr,
    geo.width-border*2,
    geo.height-titlebar_height-border,
    inner_shape_args
  )
  cr:fill()
  draw.shape_clip = img._native

  img:finish()
end
local pending_shapes = {}
local function round_up_client_corners(c, force, reference)
  if not force and ((
    -- @TODO: figure it out and uncomment
    not beautiful.client_border_radius or beautiful.client_border_radius == 0
  ) or (
    not c.valid
  ) or (
    c.fullscreen
  ) or (
    pending_shapes[c]
  ) or (
    #c:tags() < 1
  )) or beautiful.skip_rounding_for_crazy_borders then
    --clog('R1 F='..(force or 'nil').. ', R='..(reference or '')..', C='.. (c and c.name or '<no name>'), c)
    return
  end
  --clog({"Geometry", c:tags()}, c)
  pending_shapes[c] = true
  delayed_call(function()
    local client_tag = choose_tag(c)
    if not client_tag then
      nlog('no client tag')
      return
    end
    local num_tiled = get_num_tiled(client_tag)
    --clog({"Shape", num_tiled, client_tag.master_fill_policy, c.name}, c)
    --if not force and (c.maximized or (
    if (
      c.maximized or c.fullscreen
    or (
      (num_tiled<=1 and client_tag.master_fill_policy=='expand')
      and not c.floating
      and client_tag.layout.name ~= "floating"
    )) then
      pending_shapes[c] = nil
      --nlog('R2 F='..(force and force or 'nil').. ', R='..reference..', C='.. c.name)
      return
    end
    -- Draw outer shape only if floating layout or useless gaps
    local outer_shape_args = 0
    if client_tag.layout.name == "floating" or client_tag:get_gap() ~= 0 then
      outer_shape_args = beautiful.client_border_radius
    end
    local inner_shape_args = beautiful.client_border_radius*0.75
    --local inner_shape_args = beautiful.client_border_radius - beautiful.base_border_width
    --if inner_shape_args < 0 then inner_shape_args = 0 end
    apply_shape(c, gears.shape.rounded_rect, outer_shape_args, inner_shape_args)
    --clog("apply_shape "..(reference or 'no_ref'), c)
    pending_shapes[c] = nil
    --nlog('OK F='..(force and "true" or 'nil').. ', R='..reference..', C='.. c.name)
  end)
end --]]
-- Autostart
awful.spawn.with_shell("$HOME/.config/awesome/autorun.sh")
