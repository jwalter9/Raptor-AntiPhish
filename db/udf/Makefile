LIBDIR=/usr/lib/mysql/plugin
all:
	gcc -Wall -fPIC -I/usr/include/mysql -I. -shared udf_emailer.c -lesmtp -o ./udf_emailer.so 

install:
	cp udf_emailer.so $(LIBDIR)
