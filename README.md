# Oracle 11g to import dumps

Hay que tener en cuenta que es un fork personalizado adaptado a ciertas necesidades.

##Cambios Realizados:

1. La dirección del host, se ha cambiado directamente a **localhost**, por lo cual **se asume que todo lo que se haga, tiene que hacerse desde la propia máquina Linux, y no con instalaciones de boot2docker**

2. Se han parametrizados el mapeo de los puertos externos. Ahora se encuentran como variables en el fichero MakeFile

3. Se ha creado la varibale **CONTAINER_NAME** en el fichero *Makefile*, para crear un contenedor con ese nombre.

4. Se ha cambiado el comando **impdp** del files/setup.sh por el comando **imp** para la importación .

5. El fichero ahora debe llamarse **dump.dmp**. Se ha cambiado el nombre para generalizarlo.

6. Ahora la imagen de la que se hereda es **wnameless/oracle-xe-11g:latest** en vez de **alexeiled/docker-oracle-xe-11g:latest**

##Actuaciones antes de ejecutar el proceso original:

1. En el fichero **/files/setup.sh** se debe cambiar el primer cat, con el script *SQL* de creación de usuarios, tablespaces, etc...

2. En el fichero **/files/setup.sh** se debe cambiar el **TABLESPACE_ORIGEN** y el **TABLESPACE_DESTINO** a los que se necesite usar

3. En el fichero **/files/setup.sh** se debe cambiar el **ESQUEMA_ORIGEN** y el **ESQUEMA_DESTINO** a los que se necesite usar

4. Cambiar la variable **CONTAINER_NAME** del archivo *Makefile* a un nombre representativo de lo que se quiere desplegar en la base de datos.

---

##Proceso original:

This simple docker image makes it easy to import an Oracle dump you got from someone else.

It extends the alexeiled/docker-oracle-xe-11g:latest image by adding a couple of script to make this process a bit easier.

1. The first step is to clone this repository:

> git clone https://github.com/Digibis/img-oracle-11g-import.git

2. Now, build the Docker image:

> make build

3. Copy the dump file to '''./tmp/dump.dmp'''

4. Start the container:

> make start

5. SSH into it (note that if you get a connection refused, wait for a few seconds and try again. El contenedor con oracle tarda un poco en levantarse del todo):

> make ssh

6. Run the setup script that will create the tablespace and the frevvo user with the correct privileges

>
> root@b83ce9769354:~# sqlplus
>
> SQL*Plus: Release 11.2.0.2.0 Production on Wed May 13 18:41:36 2015
>
> Copyright (c) 1982, 2011, Oracle.  All rights reserved.
>
> Enter user-name: system
>
> Enter password:
>
> ERROR:
>
> ORA-28002: the password will expire within 6 days
>
>
>
> Connected to:
>
> Oracle Database 11g Express Edition Release 11.2.0.2.0 - 64bit Production
>
> SQL> @/setup.sql
>
> SQL> exit
>
> root@b83ce9769354:~#
>

7. Now, import the dump

> root@b83ce9769354:~# /import.sh
>
> Import: Release 11.2.0.2.0 - Production on Wed May 13 18:09:56 2015
>
> Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.
>
> UDI-28002: operation generated ORACLE error 28002
>
> ORA-28002: the password will expire within 6 days
>
> Connected to: Oracle Database 11g Express Edition Release 11.2.0.2.0 - 64bit Production
>
> Master table "SYSTEM"."SYS_IMPORT_FULL_01" successfully loaded/unloaded
>
> Starting "SYSTEM"."SYS_IMPORT_FULL_01":  system/******** directory=DUMP_DIR dumpfile=dump.dmp full=y
>
> Processing object type TABLE_EXPORT/TABLE/TABLE
>
> Processing object type TABLE_EXPORT/TABLE/TABLE_DATA
>
> . . imported "FREVVO"."RESOURCES"                        64.57 MB     803 rows
>
> Processing object type TABLE_EXPORT/TABLE/INDEX/INDEX
>
> Processing object type TABLE_EXPORT/TABLE/CONSTRAINT/CONSTRAINT
>
> Processing object type TABLE_EXPORT/TABLE/INDEX/STATISTICS/INDEX_STATISTICS
>
> Processing object type TABLE_EXPORT/TABLE/TRIGGER
>
> Processing object type TABLE_EXPORT/TABLE/STATISTICS/TABLE_STATISTICS
>
> Job "SYSTEM"."SYS_IMPORT_FULL_01" successfully completed at 18:10:31
>
> root@b83ce9769354:~#

