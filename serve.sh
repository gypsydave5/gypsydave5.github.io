#!/bin/bash
ruby -run -ehttpd ./site -p8000 &> server_log.txt &
printf "Blog serving on 8000 - PID $!\n"