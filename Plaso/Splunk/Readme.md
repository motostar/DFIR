# Plaso log2timeline
**log2timeline**  is a command line tool to extract  events from individual files, recursing a directory (e.g. mount point) or storage media image or device. log2timeline creates a Plaso output file which can be analyzed with Splunk or ELK.

The Plaso storage file contains the extracted events and various metadata about the collection process alongside information collected from the source data. It may also contain information about tags applied to events and reports from analysis plugins.
# Ouput format
## CSV Output
The first line in the CSV file is a header, containing the name of each field. Other lines in the CSV file refers to one timestamped entry, which means that each timestamp object may be expanded to several lines.

The header consists of:

```
date,time,timezone,MACB,source,sourcetype,type,user,host,short,desc,version,filename,inode,notes,format,extra
```
and the fields contain the following values:

Name | Description
--- | ---
date | The date of the event(s), in the format of "MM/DD/YYYY" (n.b this might get changed in a future version to YYYY-MM-DD, but for now this will stay this way).
time | time of day, expressed in a 24h format, HH:MM:SS (in future versions this may change to include ms values in the format of HH:MM:SS.ms).
timezone | The name of the timezone used as the output timezone, or the chosen timezone of the input file if no output timezone was chosen.
MACB | MACB or legacy meaning of the fields, mostly for compatibility with the output of the Sleuthkit mactime utility.
source | Short name for the source. This may be something like LOG, WEBHIST, REG, etc. This field name should correspond to the type field in the TLN output format and describes the nature of the log format on a high level (all log files are marked as LOG, all registry as REG, etc.)
sourcetype | More comprehensive description of the source. This field further describes the format, such as "Syslog" instead of simply "LOG", "NTUSER.DAT Registry" instead of "REG", etc.
type | type of the timestamp itself, such as “Last Accessed”, “Last Written” or “Last modified”, etc.
user | username associated with the entry, if one is available.
host | hostname associated with the entry, if one is available.
short | short description of the entry, usually contains less text than the full description field. This is created to assist with tools that try to visualize the event. In those output the short description is used as the default text, and further information or the full description can be seen by either hovering over the text or clicking on further details about the event.
desc | description field, this is where most of the information is stored. This field is the full description of the field, the interpreted results or the content of the actual log line.
version | version number of the timestamp object. Current version is 2.
filename | filename with the full path of the filename that contained the entry. In most input modules this is the name of the logfile or file being parsed, but in some cases it is a value extracted from it, in the instance of $MFT this field is populated as the name of the file in question, not the $MFT itself.
inode | inode number of the file being parsed, or in the case of $MFT parsing and possibly some other input modules the inode number of each file inside the $MFT file.
notes | Some input modules insert additional information in the form of a note, which comes here. This might be some hints on analysis, indications that might be useful, etc. This field might also contain URL's that point to additional information, such as information about the meaning of events inside the EventLog, etc.
format | name of the input module that was used to parse the file. If this is a log2timeline input module that produced the output it should be of the format Log2t::input::NAME where name is the name of the module. However other tools that produce l2tcsv output may put their name here.
extra | additional information parsed is joined together and put here. This 'extra' field may contain various information that further describe the event. Some input modules contain additional information about events, such as further divide the event into source IP's, etc. These fields may not fit directly into any other field in the CSV file and are thus combined into this 'extra' field.

## Splunk sourcetype for CSV

Native CSV sourcetype can be applied to parse the CSV file and visualize events in dashboard.

## Json Output
Plaso outputs nested Json and each event is represented with "event_number", It is very important to break this json into individual line before parsing and visualizing in Splunk dashboard.

