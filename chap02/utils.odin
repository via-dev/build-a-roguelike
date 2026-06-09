package main

import tui "../TermCL/"
import "core:image"

get_pixel_color :: proc(img: ^image.Image, x, y: int) -> tui.Color_RGB {
	index := (img.channels * x) + ((img.width * img.channels) * y)
	red := img.pixels.buf[index]
	green := img.pixels.buf[index + 1]
	blue := img.pixels.buf[index + 2]
	return {red, green, blue}
}

centerx :: proc(txt: string) -> uint {
	return (TXCOLS / 2) - (len(txt) / 2)
}

centery :: proc(num: uint) -> uint {
	return (TXROWS / 2) - (num / 2)
}
