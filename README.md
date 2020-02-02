# Polling-station-Ethnography

Data and scripts for the priject in Polling stations ethnography initiated by Galina Selivanova and Alexei Kouprianov. These scripts are aimed at a quick visualisation of the voters' turnout dynamics and other things. 

## Folders

The project files are stored in a system of folders.

- `data/` --- contains the dataset (for now, the datset is limited to a single polling station);
- `misc/` --- contains `breaks` for time-slicing by 5, 10, 15, 20, 30, and 60 min;
- `plots/` --- contains example plots (beware: there will be more plots if you run the script with real data);
- `scripts/` --- contains scripts to transform and visualise the data.

## Dataset structure

The dataset is a `.tdv` file with nine columns:

- `PS.UID` --- polling station ID (one to four digits);
- `CAM` --- camera ID (as indicated in the video record, usually K1 or K2);
- `TIMECODE` --- timecode ("YYYY-MM-DD HH:MM:SS" MSK = GMT+3 time zone assumed);
- `ACTION.TYPE` --- action type recorded (for now, four action types are processed: "ballot cast", "strange behaviour", "lacune begins", "lacune ends");
- `GENDER` --- gender (assumed, "f" or "m");
- `AGE.GROUP` --- age group (assumed, "young" --- "medium" --- "old" or "young" --- "young-medium" --- "medium" --- "medium-old" --- "old");
- `DB.OPERATOR` --- database operator's name (Firstname Lastname);
- `COMMENT` --- any comment;
- `QUESTION` --- any questions, much the same as the comment.

