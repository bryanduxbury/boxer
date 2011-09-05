require "rubygems"
require "ruby-debug"

def compute_anchor_dims(d)
  num_anchors = (d / 100.0).floor - 1
  dist_between_anchors = d / (num_anchors + 1)
  [num_anchors, dist_between_anchors]
end

def line_of_anchors_x(x_off, y, w, material_thickness)
  num_anchors, dist_between_anchors = compute_anchor_dims(w)

  anchors = ""
  0.upto(num_anchors) do |n|
    anchors << "<rect class='cutline' x='#{x_off+dist_between_anchors/2-5}' y='#{y}' height='#{material_thickness}' width='10' />"
    x_off += dist_between_anchors
  end
  anchors
end

def line_of_anchors_y(y_off, x, h, material_thickness)
  num_anchors, dist_between_anchors = compute_anchor_dims(h)

  anchors = ""
  0.upto(num_anchors) do |n|
    anchors << "<rect class='cutline' y='#{y_off+dist_between_anchors/2-5}' x='#{x}' width='#{material_thickness}' height='10' />"
    y_off += dist_between_anchors
  end
  anchors
end

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
    #{line_of_anchors_x(material_thickness, material_thickness, w - 2*material_thickness, material_thickness)}
    #{line_of_anchors_x(material_thickness, h-2*material_thickness, w - 2*material_thickness, material_thickness)}
    #{line_of_anchors_y(material_thickness, w-2*material_thickness, h - 2*material_thickness, material_thickness)}
    #{line_of_anchors_y(material_thickness, material_thickness, h - 2*material_thickness, material_thickness)}

  </g>
  EOF
end

def draw_side(x, y, w, h, material_thickness, rotate = false, flip = false, screw_width = 3.0, incut=true)
  num_anchors, dist_between_anchors = compute_anchor_dims(w)

  anchors = ""
  0.upto(num_anchors) do |n|
    anchors << "h#{dist_between_anchors/2-5 - (n==0 && !incut ? material_thickness : 0)}v#{material_thickness}h10v-#{material_thickness}"
    anchors << "h#{dist_between_anchors/2-5 - (n==num_anchors && !incut ? material_thickness : 0)}"
  end

  adjusted_height = h-material_thickness

  lside = "v#{adjusted_height}"
  rside = "v-#{adjusted_height}"
  if incut
    lside = "v#{adjusted_height / 2 - 5}h#{material_thickness}v10h-#{material_thickness}v#{adjusted_height/2-5}"
    rside = "v-#{adjusted_height / 2 - 5}h-#{material_thickness}v-10h#{material_thickness}v-#{adjusted_height/2-5}"
  else
    lside = "M#{material_thickness} 0v#{adjusted_height / 2 - 5}h-#{material_thickness}v10h#{material_thickness}v#{adjusted_height / 2 - 5}"
    rside = "v-#{adjusted_height / 2 - 5}h#{material_thickness}v-10h-#{material_thickness}v-#{adjusted_height / 2 - 5}"
  end

  puts <<-EOF
  <g transform='translate(#{x} #{y}) #{rotate ? "translate(#{h}, 0) rotate(90)" : "" } rotate(#{flip ? 180 : 0}, #{w/2}, #{h/2})'>
    <path d='
      M0 0
      #{lside}
      #{anchors}
      #{rside}
      h-#{incut ? w : w - 2 * material_thickness}'
      class="cutline"
    />
    <rect class="cutline" x="#{w/2 - 5 - 10}" y="#{material_thickness}" width="10" height="#{material_thickness}" />
    <rect class="cutline" x="#{w/2 + 5}" y="#{material_thickness}" width="10" height="#{material_thickness}" />
    <circle class="cutline" cx="#{w/2}" cy="#{material_thickness + screw_width/2}" r="#{screw_width / 2}" />
  </g>
  EOF
end

def draw_bottom_edge(x, y, w, r, material_thickness, screw_width, screw_length)
  num_anchors, dist = compute_anchor_dims(w)
  p = ""
  0.upto(num_anchors) do |n|
    p << "h#{dist/2 - 15 - (n==0 ? material_thickness : 0)}"
    p << "v-#{material_thickness}"
    p << "h10"
    p << "v#{material_thickness}"

    p << "h#{5-screw_width/2}"
    p << "v#{(screw_length / 2 - screw_width / 2)}"
    p << "h-#{screw_width / 2}"
    p << "v#{screw_width}"
    p << "h#{screw_width / 2}"
    p << "v#{(screw_length / 2 - screw_width / 2)}"
    p << "h#{screw_width}"
    p << "v-#{ (screw_length / 2 - screw_width / 2)}"
    p << "h#{screw_width / 2}"
    p << "v-#{ screw_width}"
    p << "h-#{screw_width / 2}"
    p << "v-#{ (screw_length / 2 - screw_width / 2)}"
    p << "h#{(5 - screw_width / 2)}"

    p << "v-#{material_thickness}"
    p << "h10"
    p << "v#{material_thickness}"
    p << "h#{dist/2 - 15 - (n==num_anchors ? material_thickness : 0)}"
  end

  <<-EOF
  <path transform="translate(#{x}, #{y}) rotate(#{r})"
    d="
      M#{material_thickness} #{material_thickness}
      #{p}
    "
    class="cutline"
  />
  EOF
end

def draw_bottom(x, y, w, h, material_thickness, screw_width, screw_length)
  num_anchors_x, distance_x = compute_anchor_dims(w)
  num_anchors_y, distance_y = compute_anchor_dims(h)

  puts <<-EOF
  <g transform="translate(#{x}, #{y})">
    #{draw_bottom_edge(0, 0, w, 0, material_thickness, screw_width, screw_length)}
    #{draw_bottom_edge(w, 0, h, 90, material_thickness, screw_width, screw_length)}
    #{draw_bottom_edge(w, h, w, 180, material_thickness, screw_width, screw_length)}
    #{draw_bottom_edge(0, h, h, 270, material_thickness, screw_width, screw_length)}
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


draw_side(top_side_origin_x, top_side_origin_y, side_width, side_height, material_thickness, false, false)
draw_face(faceplate_origin_x, faceplate_origin_y, faceplate_width, faceplate_height, material_thickness)
draw_side(bottom_side_origin_x, bottom_side_origin_y, side_width, side_height, material_thickness, false, true)
draw_side(right_side_origin_x, right_side_origin_y, right_side_width, right_side_height, material_thickness, true, false, screw_width, false)
draw_bottom(back_origin_x, back_origin_y, back_width, back_height, material_thickness, screw_width, screw_length)
draw_side(left_side_x, left_side_y, right_side_width, right_side_height, material_thickness, true, true, screw_width, false)

puts <<-EOF
  </svg>
</body>
</html>
EOF