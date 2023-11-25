'use client'

import React, {useState, useEffect} from 'react'
import { useRouter } from 'next/router'
import PageTitle from '@/components/pagetitle'
import Layout from '@/components/layout'
import SupplierCard from '@/components/suppliercard'
import LinkDemandCard from '@/components/linkdemandcard'
import TrafficLights from '@/components/ProposalTrafficLights'

export default function Proposal() {
    const router = useRouter()
    const [proposal, setProposal] = useState()
    const [paidLinks, setPaidLinks] = useState()
    const [supplier, setSupplier] = useState()
    const [linkDemands, setLinkDemands] = useState()

    function parseId(entity) {
        const url = entity._links.self.href;
        const id = url.substring(url.lastIndexOf('/')+1);
        return id;
    }

    useEffect(
        () => {
            if(router.isReady) {
                const proposalsUrl = "http://localhost:8080/proposals/"+router.query.proposalid;
                fetch(proposalsUrl).then( (res) => res.json()).then( (p) => setProposal(p));
            }
        }, [router.isReady]);
    
    useEffect(() => {
        if(proposal) {
            const paidLinksUrl = proposal._links.paidLinks.href;
            fetch(paidLinksUrl).then( (resp) => resp.json()).then((pl)=> setPaidLinks(pl));
        }
    }, [proposal])

    // get the supplier
    useEffect( () => {
        if(paidLinks) {
            fetch(paidLinks._embedded.paidlinks[0]._links.blogger.href).then( (res) => res.json()).then( (s) => setSupplier(s));
        }
    }, [paidLinks])

    // get the link demands
    useEffect( () => {
        if(paidLinks) {
            const linkDemandPromises = []
            paidLinks._embedded.paidlinks.forEach( (pl) => {linkDemandPromises.push(fetch(pl._links.linkDemand.href))})
            const jsonPromises = []
            Promise.all(linkDemandPromises)
                .then( (responses) => {
                    responses.forEach( (r) => jsonPromises.push(r.json()))
                    Promise.all(jsonPromises).then( (demandArr) => {
                        setLinkDemands(demandArr)
                    });
                });
        }
    }, [paidLinks])

    if(proposal && supplier && linkDemands) {
        return (
            <>
                <Layout>
                    <PageTitle title="Proposal"/>
                    <div>{proposal.dateCreated}</div>
                    <TrafficLights proposal={proposal}/>
                    <div className="grid grid-cols-3">
                        <div>
                            <SupplierCard supplier={supplier}/>
                        </div>
                        <div className="col-span-2">
                            {linkDemands.map( (ld) => <LinkDemandCard linkdemand={ld} key={parseId(ld)}/>)}
                        </div>
                    </div>
                </Layout>
            </>
        );
    }
    else {
        return <>Loading...</>
    }
}