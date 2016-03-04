cat <<-END > /setup.sql
--Aqui puede ir cualquier script para crear usuarios, tablespaces, etc...
END

cat <<-END > /import.sh
--Se deben cambiar los usuarios de origen y destino por los necesarios
  imp system/oracle FILE=/dump/${DUMP_FILE} FROMUSER=ORIGIN_USER TOUSER=TARGET_USER IGNORE=Y log=import.log
END
chmod +x /import.sh
