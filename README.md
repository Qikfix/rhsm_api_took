# rhsm_api_took

Welcome

This script will help you consume the RHSM via API. You will be able to list the registered machines as well as delete them.

Before we start, some additional steps will be necessary:

# Getting started with RHSM APIs in tech preview

 https://access.redhat.com/articles/3626371

All the information about `How to Configure` the environment is available on this guide.

Note. Please, download the latest version of `took application` or at least the version `1.8.6`.

# Running the Script

Let's download the script
```
# wget https://raw.githubusercontent.com/waldirio/rhsm_api_took/master/rhsm_api.sh
```

Now, let's edit the RHSM username. To do that, open the script and change as below

From
```
RHSM_USERNAME="rhn-support-wpinheir"
```
To
```
RHSM_USERNAME="<your RHSM username and/or account>"
```

Great, now we are good to move forward.


As you can see below, there are some options. `sync_data`, `process_file` and `remove_uuid_list` but BEFORE we need to run the command `"took token -e rhsm-auth <rhsm_username>"` to start the session.
```
$ ./rhsm_api.sh 
## Please call this script passing the parameter
#
# ./rhsm_api.sh sync_data
  or
# ./rhsm_api.sh process_file
  or
# ./rhsm_api.sh remove_uuid_list <path to the file with uuid to be removed>

## ATTENTION: Before you start, type on the console the command "took token -e rhsm-auth <rhsm_username>"
```

Let's do it. The output should be similar to below:
```
$ took token -e rhsm-auth rhn-support-wpinheir
Configuration/Token encryption password: 
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJUbGxUMnpuUVdJQjh6TFBDYnhLWGw0SHZiYmlFa0ZlRnFiUmdORUxFQ1NzIn0.eyJqdGkiOiIwZWQ4YjA4Yi00NWM1LTQ2NDktOTE0Ni1iMGIwYTgwMTQ2NDQiLCJleHAiOjE1NTI2Njc0MzgsIm5iZiI6MCwiaWF0IjoxNTUyNjY3MTM4LCJpc3MiOiJodHRwczovL3Nzby5yZWRoYXQuY29tL2F1dGgvcmVhbG1zLzNzY2FsZSIsImF1ZCI6Ijc2ODIxMjBiIiwic3ViIjoiZjpmZDM4OWM5Mi1mZDk5LTQyN2EtYjQ1ZS1lOTQyZDZmOTExZmU6cmhuLXN1cHBvcnQtd3BpbmhlaXIiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiI3NjgyMTIwYiIsImF1dGhfdGltZSI6MCwic2Vzc2lvbl9zdGF0ZSI6ImZjYjUyNzJiLTBhNDgtNGZjNC1hYTVjLTUwMGY0MWY1ODg4MCIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOltdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiYXV0aGVudGljYXRlZCIsInJlZGhhdDplbXBsb3llZXMiLCJwb3J0YWxfbWFuYWdlX3N1YnNjcmlwdGlvbnMiLCJvZmZsaW5lX2FjY2VzcyIsImFkbWluOm9yZzphbGwiLCJjc2VydmljZSIsInVtYV9hdXRob3JpemF0aW9uIiwicG9ydGFsX21hbmFnZV9jYXNlcyIsInBvcnRhbF9zeXN0ZW1fbWFuYWdlbWVudCIsInBvcnRhbF9kb3dubG9hZCJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sIm5hbWUiOiJXYWxkaXJpbyBQaW5oZWlybyIsInByZWZlcnJlZF91c2VybmFtZSI6InJobi1zdXBwb3J0LXdwaW5oZWlyIiwiZ2l2ZW5fbmFtZSI6IldhbGRpcmlvIiwiZmFtaWx5X25hbWUiOiJQaW5oZWlybyIsImVtYWlsIjoid2FsZGlyaW9AcmVkaGF0LmNvbSJ9.tqyOqk9rgSbCYhVREGnmMWV2RCwgHQAnJ6cKkZUukwEM2UWEd7zcQfognY3IpOWUP9VPzNOGCRc5LNiJJQIQVBsWNeIUj103qTZPMQkIKM-wJUXqtiS7X1UK0HVbTgqY7l1pFJDQXGXACinnbSJM-3lnQhkVWVw6P8Dum7VVDy85bS-VEkCQjwMvfs3cWwgMYuT-aZ-Mo4fLwt4nEEjZbGZCJMdaEYdH2HsgPXvwhPY65wcBX_jeIitW0dDPRFYgCznXVZ2bgOCCzZjmz_LchGTovIKvBQtLmp890oHURJMGxiOGC5boRxXlZMCXMGJZ94IRIm4nj0dsCD8Nj1gPIw
```

