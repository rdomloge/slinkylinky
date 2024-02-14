export function addProtocol(url) {
    if (!/^(?:f|ht)tps?\:\/\//i.test(url)) {
        url = "https://" + url;
***REMOVED***
    return url;
}