# !/bin/sh
##################################
# 部署在路由器
##################################

#  SMTP配置
smtpserver=smtp.163.com
smtpuser=bbn9435
smtppwd=123456
fromaddress=bbn9435@163.com
toaddress=bbn9435@163.com

# 文件路径，最新ip写入lastwanip.txt
iptxt="/home/admin/lastwanip.txt"

# 文件路径，邮件正文，写入mail文件
mailtxtpath="/home/admin/mail.txt"

# 检测时间
now=`date "+%Y-%m-%d %H:%M:%S"`
echo "now=$now"

# 获取路由器本身wan口ip地址
devwanip=`ip addr|grep inet|grep ppp|awk '{print $2}'`
echo "devwanip=$devwanip"

# 获取WANIP接口。如接口获取不到ip，本次取消发送
newwanip=`wget http://members.3322.org/dyndns/getip -q -O -`
echo "newwanip=$newwanip"
if [ -z $newwanip ]; then
    echo "cann't get wan ip!"
    exit
fi

# 是否私网IP上网
if [ $newwanip != $devwanip ]; then
    echo "private ip addr! newwanip=$newwanip, but devwanip=$devwanip, skip send email."
    exit
fi

# 上一次外网IP
if [ -f $iptxt ]; then
    oldwanip=`cat $iptxt`
else
    oldwanip="0.0.0.0"
fi
echo "oldwanip=$oldwanip"

# 对比上次外网IP，如相同则不发邮件，否则发送
if [ $newwanip = $oldwanip ]; then
    echo "same ip, skip send email."
    exit
fi
if [ -f $mailtxtpath ]; then
    rm -f $mailtxtpath
fi

# 邮件正文
cat  <<EOF >>$mailtxtpath
Subject: 路由器外网IP：${newwanip} @ ${now}
EOF
cat $mailtxtpath

# 发送邮件
sendmail -w 10 -f $fromaddress -t $toaddress -S $smtpserver -au$smtpuser -ap$smtppwd <$mailtxtpath

# 缓存最新ip地址，写入/etc/storage/lastwanip.txt"
if [ $? = 0 ]; then
    echo "send email success!"
    echo $newwanip > $iptxt
fi

