#!/bin/sh
#
# M/MONIT SQLITE TO SQL EXPORT
#


MMONIT_HOME=`dirname ${0}`/..
SQLITE="$MMONIT_HOME/bin/sqlite3"
DBPATH="$MMONIT_HOME/db/mmonit.db"
DBTYPE=""


help() {
       /bin/echo "Usage: $0 -t {mysql|postgresql} [-h]";
       /bin/echo "Options are as follows:";
       /bin/echo "    -t Target database type (mysql or postgresql)";
       /bin/echo "    -h Print this text";
       /bin/echo "Use this script to dump data from a M/Monit SQLite database into a MySQL or a PostgreSQL database.";
       /bin/echo "Examples:";
       /bin/echo "    Export to MySQL: ./db/migrate_db.sh -t mysql | mysql -u mmonit mmonit -p";
       /bin/echo "    Export to PostgreSQL: ./db/migrate_db.sh -t postgresql | psql -U mmonit mmonit 2>&1 | grep ERROR";
       exit 0;
}


error() {
        /bin/echo "Error: $1";
        exit 1;
}


predump() {
        /bin/echo "DELETE FROM actionrow;";
        /bin/echo "DELETE FROM actionrowoption;";
        /bin/echo "DELETE FROM actionrowtarget;";
        /bin/echo "DELETE FROM actionqueue;";
        /bin/echo "DELETE FROM event;";
        /bin/echo "DELETE FROM eventfilter;";
        /bin/echo "DELETE FROM eventnotice;";
        /bin/echo "DELETE FROM groupedhost;";
        /bin/echo "DELETE FROM groupedservices;";
        /bin/echo "DELETE FROM host;";
        /bin/echo "DELETE FROM hostgroup;";
        /bin/echo "DELETE FROM jabberserver;";
        /bin/echo "DELETE FROM mailserver;";
        /bin/echo "DELETE FROM message;";
        /bin/echo "DELETE FROM messageformat;";
        /bin/echo "DELETE FROM messagequeue;";
        /bin/echo "DELETE FROM messagerecipients;";
        /bin/echo "DELETE FROM mmonit;";
        /bin/echo "DELETE FROM name;";
        /bin/echo "DELETE FROM roles;";
        /bin/echo "DELETE FROM rule;";
        /bin/echo "DELETE FROM rulerow;";
        /bin/echo "DELETE FROM rulerowevent;";
        /bin/echo "DELETE FROM rulerowhost;";
        /bin/echo "DELETE FROM rulerowhostgroup;";
        /bin/echo "DELETE FROM rulerowservice;";
        /bin/echo "DELETE FROM rulerowservicegroup;";
        /bin/echo "DELETE FROM rulerowstate;";
        /bin/echo "DELETE FROM service;";
        /bin/echo "DELETE FROM servicegroup;";
        /bin/echo "DELETE FROM session;";
        /bin/echo "DELETE FROM statistics;";
        /bin/echo "DELETE FROM statistics_double;";
        /bin/echo "DELETE FROM statistics_aggregate_12h;";
        /bin/echo "DELETE FROM statistics_aggregate_14d;";
        /bin/echo "DELETE FROM statistics_aggregate_15m;";
        /bin/echo "DELETE FROM statistics_aggregate_1d;";
        /bin/echo "DELETE FROM statistics_aggregate_1m;";
        /bin/echo "DELETE FROM statistics_aggregate_2h;";
        /bin/echo "DELETE FROM statistics_aggregate_7d;";
        /bin/echo "DELETE FROM statistics_float;";
        /bin/echo "DELETE FROM statistics_int;";
        /bin/echo "DELETE FROM statistics_llong;";
        /bin/echo "DELETE FROM statistics_string;";
        /bin/echo "DELETE FROM userroles;";
        /bin/echo "DELETE FROM users;";
}


dump() {
$SQLITE $DBPATH << ELO
.mode insert mmonit
SELECT * FROM mmonit;
.mode insert name
SELECT * FROM name;
.mode insert roles
SELECT * FROM roles;
.mode insert users
SELECT * FROM users;
.mode insert userroles
SELECT * FROM userroles;
.mode insert host
SELECT * FROM host;
.mode insert hostgroup
SELECT * FROM hostgroup;
.mode insert groupedhost
SELECT * FROM groupedhost;
.mode insert service
SELECT * FROM service;
.mode insert servicegroup
SELECT * FROM servicegroup;
.mode insert groupedservices
SELECT * FROM groupedservices;
.mode insert event
SELECT * FROM event;
.mode insert eventfilter
SELECT * FROM eventfilter;
.mode insert eventnotice
SELECT * FROM eventnotice;
.mode insert statistics
SELECT * FROM statistics;
.mode insert statistics_double
SELECT * FROM statistics_double;
.mode insert statistics_aggregate_12h
SELECT * FROM statistics_aggregate_12h;
.mode insert statistics_aggregate_14d
SELECT * FROM statistics_aggregate_14d;
.mode insert statistics_aggregate_15m
SELECT * FROM statistics_aggregate_15m;
.mode insert statistics_aggregate_1d
SELECT * FROM statistics_aggregate_1d;
.mode insert statistics_aggregate_1m
SELECT * FROM statistics_aggregate_1m;
.mode insert statistics_aggregate_2h
SELECT * FROM statistics_aggregate_2h;
.mode insert statistics_aggregate_7d
SELECT * FROM statistics_aggregate_7d;
.mode insert statistics_float
SELECT * FROM statistics_float;
.mode insert statistics_int
SELECT * FROM statistics_int;
.mode insert statistics_llong
SELECT * FROM statistics_llong;
.mode insert statistics_string
SELECT * FROM statistics_string;
.mode insert jabberserver
SELECT * FROM jabberserver;
.mode insert mailserver
SELECT * FROM mailserver;
.mode insert message
SELECT * FROM message;
.mode insert messageformat
SELECT * FROM messageformat;
.mode insert messagequeue
SELECT * FROM messagequeue;
.mode insert messagerecipients
SELECT * FROM messagerecipients;
.mode insert rule
SELECT * FROM rule;
.mode insert rulerow
SELECT * FROM rulerow;
.mode insert rulerowevent
SELECT * FROM rulerowevent;
.mode insert rulerowhost
SELECT * FROM rulerowhost;
.mode insert rulerowhostgroup
SELECT * FROM rulerowhostgroup;
.mode insert rulerowservice
SELECT * FROM rulerowservice;
.mode insert rulerowservicegroup
SELECT * FROM rulerowservicegroup;
.mode insert rulerowstate
SELECT * FROM rulerowstate;
.mode insert actionrow
SELECT * FROM actionrow;
.mode insert actionrowoption
SELECT * FROM actionrowoption;
.mode insert actionrowtarget
SELECT * FROM actionrowtarget;
.mode insert actionqueue
SELECT * FROM actionqueue;
ELO
}


while getopts ":ht:" c
do
case $c in
        t) case $OPTARG in
                mysql | postgresql)
                        DBTYPE=$OPTARG;
                        ;;
                *)
                        /bin/echo "Unknow database type: $OPTARG";
                        exit 1;
                        ;;
           esac;;
        *) help;;
esac
done


if test x$DBTYPE = "x"
then
        /bin/echo "Error: -t option required"
        help
fi


if [ ! -e "$DBPATH" ]
then
        error "SQLite database file '$DBPATH' does not exist";
else
        predump;
        dump;
fi

exit;