{"event_0": {"__container_type__": "event", "__type__": "AttributeContainer", "data_type": "windows:registry:appcompatcache", "entry_index": 10, "hostname": "DESKTOP-0QT8017", "inode": 0, "key_path": "HKEY_LOCAL_MACHINE\\System\\ControlSet001\\Control\\Session Manager\\AppCompatCache", "message": "[HKEY_LOCAL_MACHINE\\System\\ControlSet001\\Control\\Session Manager\\AppCompatCache] Cached entry: 10 Path: 00000009\t3e812ca14e7e0000\t000a000045630000\t8664\tMicrosoft.Office.OneNote\t8wekyb3d8bbwe\t", "offset": 3018, "parser": "winreg/appcompatcache", "path": "00000009\t3e812ca14e7e0000\t000a000045630000\t8664\tMicrosoft.Office.OneNote\t8wekyb3d8bbwe\t", "pathspec": {"__type__": "PathSpec", "location": "\\Windows\\System32\\config\\SYSTEM", "mft_attribute": 1, "mft_entry": 83339, "parent": {"__type__": "PathSpec", "location": "/p1", "parent": {"__type__": "PathSpec", "parent": {"__type__": "PathSpec", "location": "/mnt/c/Users/landers/Desktop/Sample.E01", "type_indicator": "OS"}, "type_indicator": "EWF"}, "part_index": 2, "start_offset": 576716800, "type_indicator": "TSK_PARTITION"}, "type_indicator": "NTFS"}, "sha256_hash": "df2d4fd6eed8a025632be22f0cda1a821696030d40ee4c5512913374e250eb04", "timestamp": 0, "timestamp_desc": "File Last Modification Time"}
, "event_1": {"__container_type__": "event", "__type__": "AttributeContainer", "data_type": "windows:registry:appcompatcache", "entry_index": 105, "hostname": "DESKTOP-0QT8017", "inode": 0, "key_path": "HKEY_LOCAL_MACHINE\\System\\ControlSet001\\Control\\Session Manager\\AppCompatCache", "message": "[HKEY_LOCAL_MACHINE\\System\\ControlSet001\\Control\\Session Manager\\AppCompatCache] Cached entry: 105 Path: 00000009\t000e002800460000\t000a000042ee0000\t8664\tMicrosoft.SkypeApp\tkzf8qxf38zg5c\t", "offset": 29778, "parser": "winreg/appcompatcache", "path": "00000009\t000e002800460000\t000a000042ee0000\t8664\tMicrosoft.SkypeApp\tkzf8qxf38zg5c\t", "pathspec": {"__type__": "PathSpec", "location": "\\Windows\\System32\\config\\SYSTEM", "mft_attribute": 1, "mft_entry": 83339, "parent": {"__type__": "PathSpec", "location": "/p1", "parent": {"__type__": "PathSpec", "parent": {"__type__": "PathSpec", "location": "/mnt/c/Users/landers/Desktop/Sample.E01", "type_indicator": "OS"}, "type_indicator": "EWF"}, "part_index": 2, "start_offset": 576716800, "type_indicator": "TSK_PARTITION"}, "type_indicator": "NTFS"}, "sha256_hash": "df2d4fd6eed8a025632be22f0cda1a821696030d40ee4c5512913374e250eb04", "timestamp": 0, "timestamp_desc": "File Last Modification Time"}
}
## Custom sourcetype/props for Json Output

from the splunk sourcetype cration wizard pick the existing json props to edit with below values and save with new name to apply sourcetype for parsing plaso json logs
```
[ plaso ]
CHARSET=UTF-8
LINE_BREAKER=([\r\n]+)|(\{"event_\d+":)|(\,\s*"event_\d+":)
SHOULD_LINEMERGE=false
disabled=false
pulldown_type=true
```

# Conclusion
It is recommended to use CSV output as the data representatin is clean compared to Json and also be easily handled in both ELK and Splunk. Plaso even has a configuration to breakup the CSV by date to avoid large file sizes and import. 

here is an excellent article on how to create a new sourcetype with Splunk
[Create Sourcetypes](https://docs.splunk.com/Documentation/Splunk/latest/Data/Createsourcetypes)

1. At the time of writing the App the Splunk version was 9.0.4, similar version or the most recent version is recommended for hosting this investigator dash
2. Admin or similar role on Splunk to import and create splunk resources
4. Create a new index on splunk with the name plaso
5. install the .zip app from App manager in splunk to access the timeline analysis Dash.
