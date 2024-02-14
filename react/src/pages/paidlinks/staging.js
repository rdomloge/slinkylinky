'use client'

import React, {useState, useEffect} from 'react'
import { useSearchParams } from 'next/navigation'
import { useSession } from "next-auth/react";

import DemandCard from '@/components/demandcard'
import SupplierCard from '@/components/suppliercard'
import PageTitle from '@/components/pagetitle'
import Layout from '@/components/layout/Layout'
import SelectableDemandCard from '@/components/SelectableDemandCard'
import Loading from '@/components/Loading';
import ErrorMessage from '@/components/atoms/Messages';
import ProposalValidationPanel from '@/components/ProposalWarnings';
import { ClickHandlerButton } from '@/components/atoms/Button';

function parseId(entity) {
    const url = entity._links.self.href;
    const id = url.substring(url.lastIndexOf('/')+1);
    return id;
}

export default function App() {
    const { data: session } = useSession();
    const searchParams = useSearchParams()
    
    const [demand, setDemand] = useState(null);
    const [supplier, setSupplier] = useState(null);
    const [otherDemands, setOtherDemands] = useState(null);
    const [selectedOtherDemands, setSelectedOtherDemands] = useState([]);
    const [error, setError] = useState(null);
    const [ready, setReady] = useState(false);

    
    const handleSubmit = (supplierId) => {

        const aggregateDemand = selectedOtherDemands.concat([demand]);
        const proposalUrl = "/.rest/proposalsupport/createProposal?supplierId=" + supplierId + "&demandIds=" + aggregateDemand.map((d) => d.id).join(',');

        fetch(proposalUrl, {
            method: 'POST',
            headers: {'Content-Type':'application/json', 'user': session.user.email},
        })
        .then( (resp) => {
            if(resp.ok) {
                const locationUrl = resp.headers.get('Location')
                location.href = "/proposals/"+locationUrl.substring(locationUrl.lastIndexOf('/')+1);
            }
            else {
                setError("Could not create proposal: "+resp.statusText)
            }
        });
    }

    useEffect(
        () => {
            if(searchParams.has('supplierId') && searchParams.has('demandId')) {
                const supplierId = searchParams.get('supplierId')
                const demandId = searchParams.get('demandId')
                const demandUrl = "/.rest/demands/"+ demandId+"?projection=fullDemand";
                const supplierUrl = "/.rest/suppliers/"+ supplierId+"?projection=fullSupplier";
                const otherDemandsUrl = "/.rest/demands/search/findDemandForSupplierId?supplierId="
                                            + supplierId + "&demandIdToIgnore="+demandId+"&projection=fullDemand";
                
                Promise.all([fetch(demandUrl), fetch(supplierUrl), fetch(otherDemandsUrl)])
                    .then(([resDemand, resSupplier, resOtherDemands]) => 
                        Promise.all([resDemand.json(), resSupplier.json(), resOtherDemands.json()])
                    )
                    .then(([dataDemand, dataSupplier, dataOtherDemands]) => {
                        dataDemand.id = demandId; // eurgh... have to find a way to get spring data rest to include the IDs
                        setDemand(dataDemand);
                        setSupplier(dataSupplier);
                        setOtherDemands(dataOtherDemands);
                    })
                    .catch((error) => {
                        setError(error);
                    });
                    
            }
        }, [searchParams]
    );   

    return (
        <Layout>
            <PageTitle title="Proposal Staging"/>
            
            <ClickHandlerButton label="Submit" clickHandler={() => handleSubmit(searchParams.get('supplierId'))} disabled={!ready} id={"submitProposal"}/>

            {( !error && supplier && demand && otherDemands) ?
                <>
                <ProposalValidationPanel primaryDemand={demand} 
                    otherDemands={selectedOtherDemands} 
                    supplier={supplier}
                    readinessCallback={(ready) => { 
                        // const button = document.getElementById("submitproposal");
                        // button.disabled = !ready;
                        setReady(ready);
                     }}
                    />
                <div className="grid grid-cols-2 gap-4">
                    <div>
                        <SupplierCard supplier={supplier}/>
                        <DemandCard demand={demand}/>
                    </div>
                    <div>
                        <p>Other matching demand:</p>
                        
                        {otherDemands.map( (d,index) => 
                            <SelectableDemandCard 
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
                                <DemandCard demand={d} />
                            </SelectableDemandCard>
                            )}
                    </div>
                </div>
                </>
            : 
                <Loading error={error} />
            }

        </Layout>
    );
}
