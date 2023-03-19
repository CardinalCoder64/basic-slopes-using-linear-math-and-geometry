function scr_collision() {
	mask_index = sprite_index;//Change this to match the collision mask of your sprite
	sprite_bbox_top = (sprite_get_bbox_top(mask_index)-sprite_get_yoffset(mask_index))*image_yscale;
	sprite_bbox_bottom = (sprite_get_bbox_bottom(mask_index)-sprite_get_yoffset(mask_index)+1)*image_yscale;
	sprite_bbox_left = (sprite_get_bbox_left(mask_index)-sprite_get_xoffset(mask_index))*image_xscale;
	sprite_bbox_right = (sprite_get_bbox_right(mask_index)-sprite_get_xoffset(mask_index)+1)*image_xscale;
	
	//Snap coordinates
	snap_x = 0;
	snap_y = 0;
	
	#region//Collisions (slopes)
	var slope_list = ds_list_create();
	var slope_num = collision_real_list(0,0,oWall_slope,slope_list);
	if slope_num > 0 {
		var on_slope;
		for(var i=0;i<slope_num;i++) {
			on_slope[i] = false;
			var slope_id = slope_list[| i];
			with slope_id {
				//Set collision line
				if collision_line(x1,y1,x2,y2,other,false,true) != noone {
					on_slope[i] = true;
				}
			}
			if on_slope[i] snap_to_slope(slope_id);
		}
		
		#region//Two slopes
		if slope_num > 1 {
			var slope_1 = slope_list[| 0];
			var slope_2 = slope_list[| 1];
			var m1 = slope_1.slope;
			var m2 = slope_2.slope;
			var b1 = slope_1.y_intercept;
			var b2 = slope_2.y_intercept;
			
			//If on both slopes
			if on_slope[0] && on_slope[1] {
				var snap = true;
				
				//Get the point of intersection
				var xi = (b2-b1)/(m1-m2);
				var yi = ((m2*b1)-(m1*b2))/(m2-m1);
				
				if sign(m1) != sign(m2) {//Different slopes
					//If triangles share the same base
					if sign(slope_1.image_yscale) == sign(slope_2.image_yscale) {
						//Applicable side length of calling instance
						var sw = (2*sprite_bbox_right)*sign(m1-m2)*sign(slope_1.image_yscale);
					
						//Get the point of contact
						var xc = ((m2*sw)+b2-b1)/(m1-m2);
						var yc = (m1*xc)+b1;
						
						//Detachment
						if slope_1.image_yscale > 0 {//Normal
							if vspd < 0 snap = false;
						} else {//Inverted
							if vspd > 0 snap = false;
						}
						
						//Snap between slopes
						if snap && vspd != 0 {
							var x_offset = xc+(sw/2)-xi;
							snap_x = xi+x_offset;
							vspd = 0;
						}
					}
				
					//If triangles share the same perpendicular
					if sign(slope_1.image_xscale) == sign(slope_2.image_xscale) {
						//Applicable side length of calling instance
						var sh = (2*sprite_bbox_bottom)*sign(m1-m2)*sign(slope_1.image_xscale);
					
						//Get the point of contact
						var yc = ((m2*b1)+(m1*(sh-b2)))/(m2-m1);
						var xc = (yc-b1)/m1;
						
						//Detachment
						if slope_1.image_xscale > 0 {//Normal
							if hspd < 0 snap = false;
						} else {//Inverted
							if hspd > 0 snap = false;
						}
						
						//Snap between slopes
						if snap && hspd != 0 {
							var y_offset = yc+(sh/2)-yi;
							snap_y = yi+y_offset;
							hspd = 0;
						}
					}
				}
			}
		}
		#endregion
	}
	ds_list_destroy(slope_list);
	
	//Sidewall collisions
	#region//Horizontal
	var slope_x = collision_real_id(hspd,0,oWall_slope);
	if slope_x != noone {
		var slope_xscale = slope_x.image_xscale;
		
		//Side walls
		if (x > slope_x.x2 && slope_xscale > 0) 
		|| (x < slope_x.x2 && slope_xscale < 0) {
			wall_collision(oWall_slope);
		}
		
		//Corners
		if !slope_x.connected {
			if (x < slope_x.x1 && slope_xscale > 0) 
			|| (x > slope_x.x1 && slope_xscale < 0) {
				if slope_x.image_yscale > 0 {
					if bbox_bottom > slope_x.y1 wall_collision(oWall_slope);
				} else {
					if bbox_top < slope_x.y1 wall_collision(oWall_slope);
				}
			}
		}
	}
	#endregion
	#region//Vertical
	var slope_y = collision_real_id(0,vspd,oWall_slope);
	if slope_y != noone {
		var slope_yscale = slope_y.image_yscale;
		
		//Side walls
		if (y > slope_y.y1 && slope_yscale > 0) 
		|| (y < slope_y.y1 && slope_yscale < 0) {
			wall_collision(oWall_slope);
		}
		
		//Corners
		if !slope_y.connected {
			if (y < slope_y.y2 && slope_yscale > 0) 
			|| (y > slope_y.y2 && slope_yscale < 0) {
				if slope_y.image_xscale > 0 {//Normal
					if bbox_right > slope_y.x2 wall_collision(oWall_slope);
				} else {//Inverted
					if bbox_left < slope_y.x2 wall_collision(oWall_slope);
				}
			}
		}
	}
	#endregion
	#endregion
	
	//Collisions (no slopes)
	wall_collision(oWall);
	
	x += hspd;
	y += vspd;
	if snap_x != 0 x = snap_x;
	if snap_y != 0 y = snap_y;
}

