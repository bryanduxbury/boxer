def draw_face(x, y, w, h, material_thickness)
  puts <<-EOF 
  <g transform='translate(#{x} #{y})'>
    <path d="
      M0 0
      h#{w}
      v#{h}
      h-#{w}
      v-#{h}
      "
      class="cutline"
    />
    <rect class="cutline" x="#{w/2 - 5}" y="#{material_thickness}" width="10" height="#{material_thickness}" />
    <rect class="cutline" x="#{w/2 - 5}" y="#{h-2*material_thickness}" width="10" height="#{material_thickness}" />
    <rect class="cutline" x="#{material_thickness}" y="#{h/2-5}" width="#{material_thickness}" height="10" />
    <rect class="cutline" x="#{w-2*material_thickness}" y="#{h/2-5}" width="#{material_thickness}" height="10" />
  </g>
  EOF
end

def draw_side(x, y, w, h, material_thickness, rotate = false, flip = false, screw_width = 3.0)
  num_anchors = (w / 100.0).ceil
  dist_between_anchors = w / (num_anchors + 1)
  anchors = ""
  x = 0
  0.upto(num_anchors) do |n|
    anchors << "h#{dist_between_anchors/2-5}v#{material_thickness}h10v-#{material_thickness}"
    [x+dist_between_anchors/2-5,x+dist_between_anchors/2+5]
    x+=dist_between_anchors
  end
  anchors << "h#{dist_between_anchors/2-5}"

  puts <<-EOF
  <g transform='translate(#{x} #{y}) #{rotate ? "translate(#{h}, 0) rotate(90)" : "" } rotate(#{flip ? 180 : 0}, #{w/2}, #{h/2})'>
    <path d='
      M0 0
      v#{h - material_thickness}
      #{anchors}
      v#{h - material_thickness}
      h#{w}'
      class="cutline"
    />
    <rect class="cutline" x="#{w/2 - 5 - 10}" y="#{material_thickness}" width="10" height="#{material_thickness}" />
    <rect class="cutline" x="#{w/2 + 5}" y="#{material_thickness}" width="10" height="#{material_thickness}" />
    <circle class="cutline" cx="#{w/2}" cy="#{material_thickness + screw_width/2}" r="#{screw_width / 2}" />
  </g>
  EOF
end

def screw_slot(h, v, x_dir, y_dir, screw_width, screw_length)
  <<-EOF
  #{h}#{x_dir * (5-screw_width/2)}
  #{v}#{y_dir * (screw_length / 2 - screw_width / 2)}
  #{h}#{-x_dir *screw_width / 2}
  #{v}#{y_dir * screw_width}
  #{h}#{x_dir *screw_width / 2}
  #{v}#{y_dir * (screw_length / 2 - screw_width / 2)}
  #{h}#{x_dir *screw_width}
  #{v}#{-y_dir * (screw_length / 2 - screw_width / 2)}
  #{h}#{x_dir *screw_width / 2}
  #{v}#{-y_dir * screw_width}
  #{h}#{-x_dir *screw_width / 2}
  #{v}#{-y_dir * (screw_length / 2 - screw_width / 2)}
  #{h}#{x_dir * (5 - screw_width / 2)}
  EOF
end

