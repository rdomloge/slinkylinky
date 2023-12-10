'use client'

import React, {useState, useEffect} from 'react'
import { useRouter } from 'next/router'
import PageTitle from '@/components/pagetitle'
import Layout from '@/components/layout'
import SupplierCard from '@/components/suppliercard'
import LinkDemandCard from '@/components/linkdemandcard'
import TrafficLights from '@/components/ProposalTrafficLights'
import NiceDate from '@/components/Date'
import Link from 'next/link'

export default function Proposal() {
    const router = useRouter()
    const [proposal, setProposal] = useState()
    const [supplier, setSupplier] = useState()
    const [linkDemands, setLinkDemands] = useState()

    useEffect(
        () => {
            if(router.isReady) {
                const proposalsUrl = "/proposals/"+router.query.proposalid+"?projection=fullProposal";
                fetch(proposalsUrl)
                    .then( (res) => res.json())
                    .then( (p) => {
                        setProposal(p);
                        setLinkDemands(p.paidLinks.map(pl => pl.linkDemand))
                        setSupplier(p.paidLinks[0].supplier);
                ***REMOVED***);
        ***REMOVED***
    ***REMOVED***, [router.isReady, router.query.proposalid]);
    
    if(proposal) {
        return (
            <>
                <Layout>
                    <PageTitle title="Proposal"/>
                    <div><NiceDate isostring={proposal.dateCreated}/></div>
                    <TrafficLights proposal={proposal} updateHandler={setProposal} interactive={true}/>
                    {proposal.blogLive ?
                        <div className="card grid grid-cols-3 m-4">
                            <span className='text-center font-extrabold text-lg col-span-2'>{proposal.liveLinkTitle}</span>
                            <span className='truncate'>
                                <Link href={proposal.liveLinkUrl} className='truncate'>
                                    {proposal.liveLinkUrl}
                                </Link>
                            </span>
                        </div>
                    : null}
                    <div className="grid grid-cols-3">
                        <div>
                            <SupplierCard supplier={supplier}/>
                            <div className="card list-card">
                                <div className="grid grid-cols-2">
                                    <span>Created</span> <NiceDate isostring={proposal.dateCreated}/>
                                    <span>Sent to supplier</span> <NiceDate isostring={proposal.dateSentToSupplier}/>
                                    <span>Accepted by supplier</span> <NiceDate isostring={proposal.dateAcceptedBySupplier}/>
                                    <span>Date invoice received</span> <NiceDate isostring={proposal.dateInvoiceReceived}/>
                                    <span>Date invoice paid</span> <NiceDate isostring={proposal.dateInvoicePaid}/>
                                    <span>Blog live</span> <NiceDate isostring={proposal.dateBlogLive}/>
                                </div>
                            </div>
                        </div>
                        <div className="col-span-2">
                            {linkDemands.map( (ld) => <LinkDemandCard linkdemand={ld} key={ld.name}/>)}
                        </div>
                    </div>
                </Layout>
            </>
        );
***REMOVED***
    else {
        return <>Loading...</>
***REMOVED***
}