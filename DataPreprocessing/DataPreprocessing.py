# -*- coding: utf-8 -*-
import csv
'''
Usage:
    1. Provide new data into RawData.csv (see format requirements below).
    2. Run this script.
    3. Work with processed data.

Raw data should be CSV file with answers sorted by time
Use this query for obtain it form MySQL table:
    SELECT
        id_year,
        year.name, 
        answer.id_team, 
        team.name,
        task.type,
        ((date_format(answer.inserted, '%H')-15)*60 + date_format(answer.inserted, '%i')) AS minutes,
        answer.id_answer,
        answer.inserted,
        IF(answer.code = task.code, "TRUE", "FALSE") AS correct,
        answer.id_task,
        IF(answer.code != task.code,
            0,
            1000-(
                SELECT
                    COUNT(help.id_answer)
                FROM answer AS help
                WHERE
                    help.code = task.code AND 
                    help.inserted < answer.inserted AND 
                    help.id_task = answer.id_task
            )
        ) AS score
    FROM answer
    INNER JOIN task USING(id_task)
    INNER JOIN team USING (id_team)
    INNER JOIN year USING (id_year)
    ORDER BY id_year, minutes, id_answer
    
So one row is:
    0 -> ﻿id_year
    1 -> name of year
    2 -> id_team
    3 -> name of team
    4 -> task type
    5 -> minutes from beginning
    6 -> id_answer
    7 -> inserted
    8 -> correct
    9 -> id_task
    10 -> score
'''

'''
Data structure:
years[2010][62] = ["TEAM NAME", states]
states[0] = [NUM_LOGIC, NUM_PROG, NUM_IDEA, POINTS_LOGIC, POINTS_PROG, POINTS_IDEA, BONUS, PENALIZATION]
'''

years = {}

def maintainPrevious(year, team, minutes):
    states = years[year][team][1]
    for minute in range(0, minutes):
        if not minute in states:
            if minute == 0:
                states[minute] = [0 for _ in range(8)]
            else:
                states[minute] = list(states[minute-1])
    
                
def appendTask(state, year, taskType, correct, score):
    if correct == "FALSE":
        if int(year) >= 2013:
            state[7] += 30
        else:
            state[7] += 10
        return
    
    if taskType == "idea":
        pos = 2
    elif taskType == "logical":
        pos = 0
    elif taskType == "programming":
        pos = 1
   
    state[pos] += 1
    state[pos + 3] += int(score)
    
    common = min(state[0:3])
    state[6] = common * 500

def processRow(row):
    year = row[1]
    team = row[2]
    teamName = row[3]
    minutes = int(row[5])
    # Check year
    if not year in years:
        years[year] = {}
    # Check team
    if not team in years[year]:
        years[year][team] = [teamName, {}]
    # Check if previous minutes are filled
    maintainPrevious(year, team, minutes)
    # Add new data to previous data
    score = row[10]
    taskType = row[4]
    correct = row[8]
    states = years[year][team][1]
    if not (minutes in states):
        if minutes == 0:
            states[minutes] = [0 for _ in range(8)]
        else:
            states[minutes] = list(states[minutes-1])
    appendTask(states[minutes], year, taskType, correct, score)
    

# Main program

# Read and parse
with open('../Data/RawData.csv', 'r') as rawDataFile:
    rawData = csv.reader(rawDataFile, delimiter=';')
    isFirst = True
    for row in rawData:
        if isFirst:
            isFirst = False
            continue
        processRow(row)

for year in years:    
    with open('../Data/ProcessedDataYear' + str(year) + '.csv', 'w') as processedDataFile:
        writer = csv.writer(processedDataFile, delimiter=';')
        for team in years[year]:
            output = []
            temp = years[year][team]
            output.append(team)
            output.append(temp[0])
            for minute in temp[1]:
                output.append(minute)
                output.extend(temp[1][minute])
            writer.writerow(output)

"""        
debug = years["2013"]["516"]
print debug[0]
for key in debug[1]:
    print str(key) + ": " + str(debug[1][key])
"""