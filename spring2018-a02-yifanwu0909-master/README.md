# Assignment # 2
ANLY502 - Massive Data Fundamentals, Spring 2018
<br>Marck Vaisman & Irina Vayndiner
<br>Due Sunday, Feb 25 at 11:59pm


You will be performing Hadoop Streaming exercises in this assignment. 

Start an Amazon Elastic MapReduce (EMR) Cluster using Quickstart with the following setup:

*  Give the cluster a name that is meaningful to you
*  Use Release `emr-5.11.1`
*  Select the first option under Applications
*  Select 1 master and 4 core nodes, using `m4.large` instance types
*  Select your correct EC2 keypair or you will not be able to connect to the cluster
*  Click **Create Cluster**


## Provide the Master Node and Cluster Metadata

Once you are ssh'd into the master node, query the instance metadata just as you did for Assignment A1.

```
curl http://169.254.169.254/latest/dynamic/instance-identity/document/ > instance-metadata.json
```

Also, since you are using a cluster, please provide some metadata files about your cluster. Run the following commands:

```
cat /mnt/var/lib/info/instance.json > master-instance.json
cat /mnt/var/lib/info/extraInstanceData.json > extra-master-instance.json
```

## Problem 1 - The _quazyilx_ scientific instrument (3 points)


For this problem, you will be working again with data from the _quazyilx_ instrument. However, this time you will work with various text files stored on S3 that are in the 1-50 GB range. 

When one of the measurements is not present, the result is displayed as negative 1 (e.g. `-1`). 

The quazyilx has been malfunctioning, and occasionally generates output with a `-1` for all four measurements, like this:

    2015-12-10T08:40:10Z fnard:-1 fnok:-1 cark:-1 gnuck:-1

There are four different versions of the _quazyilx_ file, each of a different size. As you can see in the output below the file sizes are 50MB (1,000,000 rows), 4.8GB (100,000,000 rows), 18GB (369,865,098 rows) and 36.7GB (752,981,134 rows). The only difference is the length of the number of records, the file structure is the same. 

```
[hadoop@ip-172-31-1-240 ~]$ hadoop fs -ls s3://bigdatateaching/quazyilx/
Found 4 items
-rw-rw-rw-   1 hadoop hadoop    52443735 2018-01-25 15:37 s3://bigdatateaching/quazyilx/quazyilx0.txt
-rw-rw-rw-   1 hadoop hadoop  5244417004 2018-01-25 15:37 s3://bigdatateaching/quazyilx/quazyilx1.txt
-rw-rw-rw-   1 hadoop hadoop 19397230888 2018-01-25 15:38 s3://bigdatateaching/quazyilx/quazyilx2.txt
-rw-rw-rw-   1 hadoop hadoop 39489364082 2018-01-25 15:41 s3://bigdatateaching/quazyilx/quazyilx3.txt
```

Your job is to find all of the times where the four instruments malfunctioned together using `grep` with Hadoop Streaming. 

You will run **two** Hadoop Streaming jobs, one for the 4.8GB file, one for the 18GB file.

In this case, our mapper program will be the `grep` tool with its parameters. The way to invoke the Hadoop Streaming Job is:

```
hadoop jar /usr/lib/hadoop/hadoop-streaming.jar \
-D mapreduce.job.reduces=0 \
-D stream.non.zero.exit.is.failure=false \
-input [[input-file]] \
-output [[output-location]] \
-mapper "/bin/grep \"fnard:-1 fnok:-1 cark:-1 gnuck:-1\""
```

**What does all this mean?**

* The first line `hadoop jar /usr/lib/hadoop/hadoop-streaming.jar` is launching Hadoop with the Hadoop Streaming jar. A jar is a Java Archive file, and Hadoop Streaming is a special kind of jar that allows you to run non Java programs.
* The second line `-D mapreduce.job.reduces=0` tells the job that you want zero reduce tasks. **This is a map-only job since all we are doing is filtering and not aggregating.**
* The third line `-D stream.non.zero.exit.is.failure=false` is another parameter for the streaming job which tells Hadoop to not fail on task error. This is necessary in this case because Hadoop is expecting output from every map task, but since we are filtering the data the majority of the map tasks will not have an output. Without this parameter, the job will fail.
* The fourth line `-input [[input-file]]` tells the job where your source file(s) are. These files need to be either in HDFS or S3. If you specify a directory, all files in the directory will be used as inputs
* The fifth line `-output [[output-location]]` tells the job where to store the output of the job, either in HDFS or S3. **This parameter is just a name of a location, and it must not exist before running the job otherwise the job will fail.**
* The sixth line `-mapper "/bin/grep \"fnard:-1 fnok:-1 cark:-1 gnuck:-1\""` is the actual mapper process.

When you finish running the Hadoop Streaming jobs, you will need to extract the results from **HDFS** using `hdfs dfs -cat` and create and commit three files: `p1-1-results.txt`, `p1-2-results.txt`. **These results files must be sorted by date and time.**


## Problem 2 - Log file analysis (7 points)

The file `s3://bigdatateaching/forensicswiki/2012_logs.txt` is a year's worth of Apache logs for the [forensicswiki website](http://forensicswiki.org/wiki/Main_Page). Each line of the log file correspondents to a single `HTTP GET` command sent to the web server. The log file is in the [Combined Log Format](https://httpd.apache.org/docs/1.3/logs.html#combined).

Your goal in this problem is to report the number of hits for each month. Your final job output should look like this:

    2010-01 xxxxxx
    2010-02 yyyyyy
    ...

Where `xxxxxx` and `yyyyyy` are replaced by the actual number of hits in each month.

There are two starter scripts in the repository: `mapper.py` and `reducer.py` which contain mapper and reducer shells. **You need to modify these files to make this work.**

Here are some hints to solve the problem:

* Your mapper should read each line of the input file and output a key/value pair in the form `YYYY-MM\t1` where `YYYY-MM` is the year and the month of the log file, `\t` is the tab character, and `1` is the number one.
* Your reducer should tally up the number of hits for each key and output the results.
* You will need to run the Hadoop Streaming job with the appropriate parameters
* You will need to "ship" the mapper and reducer to each node in the cluster along with the job
* You should not need to use any of the `-D` parameters you used in Problem 1

```
hadoop jar /usr/lib/hadoop/hadoop-streaming.jar \
-files file1, file2 \
...
```

When you finish running the Hadoop Streaming jobs, you will need to extract the results from **HDFS** using `hdfs dfs -cat` with redirections to create and commit `logfile-results.txt`. **This results files must be sorted by date.**

The files to be committed to the repository for this problem are your modified mapper, reducer, and `logfile-results.txt`.


## Submitting the Assignment

Make sure you commit **only the files requested**, and push your repository to GitHub!

The files to be committed to the repository for this assignment are:

* `instance-metadata.json`
* `master-instance.json`
* `extra-master-instance.json`
* `p1-1-results.txt`
* `p1-2-results.txt`
* `mapper.py`
* `reducer.py`
* `logfile-results.txt`


## Grading Rubric

* We will look at the submitted files first. If the result files are exactly what is expected, in the proper format, etc., then you will get full credit for the problem.
* If the files are not what is expected, we will look at code (if applicable) and provide partial credit where possible.
* Points will be deducted for each the following reasons:
	* Instructions are not followed
	* Output is not in expected format
	* There are more files in your repository than need to be 
	* Additional lines in the results files (whether empty or not)



	