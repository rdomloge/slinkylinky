'use client'

import React, {useState, useEffect} from 'react'
import { useSession } from "next-auth/react";
import { useRouter } from 'next/router'

import ProposalListItem from "@/components/ProposalListItem";
import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/pagetitle";
import MonthsBack from "@/components/monthsBack";
import OwnerFilter from "@/components/OwnerFilter";
import Loading from '@/components/Loading';
import Divider from '@/components/divider';

export default function ListProposals() {
    const router = useRouter()
    const { data: session } = useSession();
    const [proposals, setProposals] = useState()
    const [personal, setPersonal] = useState()
    const [error, setError] = useState()

    const [completeProposals, setCompleteProposals] = useState();
    const [waitingForSupplier, setWaitingForSupplier] = useState();
    const [waitingForAdmin, setWaitingForAdmin] = useState();

    function isLeapYear(year) { 
        return (((year % 4 === 0) && (year % 100 !== 0)) || (year % 400 === 0)); 
    }
    
    function getDaysInMonth(year, month) {
        return [31, (isLeapYear(year) ? 29 : 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month];
    }
    
    function goBackMonths(date, value) {
        var d = new Date(date),
            n = date.getDate();
        d.setDate(1);
        d.setMonth(d.getMonth() - value);
        d.setDate(Math.min(n, getDaysInMonth(d.getFullYear(), d.getMonth())));
        return d;
    }

    function dd(i) {
        if(i > 9) return i;
        else  return "0"+i;
    }
    
    function buildUrl(minusMonths) {
        var date = new Date();
        if(minusMonths) {
            date = goBackMonths(date, minusMonths);
        }
        const firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
        const lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);

        const firstDateString = firstDay.getFullYear()+"-"+dd(firstDay.getMonth()+1)+"-01"
        const lastDateString = lastDay.getFullYear()+"-"+dd(lastDay.getMonth()+1)+"-"+dd(lastDay.getDate())


        const proposalsUrl = 
            "/.rest/proposalsupport/getProposalsWithOriginalSuppliers"+
            "?startDate="+firstDateString+"T00:00"+
            "&endDate="+lastDateString+"T23:59"+
            "&projection=fullProposal";
        return proposalsUrl;
    }
    
    
    function filterForThisUser(data) {
        if(personal) {
            const filteredProposals = data.filter( (p) => {
                return paidLinksContainsDemandForMe(p.paidLinks)
            })
            return filteredProposals
        }
        else {
            return data
        }
    }

    function paidLinksContainsDemandForMe(paidLinks) {
        if( ! session) return true;
        var forMe = false;
        paidLinks.forEach( pl => {if(pl.demand.createdBy === session.user.email) forMe = true});
        return forMe;
    }

    // filter proposals into 3 buckets for presentation
    function filterProposals(data) {

        const [waitingForSupplier, waitingForAdmin, complete] = data.reduce( (acc, p) => {
            const third = p.paidLinks[0].supplier.thirdParty;
            if( (!p.proposalAccepted && p.proposalSent && !third) || (third && !p.blogLive)) {
                acc[0].push(p)
            }
            else if(p.validated && (p.invoicePaid || third)) {
                acc[2].push(p)
            }
            else {
                acc[1].push(p)
            }
            return acc;
        }, [[],[],[]])
        setCompleteProposals(complete)
        setWaitingForSupplier(waitingForSupplier)
        setWaitingForAdmin(waitingForAdmin)
    }

    useEffect(
        () => {
            if(router.isReady) {

                const minusMonths = router.query.minusMonths
                
                fetch(buildUrl(minusMonths))
                    .then( (res) => {
                        if(!res.ok) {
                            throw new Error("Can't fetch proposals.")
                        }
                        return res.json()
                    })
                    .then( (data) => {

                        setProposals(filterForThisUser(data));
                        filterProposals(data);
                    })
                    .catch( (error) => setError(error.message));
            }
            
        }, [router.isReady, router.query.minusMonths, personal]
    );

    return (
        <Layout pagetitle='Proposals'>
            <PageTitle id="proposal-list-id" title="Proposals" count={proposals}/>
            <div className='block'>
                <MonthsBack/>
                <OwnerFilter changeHandler={ (e) => setPersonal(e)}/>
            </div>
            
            <Divider text={"Waiting for us"} size='text-3xl'/>

            {waitingForAdmin ?
                <ul>
                {waitingForAdmin.map( (p) => 
                    <li className="m-2" key={p.id}>
                        <ProposalListItem proposal={p}/>
                    </li>
                )}
                </ul>
            : 
                <Loading error={error}/>
            }
            
            
            <Divider text={"Waiting for them"} size='text-3xl'/>

            {waitingForSupplier ?
                <ul>
                {waitingForSupplier.map( (p) => 
                    <li className="m-2" key={p.id}>
                        <ProposalListItem proposal={p}/>
                    </li>
                )}
                </ul>
            : 
                <Loading error={error}/>
            }
            
            
            <Divider text={"Complete"} size='text-3xl'/>

            {completeProposals ?
                <ul>
                {completeProposals.map( (p) => 
                    <li className="m-2" key={p.id}>
                        <ProposalListItem proposal={p}/>
                    </li>
                )}
                </ul>
            : 
                <Loading error={error}/>
            }
        </Layout>
    );
}