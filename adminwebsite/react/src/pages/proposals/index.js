'use client'

import React, {useState, useEffect} from 'react'
import { useSession } from "next-auth/react";
import { useRouter } from 'next/router'

import ProposalListItem from "@/components/ProposalListItem";
import Layout from "@/components/layout/Layout";
import PageTitle from "@/components/pagetitle";
import MonthsBack from "@/components/monthsBack";
import Loading from '@/components/Loading';
import Divider from '@/components/divider';
import Link from 'next/link';
import FiltersPanel from '@/components/filters';
import { Toggle } from '@/components/atoms/Toggle';
import { fetchWithAuth } from '@/utils/fetchWithAuth';


export default function ListProposals() {
    const router = useRouter()
    const [proposals, setProposals] = useState()
    const [error, setError] = useState()

    const [completeProposals, setCompleteProposals] = useState([]);
    const [waitingForSupplier, setWaitingForSupplier] = useState([]);
    const [waitingForAdmin, setWaitingForAdmin] = useState([]);
    const [unpaidfilter, setUnpaidFilter] = useState(false);

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

    function applyUnpaidFilter() {
        if(unpaidfilter) {
            setUnpaidFilter(false);
            filterProposals(proposals);
        }
        else {
            setUnpaidFilter(true);
            setCompleteProposals([]);
            setWaitingForSupplier([]);
            const [unpaid] = proposals.reduce( (acc, p) => {
                if(!p.invoicePaid && p.validated && p.proposalSent && !p.paidLinks[0].supplier.thirdParty && p.blogLive && p.proposalAccepted) {
                    acc[0].push(p)
                }
                return acc;
            }, [[]])
            setWaitingForAdmin(unpaid)
        }
        
    }

    useEffect(
        () => {
            if(router.isReady) {

                const minusMonths = router.query.minusMonths
                
                fetchWithAuth(buildUrl(minusMonths))
                    .then( (res) => {
                        if(!res.ok) {
                            throw new Error("Can't fetch proposals.")
                        }
                        return res.json()
                    })
                    .then( (data) => {
                        filterProposals(data);
                        setProposals(data);
                    })
                    .catch( (error) => setError(error.message));
            }
            
        }, [router.isReady, router.query.minusMonths]
    );

    return (
        <Layout pagetitle='Proposals'>
            <PageTitle id="proposal-list-id" title="Proposals" count={proposals}/>
            <div className='block'>
                <MonthsBack/>
            </div>
            <FiltersPanel>
                <Toggle initialValue={unpaidfilter} changeHandler={applyUnpaidFilter} label={"Unpaid"}/>
            </FiltersPanel>
            <nav className='sticky top-0 border-b-2 bg-white pb-4 ps-1'>
                <Link href={"#waiting-for-us"}>{waitingForAdmin.length + " needing attention, "} </Link>
                <Link href={"#waiting-for-them"}>{waitingForSupplier.length + " need chasing, "} </Link>
                <Link href={"#complete-proposals"}>{completeProposals.length + " complete"} </Link>
            </nav>
            
            <Divider text={"Waiting for us"} size='text-3xl' id='waiting-for-us'/>

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
            
            
            <Divider text={"Waiting for them"} size='text-3xl' id='waiting-for-them'/>

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
            
            
            <Divider text={"Complete"} size='text-3xl' id='complete-proposals'/>

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