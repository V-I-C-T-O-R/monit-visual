#!/bin/sh

# This script copies data from old to new installation


help()
{
       /bin/echo "Usage: $0 [-h] -t {mysql|postgresql|sqlite} -o {path} -n {path}";
       /bin/echo " -h Print this text";
       /bin/echo " -t Database type (mysql, postgresql or sqlite)";
       /bin/echo " -o Path to old M/Monit installation";
       /bin/echo " -n Path to new M/Monit installation";
}


# arguments

while getopts "ht:o:n:" c
do
case $c in
        t) case $OPTARG in
                mysql)
                        DBTYPE=$OPTARG;
                        ;;
                postgresql)
                        DBTYPE=$OPTARG;
                        ;;
                sqlite)
                        DBTYPE=$OPTARG;
                        ;;
                *)
                        /bin/echo "Unknow database type: $OPTARG";
                        exit 1;
                        ;;
           esac;;
        o) MMONIT_OLD=$OPTARG;;
        n) MMONIT_NEW=$OPTARG;;
        *) help; exit 0;;
esac
done

if test x$DBTYPE = "x"
then
        /bin/echo "Error: -t option required"
        exit 1
fi

if test x$MMONIT_OLD = "x"
then
        /bin/echo "Error: -o option required"
        exit 1
fi

if test x$MMONIT_NEW = "x"
then
        /bin/echo "Error: -n option required"
        exit 1
fi


# database dependent tasks

case $DBTYPE in

        mysql)
        ;;

        postgresql)
        ;;

        sqlite)
        /bin/echo -n "Copying database file from $MMONIT_OLD/db/mmonit.db to $MMONIT_NEW/db/ ... "
        cp $MMONIT_OLD/db/mmonit.db $MMONIT_NEW/db/ || exit 1
        /bin/echo "done"
        ;;

esac


# common tasks

/bin/echo -n "Copying configuration files from $MMONIT_OLD/conf/ to $MMONIT_NEW/conf/ ... "
cp -rp $MMONIT_OLD/conf/* $MMONIT_NEW/conf/ || exit 1
/bin/echo "done"

if [ -d $MMONIT_OLD/docroot/uploads ]
then
        /bin/echo -n "Copying uploaded files from $MMONIT_OLD/docroot/uploads/ to $MMONIT_NEW/docroot/uploads/ ... "
        cp $MMONIT_OLD/docroot/uploads/* $MMONIT_NEW/docroot/uploads/
        /bin/echo "done"
fi

exit 0

