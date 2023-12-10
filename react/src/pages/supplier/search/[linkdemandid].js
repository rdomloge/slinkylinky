'use client'

import React, {useState, useEffect} from 'react'
import { useRouter } from 'next/router'
import LinkDemandCard from '@/components/linkdemandcard'
import SupplierCard from '@/components/suppliercard'
import PageTitle from '@/components/pagetitle'
import Layout from '@/components/layout'

export default function App() {
    const router = useRouter()
    const [demand, setDemand] = useState(null);
    const [suppliers, setSuppliers] = useState(null);
    const [existingLinkCount, setExistingLinkCount] = useState()

    useEffect(
        () => {
            if(router.isReady) {
                const demandUrl = "/linkdemands/"+ router.query.linkdemandid+"?projection=fullLinkDemand";
                const suppliersUrl = "/suppliers/search/findSuppliersForLinkDemandId?linkDemandId="
                    + router.query.linkdemandid+"&projection=fullSupplier";
                const existingLinkCountUrl = "/paidlinks/search/countByLinkDemand_domain?domain="

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
                ***REMOVED***);
        ***REMOVED***
    ***REMOVED***, [router.isReady, router.query.linkdemandid]
    );

    return (
        <Layout>
            <PageTitle title="Find a matching supplier"/>
            <div className='flex'>
                <div className='flex-1'>
                    <LinkDemandCard linkdemand={demand} />
                </div>
                <div className='card flex-none text-lg font-bold m-4 text-zinc-600'>There are <span className='text-5xl'>{existingLinkCount}</span> historical links tracked for this domain</div>
            </div>
            <div>Matching suppliers</div>
            <SupplierList suppliers={suppliers} linkdemand={demand} linkdemandid={router.query.linkdemandid}/>
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
        <div>
            {props.suppliers.map((s,index) => (
                <a href={'/paidlinks/staging?supplierId='+s.id+'&linkDemandId='+props.linkdemandid} key={index}>
                    <SupplierCard supplier={s} />
                </a>
            ))}
        </div>
    );
}