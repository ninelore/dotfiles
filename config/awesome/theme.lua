---------------------------------------------
-- Awesome theme which follows xrdb config --
--   by Yauhen Kirylau                    --
---------------------------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local gears_shape = require("gears.shape")
local wibox = require("wibox")
local awful_widget_clienticon = require("awful.widget.clienticon")

-- inherit default theme
local theme = dofile(themes_path.."default/theme.lua")
-- load vector assets' generators for this theme

theme.font          = "Overpass 10"

theme.bg_normal     = xrdb.background
theme.bg_focus      = xrdb.color14
theme.bg_urgent     = xrdb.color9
theme.bg_minimize   = "#090909"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = xrdb.foreground
theme.fg_focus      = theme.bg_normal
theme.fg_urgent     = theme.bg_normal
theme.fg_minimize   = theme.fg_normal

theme.useless_gap   = 2
theme.border_width  = 2
theme.border_normal = xrdb.color0
theme.border_focus  = theme.bg_focus
theme.border_marked = xrdb.color10

theme.wibar_height  = 24
theme.wibar_opacity = 0.95

theme.tasklist_spacing = 2
theme.tasklist_shape = gears_shape.rectangle_shape
theme.tasklist_shape_border_width = 2
theme.tasklist_shape_border_color = theme.bg_focus
theme.tasklist_disable_task_name = true
--theme.tasklist_disable_icon = true

theme.taglist_bg_occupied = theme.bg_normal
theme.taglist_fg_occupied = theme.fg_normal
theme.taglist_bg_empty = theme.bg_normal
theme.taglist_fg_empty = xrdb.color8

theme.tooltip_fg = theme.fg_normal
theme.tooltip_bg = theme.bg_normal

theme.menu_height = dpi(20)
theme.menu_width  = dpi(150)
theme.menu_submenu_icon = nil
theme.menu_submenu = "▸ "

-- Recolor Layout icons:
theme = theme_assets.recolor_layout(theme, theme.fg_normal)

-- Recolor titlebar icons:
--
local function darker(color_value, darker_n)
    local result = "#"
    for s in color_value:gmatch("[a-fA-F0-9][a-fA-F0-9]") do
        local bg_numeric_value = tonumber("0x"..s) - darker_n
        if bg_numeric_value < 0 then bg_numeric_value = 0 end
        if bg_numeric_value > 255 then bg_numeric_value = 255 end
        result = result .. string.format("%2.2x", bg_numeric_value)
    end
    return result
end
theme = theme_assets.recolor_titlebar(
    theme, theme.fg_normal, "normal"
)
theme = theme_assets.recolor_titlebar(
    theme, darker(theme.fg_normal, -60), "normal", "hover"
)
theme = theme_assets.recolor_titlebar(
    theme, xrdb.color1, "normal", "press"
)
theme = theme_assets.recolor_titlebar(
    theme, theme.fg_focus, "focus"
)
theme = theme_assets.recolor_titlebar(
    theme, darker(theme.fg_focus, -60), "focus", "hover"
)
theme = theme_assets.recolor_titlebar(
    theme, xrdb.color1, "focus", "press"
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "/usr/share/candy-icons/"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- No taglist squares
theme.taglist_squares_sel = nil
theme.taglist_squares_unsel = nil

local is_dark_bg = true

-- Generate wallpaper:
local wallpaper_bg = xrdb.color8
local wallpaper_fg = xrdb.color7
local wallpaper_alt_fg = xrdb.color12
if not is_dark_bg then
    wallpaper_bg, wallpaper_fg = wallpaper_fg, wallpaper_bg
end
theme.wallpaper = function(s)
    return theme_assets.wallpaper(wallpaper_bg, wallpaper_fg, wallpaper_alt_fg, s)
end


-- Icons
theme.icon_size = 12
--theme.icon_font = "Font Awesome 5 Free-Solid-900 "
theme.icon_font = "Symbols Nerd Font "
theme.icon_color = theme.fg_normal
--
local function make_fa_icon( code )
    return wibox.widget{
        markup = ' <span font_desc="'.. theme.icon_font .. theme.icon_size ..'" color="'.. theme.icon_color ..'">' .. code .. '</span> ',
        --markup = ' ' .. code .. ' ',
        align  = 'center',
        valign = 'center',
        widget = wibox.widget.textbox
    }
end

myvolicon = make_fa_icon('\u{f028}')
mybaticon = make_fa_icon('\u{f242}')
mybcklicon = make_fa_icon('\u{f5de}')
--]]


---- bling variables
-- tabbars
theme.mstab_dont_resize_slaves = true
theme.tabbar_style = "default"
theme.mstab_tabbar_style = "default"
-- window swallowing
theme.dont_swallow_classname_list    = {"firefox", "Gimp"}
theme.dont_swallow_filter_activated  = true
-- flash focus
theme.flash_focus_start_opacity = 0.6
theme.flash_focus_step = 0.01

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
