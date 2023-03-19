display_set_gui_size(room_width,room_height);

if show_lines {
	show_lines = false;
	var x_intercept = -y_intercept/slope;
	var w_intercept = (slope*room_width)+y_intercept;
	draw_set_color(c_red);
	if slope < 0 {
		draw_line(-1,y_intercept-1,x_intercept-1,-1);
	} else {
		draw_line(x_intercept-1,-1,room_width-1,w_intercept-1);
	}
	//Draw offsets
	var px = oPlayer.x;
	var py = oPlayer.y;
	var xx = (py-y_intercept)/slope;
	var yy = (slope*px)+y_intercept;
	draw_set_color(c_yellow);
	draw_line(px-1,py-1,xx-1,py-1);//x offset
	draw_line(px-1,py-1,px-1,yy-1);//y offset
}

display_set_gui_size(480,270);