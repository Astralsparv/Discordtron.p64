# characters 127+ are custom
characterset=" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~£"
specialchars="\n"
def convert(txt):
    res=""
    for i in range(len(txt)):
        char=txt[i]
        replacement=""
        if (specialchars.find(char)==-1):
            index=characterset.find(char)
            if (index==-1):
                replacement="\\255"
            else:
                replacement=f"\\{index+32}"
        else:
            if (char=="\n"):
                replacement="\\n"
            else:
                replacement="\\255"
        res+=replacement
    return res

def correct(txt):
    res=""
    i=0
    length=len(txt)
    while i < length:
        if (txt[i]=="\\"):
            charcode=txt[i+1]+txt[i+2]+txt[i+3]
            if (charcode=="127"):
                res+="£"
            elif (charcode=="092"):
                res+="\\"
            else:
                print("Unknown character received: " + charcode)
                res+="�"
            i+=3
        else:
            res+=txt[i]
        i+=1
    return res
