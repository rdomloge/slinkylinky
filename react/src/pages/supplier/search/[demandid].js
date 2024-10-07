'use client'

import { useSession } from "next-auth/react";

import React, {useState, useEffect} from 'react'
import { useRouter } from 'next/router'

import DemandCard from '@/components/demandcard'
import SupplierCard from '@/components/suppliercard'
import PageTitle from '@/components/pagetitle'
import Layout from '@/components/layout/Layout'
import SessionButton, { ClickHandlerButton, StyledButton } from '@/components/atoms/Button'
import Modal from '@/components/atoms/Modal'
import TextInput from '@/components/atoms/TextInput'
import Loading from "@/components/Loading";

export default function App() {
    const router = useRouter()
    const { data: session } = useSession();

    const [demand, setDemand] = useState(null);
    const [suppliers, setSuppliers] = useState(null);
    const [existingLinkCount, setExistingLinkCount] = useState()
    const [showModal, setShowModal] = useState(false);
    const [newSupplierName, setNewSupplierName] = useState();
    const [supplierUsageCount, setSupplierUsageCount] = useState();
    const [error, setError] = useState();

    useEffect(
        () => {
            if(router.isReady) {
                const demandUrl = "/.rest/demands/"+ router.query.demandid+"?projection=fullDemand";
                const suppliersUrl = "/.rest/suppliers/search/findSuppliersForDemandId?demandId="
                    + router.query.demandid+"&projection=fullSupplier";
                const existingLinkCountUrl = "/.rest/paidlinks/search/countByDemand_domain?domain="
                const supplierUsageCountUrl = "/.rest/paidlinksupport/getcountsforsuppliers?supplierIds="

                Promise.all([fetch(demandUrl), fetch(suppliersUrl)])
                    .then(([resDemand, resSuppliers]) => {
                        if(!resDemand.ok || !resSuppliers.ok) {
                            if(!resDemand.ok) throw new Error("Could not load demand")
                            if(!resSuppliers.ok) throw new Error("Could not load supplier")
                        }
                        return Promise.all([resDemand.json(), resSuppliers.json()])
                    })
                    .then(([dataDemand, dataSuppliers]) => {
                        setDemand(dataDemand);
                        setSuppliers(dataSuppliers);
                        fetch(existingLinkCountUrl+dataDemand.domain)
                            .then(resCount => resCount.json())
                            .then(count => setExistingLinkCount(count));
                        
                        var usageUrl = supplierUsageCountUrl;
                        dataSuppliers.forEach((s,index) => usageUrl += s.id + (index < dataSuppliers.length-1 ? "," : ""));
                        fetch(usageUrl)
                            .then(resCount => resCount.json())
                            .then(counts => {
                                setSupplierUsageCount(counts)
                            })
                    })
                    // .catch((error) => {
                    //     if (typeof error === 'string' || error instanceof String) { 
                    //         setError(error);
                    //     }
                    //     else {
                    //         setError(error.message);
                    //     }
                    // })
            }
        }, [router.isReady, router.query.demandid]
    );

    function create3rdPartyProposal() {
        console.log("Creating 3rd party Supplier: "+newSupplierName);
        setShowModal(false);

        const combiUrl = "/.rest/proposalsupport/resolveProposal3rdParty?name="+newSupplierName+"&demandId="+demand.id

        fetch(combiUrl, {
            method: 'POST',
            headers: {'Content-Type':'application/json', 'user': session.user.email}
        })
        .then( (resp) => {
            if(resp.ok) {
                console.log("Created proposal");
                const locationUrl = resp.headers.get('Location')
                location.href = "/proposals/"+locationUrl.substring(locationUrl.lastIndexOf('/')+1);
            }
            else {
                console.log("Created proposal failed: "+JSON.stringify(resp));
            }
        })
    }

    return (
        <Layout pagetitle="Supplier search">
            <PageTitle id="supplier-search-id"  title="Find a matching supplier"/>
            {error || !demand ? 
                <Loading error={error}/> 
            : 
                <>
                <div className='flex'>
                    <div className='flex-1'>
                        {demand ?
                            <DemandCard demand={demand} />
                        : null}
                    </div>
                    <div className='card flex-none text-lg font-bold m-4 text-zinc-600'>
                        There are 
                        <span className='text-5xl'> {existingLinkCount} </span> 
                        historical links tracked for this domain
                        <div className='mt-4'>
                            <SessionButton label="Use 3rd party" clickHandler={(e) => setShowModal(true)}/>
                        </div>
                    </div>
                </div>
                {showModal ?
                    <Modal dismissHandler={()=>setShowModal(false)} title="3rd Party options" >
                        <TextInput label="Supplier name" changeHandler={(e)=>setNewSupplierName(e)}/>
                        <div className='mt-4'>
                            <ClickHandlerButton label="Create" clickHandler={()=>create3rdPartyProposal()}/>
                        </div>
                    </Modal>
                : 
                    null
                }
                <div>Matching suppliers</div>
                {suppliers ?
                    <SupplierList suppliers={suppliers} demand={demand} 
                        demandid={router.query.demandid} usages={supplierUsageCount}/>
                : 
                    null
                }
                </>
            }
        </Layout>
    );
}

function selectSupplier(s, props) {
    window.location.href="/paidlinks/staging?supplierId="+s.id+"&demandId="+props.demandid
}

function SupplierList(props) {
    
    if(props.suppliers === null || props.demand === null) return <p>Loading...</p>;
    else return (
        <div className="grid grid-cols-3">
            {props.suppliers.map((s,index) => (
                <div key={index} id={"selectableSupplierCard-"+index}>
                    <div className="top-10 right-10 relative float-right z-50">
                        <StyledButton id="supplier-selectbtn-id"
                            label="Select" 
                            submitHandler={()=>{selectSupplier(s,props)}} 
                            isText={true} 
                            key={index} 
                            type="secondary" 
                            extraClass="text-xl font-bold"/>
                    </div>
                    <SupplierCard supplier={s} linkable={true} usages={props.usages}/>
                </div>
            ))}
        </div>
    );
}