def draw_bottom(x, y, w, h, material_thickness, screw_width, screw_length)
  puts <<-EOF
  <g transform="translate(#{x}, #{y})">
    <path d="
      M#{material_thickness} #{material_thickness}
      h#{w/2 - 15 - material_thickness}
      v-#{material_thickness}
      h10
      v#{material_thickness}

      #{screw_slot("h", "v", 1, 1, screw_width, screw_length)}

      v-#{material_thickness}
      h10
      v#{material_thickness}
      h#{w/2 - 15 - material_thickness}

      v#{h/2 - 15 - material_thickness}
      h#{material_thickness}
      v10
      h-#{material_thickness}

      #{screw_slot("v", "h", 1, -1, screw_width, screw_length)}

      h#{material_thickness}
      v10
      h-#{material_thickness}
      v#{h/2 - 15 - material_thickness}

      h-#{w/2 - 15 - material_thickness}
      v#{material_thickness}
      h-10
      v-#{material_thickness}

      #{screw_slot("h", "v", -1, -1, screw_width, screw_length)}

      v#{material_thickness}
      h-10
      v-#{material_thickness}
      h-#{w/2 - 15 - material_thickness}

      v-#{h/2 - 15 - material_thickness}
      h-#{material_thickness}
      v-10
      h#{material_thickness}

      #{screw_slot("v", "h", -1, 1, screw_width, screw_length)}

      h-#{material_thickness}
      v-10
      h#{material_thickness}
      v-#{h/2 - 15 - material_thickness}
    "
    class="cutline" />
  </g>
  EOF
end

w, h, d = ARGV.shift.to_f, ARGV.shift.to_f, ARGV.shift.to_f
screw_length, screw_width = ARGV.shift.to_f, ARGV.shift.to_f
material_thickness = ARGV.shift.to_f
kerf = ARGV.shift.to_f

SPACING = 5

faceplate_width = w + material_thickness * 4
faceplate_height = h + material_thickness * 4

# top side
side_width = w + material_thickness * 2
side_height = d + material_thickness * 3

top_side_origin_x = SPACING + faceplate_width / 2 - side_width / 2
top_side_origin_y = SPACING

# face
faceplate_origin_x = SPACING
faceplate_origin_y = top_side_origin_y + side_height + SPACING

# bottom side
bottom_side_origin_x = top_side_origin_x
bottom_side_origin_y = faceplate_origin_y + faceplate_height + SPACING


# right side
right_side_width = h + material_thickness * 2
right_side_height = d + material_thickness * 3

right_side_origin_x = faceplate_origin_x + faceplate_width + SPACING
right_side_origin_y = faceplate_origin_y + faceplate_height / 2 - right_side_width / 2

# back
back_width = w + material_thickness * 2
back_height = h + material_thickness * 2

back_origin_x = right_side_origin_x + side_height + SPACING
back_origin_y = faceplate_origin_y + faceplate_height / 2 - right_side_width / 2

# left side
left_side_x = back_origin_x + back_width + SPACING
left_side_y = right_side_origin_y

# header

puts <<-EOF

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>svg test</title>
<style>
  .cutline {fill:none; stroke:black; stroke-width: .25}
</style>
<script>
function signalError() {
document.getElementById('body').setAttribute("class", "invalid");
}
</script>
</head>
<body id="body" style="position:absolute; z-index:0; border:1px solid black; left:0%; top:0%; width:100%; height:100%;">
  <svg xmlns="http://www.w3.org/2000/svg" version="1.1"
    viewBox="0 0 #{SPACING * 5 + faceplate_width + 2*right_side_width + back_width} #{SPACING * 4 + 2 * side_height + faceplate_height}" preserveAspectRatio="xMinYMin"
    style="width:100%; height:100%; position:absolute; top:0; left:0; z-index:-1;">
EOF

draw_side(top_side_origin_x, top_side_origin_y, side_width, side_height, material_thickness)
draw_face(faceplate_origin_x, faceplate_origin_y, faceplate_width, faceplate_height, material_thickness)
draw_side(bottom_side_origin_x, bottom_side_origin_y, side_width, side_height, material_thickness, false, true)
draw_side(right_side_origin_x, right_side_origin_y, right_side_width, right_side_height, material_thickness, true, false)
draw_bottom(back_origin_x, back_origin_y, back_width, back_height, material_thickness, screw_width, screw_length)
draw_side(left_side_x, left_side_y, right_side_width, right_side_height, material_thickness, true, true)

puts <<-EOF
  </svg>
</body>
</html>
EOF