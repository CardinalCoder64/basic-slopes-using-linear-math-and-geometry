if counter >= 1 || counter <= 0 rate *= -1;
counter += rate;

var wall_color = merge_color(c_red,c_blue,counter);

with oWall image_blend = wall_color;
with oWall_slope image_blend = wall_color;