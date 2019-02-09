# Assignment # 1
ANLY502 - Massive Data Fundamentals, Spring 2018
<br>Marck Vaisman & Irina Vayndiner
<br>Due Sunday, Feb 11 at 11:59pm


## Instructions

1. [Read this Tutorial from start to finish](Tutorial.md). The tutorial will show you how to:
	* Create the security group
	* Start a Linux EC2 instance with ami-428aa838
	* SSH into your instance using ssh-agent
	* Clone your assignment repository
* Do the work outlined in the following tasks **on your EC2 instance**

## Task 1 - Create a text file called

1. Using your preferred text editor, create a text file called `my-text-file.txt` with the following contents, replacing `______` with your name.

	```
	Hi,
	
	I am ______ and I just created a text file on a Linux server running in the cloud!
	```

## Task 2 - Query the instance's metadata

When you are logged on to an AWS machine, it has a special API that allows you to see the instance's metadata. 

1. Run the following command to see the instance's metadata:

   `curl http://169.254.169.254/latest/dynamic/instance-identity/document/; echo`

2. Now we want to create a text file called `instance-metadata.json` from the output of the previous command. We'll be using the `>` redirect operator, which takes the output and redirects it to a file. We will be using these operators throughout the course, so we recommend you take a look at this website: [Introduction to Linux I/O Redirection](https://www.digitalocean.com/community/tutorials/an-introduction-to-linux-i-o-redirection).

	```
	curl http://169.254.169.254/latest/dynamic/instance-identity/document/ > instance-metadata.json
	```

## Task 3 - Download a file using `wget` and use `grep` to find certain lines

For this task, you will be working with a text file that you download using the command line. The file contains hypothetic measurements of a scientific instrument called a _quazyilx_ that has been specially created for this class. Every few seconds the quazyilx makes four measurements: _fnard_, _fnok_, _cark_ and _gnuck_. The output looks like this:

    YYYY-MM-DDTHH:MM:SSZ fnard:10 fnok:4 cark:2 gnuck:9

(This time format is called [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601) and it has the advantage that it is both unambiguous and that it sorts properly. The Z stands for _Greenwich Mean Time_ or GMT, and is sometimes called _Zulu Time_ because the [NATO Phonetic Alphabet](https://en.wikipedia.org/wiki/NATO_phonetic_alphabet) word for **Z** is _Zulu_.)

When one of the measurements is not present, the result is displayed as negative 1 (e.g. `-1`). 

The quazyilx has been malfunctioning, and occasionally generates output with a `-1` for all four measurements, like this:

    2015-12-10T08:40:10Z fnard:-1 fnok:-1 cark:-1 gnuck:-1

1. Download the _quazyilx_ file

	```
	wget s3.amazonaws.com/bigdatateaching/quazyilx/quazyilx0.txt
	```
1.	We will be using the `grep` command to find the lines where the _quazyilx_ failed

	```
	grep "fnard:-1 fnok:-1 cark:-1 gnuck:-1" quazyilx0.txt
	```
	
1. Using the redirect command that you learned about in Task 2, combine grep and redirect to create a new file called `quazyilx-failures.txt` 


## Submitting the Assignment

After you run these tasks, make sure you commit **only the files requested**, and push your repository to GitHub!

The files to be committed to the repository are:

* `my-text-file.txt`
* `instance-metadata.json`
* `quazyilx-failures.txt` 

### Grading Rubric

* We will look at the submitted files first. If the files are exactly what is expected, in the proper format, etc., then you will get full credit for the problem.
* If the files are not what is expected, we will look at code (if applicable) and provide partial credit where possible.
* Points will be deducted for each the following reasons:
	* Instructions are not followed
	* Output is not in expected format
	* There are more files in your repository than need to be 
	* Additional lines in the results files (wether empty or not)


