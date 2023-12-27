'use client'

import { useSession } from "next-auth/react";

import React, {useState, useEffect} from 'react'
import { useRouter } from 'next/router'
import DemandCard from '@/components/demandcard'
import SupplierCard from '@/components/suppliercard'
import PageTitle from '@/components/pagetitle'
import Layout from '@/components/Layout'
import SessionButton, { ClickHandlerButton } from '@/components/atoms/Button'
import Modal from '@/components/atoms/Modal'
import TextInput from '@/components/atoms/TextInput'
import { headers } from "../../../../next.config";

export default function App() {
    const router = useRouter()
    const { data: session } = useSession();

    const [demand, setDemand] = useState(null);
    const [suppliers, setSuppliers] = useState(null);
    const [existingLinkCount, setExistingLinkCount] = useState()
    const [showModal, setShowModal] = useState(false);
    const [newSupplierName, setNewSupplierName] = useState();

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
                ***REMOVED***);
        ***REMOVED***
    ***REMOVED***, [router.isReady, router.query.demandid]
    );

    function build3rdPartySupplier() {   
        const postData = {}
        postData.thirdParty = true
        postData.createdBy = session.user.email
        postData.name = newSupplierName
        return postData
***REMOVED***

    function buildPaidLink(newSupplierLocation) {
        
        const plData = {
            "supplier": newSupplierLocation,
            "demand": "/demands/"+demand.id
    ***REMOVED***
        return plData
***REMOVED***

    function buildProposal(plLocation) {
        const plLocations = [plLocation]
        const pData = {
            "paidLinks": plLocations,
            "dateCreated": new Date().toISOString(),
            "createdBy": session.user.email
    ***REMOVED***
        return pData
***REMOVED***

    function create3rdPartyProposal() {
        console.log("Creating 3rd party Supplier: "+newSupplierName);
        setShowModal(false);
        
        const supplierUrl = "/.rest/suppliers"
        fetch(supplierUrl, {
            method: 'POST',
            headers: {'Content-Type':'application/json'},
            body: JSON.stringify(build3rdPartySupplier())
    ***REMOVED***)
        .then( (resp) => {
            if(resp.ok) {
                const paidlinkUrl = "/.rest/paidlinks";
                return fetch(paidlinkUrl, {
                    method: 'POST',
                    headers: {'Content-Type':'application/json'},
                    body: JSON.stringify(buildPaidLink(resp.headers.get('Location')))
             ***REMOVED***)
        ***REMOVED***
            else {
                console.log("Created 3rd party supplier failed: "+JSON.stringify(resp));
        ***REMOVED***
    ***REMOVED***)
        .then( (resp) => {  
            if(resp.ok) {
                const proposalUrl = "/.rest/proposals";
                return fetch(proposalUrl, {
                    method: 'POST',
                    headers: {'Content-Type':'application/json'},
                    body: JSON.stringify(buildProposal(resp.headers.get('Location')))
            ***REMOVED***)
        ***REMOVED***
            else {
                console.log("Created paidlink failed: "+JSON.stringify(resp));
        ***REMOVED***
    ***REMOVED***)
        .then( (resp) => {
            if(resp.ok) {
                console.log("Created proposal");
                const locationUrl = resp.headers.get('Location')
                location.href = "/proposals/"+locationUrl.substring(locationUrl.lastIndexOf('/')+1);
        ***REMOVED***
            else {
                console.log("Created proposal failed: "+JSON.stringify(resp));
        ***REMOVED***
    ***REMOVED***)
***REMOVED***


    return (
        <Layout>
            <PageTitle title="Find a matching supplier"/>
            <div className='flex'>
                <div className='flex-1'>
                    <DemandCard demand={demand} />
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
        ***REMOVED***
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