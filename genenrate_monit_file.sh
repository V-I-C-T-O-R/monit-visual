#!/bin/bash
if [ $# -gt 2 ];then
   echo '传入参数过多,参数个数为2,参数1为ip,参数2为表名即可'
   exit 0
fi

echo '传入表名:'$1"_"$2
table_name=$1"_"$2
echo '准备生成monit业务配置文件'
base_str_title="#!/bin/sh\n"
process_str='process=`ps aux | grep '$table_name' | grep -v grep | wc -l`\n'
line_str="\n    "

start_body_one_str=$base_str_title$process_str"if [ \$process -le 0 ];then"$line_str"echo '"$table_name"进程不存在,准备启动'"$line_str"cd /opt/cloudera/parcels/CDH-5.16.1-1.cdh5.16.1.p0.3/lib/flume-ng"$line_str"nohup ./bin/flume-ng agent --conf /opt/cloudera/parcels/CDH-5.16.1-1.cdh5.16.1.p0.3/lib/flume-ng/conf --conf-file /data/flume_kudu_conf/"$table_name".conf --name agent -Dflume.log.file="$table_name".log > /dev/null 2>&1 &"$line_str"echo '"$table_name"启动完成'\nelse"$line_str"echo '"$table_name"进程存在,不操作'\nfi"

#echo $start_body_one_str
monit_start_fname=$2"-start.sh"
echo "生成$monit_start_fname文件"
/bin/echo -e "$start_body_one_str" > /opt/monitor/monit-5.25.0/monit.d/$monit_start_fname

stop_body_one_str=$base_str_title'PIDS=`''ps aux | grep '$table_name' | grep -v grep | awk "{print $2}"`\nfor pid in $PIDS\ndo'$line_str'kill -9 ${pid}'$line_str'echo "kill ${pid}"\ndone\necho "'$table_name'进程kill完成"'

#echo $stop_body_one_str
monit_stop_fname=$2"-stop.sh"
echo "生成$monit_stop_fname"
/bin/echo -e "$stop_body_one_str" > /opt/monitor/monit-5.25.0/monit.d/$monit_stop_fname

monitor_table_str='check process '$table_name' with matching "'$table_name'"'$line_str'EVERY 3 CYCLES'$line_str'start program = "/bin/sh /opt/monitor/monit-5.25.0/monit.d/'$monit_start_fname'" with timeout 30 seconds'$line_str'stop program = "/bin/sh /opt/monitor/monit-5.25.0/monit.d/'$monit_start_fname'"'$line_str'if 2 restarts within 3 cycles then unmonitor\n'

echo "插入内容到monit服务，更新配置..."
/bin/echo -e "$monitor_table_str" >> /opt/monitor/monit-5.25.0/monit.d/business.conf

echo '更新配置完成'
