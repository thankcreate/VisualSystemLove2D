
-- Linear interpolation

function lerp(t, from, to)

	return (from * (1 - t)) + (to * t)

end