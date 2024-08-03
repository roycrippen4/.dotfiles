# from datetime import datetime
from kitty.boss import get_boss
from kitty.fast_data_types import Screen, add_timer, get_options
from kitty.utils import color_as_int
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    Formatter,
    TabBarData,
    as_rgb,
    draw_attributed_string,
    draw_title,
)

opts = get_options()

LEFT_END = ""
LEFT_END_BGCOLOR = as_rgb(color_as_int(opts.active_tab_background))
LEFT_END_FGCOLOR = as_rgb(color_as_int(opts.tab_bar_background))

CLOCK_SEP = " │ "

CLOCK_BG = as_rgb(color_as_int(opts.color4))
CLOCK_FG = as_rgb(color_as_int(opts.active_tab_background))

DATE_BG = as_rgb(color_as_int(opts.color8))
DATE_FG = as_rgb(color_as_int(opts.active_tab_background))

bat_text_color = as_rgb(color_as_int(opts.color15))
SEPARATOR_SYMBOL, SOFT_SEPARATOR_SYMBOL = ("", "")
# RIGHT_MARGIN = 0
REFRESH_TIME = 1


def _draw_left_status(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    if screen.cursor.x >= screen.columns:
        return screen.cursor.x
    tab_bg = screen.cursor.bg
    tab_fg = screen.cursor.fg
    default_bg = as_rgb(int(draw_data.default_bg))
    if extra_data.next_tab:
        next_tab_bg = as_rgb(draw_data.tab_bg(extra_data.next_tab))
        needs_soft_separator = next_tab_bg == tab_bg
    else:
        next_tab_bg = default_bg
        needs_soft_separator = False
    # if screen.cursor.x <= len(ICON):
    #     screen.cursor.x = len(ICON)
    screen.draw(" ")
    screen.cursor.bg = tab_bg
    draw_title(draw_data, screen, tab, index)
    if not needs_soft_separator:
        screen.draw(" ")
        screen.cursor.fg = tab_bg
        screen.cursor.bg = next_tab_bg
        screen.draw(SEPARATOR_SYMBOL)
    else:
        prev_fg = screen.cursor.fg
        if tab_bg == tab_fg:
            screen.cursor.fg = default_bg
        elif tab_bg != default_bg:
            c1 = draw_data.inactive_bg.contrast(draw_data.default_bg)
            c2 = draw_data.inactive_bg.contrast(draw_data.inactive_fg)
            if c1 < c2:
                screen.cursor.fg = default_bg
        screen.cursor.fg = prev_fg  # separator_fg
        screen.draw(" " + SOFT_SEPARATOR_SYMBOL)
    end = screen.cursor.x
    return end


# def _draw_right_status(screen: Screen, is_last: bool, cells: list) -> int:
#     if not is_last:
#         return 0
#     draw_attributed_string(Formatter.reset, screen)
#     screen.cursor.x = screen.columns - right_status_length
#     screen.cursor.fg = 0
#     for bgColor, fgColor, status in cells:
#         screen.cursor.fg = fgColor
#         screen.cursor.bg = bgColor
#         screen.draw(status)
#     screen.cursor.bg = 0
#     return screen.cursor.x


def _redraw_tab_bar(_):
    tm = get_boss().active_tab_manager
    if tm is not None:
        tm.mark_tab_bar_dirty()


timer_id = None
# right_status_length = -1


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    global timer_id
    # global right_status_length
    # if timer_id is None:
    #     timer_id = add_timer(_redraw_tab_bar, REFRESH_TIME, True)
    # cells = [
    #     (LEFT_END_FGCOLOR, LEFT_END_BGCOLOR, LEFT_END),
    #     (CLOCK_FG, CLOCK_BG, datetime.now().strftime(" %I:%M:%S")),
    #     (DATE_FG, DATE_BG, CLOCK_SEP),
    #     (DATE_FG, DATE_BG, datetime.now().strftime("%m/%d/%Y ")),
    # ]
    # right_status_length = RIGHT_MARGIN
    # for cell in cells:
    #     right_status_length += len(str(cell[2]))

    # _draw_icon(screen, index)
    _draw_left_status(
        draw_data,
        screen,
        tab,
        before,
        max_title_length,
        index,
        is_last,
        extra_data,
    )
    # _draw_right_status(
    #     screen,
    #     is_last,
    #     cells,
    # )
    return screen.cursor.x
