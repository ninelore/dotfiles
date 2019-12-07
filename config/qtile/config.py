# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


import os
import re
import socket
import subprocess
from libqtile.config import Drag, Key, Screen, Group, Drag, Click, Rule
from libqtile.command import lazy, Client
from libqtile import layout, bar, widget, hook
from libqtile.widget import Spacer
import arcobattery
#import arcomemory

#mod4 or mod = super key
mod = "mod4"
mod1 = "alt"
mod2 = "control"
home = os.path.expanduser('~')


@lazy.function
def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)

@lazy.function
def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)


keys = [

# SUPER + FUNCTION KEYS

    Key([mod], "e", lazy.spawn('urxvt -e vim')),
    Key([mod], "g", lazy.window.toggle_fullscreen()),
    Key([mod], "p", lazy.spawn("passmenu -i -nb '#262626' -nf '#73b3e7' -sb '#73b3e7' -sf '#262626' -fn 'NotoMonoRegular:pixelsize=16'")),
    Key([mod], "q", lazy.window.kill()),
    Key([mod], "t", lazy.spawn(home + '/.config/qtile/scripts/todo.sh')),
    Key([mod], "a", lazy.spawn('pavucontrol')),
    Key([mod], "w", lazy.spawn('qutebrowser')),
    Key([mod], "x", lazy.spawn('oblogout')),
    Key([mod], "Escape", lazy.spawn('xkill')),
    Key([mod], "Return", lazy.spawn('urxvt')),
    Key([mod], "f", lazy.spawn('urxvt -e ranger')),
    Key([mod], "o", lazy.spawn("networkmanager_dmenu -i -nb '#262626' -nf '#73b3e7' -sb '#73b3e7' -sf '#262626' -fn 'NotoMonoRegular:pixelsize=16'")),
    Key([mod], "r", lazy.spawn('urxvt -e rtv')),
    Key([mod], "d", lazy.spawn('dmenu')),
    Key([mod], "d", lazy.spawn("dmenu_run -i -nb '#262626' -nf '#73b3e7' -sb '#73b3e7' -sf '#262626' -fn 'NotoMonoRegular:pixelsize=16'")),
    Key([mod], "b", lazy.spawn(home + '/.config/qtile/scripts/btmenu.sh')),


    # SUPER + SHIFT KEYS
    Key([mod, "shift"], "t", lazy.spawn('urxvt -e ranger')),   
    Key([mod, "shift"], "Return", lazy.spawn(home + '/.config/qtile/scripts/fmenu.sh')),
    Key([mod, "shift"], "d", lazy.spawn(home + '/.config/qtile/scripts/fmenu.sh')),
    Key([mod, "shift"], "q", lazy.window.kill()),
    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "shift"], "Escape", lazy.spawn('urxvt -e htop')),
    Key([mod, "shift"], "a", lazy.spawn('urxvt -e ncpamixer')),
    Key([mod, "shift"], "w", lazy.spawn('firefox')),
    Key([mod, "control"], "o", lazy.spawn(home + '/.config/qtile/scripts/compton-toggle.sh')),
    

    # SCREENSHOTS
    Key([], "Print", lazy.spawn('gnome-screenshot -i')),

# MULTIMEDIA KEYS

# INCREASE/DECREASE BRIGHTNESS
    Key([], "XF86MonBrightnessUp", lazy.spawn("xbacklight -inc 5")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("xbacklight -dec 5")),

# INCREASE/DECREASE/MUTE VOLUME
    Key([], "XF86AudioMute", lazy.spawn("amixer -q set Master toggle")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -q set Master 5%-")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -q set Master 5%+")),

    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
    Key([], "XF86AudioStop", lazy.spawn("playerctl stop")),

#    Key([], "XF86AudioPlay", lazy.spawn("mpc toggle")),
#    Key([], "XF86AudioNext", lazy.spawn("mpc next")),
#    Key([], "XF86AudioPrev", lazy.spawn("mpc prev")),
#    Key([], "XF86AudioStop", lazy.spawn("mpc stop")),

# QTILE LAYOUT KEYS
    Key([mod], "n", lazy.layout.normalize()),
    Key([mod], "space", lazy.next_layout()),

# CHANGE FOCUS
    Key([mod], "Up", lazy.layout.up()),
    Key([mod], "Down", lazy.layout.down()),
    Key([mod], "Left", lazy.layout.left()),
    Key([mod], "Right", lazy.layout.right()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),


# RESIZE UP, DOWN, LEFT, RIGHT
    Key([mod, "control"], "l",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
        ),
    Key([mod, "control"], "Right",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
        ),
    Key([mod, "control"], "h",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
        ),
    Key([mod, "control"], "Left",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
        ),
    Key([mod, "control"], "k",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
        ),
    Key([mod, "control"], "Up",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
        ),
    Key([mod, "control"], "j",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
        ),
    Key([mod, "control"], "Down",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
        ),


# FLIP LAYOUT FOR MONADTALL/MONADWIDE
    Key([mod, "shift"], "f", lazy.layout.flip()),

