# block non-live hosts
if ( !(req.http.Fastly-Client-IP ~ acl_1) && !(req.http.Fastly-Client-IP ~ acl_2) && !(req.http.host ~ "www.example.com") ){
    error 900 "unauthorized";
}

if ( req.url ~ "(?i)^/([^/]*)" ){
    set req.http.x-path = querystring.remove(re.group.1);
}

if ( req.http.x-path ~ "^/one" ){
    set req.backend = F_one;
    set req.http.backend = "one";

    if (!req.http.Fastly-SSL) {
        error 817 "force_ssl";
    }
} else {
    if (req.http.Fastly-SSL) {
        set req.backend = F_two;
        set req.http.backend = "two";
    } else {
        set req.backend = F_twohttp;
        set req.http.backend = "two-http";
    }
}

# geo location info added to a querysting parameter 
set req.url = querystring.add(req.url, "country", client.geo.country_code);
