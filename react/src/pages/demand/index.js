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
    const [error, setError] = useState();

    useEffect( () => {

        const storedSortOrder = window.localStorage.getItem("demandSortOrder");
        
        const requestedOrderUrl = "/.rest/demands/search/findUnsatisfiedDemandOrderedByRequested?projection=fullDemand"
        const daNeededOrderUrl = "/.rest/demands/search/findUnsatisfiedDemandOrderedByDaNeeded?projection=fullDemand"
        const url = (storedSortOrder) === "daNeeded" ? daNeededOrderUrl : requestedOrderUrl;

        fetch(url)
            .then(res => res.json())
            .then((result) => setDemands(filterPersonalIfNeeded(result)))
            .catch((error) => {
                setError(error.message);
            });

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

    function setSortOrder(e) {
        window.localStorage.setItem("demandSortOrder", e);
    }

    function buildSortOptions() {
        return [
            {value: "requested", name: "Requested (ASC)"}, 
            {value: "daNeeded", name: "DA (DESC)"}
        ]
    }

    function demandDeleteHandler(demand) {
        setDemands(demands.filter( d => d.id !== demand.id));
    }

    return (
        <Layout pagetitle="Demand">
            <PageTitle id="demand-list-id" title="Demand" count={demands}/>
            <div className="inline-block content-center pl-4">
                <Link href='/demand/Add' rel='nofollow'>
                    <SessionButton label="New"/>
                </Link>
            </div>
            <div className="block pt-4">
                <OwnerFilter changeHandler={ (e) => setPersonal(e)}/>
                <Select label="Sort" changeHandler={ (e) => setSortOrder(e)}
                    options={buildSortOptions()}/>
            </div>

            {demands ? 
                <div className="grid grid-cols-2">
                {demands.map( (ld,index) => (
                    <div key={index}>
                        <DemandCard demand={ld} key={index} fullfilable={true} editable={true} id={"demandCard-"+index} deleteCascader={()=>demandDeleteHandler(ld)}/>
                    </div>
                ))}
                </div>
            : 
                <Loading error={error}/>
            }
        </Layout>
    );
    
}