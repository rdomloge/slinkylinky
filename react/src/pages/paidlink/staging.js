'use client'

import React, {useState, useEffect} from 'react'
import { useSearchParams } from 'next/navigation'
import LinkDemandCard from '@/components/linkdemandcard'
import SupplierCard from '@/components/suppliercard'
import PageTitle from '@/components/pagetitle'
import Layout from '@/components/layout'

export default function App() {
    const searchParams = useSearchParams()
    
    const [demand, setDemand] = useState(null);
    const [supplier, setSupplier] = useState(null);
    const [otherDemands, setOtherDemands] = useState(null);

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
                            <p>Other matching demand:</p>
                            {otherDemands._embedded.linkdemands.map( (d) => 
                                <LinkDemandCard linkdemand={d} />
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