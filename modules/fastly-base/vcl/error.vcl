# error block to process redirects

if (obj.status == 817) {
    set obj.status = 301;
    set obj.http.Location = "https://" req.http.host req.url;
    return (deliver);
}

if (obj.status == 900 && obj.response == "unauthorized") {
    set obj.status = 401;
    set obj.response = "UNAUTHORIZED";
    return(deliver);
}
