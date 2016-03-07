cat <<-END > /setup.sql
CREATE OR REPLACE DIRECTORY DUMP_DIR AS '${DUMP_DIR}';
SELECT directory_name, directory_path FROM dba_directories WHERE directory_name = 'DUMP_DIR';
--Aqui puede ir cualquier script para crear usuarios, tablespaces, etc...
END

cat <<-END > /import.sh
#Se deben cambiar los esquemas de origen y destino por los necesarios, al igual que los tablespaces
  impdp system/oracle full=Y directory=DUMP_DIR DUMPFILE=${DUMP_FILE} REMAP_TABLESPACE=TABLESPACE_ORIGEN:TABLESPACE_DESTINO REMAP_SCHEMA=ESQUEMA_ORIGEN:ESQUEMA_DESTINO log=import.log
END
chmod +x /import.sh
