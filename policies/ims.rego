package ims

import rego.v1

default allow_user := false

allow_user if {
	some i
	input.user.imsi == data.ims.whitelist[i]
}