'use client'

import React, {useState, useEffect} from 'react'
import { useRouter } from 'next/router'
import LinkDemandCard from '@/components/linkdemand'
import SupplierCard from '@/components/supplier'

export default function App() {
    const router = useRouter()
    const [demand, setDemand] = useState(null);

    useEffect(
        () => {
            if(router.isReady) {
                const demandUrl = 'http://localhost:8080/linkdemands/'+ router.query.linkdemandid;
                console.log(demandUrl);
                fetch(demandUrl)
                    .then((response) => response.json())
                    .then((json) => setDemand(json));
        ***REMOVED*** 
            else {
                console.log('Router not ready yet')
        ***REMOVED***
    ***REMOVED***, [router.isReady]
    );

    return (
        <div>
            <LinkDemandCard linkdemand={demand} />
            <SupplierList/>
        </div>
    );
}

function SupplierList() {
    const router = useRouter()
    const [suppliers, setSuppliers] = useState(null);
    

    useEffect(
        () => {
            if(router.isReady) {
                const suppliersUrl = 'http://localhost:8080/bloggers/search/findBloggersForLinkDemandId?linkDemandId='+ router.query.linkdemandid;
                console.log(suppliersUrl)
                fetch(suppliersUrl)
                    .then((response) => response.json())
                    .then((json) => setSuppliers(json));
        ***REMOVED*** 
            else {
                console.log('Router not ready yet')
        ***REMOVED***
    ***REMOVED***, [router.isReady]
    );

    if(suppliers === null) return <p>Loading...</p>;
    else return (
        <div>
            {suppliers._embedded.bloggers.map((s) => <SupplierCard supplier={s} key={s.website} />)}
        </div>
    );
}