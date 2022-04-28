#!/bin/bash

# Initializes the service if it wasn't yet.
echo "Initializing the service..."

if [ ! -d /var/lib/mysql/mysql ]; then
	mysql_install_db --user=root
fi

echo "Service initialized!"

# Start the service.
echo "Starting the service...!"

/usr/bin/mysqld --user=root --skip-grant-tables &

# Check if it was started successfully.
while [ true ];
do
	RESULT=`netstat -an|grep 3306|grep LISTEN`
	
	if [ -z "$RESULT" ]; then
		sleep 1
	else
		break
	fi
done

# Apply the default permissions.
mysql -u root -e "flush privileges; alter user 'root'@'localhost' identified by '$MYSQL_ROOT_PASSWORD';" > /dev/null 2>&1

exist=`mysql -u root -p$MYSQL_ROOT_PASSWORD -e "select User from mysql.user where Host = '%' and User = 'root';"`

if [ -z "$exist" ]; then
  mysql -u root -p$MYSQL_ROOT_PASSWORD -e "flush privileges; create user 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD';" > /dev/null 2>&1
else
  mysql -u root -p$MYSQL_ROOT_PASSWORD -e "flush privileges; alter user 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD';" > /dev/null 2>&1
fi

mysql -u root -p$MYSQL_ROOT_PASSWORD -e "grant all on demo.* to 'root'@'localhost';"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "grant all on demo.* to 'root'@'%';"

echo "Service started!"

# Apply the database scripts.
echo "Applying the database scripts..."

flyway -user=root -password="$MYSQL_ROOT_PASSWORD" migrate

echo "Database scripts applied!"

# Check if the service still running.
while [ true ];
do
	RESULT=`netstat -an|grep 3306|grep LISTEN`

	if [ ! -z "$RESULT" ]; then
		sleep 1
	else
	  echo "Service stopped!"

		break
	fi
done


