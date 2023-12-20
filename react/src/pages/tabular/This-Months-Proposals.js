import Layout from '@/components/Layout';
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

    if(proposals) {
        return (
            <Layout>
                <PageTitle title={"Proposals ("+proposals.length+")"}/>
                <table className="table-auto border-separate border-spacing-2 border border-slate-400">
                <thead>
                    <tr>
                    <th>Supplier</th>
                    <th>Supplier Email</th>
                    <th>Supplier fee</th>
                    <th>Demand 1 name</th>
                    <th>Demand 1 URL</th>
                    </tr>
                </thead>
                <tbody>
                    { 
                        proposals.map( (p,index) => { return (
                            <tr key="index">
                                <td className="border border-slate-300">{p.paidLinks[0].supplier.name}</td>
                                <td className="border border-slate-300">{p.paidLinks[0].supplier.email}</td>
                                <td className="border border-slate-300">{p.paidLinks[0].supplier.weWriteFeeCurrency}{p.paidLinks[0].supplier.weWriteFee}</td>
                                <td className="border border-slate-300">{p.paidLinks[0].demand.name}</td>
                                <td className="border border-slate-300">{p.paidLinks[0].demand.url}</td>
                            </tr>
                        )})
                    }
                </tbody>
                </table>
            </Layout>
        );
    }
    else {
        return <div>Loading...</div>
    }
}