# Godot Sponza: Custom FPS counter implementation
# Inspired by <http://www.growingwiththeweb.com/2017/12/fast-simple-js-fps-counter.html>
#
# Copyright © 2017-present Hugo Locurcio and contributors - MIT License

#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


extends Label

# Timestamps of frames rendered in the last second
var times := []

# Frames per second
var fps := 0


func _process(_delta: float) -> void:
	var now := Time.get_ticks_msec()

	# Remove frames older than 1 second in the `times` array
	while times.size() > 0 and times[0] <= now - 1000:
		times.pop_front()

	times.append(now)
	fps = times.size()

	# Display FPS in the label
	text = str(fps) + " FPS"
