package internet

import rego.v1

default allow_user := false

allow_user if {
	input.user.credits > data.internet.min_credits
}