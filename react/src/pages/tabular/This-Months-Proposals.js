import Layout from '@/components/layout/Layout';
import Loading from '@/components/Loading';
import PageTitle from '@/components/pagetitle';
import React, {useState, useEffect} from 'react'


export default function TabularProposalData() {
    const [proposals, setProposals] = useState()

    function dd(i) {
        if(i > 9) return i;
        else  return "0"+i;
    }
    
    function buildUrl() {
        var date = new Date();
        const firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
        const lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);

        const firstDateString = firstDay.getFullYear()+"-"+dd(firstDay.getMonth()+1)+"-01"
        const lastDateString = lastDay.getFullYear()+"-"+dd(lastDay.getMonth()+1)+"-"+dd(lastDay.getDate())

        const proposalsUrl = 
            "/.rest/proposals/search/findAllByDateCreatedLessThanEqualAndDateCreatedGreaterThanEqualOrderByDateCreatedAsc"+
            "?startDate="+firstDateString+"T00:00"+
            "&endDate="+lastDateString+"T23:59"+
            "&projection=fullProposal";
        return proposalsUrl;
    }

    useEffect(
        () => {

            fetch(buildUrl())
                .then( (res) => res.json())
                .then( (data) => setProposals(data._embedded.proposals));
            
        }, []
    );

    return (
        <Layout>
            <PageTitle title="Proposals" count={proposals}/>
            { ! proposals ? <Loading/> : null}
            <table className="table-auto border-separate border-spacing-0 border border-slate-400">
            <thead>
                <tr>
                <th className="border border-slate-300 bg-blue-200 p-2">Company name</th>
                <th className="border border-slate-300 bg-blue-200 p-2">DA needed</th>
                <th className="border border-slate-300 bg-blue-200 p-2">Client website</th>
                <th className="border border-slate-300 bg-blue-200 p-2">Anchor text</th>

                <th className="border border-slate-300 bg-green-100 p-2">Supplier name</th>
                <th className="border border-slate-300 bg-green-100 p-2">Supplier website</th>
                <th className="border border-slate-300 bg-green-100 p-2">Cost</th>
                <th className="border border-slate-300 bg-green-100 p-2">Supplier DA</th>
                <th className="border border-slate-300 bg-green-100 p-2">Supplier email</th>
                </tr>
            </thead>
            <tbody>
                { 
                proposals ?
                    proposals.map( (p,index) => (
                        p.paidLinks.map( (pl, index) => (
                            <tr key={index}>
                                <td className="border border-slate-300 bg-blue-200 p-2">{pl.demand.name}</td>
                                <td className="border border-slate-300 bg-blue-200 p-2">{pl.demand.daNeeded}</td>
                                <td className="border border-slate-300 bg-blue-200 p-2">{pl.demand.url}</td>
                                <td className="border border-slate-300 bg-blue-200 p-2">{pl.demand.anchorText}</td>

                                <td className="border border-slate-300 bg-green-100 p-2">{pl.supplier.name}</td>
                                <td className="border border-slate-300 bg-green-100 p-2">{pl.supplier.website}</td>
                                <td className="border border-slate-300 bg-green-100 p-2">{pl.supplier.weWriteFeeCurrency}{pl.supplier.weWriteFee}</td>
                                <td className="border border-slate-300 bg-green-100 p-2">{pl.supplier.da}</td>
                                <td className="border border-slate-300 bg-green-100 p-2">{pl.supplier.email}</td>
                            </tr>
                        )
                    )))
                :
                    null
                }
            </tbody>
            </table>
        </Layout>
    );
}