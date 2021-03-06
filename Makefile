LEX=flex
# YACC=yacc --debug --verbose

LDLIBS=-ll
# CC=CC -DPHDEBUG -DSCANDEBUG

MONGO_INC=/usr/local/include/libmongoc-1.0
BSON_INC=/usr/local/include/libbson-1.0

LOAD_OBJ=load.o types.o scan.o parse_handler.o

all: load_sqlite3 load_mongo dolex

load_sqlite3: LDLIBS += -lsqlite3
load_sqlite3: db.o $(LOAD_OBJ)
	$(CC) $(LDFLAGS) $(LDLIBS) $(LOAD_OBJ) db.o -o load_sqlite3

load_mongo: LDLIBS += -lmongoc-1.0 -lbson-1.0
load_mongo: LDFLAGS += -L/usr/local/lib
load_mongo: mongo_db.o $(LOAD_OBJ)
	$(CC) $(LDFLAGS) $(LDLIBS) $(LOAD_OBJ) mongo_db.o -o load_mongo

dolex: scan.o parse_only.o

mongo_db.o: mongo_db.c
	$(CC) -I$(MONGO_INC) -I$(BSON_INC) mongo_db.c -c mongo_db.c

scan.o: scan.l y.tab.c
y.tab.c: parse.ym
	$(YACC) parse.ym

clean:
	$(RM) load_sqlite3 load_mongo dolex *.o scan.c y.tab.c y.output
