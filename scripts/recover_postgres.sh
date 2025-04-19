rm /home/qihan/databases/postgresql.auto.conf
sleep 2
/home/qihan/postgresql-16.4/bin/pg_ctl restart -D /home/qihan/databases -o "-c config_file=/home/qihan/databases/postgresql.conf"