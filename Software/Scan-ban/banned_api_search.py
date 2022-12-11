#! python
###############################################
#   .c/.cpp banned windows API checker        #
#   Author: malwrforensics                    #
#   Contact: malwr at malwrforensics dot com  #
###############################################

import os
import sys

banned_apis = [
#01.string copy
"strcpy", "strcpyA", "strcpyW", "wcscpy", "_tcscpy", "_mbscpy", "StrCpy", "StrCpyA", "StrCpyW", "lstrcpy", "lstrcpyA", "lstrcpyW",
"_tccpy", "_mbccpy", "_ftcscpy", "strncpy", "wcsncpy", "_tcsncpy", "_mbsncpy", "_mbsnbcpy", "StrCpyN", "StrCpyNA", "StrCpyNW",
"StrNCpy", "strcpynA", "StrNCpyA", "StrNCpyW", "lstrcpyn", "lstrcpynA", "lstrcpynW",

#02.string concatenation 
"strcat", "strcatA", "strcatW", "wcscat", "_tcscat", "_mbscat", "StrCat", "StrCatA", "StrCatW", "lstrcat", "lstrcatA", "lstrcatW",
"StrCatBuff", "StrCatBuffA", "StrCatBuffW", "StrCatChainW", "_tccat", "_mbccat", "_ftcscat", "strncat", "wcsncat", "_tcsncat",
"_mbsncat", "_mbsnbcat", "StrCatN", "StrCatNA", "StrCatNW", "StrNCat", "StrNCatA", "StrNCatW", "lstrncat", "lstrcatnA", "lstrcatnW",
"lstrcatn",

#03.sprintf
"printf","sprintfW", "sprintfA", "wsprintf", "wsprintfW", "wsprintfA", "sprintf", "swprintf", "_stprintf", "wvsprintf", "wvsprintfA",
"wvsprintfW", "vsprintf", "_vstprintf", "vswprintf",
    #Recommended:
"wnsprintf", "wnsprintfA", "wnsprintfW", "_snwprintf", "snprintf", "sntprintf _vsnprintf", "vsnprintf", "_vsnwprintf",
"_vsntprintf", "wvnsprintf", "wvnsprintfA", "wvnsprintfW",

#04."n" sprintf
"_snwprintf", "_snprintf", "_sntprintf", "nsprintf",

#05.variable argument sprintf
"wvsprintf", "wvsprintfA", "wvsprintfW", "vsprintf", "_vstprintf", "vswprintf",

#06.variable argument "n" sprintf
"_vsnprintf", "_vsnwprintf", "_vsntprintf", "wvnsprintf", "wvnsprintfA", "wvnsprintfW",

#07."n" string copy
"strncpy", "wcsncpy", "_tcsncpy", "_mbsncpy", "_mbsnbcpy", "StrCpyN", "StrCpyNA", "StrCpyNW", "StrNCpy", "strcpynA",
"StrNCpyA", "StrNCpyW", "lstrcpyn", "lstrcpynA", "lstrcpynW", "_fstrncpy",

#08."n" string concatenation
"strncat", "wcsncat", "_tcsncat", "_mbsncat", "_mbsnbcat", "StrCatN", "StrCatNA", "StrCatNW", "StrNCat", "StrNCatA",
"StrNCatW", "lstrncat", "lstrcatnA", "lstrcatnW", "lstrcatn", "_fstrncat",

#09.string tokenizing
"strtok", "_tcstok", "wcstok", "_mbstok",

#10.Makepath
"makepath", "_tmakepath", "_makepath", "_wmakepath",

#11.Splitpath
"_splitpath", "_tsplitpath", "_wsplitpath",

#12.scanf
"scanf", "wscanf", "_tscanf", "sscanf", "swscanf", "_stscanf",

#13 "n"scanf
"snscanf", "snwscanf", "_sntscanf",

#14.numeric conversion
"_itoa", "_itow", "_i64toa", "_i64tow", "_ui64toa", "_ui64tot", "_ui64tow", "_ultoa", "_ultot", "_ultow",

#15.gets
"gets", "_getts", "_gettws",

#16.IsBad
"IsBadWritePtr", "IsBadHugeWritePtr", "IsBadReadPtr", "IsBadHugeReadPtr", "IsBadCodePtr", "IsBadStringPtr",

#17.OEM conversion
"CharToOem", "CharToOemA", "CharToOemW", "OemToChar", "OemToCharA", "OemToCharW", "CharToOemBuffA", "CharToOemBuffW",

#18.stack dynamic memory allocation
"alloca", "_alloca",

#19.string length functions
"strlen", "wcslen", "_mbslen", "_mbstrlen", "StrLen", "lstrlen",

#20.memory copy functions
"memcpy", "RtlCopyMemory", "CopyMemory", "wmemcpy",

#21.window messaging
"ChangeWindowMessageFilter",

#22.OS
"system", "ShellExecute", "_wsystem", "popen",  "exec", "execl", "execlp", "execle", "execv", "execvp", "execvpe", "execveat",

#banned
"unique_lock", "<mutex>", "shared_prt", "volatile", "mepGetDefault", "map::operator", "vactor::operator"

]



def contains_banned_api(s):
    global banned_apis
    for api in banned_apis:
        if api in s:
            return 1
    return 0

def check_banned_api(fname):
    try:
        if len(fname) < 3:
            return

        counter_line = 0
        with open(fname, "r") as f:
            for line in f:
                counter_line = counter_line + 1
                if contains_banned_api(line) == 1:
                    print(fname + ":(L" + str(counter_line) +"):" + line)
    except:
        print("[-] check_banned_api(): Error reading from file " + str(fname))
    return

def get_files(path):
  for root, subdirs, files in os.walk(path):
    for file in os.listdir(root):
        filePath = os.path.join(root, file)
        if os.path.isdir(filePath):
            pass
        else:
            if len(filePath) > 3:
                if ".c" in filePath[-2:] or ".h" in filePath[-2:] or ".cpp" in filePath[-4:]:
                    check_banned_api(filePath)

if __name__ == "__main__":
    if len(sys.argv) == 2:
        print("malwrforensics.com - Banned Windows API checker v1.0\n")
        get_files(sys.argv[1])
        print("[+] Done")
    else:
        print("program [folder]")
