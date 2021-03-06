# import json
import sys
import time
import os
import threading

PIDS = []
DEBUG = False
INVALIDS = []
#lowercase before checking
EXIT_STRINGS = ['exit','-1']

def on_start():
    print('DO NOT EXIT WITH CTRL+C')
    name,Cerebro = check_settings()
    print('subjectlistQC_{name}.json'.format(name = name)) if DEBUG else None
    with open('subjectlistQC_{name}.json'.format(name = name)) as f:
        data = json.load(f)
    
    order = data['order']
    position = data['position']
    
    return data, order, position,name,Cerebro

def check_settings():
    if os.path.exists('./settings.json'):
        with open('settings.json') as f:
            settings = json.load(f)
    else:
        name = input('Enter your firstname\n')
        Cerebro = input('Enter your path to Cerebro (Whatever directory that lets you access the Studies folder)\n')
        settings = {}
        settings['name'] = name
        settings['Cerebro'] = Cerebro
        with open('settings.json','w') as f:
            json.dump(settings,f)
    return settings['name'], settings['Cerebro']

def on_close(name,data,position):
    data['position'] = position
    with open('subjectlistQC_{n}.json'.format(n = name), 'w') as f:
        json.dump(data, f)
        
def open_image(cerebro,subjectID,scanID):
    toADNI = "Studies/ADNI_2020/Public/Analysis/data/ADNI1/"
    suffix = "step01_structural_processing/wstrip_mMPRAGE.nii"
    imagepath = toADNI+"ADNI1_Structural_Processing/ADNI1_data/{sub}/{scan}/".format(sub=subjectID,scan=scanID)+suffix
    mask = toADNI+"misc/rmask_ICV.nii"
    exists = os.path.exists("{base}/{imgPath}".format(base=cerebro,imgPath=imagepath))
    print(exists) if DEBUG else None
    command = "itksnap -g {base}/{imgPath} -s {base}/{maskPath} &".format(base=cerebro,imgPath=imagepath,maskPath=mask)
    if exists:
        pid = os.system(command)
    else:
        with open("missing_processing.txt", "a") as f:
            f.write("{base}/{imgPath}".format(base=cerebro,imgPath=imagepath))
    return exists

def main():
    name = 'test'
    data, order, position,name,cerebro = on_start()
    counter = 0
    while position<len(order):
        if counter%10 == 0 and counter > 0:
            print('Please close all open itk-snap windows')
            print('Take a break!')
            time.sleep(5*60)
        
        valid = False
        while not valid:
            currentKey= list(data.keys())[order[position]]
            currentScan = data[currentKey]
            valid = open_image(cerebro,currentScan['SubjectID'],currentScan['ScanID'])
            if not valid:
                position += 1
        time.sleep(3)
        #pid = open_image(cerebro,currentScan['SubjectID'],currentScan['ScanID'])
        print(position) if DEBUG else None
        print(pid) if DEBUG else None
        valid = False
        while not valid:
            userInput = input("Enter 1 for a pass or 0 for a fail.\nType 'exit' to exit.\n")
            if userInput == '1':
                data[currentKey]['QC'] = 1
                print(currentKey) if DEBUG else None
                valid = True
                position += 1
                counter += 1
            elif userInput == '0':
                data[currentKey]['QC'] = 0
                valid = True
                position += 1
                counter += 1
            elif str(userInput).lower() in EXIT_STRINGS:
                print("Last position: {pos}".format(pos = position))
                print("Last subject: {sub}".format(sub= currentKey))
                on_close(name,data,position)
                print('Thanks!')
                return
            else:
                print('Invalid input')
                
if __name__ =='__main__':
    main()