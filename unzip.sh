#remove the k to remove the files
#bzip2 -dk 5815949971.dem.bz2
bzip2 -dk $1


#run powershell or python script to
# 1. check if dota 2 is running
# 2. if not, run it with command line options adding "+playdemo replay/{matchID}.dem" to the end
# 3. if so, run image detection script to identify the console and input the line "playdemo replay/{matchID}.dem"