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

export function url_domain(data) {
    try {
        let domain =  new URL(addProtocol(data))
        let hostname = domain.hostname
        return hostname.replace('www.','');
    }
    catch(e) {
        console.log("Error parsing domain: "+e)
        return null
    }
}

export function checkIfSupplierIsBlacklisted(website, session) {
    if(null == session || null == session.user || null == session.user.email) {
        console.warn("No session found")
        throw new Error("Missing session parameter")
    }
    const url = "/.rest/blackListedSupplierSupport/isBlackListed?website="+url_domain(website)
    return fetch(url, { method: 'GET', headers: {'user': session.user.email}})
            .then( (resp) => {
                if(resp.ok) {
                    return resp.json().then( (data) => {
                        return data
                    })
                }
                else {
                    console.log("Error determing whether blacklisted")
                    return false
                }
            })
            .catch(err => { 
                console.error("Error: "+JSON.stringify(err))
                console.warn("Error determing whether blacklisted: "+website)
                return false 
            });
}

export function checkIfSupplierExists(website, session) {
    const url = "/.rest/supplierSupport/exists?supplierWebsite="+website
    return fetch(url, {method: 'GET', headers: {'user': session.user.email}})
        .then( (resp) => {
            if(resp.ok) {
                return resp.json().then( (data) => {
                    return data
                })
            }
            else {
                return false
            }
        })
        .catch(err => { 
            return false
        });
}