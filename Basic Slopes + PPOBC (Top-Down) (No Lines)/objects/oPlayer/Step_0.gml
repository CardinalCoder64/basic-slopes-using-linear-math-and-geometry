//Controls
var xmove = keyboard_check(vk_right)-keyboard_check(vk_left);
var ymove = keyboard_check(vk_down)-keyboard_check(vk_up);
var xscale = keyboard_check(ord("D"))-keyboard_check(ord("A"));
var yscale = keyboard_check(ord("W"))-keyboard_check(ord("S"));

//Movement
hspd = xmove*mspd;
vspd = ymove*mspd;

//Scaling
if xscale != 0 image_xscale += xscale*scale_add;
if yscale != 0 image_yscale += yscale*scale_add;
image_xscale = clamp(image_xscale,1,3);
image_yscale = clamp(image_yscale,1,3);

//Collisions
scr_collision();