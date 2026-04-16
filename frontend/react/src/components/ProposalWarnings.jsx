import React, {useState, useEffect} from 'react'
import ErrorMessage from './atoms/Messages';
import { useAuth } from "@/auth/AuthProvider";
import { fetchWithAuth } from '@/utils/fetchWithAuth';

const cache = {};

export default function ProposalValidationPanel({primaryDemand, otherDemands, supplier, readinessCallback}) {
    const { user } = useAuth();
    const [error, setError] = useState(null);
    const [validationErrors, setValidationErrors] = useState([]);

    useEffect( () => {
        if(user == null) return;
        checkAllDemands()
            .then(() => {
                checkDuplicateDomains();
                checkTooManyLinks();
                setValidationErrors([...validationErrors]);
                console.log("There are now "+validationErrors.length+" errors");
                readinessCallback(validationErrors.length === 0);
            })

    }, [otherDemands, user]);

    function checkDuplicateDomains() {
        const domains = [];
        var disabled = false;
                
        otherDemands.forEach((d) => {
            if(domains.includes(d.domain)) {
                disabled = true;
                console.log("Duplicate domain "+d.domain);
                validationErrors.push("Duplicate domain "+d.domain+" in proposal");
                setValidationErrors(validationErrors);
            }
            else {
                domains.push(d.domain);
            }
        }); 
    }

    function checkTooManyLinks() {
        var disabled = false;
        if(otherDemands.length > 2) {
            validationErrors.push("Too many links in proposal");
            setValidationErrors(validationErrors);
        }
    }

    function checkAllDemands() {
        //start fresh
        setValidationErrors([]);
        validationErrors.length = 0;

        return new Promise((resolve,reject) => {  
            const primaryPromise = checkDemand(primaryDemand, supplier) // doesn't matter that we do this again, since it is cached

            const otherDemandPromises = []
            otherDemands.forEach((d) => {
                otherDemandPromises.push(checkDemand(d, supplier))
            })

            Promise.all([primaryPromise, ...otherDemandPromises])
                .then(([primaryRes, ...otherRes]) => {
                    if(null != primaryRes) {
                        validationErrors.push("There is already a 3rd party link to "+primaryRes.target.root_domain+" from " + primaryRes.source.root_domain)
                        setValidationErrors(validationErrors)
                        console.log("Added primary error "+primaryDemand.domain)
                    }
                    else console.log("Primary is valid")

                    otherRes.forEach((res) => {
                        if(null != res) {
                            validationErrors.push("There is already a 3rd party link to "+res.target.root_domain+" from " + res.source.root_domain)
                            setValidationErrors(validationErrors)
                            console.log("Added secondary error "+res.target.root_domain)
                        }
                        else console.log("Secondary is valid")
                    })
                    resolve();
                })
        });
    }

    function checkDemand(demand, supplier) {
        return new Promise(async (resolve, reject) => {
            const cacheKey = demand.domain+supplier.domain;
            if(Object.hasOwn(cache, cacheKey)) {
                console.log("Cache hit for "+cacheKey);
                resolve(cache[cacheKey])
            }
            else {
                console.log("Cache miss for "+cacheKey);
                lookupWithMoz(demand, supplier)
                    .then((data) => {
                        cache[cacheKey] = data;
                        resolve(cache[cacheKey])
                    });
            }
        })
    }

    function lookupWithMoz(demand, supplier) {
        const mozUrl = "/.rest/mozsupport/checklink?demandurl="+demand.domain+"&supplierDomain="+supplier.domain
        return fetchWithAuth(mozUrl, {
                    method: 'GET',
                    headers: {'demandId': demand.id}
                })
            .then((resp) => {
                if(resp.ok) return resp.json();
                else return null;
            })
            .catch((err) => {
                console.log("Error: "+err);
                setError(err);
            });
    }
    
    if (!error && (!validationErrors || validationErrors.length === 0)) return null;

    return (
        <div className="px-6 pb-2 space-y-2">
            {error && <ErrorMessage message={"There was an issue using the Moz service: " + error}/>}
            {validationErrors && validationErrors.map((e, index) => (
                <ErrorMessage key={index} message={e} id={"error-" + index}/>
            ))}
        </div>
    );
}