# FLIP LAYOUT FOR BSP
    Key([mod, "mod1"], "k", lazy.layout.flip_up()),
    Key([mod, "mod1"], "j", lazy.layout.flip_down()),
    Key([mod, "mod1"], "l", lazy.layout.flip_right()),
    Key([mod, "mod1"], "h", lazy.layout.flip_left()),

# MOVE WINDOWS UP OR DOWN BSP LAYOUT
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),

# MOVE WINDOWS UP OR DOWN MONADTALL/MONADWIDE LAYOUT
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "Left", lazy.layout.swap_left()),
    Key([mod, "shift"], "Right", lazy.layout.swap_right()),

# TOGGLE FLOATING LAYOUT
    Key([mod, "shift"], "space", lazy.window.toggle_floating()),]

groups = []

# FOR QWERTY KEYBOARDS
group_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0",]

# FOR AZERTY KEYBOARDS
#group_names = ["ampersand", "eacute", "quotedbl", "apostrophe", "parenleft", "section", "egrave", "exclam", "ccedilla", "agrave",]

group_labels = ["I ", "II ", "III ", "IV ", "V ", "VI ", "VII ", "VIII ", "IX ", "X ",]
#group_labels = ["Web", "Edit", "Ink", "Gimp", "Meld", "Vlc", "VB", "Thunar", "Mail", "Music",]

group_layouts = ["monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall",]
#group_layouts = ["monadtall", "matrix", "monadtall", "bsp", "monadtall", "matrix", "monadtall", "bsp", "monadtall", "monadtall",]

for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
        ))

for i in groups:
    keys.extend([

#CHANGE WORKSPACES
        Key([mod], i.name, lazy.group[i.name].toscreen()),
        Key([mod], "Tab", lazy.screen.next_group()),
        #Key(["mod1"], "Tab", lazy.screen.next_group()),
        #Key(["mod1", "shift"], "Tab", lazy.screen.prev_group()),

# MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND STAY ON WORKSPACE
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
# MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND FOLLOW MOVED WINDOW TO WORKSPACE
        Key([mod, "mod2"], i.name, lazy.window.togroup(i.name) , lazy.group[i.name].toscreen()),
    ])


def init_layout_theme():
    return {"margin":5,
            "border_width":2,
            "border_focus": "#73b3e7",
            "border_normal": "#4c566a"
            }

layout_theme = init_layout_theme()


layouts = [
    layout.MonadTall(margin=8, border_width=2, border_focus="#73b3e7", border_normal="#262626"),
    layout.MonadWide(margin=8, border_width=2, border_focus="#73b3e7", border_normal="#4c566a"),
    layout.Matrix(**layout_theme),
    layout.Bsp(**layout_theme),
    layout.Floating(**layout_theme),
    layout.RatioTile(**layout_theme),
    layout.Max(**layout_theme)
]

# COLORS FOR THE BAR

def init_colors():
    return [["#1e1e1e", "#1e1e1e"], # color 0
            ["#1e1e1e", "#1e1e1e"], # color 1
            ["#b7bec9", "#b7bec9"], # color 2
            ["#73b3e7", "#73b3e7"], # color 3
            ["#73b3e7", "#73b3e7"], # color 4
            ["#f3f4f5", "#f3f4f5"], # color 5
            ["#e77171", "#e77171"], # color 6
            ["#a1bf78", "#a1bf78"], # color 7
            ["#73b3e7", "#73b3e7"], # color 8
            ["#b7bec9", "#b7bec9"]] # color 9

colors = init_colors()



# WIDGETS FOR THE BAR

def init_widgets_defaults():
    return dict(font="Noto Sans",
                fontsize = 12,
                padding = 2,
                background=colors[1])

widget_defaults = init_widgets_defaults()

