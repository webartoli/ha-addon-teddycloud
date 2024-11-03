def leaf: .value | type != "object";
def nav: to_entries[] | 
    if leaf 
        then (.key) + "=" + (.value | tostring) 
        else (.key) + "." + (.value | nav) 
    end;

. | nav
