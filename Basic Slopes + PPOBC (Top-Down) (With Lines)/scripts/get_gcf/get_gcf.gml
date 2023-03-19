///@arg a
///@arg b
function get_gcf(argument0,argument1) {
	var a = abs(argument0);
	var b = abs(argument1);
	var new_a, new_b;
	
	while a != b && a != 0 && b != 0 {
		new_a = a mod b;
		new_b = b mod a;
		a = new_a;
		b = new_b;
	}
	
	return max(a,b);
}