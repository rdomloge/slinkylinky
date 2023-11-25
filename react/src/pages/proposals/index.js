'use client'

import ProposalListItem from "@/components/ProposalListItem";
import Layout from "@/components/layout";
import PageTitle from "@/components/pagetitle";
import Link from "next/link";
import React, {useState, useEffect} from 'react'

export default function ListProposals() {
    const [proposals, setProposals] = useState()
    const proposalsUrl = "http://localhost:8080/proposals";
    
    function parseId(entity) {
        const url = entity._links.self.href;
        const id = url.substring(url.lastIndexOf('/')+1);
        return id;
    }

    useEffect(
        () => {
            fetch(proposalsUrl)
                .then( (res) => res.json())
                .then( (data) => setProposals(data));
        }, []
    );

    if(proposals) {
        return (
            <Layout>
                <PageTitle title="Proposals"/>
                <ul>
                {proposals._embedded.proposals.map( (p) => 
                    <li className="m-2" key={parseId(p)}>
                        <Link href={"/proposals/"+parseId(p)}>
                        <ProposalListItem proposal={p}/>
                        </Link>
                    </li>
                )}
                </ul>
            </Layout>
        );
    }
    else {
        return <div>Loading...</div>
    }
}