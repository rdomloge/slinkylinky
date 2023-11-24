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
        <Layout>
            <PageTitle title="Matching suppliers"/>
            <LinkDemandCard linkdemand={demand} />
            <div>Suppliers</div>
            <SupplierList suppliers={suppliers} linkdemand={demand}/>
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
            {props.suppliers._embedded.bloggers.map((s) => (
                <a href={'/paidlink/staging?supplierId='+parseId(s)+'&linkDemandId='+parseId(props.linkdemand)} key={parseId(props.linkdemand)}>
                    <SupplierCard supplier={s} key={s.website} />
                </a>
            ))}
        </div>
    );
}