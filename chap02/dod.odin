package main

import "core:fmt"
import "core:image"
import _ "core:image/bmp"
import "core:os"

import tui "../TermCL/"
import tb "../TermCL/term"

TXCOLS :: 80
TXROWS :: 60

@(rodata)
TITLE_IMG := #load("../images/title.bmp")

display_title :: proc(screen: ^tui.Screen) {
	title_img, img_error := image.load_from_bytes(TITLE_IMG)
	if img_error != nil {
		fmt.eprintln("Error loading title image:", img_error)
		os.exit(1)
	}

	for y in 0 ..< title_img.height {
		for x in 0 ..< title_img.width {
			color := get_pixel_color(title_img, x, y)
			tui.move_cursor(screen, uint(y), uint(x))
			tui.set_color_style(screen, nil, color)
			tui.write(screen, " ")
			tui.reset_styles(screen)
		}
	}

	txt := "Copyright (C) 2010, by Richard D. Clark"
	tx: uint = centerx(txt)
	ty: uint = TXROWS - 2

	tui.move_cursor(screen, ty, tx)
	tui.write(screen, txt)

	tui.blit(screen)

	for {
		_, proceed := tui.read(screen).(tui.Keyboard_Input)
		if proceed do break
	}
}

main :: proc() {
	s := tui.init_screen(tb.VTABLE)
	defer tui.destroy_screen(&s)

	tui.set_term_mode(&s, .Cbreak)
	tui.hide_cursor(true)

	tui.clear(&s, .Everything)

	tui.move_cursor(&s, 0, 0)

	display_title(&s)

	tui.hide_cursor(false)
}
