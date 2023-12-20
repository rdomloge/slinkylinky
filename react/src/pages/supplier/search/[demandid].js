'use client'

import React, {useState, useEffect} from 'react'
import { useRouter } from 'next/router'
import DemandCard from '@/components/demandcard'
import SupplierCard from '@/components/suppliercard'
import PageTitle from '@/components/pagetitle'
import Layout from '@/components/Layout'

export default function App() {
    const router = useRouter()
    const [demand, setDemand] = useState(null);
    const [suppliers, setSuppliers] = useState(null);
    const [existingLinkCount, setExistingLinkCount] = useState()

    useEffect(
        () => {
            if(router.isReady) {
                const demandUrl = "/.rest/demands/"+ router.query.demandid+"?projection=fullDemand";
                const suppliersUrl = "/.rest/suppliers/search/findSuppliersForDemandId?demandId="
                    + router.query.demandid+"&projection=fullSupplier";
                const existingLinkCountUrl = "/.rest/paidlinks/search/countByDemand_domain?domain="

                Promise.all([fetch(demandUrl), fetch(suppliersUrl)])
                    .then(([resDemand, resSuppliers]) => 
                        Promise.all([resDemand.json(), resSuppliers.json()])
                    )
                    .then(([dataDemand, dataSuppliers]) => {
                        setDemand(dataDemand);
                        setSuppliers(dataSuppliers);
                        fetch(existingLinkCountUrl+dataDemand.domain)
                            .then(resCount => resCount.json())
                            .then(count => setExistingLinkCount(count));
                    });
            }
        }, [router.isReady, router.query.demandid]
    );

    return (
        <Layout>
            <PageTitle title="Find a matching supplier"/>
            <div className='flex'>
                <div className='flex-1'>
                    <DemandCard demand={demand} />
                </div>
                <div className='card flex-none text-lg font-bold m-4 text-zinc-600'>There are <span className='text-5xl'>{existingLinkCount}</span> historical links tracked for this domain</div>
            </div>
            <div>Matching suppliers</div>
            <SupplierList suppliers={suppliers} demand={demand} demandid={router.query.demandid}/>
        </Layout>
    );
}

function parseId(entity) {
    const url = entity._links.self.href;
    const id = url.substring(url.lastIndexOf('/')+1);
    return id;
}

function SupplierList(props) {
    
    if(props.suppliers === null || props.demand === null) return <p>Loading...</p>;
    else return (
        <div className="grid grid-cols-3">
            {props.suppliers.map((s,index) => (
                <a href={'/paidlinks/staging?supplierId='+s.id+'&demandId='+props.demandid} key={index}>
                    <SupplierCard supplier={s} linkable={false}/>
                </a>
            ))}
        </div>
    );
}