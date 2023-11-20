'use client'

import React, {useState, useEffect} from 'react'
import { useRouter } from 'next/router'
import LinkDemandCard from '@/components/linkdemandcard'
import SupplierCard from '@/components/suppliercard'

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
                    });
            } 
            else {
                console.log('Router not ready yet')
            }
        }, [router.isReady]
    );

    return (
        <div>
            <LinkDemandCard linkdemand={demand} />
            <h1>Matching suppliers</h1>
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