original_verbosity = $VERBOSE
$VERBOSE = nil
	BCrypt::Engine::DEFAULT_COST = 4 # one of the biggest performance boosts you'll ever see
$VERBOSE = original_verbosity