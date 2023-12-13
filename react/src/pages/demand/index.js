'use client'

import React, {useState, useEffect} from 'react'
import { useSession } from "next-auth/react";
import LinkDemandCard from '@/components/linkdemandcard';
import PageTitle from '@/components/pagetitle'
import Layout from '@/components/layout';
import Link from 'next/link';
import OwnerFilter from '@/components/OwnerFilter';
import SessionButton from '@/components/Button';

export default function LinkDemand() {
    const [personal, setPersonal] = useState()
    const [linkDemands, setLinkDemands] = useState()
    const { data: session } = useSession();

    useEffect( () => {
        const url = "/.rest/linkdemands/search/findUnsatisfiedDemand?projection=fullLinkDemand"

        fetch(url)
            .then(res => res.json())
            .then((result) => setLinkDemands(filterPersonalIfNeeded(result)));

***REMOVED***, [personal]) 

    function filterPersonalIfNeeded(data) {
        if( ! session) return data;
        if(personal) {
            return data.filter( d => d.createdBy === session.user.email);
    ***REMOVED***
        else {
            return data;
    ***REMOVED***
***REMOVED***

    function parseId(linkdemand) {
        const url = linkdemand._links.self.href;
        const id = url.substring(url.lastIndexOf('/')+1);
        return id;
***REMOVED***

    if(linkDemands) {
        return (
            <Layout>
                <PageTitle title={"Demand ("+linkDemands.length+")"}/>
                <div className="inline-block content-center">
                    <Link href='/demand/Add'>
                        <SessionButton labelText="New"/>
                    </Link>
                </div>
                <OwnerFilter changeHandler={ (e) => setPersonal(e)}/>
                <div className="grid grid-cols-2">
                {linkDemands.map( (ld,index) => (
                    <div key={index}>
                        <LinkDemandCard linkdemand={ld} key={index} fullfilable={true} editable={true}/>
                    </div>
                ))}
                </div>
            </Layout>
        );
***REMOVED***
    else {
        return (<div>Loading...</div>);
***REMOVED***
}