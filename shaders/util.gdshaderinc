vec2 snap_vec2(vec2 size, vec2 offset, vec2 vector) {
	vec2 result = vec2(
		round(vector.x*size.x)/size.x,
		round(vector.y*size.y)/size.y
	);
	
	return result;
}