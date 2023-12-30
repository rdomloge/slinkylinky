'use client'

import React, {useState, useEffect} from 'react'
import { useRouter } from 'next/router'
import PageTitle from '@/components/pagetitle'
import Layout from '@/components/Layout'
import SupplierCard from '@/components/suppliercard'
import DemandCard from '@/components/demandcard'
import TrafficLights from '@/components/ProposalTrafficLights'
import NiceDate from '@/components/atoms/DateTime'
import Link from 'next/link'
import Loading from '@/components/Loading'

export default function Proposal() {
    const router = useRouter()
    const [proposal, setProposal] = useState()
    const [supplier, setSupplier] = useState()
    const [demands, setDemands] = useState()
    const [error, setError] = useState(null)

    useEffect(
        () => {
            if(router.isReady) {
                const proposalsUrl = "/.rest/proposals/"+router.query.proposalid+"?projection=fullProposal";
                fetch(proposalsUrl)
                    .then( (res) => res.json())
                    .then( (p) => {
                        setProposal(p);
                        setDemands(p.paidLinks.map(pl => pl.demand))
                        setSupplier(p.paidLinks[0].supplier);
                ***REMOVED***)
                    .catch( (err) => setError(err));
        ***REMOVED***
    ***REMOVED***, [router.isReady, router.query.proposalid]);
    
    return (
            <Layout>
                <PageTitle title="Proposal"/>
                {proposal ?
                    <>
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
                            {demands.map( (ld) => <DemandCard demand={ld} key={ld.name}/>)}
                        </div>
                    </div>
                    </>
                :
                    <Loading error={error}/>
            ***REMOVED***
            </Layout>
    );
}