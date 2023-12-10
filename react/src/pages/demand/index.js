'use client'

import React, {useState, useEffect} from 'react'
import { useSession } from "next-auth/react";
import LinkDemandCard from '@/components/linkdemandcard';
import PageTitle from '@/components/pagetitle'
import Layout from '@/components/layout';
import Link from 'next/link';
import OwnerFilter from '@/components/OwnerFilter';

export default function LinkDemand() {
    const [personal, setPersonal] = useState()
    const [linkDemands, setLinkDemands] = useState()
    const { data: session } = useSession();

    useEffect( () => {
        const url = "/linkdemands/search/findUnsatisfiedDemand?projection=fullLinkDemand"

        fetch(url)
            .then(res => res.json())
            .then((result) => setLinkDemands(filterPersonalIfNeeded(result)));

    }, [personal]) 

    function filterPersonalIfNeeded(data) {
        if( ! session) return data;
        if(personal) {
            return data.filter( d => d.createdBy === session.user.email);
        }
        else {
            return data;
        }
    }

    function parseId(linkdemand) {
        const url = linkdemand._links.self.href;
        const id = url.substring(url.lastIndexOf('/')+1);
        return id;
    }

    if(linkDemands) {
        return (
            <Layout>
                <PageTitle title={"Demand ("+linkDemands.length+")"}/>
                <div className="inline-block content-center">
                    <Link href='/demand/Add'>
                        <button id="createnew" disabled={!session}
                            className={"text-white font-bold py-2 px-4 border border-blue-700 rounded "
                                +(session ? "bg-blue-500 hover:bg-blue-700" : "bg-grey-500 hover:bg-grey-700")}>
                            New
                        </button>
                    </Link>
                </div>
                <OwnerFilter changeHandler={ (e) => setPersonal(e)}/>
                <div className="grid grid-cols-2">
                {linkDemands.map( (ld,index) => (
                    <div key={"li-"+index}>
                        <LinkDemandCard linkdemand={ld} key={index} active={true}/>
                    </div>
                ))}
                </div>
            </Layout>
        );
    }
    else {
        return (<div>Loading...</div>);
    }
}