# Oracle 11g to import dumps

This simple docker image makes it easy to import an Oracle dump you got from someone else.

It extends the alexeiled/docker-oracle-xe-11g:latest image by adding a couple of script to make this process a bit easier.

Note that the Makefile assumes that you have an up-to-date *docker* and *boot2docker* installation (e.g. 1.6+)

1. The first step is to clone this repository:

> git clone git@github.com:frevvo/img-oracle-11g-import.git

2. Now, build the Docker image:

> make build

3. Copy the dump file to '''./tmp/frevvo.dmp'''

4. Start the container:

> make start

5. SSH into it (note that if you get a connection refused, wait for a few seconds and try again):

> make ssh

6. Run the setup script that will create the tablespace and the frevvo user with the correct privileges

> root@b83ce9769354:~# sqlplus
>
> SQL*Plus: Release 11.2.0.2.0 Production on Wed May 13 18:41:36 2015
>
> Copyright (c) 1982, 2011, Oracle.  All rights reserved.
>
> Enter user-name: system
> Enter password:
> ERROR:
> ORA-28002: the password will expire within 6 days
>
>
>
> Connected to:
> Oracle Database 11g Express Edition Release 11.2.0.2.0 - 64bit Production
>
> SQL> @/setup.sql
> SQL> exit
> root@b83ce9769354:~#

7. Now, import the dump

> root@b83ce9769354:~# /import.sh
>
> Import: Release 11.2.0.2.0 - Production on Wed May 13 18:09:56 2015
>
> Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.
>
> UDI-28002: operation generated ORACLE error 28002
> ORA-28002: the password will expire within 6 days
>
> Connected to: Oracle Database 11g Express Edition Release 11.2.0.2.0 - 64bit Production
> Master table "SYSTEM"."SYS_IMPORT_FULL_01" successfully loaded/unloaded
> Starting "SYSTEM"."SYS_IMPORT_FULL_01":  system/******** directory=DUMP_DIR dumpfile=frevvo.dmp full=y
> Processing object type TABLE_EXPORT/TABLE/TABLE
> Processing object type TABLE_EXPORT/TABLE/TABLE_DATA
> . . imported "FREVVO"."RESOURCES"                        64.57 MB     803 rows
> Processing object type TABLE_EXPORT/TABLE/INDEX/INDEX
> Processing object type TABLE_EXPORT/TABLE/CONSTRAINT/CONSTRAINT
> Processing object type TABLE_EXPORT/TABLE/INDEX/STATISTICS/INDEX_STATISTICS
> Processing object type TABLE_EXPORT/TABLE/TRIGGER
> Processing object type TABLE_EXPORT/TABLE/STATISTICS/TABLE_STATISTICS
> Job "SYSTEM"."SYS_IMPORT_FULL_01" successfully completed at 18:10:31
>
> root@b83ce9769354:~#


