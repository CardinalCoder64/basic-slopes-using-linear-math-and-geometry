display_set_gui_size(room_width,room_height);

//Draw points of contact (x)
if show_points_x {
	show_points_x = false;
	
	draw_set_color(c_white);
	draw_point(xc-1,yc-1);
	draw_point(xc+sw-1,yc-1);
	
	draw_set_color(c_lime);
	draw_circle(xc-1,yc-1,1,true);
	draw_circle(xc+sw-1,yc-1,1,true);
}

//Draw points of contact (y)
if show_points_y {
	show_points_y = false;
	
	draw_set_color(c_white);
	draw_point(xc-1,yc-1);
	draw_point(xc-1,yc+sh-1);
	
	draw_set_color(c_lime);
	draw_circle(xc-1,yc-1,1,true);
	draw_circle(xc-1,yc+sh-1,1,true);
}

display_set_gui_size(480,270);

//Draw player variables
draw_set_font(fDefault);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
var spacing = 12;
draw_text(4,4,"x = "+string(x));
draw_text(4,4+spacing,"y = "+string(y));
draw_text(4,4+spacing*2,"hspd = "+string(hspd));
draw_text(4,4+spacing*3,"vspd = "+string(vspd));
draw_text(4,4+spacing*4,"x_scale = "+string(image_xscale));
draw_text(4,4+spacing*5,"y_scale = "+string(image_yscale));