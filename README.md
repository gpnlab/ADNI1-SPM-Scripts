# ADNI1-SPM-Scripts

## Quality Control

Run `python ADNI1_QC.py` to start quality control checks with python 3. One first time running the program will prompt you to enter your name to load the appropriate subject list and the appropriate path to Cerebro to open the files. The program will run itk-snap and overlay the reference segmentation. Enter 1 in the terminal if the scan passes the check and 0 if it fails (UI in development). The program will save the id of the last checked subject, your name, and cerebro path. The program ___will not close itk-snap___ for you (yet) so please close the open windows periodically. Every 10 subjects the program will stop for 5 minutes so that you take a break and can close the open itk-snap windows.

## PSC Scripts
The main scripts are run_ADNI_SPM.sh and ADNI_SPM.sh. These call the matlab script Run_SPM_PSC.m. To test if the subject list is being run properly run testSubjectList.sh. All the scripts used to generate the matlab batches can be found in the folder Matlab Batch Scripts.