function wall_collision(wall_obj) {//Basic collision script (no slopes)
	#region//Horizontal
	var wall_x = collision_real_id(hspd,0,wall_obj);
	if wall_x != noone {
		var wall_left = wall_x.bbox_left;
		var wall_right = wall_x.bbox_right;
		if x < wall_left {//right
			snap_x = wall_left-sprite_bbox_right;
		} else if x > wall_right {//left
			snap_x = wall_right-sprite_bbox_left;
		}
		hspd = 0;
	}
	#endregion
	#region//Vertical
	var wall_y = collision_real_id(0,vspd,wall_obj);
	if wall_y != noone {
		var wall_top = wall_y.bbox_top;
		var wall_bottom = wall_y.bbox_bottom;
		if y < wall_top {//down
			snap_y = wall_top-sprite_bbox_bottom;
		} else if y > wall_bottom {//up
			snap_y = wall_bottom-sprite_bbox_top;
		}
		vspd = 0;
	}
	#endregion
}

function snap_to_slope(slope_obj) {//Slope snap function
	var snap = true;
	var anchor_h, anchor_v;
	var m = slope_obj.slope;
	var b = slope_obj.y_intercept;
	var _rise = slope_obj.rise;
	var _run = slope_obj.run;
	var gcf = get_gcf(_rise,_run);//Greatest Common Factor
	var angle_1 = slope_obj.slope_angle;//Slope angle
	var angle_2 = 180-(90+angle_1);//Adjacent angle
	
	#region//Horizontal Anchor + Wall Collisions + Detachment
	if slope_obj.image_xscale > 0 {//Normal
		anchor_h = sprite_bbox_right;
		if hspd > 0 {
			if collision_real(0,-sign(slope_obj.image_yscale)/100,oWall) {
				hspd = 0;
				snap = false;
			}
		} else if hspd < 0 && (abs(m) > 1 || vspd == 0) {
			snap = false;
		}
	} else {//Inverted
		anchor_h = sprite_bbox_left;
		if hspd < 0 {
			if collision_real(0,-sign(slope_obj.image_yscale)/100,oWall) {
				hspd = 0;
				snap = false;
			}
		} else if hspd > 0 && (abs(m) > 1 || vspd == 0) {
			snap = false;
		}
	}
	#endregion
	#region//Vertical Anchor + Wall Collisions + Detachment
	if slope_obj.image_yscale > 0 {//Normal
		anchor_v = sprite_bbox_bottom;
		if vspd > 0 {
			if collision_real(-sign(slope_obj.image_xscale)/100,0,oWall) {
				vspd = 0;
				snap = false;
			}
		} else if vspd < 0 && (abs(m) < 1 || hspd == 0) {
			snap = false;
		}
	} else {//Inverted
		anchor_v = sprite_bbox_top;
		if vspd < 0 {
			if collision_real(-sign(slope_obj.image_xscale)/100,0,oWall) {
				vspd = 0;
				snap = false;
			}
		} else if vspd > 0 && (abs(m) < 1 || hspd == 0) {
			snap = false;
		}
	}
	#endregion
	
	//Snap to slope
	if snap {
		if hspd != 0 {
			var slope_snap_y = (m*x)+b;
			var y_offset = anchor_v+(anchor_h*dtan(angle_1));
			snap_y = slope_snap_y-y_offset;
			hspd /= abs(_rise/gcf);//Speed correction
			vspd = 0;
		}
		if vspd != 0 {
			var slope_snap_x = (y-b)/m;
			var x_offset = anchor_h+(anchor_v*dtan(angle_2));
			snap_x = slope_snap_x-x_offset;
			vspd /= abs(_run/gcf);//Speed correction
			hspd = 0;
		}
	}
}