export function addProtocol(url) {
    if (!/^(?:f|ht)tps?\:\/\//i.test(url)) {
        url = "https://" + url;
    }
    return url;
}

export function validDomain(url) {
    const urlRegex = /^(((http|https):\/\/|)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?)$/;
    if (urlRegex.test(url)) {
         return true;
     } else {
         return false;
     }
}

function url_domain(data) {
    let domain =  new URL(addProtocol(data))
    let hostname = domain.hostname
    return hostname.replace('www.','');
}

