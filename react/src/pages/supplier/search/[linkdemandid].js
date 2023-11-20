'use client'

import React, {useState, useEffect} from 'react'
import { useRouter } from 'next/router'
import LinkDemandCard from '@/components/linkdemand'
import SupplierCard from '@/components/supplier'

export default function App() {
    const router = useRouter()
    const [demand, setDemand] = useState(null);
    const [suppliers, setSuppliers] = useState(null);

    useEffect(
        () => {
            if(router.isReady) {
                const demandUrl = 'http://localhost:8080/linkdemands/'+ router.query.linkdemandid;
                fetch(demandUrl)
                    .then((response) => response.json())
                    .then((json) => setDemand(json));

                const suppliersUrl = 'http://localhost:8080/bloggers/search/findBloggersForLinkDemandId?linkDemandId='+ router.query.linkdemandid;
                fetch(suppliersUrl)
                    .then((response) => response.json())
                    .then((json) => setSuppliers(json));
        ***REMOVED*** 
            else {
                console.log('Router not ready yet')
        ***REMOVED***
    ***REMOVED***, [router.isReady]
    );

    return (
        <div>
            <LinkDemandCard linkdemand={demand} />
            <SupplierList suppliers={suppliers}/>
        </div>
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