'use client'

import React, {useState, useEffect} from 'react'
import { useSession } from "next-auth/react";
import DemandCard from '@/components/demandcard';
import PageTitle from '@/components/pagetitle'
import Layout from '@/components/layout/Layout';
import Link from 'next/link';
import OwnerFilter from '@/components/OwnerFilter';
import SessionButton from '@/components/atoms/Button';
import Select from '@/components/atoms/Select';
import Loading from '@/components/Loading';

export default function Demand() {
    const [personal, setPersonal] = useState()
    const [demands, setDemands] = useState()
    const { data: session } = useSession();
    const [sortCol, setSortCol] = useState();
    const [error, setError] = useState();

    useEffect( () => {
        const storedSortOrder = window.localStorage.getItem("demandSortOrder");
        if(storedSortOrder) {
            setSortCol(storedSortOrder);
        }
    }, [] )

    useEffect( () => {
        
        const requestedOrderUrl = "/.rest/demands/search/findUnsatisfiedDemandOrderedByRequested?projection=fullDemand"
        const daNeededOrderUrl = "/.rest/demands/search/findUnsatisfiedDemandOrderedByDaNeeded?projection=fullDemand"
        const url = (sortCol) === "daNeeded" ? daNeededOrderUrl : requestedOrderUrl;

        fetch(url)
            .then(res => res.json())
            .then((result) => setDemands(filterPersonalIfNeeded(result)))
            .catch((error) => {
                setError(error);
            });

    }, [personal, sortCol]) 

    function filterPersonalIfNeeded(data) {
        if( ! session) return data;
        if(personal) {
            return data.filter( d => d.createdBy === session.user.email);
        }
        else {
            return data;
        }
    }

    function setSortOrder(e) {
        setSortCol(e);
        window.localStorage.setItem("demandSortOrder", e);
    }

    function parseId(demand) {
        const url = demand._links.self.href;
        const id = url.substring(url.lastIndexOf('/')+1);
        return id;
    }

    function buildSortOptions() {
        return [
            {value: "requested", name: "Requested (ASC)"}, 
            {value: "daNeeded", name: "DA (DESC)"}
        ]
    }

    return (
        <Layout>
            <PageTitle title="Demand" count={demands}/>
            <div className="inline-block content-center">
                <Link href='/demand/Add'>
                    <SessionButton label="New"/>
                </Link>
            </div>
            <OwnerFilter changeHandler={ (e) => setPersonal(e)}/>
            <Select label="Sort" changeHandler={ (e) => setSortOrder(e)} value={sortCol}
                options={buildSortOptions()}/>

            {demands ? 
                <div className="grid grid-cols-2">
                {demands.map( (ld,index) => (
                    <div key={index}>
                        <DemandCard demand={ld} key={index} fullfilable={true} editable={true}/>
                    </div>
                ))}
                </div>
            : 
                <Loading error={error}/>
            }
        </Layout>
    );
    
}