def init_widgets_list():
    prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())
    widgets_list = [
               widget.GroupBox(font="Nano Sans Bold",
                        fontsize = 12,
                        margin_y = -1,
                        margin_x = 0,
                        padding_y = 6,
                        padding_x = 5,
                        borderwidth = 0,
                        disable_drag = True,
                        active = colors[9],
                        inactive = colors[5],
                        rounded = False,
                        highlight_method = "text",
                        this_current_screen_border = colors[8],
                        foreground = colors[2],
                        background = colors[1]
                        ),
               #widget.Sep(
               #         linewidth = 1,
               #         padding = 10,
               #         foreground = colors[2],
               #         background = colors[1]
               #         ),
               widget.CurrentLayout(
                        font = "Noto Sans Bold",
                        foreground = colors[8],
                        background = colors[1]
                        ),
               widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
               widget.WindowName(font="Noto Sans",
                        fontsize = 12,
                        foreground = colors[5],
                        background = colors[1],
                        ),
               # widget.Sep(
               #          linewidth = 1,
               #          padding = 10,
               #          foreground = colors[2],
               #          background = colors[1]
               #          ),
         
               # widget.Sep(
               #          linewidth = 1,
               #          padding = 10,
               #          foreground = colors[2],
               #          background = colors[1]
               #          ),
               widget.TextBox(
                        font="Nano Sans",
                        text=" ",
                        foreground=colors[2],
                        background=colors[1],
                        padding = 0,
                        fontsize=16
                        ),
               widget.Mpris2(
                       font="Noto Sans",
                       fontsize=12,
                       foreground=colors[5],
                       background=colors[1],
                       name = 'spotify',
                       objname = "org.mpris.MediaPlayer2.spotify",
                       display_metadata=['xesam:title', 'xesam:artist'],
                       scroll_chars=None,
                       stop_pause_text='',
                       ),
             #  widget.NetGraph(
             #         font="Noto Sans",
             #         fontsize=12,
             #         bandwidth="down",
             #         interface="auto",
             #         fill_color = colors[1],
             #         foreground=colors[2],
             #         background=colors[1],
             #         graph_color = colors[5],
             #         border_color = colors[2],
             #         padding = 0,
             #         border_width = 0,
             #         line_width=0,
             #         ),
             
             #  widget.MemoryGraph(
             #         border_color = colors[2],
             #         fill_color = colors[8],
             #         graph_color = colors[8],
             #         background=colors[1],
             #         border_width = 0,
             #         line_width = 0,
             #         type = "box"
             #         ),

             #  widget.CPUGraph(
             #         border_color = colors[2],
             #         fill_color = colors[8],
             #         graph_color = colors[8],
             #         background=colors[1],
             #         border_width = 0,
             #         line_width = 0,
             #         core = "all",
             #         type = "box"
             #         ),
                 
             #  do not activate in Virtualbox - will break qtile
             #  widget.ThermalSensor(
             #         foreground = colors[5],
             #         foreground_alert = colors[6],
             #         background = colors[1],
             #         metric = True,
             #         padding = 3,
             #         threshold = 80
             #         ),

             #  widget.Sep(
             #         linewidth = 1,
             #         padding = 10,
             #         foreground = colors[2],
             #         background = colors[1]
             #         ),
             
                widget.Pacman(
                     font="Nano Sans",
                     foreground=colors[5],
                     background=colors[1],
                     fontsize=12
                     ),

             #  arcomemory.Memory(
             #           font="Noto Sans",
             #           fmt = '{MemUsed}/{MemTotal}M',
             #           update_interval = 1,
             #           fontsize = 12,
             #           foreground = colors[5],
             #           background = colors[1],
             #           ),
               # # battery option 1  or ArcoLinux Horizontal icons by default
               # # Other options have been moved to the backup folder
               # # 3 extra possibilities for your battery usage
               # widget.Sep(
               #          linewidth = 1,
               #          padding = 10,
               #          foreground = colors[2],
               #          background = colors[1]
               #          ),

                 arcobattery.BatteryIcon(
                         padding=0,
                         scale=0.7,
                         y_poss=2,
                         theme_path=home + "/.config/qtile/icons/battery_icons_horiz",
                         update_interval = 5,
                         background = colors[1]
                         ),
      #        #  widget.Sep(
       #                 linewidth = 1,
        #                padding = 10,
         #               foreground = colors[2],
          #              background = colors[1]
           #             ),
               widget.TextBox(
                        font="FontAwesome",
                        text=" ",
                        foreground=colors[3],
                        background=colors[1],
                        padding = 0,
                        fontsize=16
                        ),
               widget.Clock(
                        foreground = colors[5],
                        background = colors[1],
                        fontsize = 12,
                        format="%d-%m-%Y %H:%M"
                        ),
    #           widget.Sep(
     #                   linewidth = 1,
      #                  padding = 10,
       #                 foreground = colors[2],
        #                background = colors[1]
         #               ),
               widget.Systray(
                        background=colors[1],
                        icon_size=20,
                        padding = 4
                        ),
              ]
    return widgets_list

widgets_list = init_widgets_list()


def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    return widgets_screen1

def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    return widgets_screen2

widgets_screen1 = init_widgets_screen1()
widgets_screen2 = init_widgets_screen2()


def init_screens():
    return [Screen(top=bar.Bar(widgets=init_widgets_screen1(), size=26)),
            Screen(top=bar.Bar(widgets=init_widgets_screen2(), size=26))]
screens = init_screens()


# MOUSE CONFIGURATION
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size())
]

dgroups_key_binder = None
dgroups_app_rules = []


main = None

@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/scripts/autostart.sh'])

@hook.subscribe.startup
def start_always():
    # Set the cursor to something sane in X
    subprocess.Popen(['xsetroot', '-cursor_name', 'left_ptr'])

@hook.subscribe.client_new
def set_floating(window):
    if (window.window.get_wm_transient_for()
            or window.window.get_wm_type() in floating_types):
        window.floating = True

floating_types = ["notification", "toolbar", "splash", "dialog"]


follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},
    {'wmclass': 'makebranch'},
    {'wmclass': 'maketag'},
    {'wmclass': 'Arandr'},
    {'wmclass': 'feh'},
    {'wmclass': 'Galculator'},
    {'wmclass': 'Oblogout'},
    {'wname': 'branchdialog'},
    {'wname': 'Open File'},
    {'wname': 'pinentry'},
    {'wmclass': 'ssh-askpass'},

],  fullscreen_border_width = 0, border_width = 0)
auto_fullscreen = True
focus_on_window_activation = "smart"

wmname = "LG3D"
