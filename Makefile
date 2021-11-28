all:
#	service
	rm -rf ebin/* *_ebin;
	rm -rf 1 2 3 4 5 6 7 8 9 controller dbase sd;
	rm -rf src/*.beam *.beam  test_src/*.beam test_ebin;
	rm -rf  *~ */*~  erl_cra*;
#	common
	erlc -o ebin ../../common/src/*.erl;
#	app
	cp src/*.app ebin;
	erlc -o ebin src/*.erl;
	echo Done
unit_test:
	rm -rf ebin/* src/*.beam *.beam test_src/*.beam test_ebin;
	rm -rf  *~ */*~  erl_cra*;
	mkdir test_ebin;
#	common
	erlc -o ebin ../../common/src/*.erl;
#	app
	cp src/*.app ebin;
	erlc -o ebin src/*.erl;
#	test application
	cp test_src/*.app test_ebin;
	erlc -o test_ebin test_src/*.erl;
	erl -pa ebin -pa test_ebin\
	    -setcookie cookie\
	    -sname test\
	    -unit_test monitor_node test\
	    -unit_test cluster_id test\
	    -unit_test cookie cookie\
	    -run unit_test start_test test_src/test.config
