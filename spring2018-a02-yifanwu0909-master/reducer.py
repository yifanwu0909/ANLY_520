#!/usr/bin/env python
#
# This file has been provided as a starting point. You need to modify this file.
# Reads key/value pairs from stdin, writes results to stdout
# --- DO NOT MODIFY ANYTHING ABOVE THIS LINE ---

import sys

if __name__ == '__main__':
	curkey = None
	total = 0
	for line in sys.stdin:
		key, val = line.split("\t")
		val = int(val)

		if key == curkey:
			total += val
		else:
			if curkey is not None:
				sys.stdout.write("{}\t{}\n".format(curkey, total))

			curkey = key
			total = val

	sys.stdout.write("{}\t{}\n".format(curkey, total))

