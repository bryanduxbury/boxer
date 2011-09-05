def draw_face(x, y, w, h, material_thickness)
  faceplate_width = w + material_thickness * 4
  faceplate_height = h + material_thickness * 4

  print "<path d='"

  print "M#{x} #{y}"

  print "L#{x} #{y + faceplate_height}"
  print "L#{x+faceplate_width} #{y + faceplate_height}"
  print "L#{x+faceplate_width} #{y}"
  puts "Z' fill='none' stroke='black' stroke-width='1' />"
  
end

w, h, d = ARGV.shift.to_f, ARGV.shift.to_f, ARGV.shift.to_f
screw_len, screw_width = ARGV.shift.to_f, ARGV.shift.to_f
material_thickness = ARGV.shift.to_f
kerf = ARGV.shift.to_f

SPACING = 5

# face

faceplate_origin_x = SPACING
faceplate_origin_y = (SPACING + d + material_thickness*3 + SPACING)
faceplate_width = w + material_thickness * 4
faceplate_height = h + material_thickness * 4

print "<path d='"

print "M#{faceplate_origin_x} #{faceplate_origin_y}"

print "L#{faceplate_origin_x} #{faceplate_origin_y + faceplate_height}"
print "L#{faceplate_origin_x+faceplate_width} #{faceplate_origin_y + faceplate_height}"
print "L#{faceplate_origin_x+faceplate_width} #{faceplate_origin_y}"
puts "Z' fill='none' stroke='black' stroke-width='1' />"


# top/bottom side

top_side_origin_x = SPACING
top_side_origin_y = SPACING
bottom_side_origin_x = SPACING
bottom_side_origin_y = faceplate_origin_y + faceplate_height + SPACING
top_side_width = w + material_thickness * 2
top_side_height = d + material_thickness*3

print "<path d='"
print "M#{top_side_origin_x} #{top_side_origin_y}"
print "L#{top_side_origin_x} #{top_side_origin_y + top_side_height}"
print "L#{top_side_origin_x+top_side_width} #{top_side_origin_y + top_side_height}"
print "L#{top_side_origin_x+top_side_width} #{top_side_origin_y}"
puts "Z' fill='none' stroke='black' stroke-width='1' />"

print "<path d='"
print "M#{bottom_side_origin_x} #{bottom_side_origin_y}"
print "L#{bottom_side_origin_x} #{bottom_side_origin_y + top_side_height}"
print "L#{bottom_side_origin_x+top_side_width} #{bottom_side_origin_y + top_side_height}"
print "L#{bottom_side_origin_x+top_side_width} #{bottom_side_origin_y}"
puts "Z' fill='none' stroke='black' stroke-width='1' />"


# left/right side

right_side_origin_x = faceplate_origin_x + faceplate_width + SPACING
right_side_origin_y = faceplate_origin_y
right_side_width = d + material_thickness * 3
right_side_height = h + material_thickness * 2

print "<path d='"
print "M#{right_side_origin_x} #{right_side_origin_y}"
print "L#{right_side_origin_x} #{right_side_origin_y + right_side_height}"
print "L#{right_side_origin_x+right_side_width} #{right_side_origin_y + right_side_height}"
print "L#{right_side_origin_x+right_side_width} #{right_side_origin_y}"
puts "Z' fill='none' stroke='black' stroke-width='1' />"

# back

back_origin_x = right_side_origin_x + right_side_width + SPACING
back_origin_y = faceplate_origin_y
back_width = w + material_thickness * 2
back_height = h + material_thickness * 2

print "<path d='"
print "M#{back_origin_x} #{back_origin_y}"
print "L#{back_origin_x} #{back_origin_y + back_height}"
print "L#{back_origin_x+back_width} #{back_origin_y + back_height}"
print "L#{back_origin_x+back_width} #{back_origin_y}"
puts "Z' fill='none' stroke='black' stroke-width='1' />"
