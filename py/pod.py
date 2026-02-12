import p8scii

def is_array(obj):
    return isinstance(obj, (list, tuple))

def pod(dict_obj, meta=None, do_not_increment=False):
    res=""
    
    if is_array(meta):
        res="--[[pod"
        for key, value in enumerate(meta):
            pkey=key
            pvalue=pod(value,None,do_not_increment)
            if (not do_not_increment):
                pkey+=1
            pkey=f"[{pkey}]"

            if (pvalue!="nil"):
                res+=f",{pkey}={pvalue}"
        res+="]]"

    if isinstance(dict_obj, dict) or is_array(dict_obj):
        if is_array(meta):
            res += "\n"

        res += "{"
        first=True

        if is_array(dict_obj):
            items=enumerate(dict_obj)
        else:
            items=dict_obj.items()

        for key, value in items:
            pkey=key
            pvalue=pod(value, None, do_not_increment)

            try:
                num_key=int(pkey)
                if (not do_not_increment):
                    num_key+=1
                pkey=f"[{num_key}]"
            except (ValueError, TypeError):
                pass
            
            if (pvalue!="nil"):
                if (not first):
                    res+=","
                res+=f"{pkey}={pvalue}"
                first=False
        return f"{res}}}"
    else:
        value=dict_obj
        
        if isinstance(value,str):
#            pvalue=value.replace("\\","\\\\")
#            pvalue=pvalue.replace('"','\\"')
            return res+f'"{p8scii.convert(value)}"'
        elif isinstance(value, bool):
            return res+("true" if value else "false")
        elif isinstance(value, (int, float)) and not (value != value):
            return res+str(value)
        else:
            return res+"nil"