At this time we will use the flag `sync_data`. This call will be responsible for downloading all the information about registered Content Hosts on the customer portal. According to the number of registered Content Hosts, this process can take some time to complete.
```
$ ./rhsm_api.sh sync_data
Syncing data from RHSM

First touch ... waiting 2 minutes
#: 0, Status: 1
#: 100, Status: 1
#: 200, Status: 1
#: 300, Status: 1
#: 400, Status: 1
#: 500, Status: 1
#: 600, Status: 1
...
#: 10800, Status: 1
#: 10900, Status: 1
#: 11000, Status: 0
Done
```
Note. The script will finish when `Status == 0`.

After concluding the step above, we have to process the file. To do that, let's move forward to the second flag `process_file`.
```
$ ./rhsm_api.sh process_file
Processing Files
There are 10993 UUID on the list
Please check the file /tmp/rhsm_report.log
```

Awesome, at this time, we can check the list on the `/tmp/rhsm_report.log` file.
```
$ cat /tmp/rhsm_report.log
fqdn,uuid,type,lastcheckin,epoch_lastcheckin
vm255-224.gsslab.pnq2.redhat.com,3a88fe8c-c631-4ef1-b70a-b0fe0dd3baa6,Virtual,2019-03-15T16:54:17.000Z,1552668857
vm254-19.gsslab.pnq2.redhat.com,e0ef7a03-e6d2-4fc2-a1d6-9daee06cee5e,Virtual,2019-03-15T16:54:15.000Z,1552668855
vm254-17.gsslab.pnq2.redhat.com,86e38086-5c47-4d6f-9fec-7c75f141b742,Virtual,2019-03-15T16:53:56.000Z,1552668836
...
localhost.localdomain,6d45a9da-222f-4c25-b919-8f13e2397a96,Virtual,,
base,03e15f8f-511e-401c-aea5-a03fcb9011df,Physical,,
```
Note. The list is sorted by lastcheckin. The first lines represents Content Host updated most recently and last lines representes the Content Hosts updated least recently or those without a lastcheckin value.

In our example, I would like to remove all machines without `lastcheckin`. To do that, let's create a new file `/tmp/remove_uuid` with the content as below:
```
localhost.localdomain,6d45a9da-222f-4c25-b919-8f13e2397a96,Virtual,,
base,03e15f8f-511e-401c-aea5-a03fcb9011df,Physical,,
```

Now, let's call the script passing the 3rd flag `remove_uuid_list`.
```
$ ./rhsm_api.sh remove_uuid_list /tmp/remove_uuid 
Removing UUID related to the file /tmp/remove_uuid
There are 2 on the list to be removed

Are you sure you would like to remove all of them? (y/n):
y
Removing ...
Removing uuid: 6d45a9da-222f-4c25-b919-8f13e2397a96

Removing uuid: 03e15f8f-511e-401c-aea5-a03fcb9011df
```

# Thanks
Hope this script help you to handle all the Content Hosts on the Customer Portal. Leave your feedback <waldirio@redhat.com>, we will be glad to help.

Special thanks to shane "Shane McDowell",  peasters "Patrick Easters" and phess "Pablo Hess"