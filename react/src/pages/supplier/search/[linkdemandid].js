'use client'

import React, {useState, useEffect} from 'react'
import { useRouter } from 'next/router'
import LinkDemandCard from '@/components/linkdemandcard'
import SupplierCard from '@/components/suppliercard'
import PageTitle from '@/components/pagetitle'

export default function App() {
    const router = useRouter()
    const [demand, setDemand] = useState(null);
    const [suppliers, setSuppliers] = useState(null);

    useEffect(
        () => {
            if(router.isReady) {
                const demandUrl = 'http://localhost:8080/linkdemands/'+ router.query.linkdemandid;
                const suppliersUrl = 'http://localhost:8080/bloggers/search/findBloggersForLinkDemandId?linkDemandId='+ router.query.linkdemandid;

                Promise.all([fetch(demandUrl), fetch(suppliersUrl)])
                    .then(([resDemand, resSuppliers]) => 
                        Promise.all([resDemand.json(), resSuppliers.json()])
                    )
                    .then(([dataDemand, dataSuppliers]) => {
                        setDemand(dataDemand);
                        setSuppliers(dataSuppliers);
                ***REMOVED***);
        ***REMOVED*** 
            else {
                console.log('Router not ready yet')
        ***REMOVED***
    ***REMOVED***, [router.isReady]
    );

    return (
        <main className="flex min-h-screen flex-col justify-between p-10">
            <PageTitle title="Matching suppliers"/>
            <LinkDemandCard linkdemand={demand} />
            <div>Suppliers</div>
            <SupplierList suppliers={suppliers} />
        </main>
    );
}

function SupplierList({suppliers}) {
    
    if(suppliers === null) return <p>Loading...</p>;
    else return (
        <div>
            {suppliers._embedded.bloggers.map((s) => <SupplierCard supplier={s} key={s.website} />)}
        </div>
    );
}