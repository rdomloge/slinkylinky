import React, {useState, useEffect} from 'react'
import ErrorMessage from './atoms/Messages';
import { useSession } from "next-auth/react";

const cache = {};

export default function ProposalValidationPanel({primaryDemand, otherDemands, supplier, readinessCallback}) {
    const { data: session } = useSession();
    const [error, setError] = useState(null);
    const [validationErrors, setValidationErrors] = useState([]);

    useEffect( () => {
        if(session == null) return;
        checkAllDemands()
            .then(() => {
                checkDuplicateDomains();
                checkTooManyLinks();
                setValidationErrors([...validationErrors]);
                console.log("There are now "+validationErrors.length+" errors");
                readinessCallback(validationErrors.length === 0);
            })

    }, [otherDemands, session]);

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
        return fetch(mozUrl, {
                    method: 'GET',
                    headers: {'user': session.user.email, 'demandId': demand.id}
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
    
    return (
        <div className={validationErrors.length > 0 ? "border-l-8 border border-red-500 bg-red-100 mx-6 my-4":""}>
        {error ?
            <ErrorMessage message={"There was an issue using the Moz service: "+error}/>
            :
        null}

        {validationErrors ? 
            validationErrors.map( (e,index) => {
                return <ErrorMessage key={index} message={e} id={"error-"+index}/>
            })
        :
            null
        }
        </div>
    );
}