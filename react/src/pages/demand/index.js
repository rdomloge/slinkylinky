'use client'

import React, {useState, useEffect} from 'react'
import { useSession } from "next-auth/react";
import LinkDemandCard from '@/components/linkdemandcard';
import PageTitle from '@/components/pagetitle'
import Layout from '@/components/layout';
import Link from 'next/link';
import OwnerFilter from '@/components/OwnerFilter';
import SessionButton from '@/components/atoms/Button';
import Select from '@/components/atoms/Select';

export default function LinkDemand() {
    const [personal, setPersonal] = useState()
    const [linkDemands, setLinkDemands] = useState()
    const { data: session } = useSession();
    const [sortCol, setSortCol] = useState();

    useEffect( () => {
        const requestedOrderUrl = "/.rest/linkdemands/search/findUnsatisfiedDemandOrderedByRequested?projection=fullLinkDemand"
        const daNeededOrderUrl = "/.rest/linkdemands/search/findUnsatisfiedDemandOrderedByDaNeeded?projection=fullLinkDemand"
        const url = sortCol === "daNeeded" ? daNeededOrderUrl : requestedOrderUrl;

        fetch(url)
            .then(res => res.json())
            .then((result) => setLinkDemands(filterPersonalIfNeeded(result)));

***REMOVED***, [personal, sortCol]) 

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
                <Select label="Sort" changeHandler={ (e) => setSortCol(e)} selected={sortCol}
                    options={[{value: "requested", name: "Requested (ASC)"}, {value: "daNeeded", name: "DA (DESC)"}]}/>
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