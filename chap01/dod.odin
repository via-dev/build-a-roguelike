package main

import "core:fmt"
import "core:image"
import _ "core:image/bmp"
import "core:os"

import t "../TermCL/"
import tb "../TermCL/term"

TXCOLS :: 80
TXROWS :: 60

@(rodata)
TITLE_IMG := #load("../images/title.bmp")

get_pixel_color :: proc(img: ^image.Image, x, y: int) -> t.Color_RGB {
	index := (img.channels * x) + ((img.width * img.channels) * y)
	red := img.pixels.buf[index]
	green := img.pixels.buf[index + 1]
	blue := img.pixels.buf[index + 2]
	return {red, green, blue}
}

display_title :: proc(screen: ^t.Screen) {
	title_img, img_error := image.load_from_bytes(TITLE_IMG)
	if img_error != nil {
		fmt.eprintln("Error loading title image:", img_error)
		os.exit(1)
	}

	for y in 0 ..< title_img.height {
		for x in 0 ..< title_img.width {
			color := get_pixel_color(title_img, x, y)
			t.move_cursor(screen, uint(y), uint(x))
			t.set_color_style(screen, nil, color)
			t.write(screen, " ")
			t.reset_styles(screen)
		}
	}

	txt := "Copyright (C) 2010, by Richard D. Clark"
	tx: uint = (TXCOLS / 2) - (len(txt) / 2)
	ty: uint = TXROWS - 2

	t.move_cursor(screen, ty, tx)
	t.write(screen, txt)

	t.blit(screen)

	for {
		_, proceed := t.read(screen).(t.Keyboard_Input)
		if proceed do break
	}
}

main :: proc() {
	s := t.init_screen(tb.VTABLE)
	defer t.destroy_screen(&s)

	t.set_term_mode(&s, .Cbreak)
	t.hide_cursor(true)

	t.clear(&s, .Everything)

	t.move_cursor(&s, 0, 0)

	display_title(&s)

	t.hide_cursor(false)
}
