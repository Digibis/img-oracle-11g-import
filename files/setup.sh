cat <<-END > /setup.sql
  CREATE OR REPLACE DIRECTORY DUMP_DIR AS '${DUMP_DIR}';
  SELECT directory_name, directory_path FROM dba_directories WHERE directory_name = 'DUMP_DIR';
  CREATE TABLESPACE frevvo DATAFILE '${DUMP_DIR}/${DUMP_FILE}.dbf' SIZE ${TABLE_SPACE_SIZE} EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K;
  CREATE USER frevvo IDENTIFIED BY frevvo DEFAULT TABLESPACE frevvo;
  GRANT ALL PRIVILEGES TO frevvo;
END

cat <<-END > /import.sh
  impdp system/oracle directory=DUMP_DIR dumpfile=${DUMP_FILE} full=y;
END
chmod +x /import.sh