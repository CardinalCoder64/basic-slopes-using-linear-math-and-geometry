//Set points
if image_xscale > 0 {
	x1 = bbox_left;
	x2 = bbox_right;
} else {
	x1 = bbox_right;
	x2 = bbox_left;
}
if image_yscale > 0 {
	y1 = bbox_bottom;
	y2 = bbox_top;
} else {
	y1 = bbox_top;
	y2 = bbox_bottom;
}

rise = y2-y1;
run = x2-x1;
slope = rise/run;//Calculate slope
y_intercept = y1-(slope*x1);//Calculate y-intercept
slope_angle = point_direction(x1,y1,x2,y2);//Get slope angle

var neighbor_list = ds_list_create();
var neighbor_num = collision_rectangle_list(bbox_left-1,bbox_top-1,bbox_right+1,bbox_bottom+1,oWall_slope,false,true,neighbor_list,true);
if neighbor_num > 0 {
	connected = true;
} else {
	connected = false;
}
ds_list_destroy(neighbor_list);