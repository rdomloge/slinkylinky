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
            if(domains.includes(d.domain)) {
                const button = document.getElementById("submitproposal");
                button.disabled = true;
        ***REMOVED***
            else {
                domains.push(d.domain);
                const button = document.getElementById("submitproposal");
                button.disabled = false;
        ***REMOVED***
    ***REMOVED***);           
***REMOVED***
    ), [selectedOtherDemands];

    const handleSubmit = () => {
        console.log("CLICK");
        console.log("Supplier: "+supplier);
        console.log("Demand: "+demand);
        console.log("Other demand: "+otherDemands);

        const url = "http://localhost:8080/proposals";
        const data = {
            "supplier": supplier,
            "demands": selectedOtherDemands.concat([demand]) 
    ***REMOVED***
        fetch(url, {
            method: 'POST',
            body: JSON.stringify(data)
    ***REMOVED***);
***REMOVED***

    useEffect(
        () => {
            if(searchParams.has('supplierId') && searchParams.has('linkDemandId')) {
                const supplierId = searchParams.get('supplierId')
                const linkDemandId = searchParams.get('linkDemandId')
                const demandUrl = 'http://localhost:8080/linkdemands/'+ linkDemandId;
                const supplierUrl = 'http://localhost:8080/bloggers/'+ supplierId;
                const otherDemandsUrl = 'http://localhost:8080/linkdemands/search/findDemandForSupplierId?supplierId='
                                            + supplierId +'&linkdemandIdToIgnore='+linkDemandId;

                Promise.all([fetch(demandUrl), fetch(supplierUrl), fetch(otherDemandsUrl)])
                    .then(([resDemand, resSupplier, resOtherDemands]) => 
                        Promise.all([resDemand.json(), resSupplier.json(), resOtherDemands.json()])
                    )
                    .then(([dataDemand, dataSupplier, dataOtherDemands]) => {
                        setDemand(dataDemand);
                        setSupplier(dataSupplier);
                        setOtherDemands(dataOtherDemands);
                ***REMOVED***);
                    
        ***REMOVED***
    ***REMOVED***, [searchParams]
    );   

    if(supplier && demand && otherDemands) {
        return (
            <Layout>
                    <PageTitle title="Staging"/>
                    <div className="grid grid-cols-2 gap-4">
                        <div>
                            <SupplierCard supplier={supplier}/>
                            <LinkDemandCard linkdemand={demand}/>
                        </div>
                        <div>
                            
                            <div className="absolute top-4 right-4">
                                <button id="submitproposal" onClick={handleSubmit} className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded">
                                    Submit
                                </button>
                            </div>
                            
                            <p>Other matching demand:</p>
                            
                            {otherDemands._embedded.linkdemands.map( (d) => 
                                <SelectableLinkDemandCard 
                                        onSelectedHandler={() => {
                                            console.log("Selected");
                                            selectedOtherDemands.push(d);
                                            setSelectedOtherDemands([...selectedOtherDemands]);
                                    ***REMOVED***} 
                                        onDeselectedHandler={() => {
                                            console.log("Deselected");
                                            const pos = selectedOtherDemands.indexOf(d);
                                            if(pos != -1)  selectedOtherDemands.splice(pos, 1);
                                            setSelectedOtherDemands([...selectedOtherDemands]);
                                    ***REMOVED***} 
                                        key={parseId(d)}>
                                    <LinkDemandCard linkdemand={d} />
                                </SelectableLinkDemandCard>
                                )}
                        </div>
                    </div>
            </Layout>
        );
***REMOVED***
    else {
        return (<div>Loading...</div>);
***REMOVED***
}