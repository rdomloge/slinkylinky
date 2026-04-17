import React, {useState, useEffect} from 'react'
import { useAuth } from "@/auth/AuthProvider"
import { useSearchParams } from 'react-router-dom'

import ProposalListItem from "@/components/ProposalListItem";
import Layout from "@/components/layout/Layout";
import MonthsBack from "@/components/MonthsBack";
import Loading from '@/components/Loading';
import Divider from '@/components/Divider';
import FiltersPanel from '@/components/Filters';
import { Toggle } from '@/components/atoms/Toggle';
import { fetchWithAuth } from '@/utils/fetchWithAuth';


export default function ListProposals() {
    const [searchParams] = useSearchParams()
    const [proposals, setProposals] = useState()
    const [error, setError] = useState()

    const [completeProposals, setCompleteProposals] = useState([]);
    const [waitingForSupplier, setWaitingForSupplier] = useState([]);
    const [waitingForAdmin, setWaitingForAdmin] = useState([]);
    const [unpaidfilter, setUnpaidFilter] = useState(false);
    const [isLoading, setIsLoading] = useState(true);

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
            const minusMonths = searchParams.get('minusMonths')

            setIsLoading(true);
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
                    setIsLoading(false);
                })
                .catch( (error) => {
                    setError(error.message);
                    setIsLoading(false);
                });

        }, [searchParams]
    );

    return (
        <Layout pagetitle='Proposals'
            headerTitle={<>Proposals {proposals && <span className="font-normal text-slate-400">({proposals.length})</span>}</>}
            headerActions={<MonthsBack/>}
        >

            {/* Filters */}
            <FiltersPanel>
                <Toggle initialValue={unpaidfilter} changeHandler={applyUnpaidFilter} label={"Unpaid"}/>
            </FiltersPanel>

            {/* Sticky counts nav */}
            {!isLoading &&
                <nav
                    className="sticky top-0 px-6 py-2.5 flex items-center gap-5 text-sm z-20"
                    style={{
                        background: 'var(--bg-primary)',
                        borderBottom: '1px solid var(--ink-hair)',
                        boxShadow:
                            '0 1px 0 0 rgba(255,255,255,0.5) inset, 0 2px 8px -2px rgba(42,36,35,0.06)',
                    }}
                >
                    <a
                        href="#waiting-for-us"
                        className="flex items-baseline gap-1.5 font-medium transition-colors cursor-pointer"
                        style={{ color: '#0c4a6e' }}
                    >
                        <span className="text-base font-bold font-mono tabular-nums" style={{ color: '#0369a1' }}>
                            {waitingForAdmin.length}
                        </span>
                        needing attention
                    </a>
                    <span style={{ color: 'var(--ink-hair)' }}>·</span>
                    <a
                        href="#waiting-for-them"
                        className="flex items-baseline gap-1.5 font-medium transition-colors cursor-pointer"
                        style={{ color: 'var(--ink-secondary)' }}
                    >
                        <span className="text-base font-bold font-mono tabular-nums" style={{ color: 'var(--ink-primary)' }}>
                            {waitingForSupplier.length}
                        </span>
                        need chasing
                    </a>
                    <span style={{ color: 'var(--ink-hair)' }}>·</span>
                    <a
                        href="#complete-proposals"
                        className="flex items-baseline gap-1.5 font-medium transition-colors cursor-pointer"
                        style={{ color: '#2e6a55' }}
                    >
                        <span className="text-base font-bold font-mono tabular-nums" style={{ color: '#3f8d73' }}>
                            {completeProposals.length}
                        </span>
                        complete
                    </a>
                </nav>
            }

            {isLoading ?
                <Loading error={error}/>
            :
                <div className="px-6 pb-6">
                    <Divider text={"Waiting for us"} size='text-2xl' id='waiting-for-us'/>
                    <ul className="flex flex-col gap-2 mb-4">
                        {waitingForAdmin.map( (p) =>
                            <li key={p.id}>
                                <ProposalListItem proposal={p}/>
                            </li>
                        )}
                    </ul>

                    <Divider text={"Waiting for them"} size='text-2xl' id='waiting-for-them'/>
                    <ul className="flex flex-col gap-2 mb-4">
                        {waitingForSupplier.map( (p) =>
                            <li key={p.id}>
                                <ProposalListItem proposal={p}/>
                            </li>
                        )}
                    </ul>

                    <Divider text={"Complete"} size='text-2xl' id='complete-proposals'/>
                    <ul className="flex flex-col gap-2 mb-4">
                        {completeProposals.map( (p) =>
                            <li key={p.id}>
                                <ProposalListItem proposal={p}/>
                            </li>
                        )}
                    </ul>
                </div>
            }
        </Layout>
    );
}
