'use client'

import React, {useState, useEffect} from 'react'
import { useSearchParams } from 'next/navigation'
import LinkDemandCard from '@/components/linkdemandcard'
import SupplierCard from '@/components/suppliercard'
import PageTitle from '@/components/pagetitle'
import Layout from '@/components/layout'
import SelectableLinkDemandCard from '@/components/SelectableLinkDemandCard'

function parseId(entity) {
    const url = entity._links.self.href;
    const id = url.substring(url.lastIndexOf('/')+1);
    return id;
}

export default function App() {
    const searchParams = useSearchParams()
    
    const [demand, setDemand] = useState(null);
    const [supplier, setSupplier] = useState(null);
    const [otherDemands, setOtherDemands] = useState(null);
    const [selectedOtherDemands, setSelectedOtherDemands] = useState([]);

    useEffect( () => {
        console.log("Change to selections: "+JSON.stringify(selectedOtherDemands));
        const domains = [];
        selectedOtherDemands.forEach((d) => {
            if(selectedOtherDemands.length > 2) {
                const button = document.getElementById("submitproposal");
                button.disabled = true;
                alert("Too many links");
                return;
            }
            if(domains.includes(d.domain)) {
                const button = document.getElementById("submitproposal");
                button.disabled = true;
                alert("Duplicate domain");
            }
            else {
                domains.push(d.domain);
                const button = document.getElementById("submitproposal");
                button.disabled = false;
            }
        });           
    }
    ), [selectedOtherDemands];

    const handleSubmit = (supplierId) => {

        const aggregateDemand = selectedOtherDemands.concat([demand]);
        const plPromises = [];

        const paidlinkUrl = "/.rest/paidlinks";
        aggregateDemand.forEach((ld) => {
            const plData = {
                "supplier": "/suppliers/"+supplierId,
                "linkDemand": "/linkdemands/"+ld.id
            }
            plPromises.push(fetch(paidlinkUrl, {
                method: 'POST',
                headers: {'Content-Type':'application/json'},
                body: JSON.stringify(plData)
            }));
        });
        
        const plLocations = []
        Promise.all(plPromises).then( (responses) => {
            responses.forEach( (resp) => {
                plLocations.push(resp.headers.get('Location'))
                }
            )
            const proposalUrl = "/.rest/proposals";
            const pData = {
                "paidLinks": plLocations,
                "dateCreated": new Date().toISOString()
            }
            fetch(proposalUrl, {
                method: 'POST',
                headers: {'Content-Type':'application/json'},
                body: JSON.stringify(pData)
            }).then( (resp) => {
                const locationUrl = resp.headers.get('Location')
                location.href = "/proposals/"+locationUrl.substring(locationUrl.lastIndexOf('/')+1);
            });
        });
    }

    useEffect(
        () => {
            if(searchParams.has('supplierId') && searchParams.has('linkDemandId')) {
                const supplierId = searchParams.get('supplierId')
                const linkDemandId = searchParams.get('linkDemandId')
                const demandUrl = "/.rest/linkdemands/"+ linkDemandId+"?projection=fullLinkDemand";
                const supplierUrl = "/.rest/suppliers/"+ supplierId+"?projection=fullSupplier";
                const otherDemandsUrl = "/.rest/linkdemands/search/findDemandForSupplierId?supplierId="
                                            + supplierId + "&linkdemandIdToIgnore="+linkDemandId+"&projection=fullLinkDemand";

                Promise.all([fetch(demandUrl), fetch(supplierUrl), fetch(otherDemandsUrl)])
                    .then(([resDemand, resSupplier, resOtherDemands]) => 
                        Promise.all([resDemand.json(), resSupplier.json(), resOtherDemands.json()])
                    )
                    .then(([dataDemand, dataSupplier, dataOtherDemands]) => {
                        dataDemand.id = linkDemandId; // eurgh... have to find a way to get spring data rest to include the IDs
                        setDemand(dataDemand);
                        setSupplier(dataSupplier);
                        setOtherDemands(dataOtherDemands);
                    });
                    
            }
        }, [searchParams]
    );   

    if(supplier && demand && otherDemands) {
        return (
            <Layout>
                    <PageTitle title="Proposal Staging"/>
                    <button id="submitproposal" className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded"
                        onClick={() => handleSubmit(searchParams.get('supplierId'))}>
                        Submit
                    </button>
                    <div className="grid grid-cols-2 gap-4">
                        <div>
                            <SupplierCard supplier={supplier}/>
                            <LinkDemandCard linkdemand={demand}/>
                        </div>
                        <div>
                            <p>Other matching demand:</p>
                            
                            {otherDemands.map( (d,index) => 
                                <SelectableLinkDemandCard 
                                        onSelectedHandler={() => {
                                            console.log("Selected");
                                            selectedOtherDemands.push(d);
                                            setSelectedOtherDemands([...selectedOtherDemands]);
                                        }} 
                                        onDeselectedHandler={() => {
                                            console.log("Deselected");
                                            const pos = selectedOtherDemands.indexOf(d);
                                            if(pos != -1)  selectedOtherDemands.splice(pos, 1);
                                            setSelectedOtherDemands([...selectedOtherDemands]);
                                        }} 
                                        key={index}>
                                    <LinkDemandCard linkdemand={d} />
                                </SelectableLinkDemandCard>
                                )}
                        </div>
                    </div>
            </Layout>
        );
    }
    else {
        return (<div>Loading...</div>);
    }
}