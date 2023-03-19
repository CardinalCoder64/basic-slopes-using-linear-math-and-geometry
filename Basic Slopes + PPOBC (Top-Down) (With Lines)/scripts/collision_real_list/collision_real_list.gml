///@arg x_offset
///@arg y_offset
///@arg obj
///@arg list

/*
	- Checks for a collision with given object without the 
	added tolerance value applied to GM's "instance_place_list"
	- Returns number of objects being collided with and adds 
	the id of each object to the given ds_list
	- DO NOT PUT X OR Y FOR X_OFFSET OR Y_OFFSET!
*/

function collision_real_list(argument0,argument1,argument2,argument3) {
	var x_offset = argument0;
	var y_offset = argument1;
	var obj = argument2;
	var list = argument3;
	var obj_count = 0;
	
	for(var i=0;i<instance_number(obj);i++) {
		var obj_id = instance_find(obj,i);
		
		if bbox_top + y_offset < obj_id.bbox_bottom 
		&& bbox_left + x_offset < obj_id.bbox_right 
		&& bbox_bottom + y_offset > obj_id.bbox_top 
		&& bbox_right + x_offset > obj_id.bbox_left {
			ds_list_add(list,obj_id);
			obj_count++;
		}
	}
	
	return obj_count;
}