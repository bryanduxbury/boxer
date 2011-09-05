def draw_face(x, y, w, h, material_thickness)
  print "<path d='"

  print "M#{x} #{y}"

  print "L#{x} #{y + h}"
  print "L#{x + w} #{y + h}"
  print "L#{x + w} #{y}"
  puts "Z' fill='none' stroke='black' stroke-width='1' />"
end

def draw_side(x, y, w, h, material_thickness, rotate = false, flip = false, screw_width = 3.0)
  puts <<-EOF
  <g transform='translate(#{x} #{y}) #{rotate ? "translate(#{h}, 0) rotate(90)" : "" } rotate(#{flip ? 180 : 0}, #{w/2}, #{h/2})'>
    <path d='
      M0 0
      L0 #{h - material_thickness}
      L#{w / 2 - 5} #{h - material_thickness}
      L#{w / 2 - 5} #{h}
      L#{w / 2 + 5} #{h}
      L#{w / 2 + 5} #{h - material_thickness}
      L#{w} #{h - material_thickness}
      L#{w} 0
      Z'
      fill='none' stroke='black' stroke-width='1'
    />
    <rect x="#{w/2 - 5 - 10}" y="#{material_thickness}" width="10" height="#{material_thickness}" fill="none" stroke-width="1" stroke="black" />
    <rect x="#{w/2 + 5}" y="#{material_thickness}" width="10" height="#{material_thickness}" fill="none" stroke-width="1" stroke="black" />
    <circle cx="#{w/2}" cy="#{material_thickness + screw_width/2}" r="#{screw_width / 2}" fill="none" stroke-width="1" stroke="black" />
  </g>
  EOF
end

def draw_bottom(x, y, w, h, material_thickness, screw_width)
  puts <<-EOF
  <g transform="translate(#{x}, #{y})">
    <path d="
      M#{material_thickness} #{material_thickness}
      h#{w/2 - 15 - material_thickness}
      v-#{material_thickness}
      h10
      v#{material_thickness}
      h10
      v-#{material_thickness}
      h10
      v#{material_thickness}
      h#{w/2 - 15 - material_thickness}

      v#{h/2 - 15 - material_thickness}
      h#{material_thickness}
      v10
      h-#{material_thickness}
      v10
      h#{material_thickness}
      v10
      h-#{material_thickness}
      v#{h/2 - 15 - material_thickness}

      h-#{w/2 - 15 - material_thickness}
      v#{material_thickness}
      h-10
      v-#{material_thickness}
      h-10
      v#{material_thickness}
      h-10
      v-#{material_thickness}
      h-#{w/2 - 15 - material_thickness}

      v-#{h/2 - 15 - material_thickness}
      h-#{material_thickness}
      v-10
      h#{material_thickness}
      v-10
      h-#{material_thickness}
      v-10
      h#{material_thickness}
      v-#{h/2 - 15 - material_thickness}
    "
    fill='none' stroke='black' stroke-width='1' />
  </g>
  EOF
  # 
  # print "<path d='"
  # 
  # print "M#{x} #{y}"
  # 
  # print "L#{x} #{y + h}"
  # print "L#{x + w} #{y + h}"
  # print "L#{x + w} #{y}"
  # puts "Z' fill='none' stroke='black' stroke-width='1' />"
end

w, h, d = ARGV.shift.to_f, ARGV.shift.to_f, ARGV.shift.to_f
screw_len, screw_width = ARGV.shift.to_f, ARGV.shift.to_f
material_thickness = ARGV.shift.to_f
kerf = ARGV.shift.to_f

SPACING = 5

# header

puts <<-EOF

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>svg test</title>
<style>
stop.begin { stop-color:yellow; }
stop.end { stop-color:green; }
body.invalid stop.end { stop-color:red; }
#err { display:none; }
body.invalid #err { display:inline; }
</style>
<script>
function signalError() {
document.getElementById('body').setAttribute("class", "invalid");
}
</script>
</head>
<body id="body" style="position:absolute; z-index:0; border:1px solid black; left:0%; top:0%; width:100%; height:100%;">
  <svg xmlns="http://www.w3.org/2000/svg" version="1.1"
    viewBox="0 0 300 300" preserveAspectRatio="xMinYMin"
    style="width:100%; height:100%; position:absolute; top:0; left:0; z-index:-1;">
EOF

# top side

top_side_origin_x = SPACING
top_side_origin_y = SPACING
side_width = w + material_thickness * 2
side_height = d + material_thickness * 3

draw_side(top_side_origin_x, top_side_origin_y, side_width, side_height, material_thickness)

# face

faceplate_origin_x = SPACING
faceplate_origin_y = top_side_origin_y + side_height + SPACING
faceplate_width = w + material_thickness * 4
faceplate_height = h + material_thickness * 4
draw_face(faceplate_origin_x, faceplate_origin_y, faceplate_width, faceplate_height, material_thickness)

# bottom side

bottom_side_origin_x = SPACING
bottom_side_origin_y = faceplate_origin_y + faceplate_height + SPACING

draw_side(bottom_side_origin_x, bottom_side_origin_y, side_width, side_height, material_thickness, false, true)

# right side

right_side_origin_x = faceplate_origin_x + faceplate_width + SPACING
right_side_origin_y = faceplate_origin_y
right_side_width = h + material_thickness * 2
right_side_height = d + material_thickness * 3

draw_side(right_side_origin_x, right_side_origin_y, right_side_width, right_side_height, material_thickness, true, false)

# back

back_origin_x = right_side_origin_x + side_height + SPACING
back_origin_y = faceplate_origin_y
back_width = w + material_thickness * 2
back_height = h + material_thickness * 2

draw_bottom(back_origin_x, back_origin_y, back_width, back_height, material_thickness, screw_width)

# left side

left_side_x = back_origin_x + back_width + SPACING
left_side_y = faceplate_origin_y

draw_side(left_side_x, left_side_y, right_side_width, right_side_height, material_thickness, true, true)

puts <<-EOF
  </svg>
</body>
</html>
EOF