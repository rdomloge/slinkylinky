'use client'

import ProposalListItem from "@/components/ProposalListItem";
import Layout from "@/components/layout";
import PageTitle from "@/components/pagetitle";
import Link from "next/link";
import React, {useState, useEffect} from 'react'
import { useRouter } from 'next/router'
import MonthsBack from "@/components/monthsBack";

export default function ListProposals() {
    const [proposals, setProposals] = useState()
    const router = useRouter()

    function isLeapYear(year) { 
        return (((year % 4 === 0) && (year % 100 !== 0)) || (year % 400 === 0)); 
***REMOVED***
    
    function getDaysInMonth(year, month) {
        return [31, (isLeapYear(year) ? 29 : 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month];
***REMOVED***
    
    function goBackMonths(date, value) {
        var d = new Date(date),
            n = date.getDate();
        d.setDate(1);
        d.setMonth(d.getMonth() - value);
        d.setDate(Math.min(n, getDaysInMonth(d.getFullYear(), d.getMonth())));
        return d;
***REMOVED***

    function dd(i) {
        if(i > 9) return i;
        else  return "0"+i;
***REMOVED***
    
    function buildUrl(minusMonths) {
        var date = new Date();
        if(minusMonths) {
            date = goBackMonths(date, minusMonths);
    ***REMOVED***
        const firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
        const lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);

        const firstDateString = firstDay.getFullYear()+"-"+dd(firstDay.getMonth()+1)+"-01"
        const lastDateString = lastDay.getFullYear()+"-"+dd(lastDay.getMonth()+1)+"-"+dd(lastDay.getDate())


        const proposalsUrl = 
            "http://localhost:8080/proposals/search/findAllByDateCreatedLessThanEqualAndDateCreatedGreaterThanEqual"+
            "?startDate="+firstDateString+"T00:00"+
            "&endDate="+lastDateString+"T23:59";
        return proposalsUrl;
***REMOVED***
    
    
    function parseId(entity) {
        const url = entity._links.self.href;
        const id = url.substring(url.lastIndexOf('/')+1);
        return id;
***REMOVED***

    useEffect(
        () => {
            if(router.isReady) {

                const minusMonths = router.query.minusMonths
                fetch(buildUrl(minusMonths))
                    .then( (res) => res.json())
                    .then( (data) => setProposals(data));
        ***REMOVED***
            
    ***REMOVED***, [router.isReady]
    );

    if(proposals) {
        return (
            <Layout>
                <PageTitle title="Proposals"/>
                <MonthsBack/>
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
***REMOVED***
    else {
        return <div>Loading...</div>
***REMOVED***
}