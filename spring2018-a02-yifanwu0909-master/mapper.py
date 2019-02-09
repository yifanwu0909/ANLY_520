#!/usr/bin/env python
#
# This file has been provided as a starting point. You need to modify this file.
# Reads whole lines stdin; writes key/value pairs to stdout
# --- DO NOT MODIFY ANYTHING ABOVE THIS LINE ---




import sys

if __name__ == "__main__":
        months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
	for line in sys.stdin:
		for word in line.split():
                        if word[0] == "[" and  word[3:4] == "/" and word[-3] == ":" :
                            month_num = months.index(word[4:7]) + 1
			    sys.stdout.write("{}\t1\n".format(word[8:12]+"-"+"{0:0=2d}".format(month_num)))
   
