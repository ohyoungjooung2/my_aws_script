#!/usr/bin/env python3
import boto3
import re
import datetime

def change_into_sec(tag):
    tag=tag.replace('T','-')
    res=int(datetime.datetime.strptime(tag,'%Y-%m-%d-%H:%M:%S+00:00').strftime('%s'));
    return res

def check_num_first(res):
    res=re.match('^2',res)
    return res


def get_users():
    session = boto3.Session(profile_name='mfa')
    im = session.client('iam')
    try:
        result=im.get_credential_report() 
    except:
        result=im.generate_credential_report() 
        result=im.get_credential_report() 
        
    cresult=result['Content'].decode('utf-8').split('\n')
    cresult=cresult[2:] 

    #TodayNineAm=datetime.datetime.today().strftime('%Y-%m-%d 09:00:00')
    TodayNineAm=datetime.datetime.today().strftime('%Y-%m-%d 00:00:00')
    #TodayNineAmInSec=int(datetime.datetime.strptime(TodayNineAm,'%Y-%m-%d %H:%M:%S').strftime('%s'))
    #Python3 below datetime.now use no utc but localtime(KST), to be utc, minus (9*60*60) 9 hours
    TodayNineAmInSec=int(datetime.datetime.now().strftime('%s')) - 32400
    #print(TodayNineAmInSec)
    #print "TodayNineInSec"+ TodayNineAmInSec
    TwentyDays=1728000
    
    print ('userName,most_recent_in_date,most_recent,RecentActSince')
    for i in range(0,len(cresult)):
        userName=cresult[i].split(',')[0]
        created_time=cresult[i].split(',')[2]
        password_last_used=cresult[i].split(',')[4]
        access_key1_last_used=cresult[i].split(',')[10]
        access_key2_last_used=cresult[i].split(',')[15]


        created_time_in_sec=change_into_sec(created_time)
        password_last_used_sec=check_num_first(password_last_used)
        if(password_last_used_sec!=None):
           password_last_used_sec=change_into_sec(password_last_used)
        else:
           password_last_used_sec=0


        access_key1_last_used_sec=check_num_first(access_key1_last_used)
        if(access_key1_last_used_sec!=None):
           access_key1_last_used_sec=change_into_sec(access_key1_last_used)
        else:
           access_key1_last_used_sec=0

        access_key2_last_used_sec=check_num_first(access_key2_last_used)
        if(access_key2_last_used_sec!=None):
           access_key2_last_used_sec=change_into_sec(access_key2_last_used)
        else:
           access_key2_last_used_sec=0


        most_recent=max(created_time_in_sec,password_last_used_sec,access_key1_last_used_sec,access_key2_last_used_sec)
        #print(most_recent)
        #print("todayninisec")
        #print(TodayNineAmInSec)
        #print("most_recent-todayninice")
        #print(most_recent - TodayNineAmInSec)
   
        RecentActSince=round((TodayNineAmInSec-most_recent)/(24*60*60)) 
        if ( (TodayNineAmInSec - most_recent) >= TwentyDays):
          most_recent_in_date=datetime.datetime.fromtimestamp(most_recent).strftime('%Y-%m-%d %H:%M:%S')
          print (userName, "," ,most_recent_in_date, "," ,most_recent, "," ,RecentActSince)
          #print userName, most_recent_in_date,most_recent,RecentActSince

get_users()
