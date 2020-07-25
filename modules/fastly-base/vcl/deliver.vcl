# set headers before returning the request

set resp.http.X-XSS-Protection = "1; mode=block";
set resp.http.Strict-Transport-Security = "max-age=600";
