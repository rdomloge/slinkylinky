import { useEffect, useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import Paging from '@/components/Paging';
import Layout from '@/components/layout/Layout';
import { CompactDate } from '@/components/atoms/DateTime';
import Loading from '@/components/Loading';
import { Link } from 'react-router-dom';
import { fetchWithAuth } from '@/utils/fetchWithAuth';


const History = () => {

    const [searchParams] = useSearchParams();
    const [proposals, setProposals] = useState([]);
    const [totalPages, setTotalPages] = useState(1);
    const [total, setTotal] = useState(0);
    const [currentPage, setCurrentPage] = useState(0);

    useEffect(() => {
        const domain = searchParams.get('domain');
        const page = searchParams.get('page') ? parseInt(searchParams.get('page')) : 0;
        setCurrentPage(page);
        if (domain) fetchPaidLinks(domain, page);
    }, [searchParams]);

    const fetchPaidLinks = async (domain, page) => {
        try {
            // /proposals/search/findByPaidLinksDemandDomain?demandDomain=acticareuk.com&projection=liteProposal&size=2&page=0
            const url = `/.rest/proposals/search/findAllByPaidLinks_Demand_DomainOrderByDateCreatedDesc?domain=${domain}&projection=liteProposal&size=30&page=${page-1}`;
            fetchWithAuth(url).then((res) => {
                if (!res.ok) {
                    throw new Error("Can't fetch historical paid links.");
                }
                return res.json();
            }).then((data) => {
                // the proposal has paid links for other domains, so we need to filter them out since this is a screen about the history for a specific customer
                data._embedded.proposals.forEach( (proposal) => {
                    const filteredLinks = proposal.paidLinks.filter( (link) => {
                        return link.demand.domain === domain
                    });
                    proposal.paidLinks = filteredLinks;
                });
                setProposals(data._embedded.proposals);
                setTotalPages(data.page.totalPages);
                setTotal(data.page.totalElements);
            });
        } catch (error) {
            console.error('Error fetching paid links:', error);
        }
    };

    function removeProtocolAndDomain(url) {
        let domain = searchParams.get('domain');
        let domainEndIndex = url.indexOf(domain) + domain.length;
        return url.substring(domainEndIndex);
    }

    return (
        <Layout pagetitle='Demand site history'>
            {/* Page header */}
            <div className="flex items-center justify-between px-6 pt-6 pb-4">
                <div>
                    <h1 id="demandsite-history-list-id" className="pageTitle">Link history</h1>
                    <p className="text-slate-500 text-sm mt-1">{searchParams.get('domain')}</p>
                </div>
                {total > 0 &&
                    <span className="text-slate-400 text-sm font-medium">{total} links</span>
                }
            </div>

            <div className="px-6">
                <Paging baseUrl={`/demandsites/history`} baseQuery={{"domain": searchParams.get('domain')}} pageCount={totalPages} total={total} page={currentPage}/>
            </div>

            {proposals ?
                <div className="px-6 pb-6">
                    <div className="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
                        <table className="table-auto w-full">
                            <thead>
                                <tr className="bg-slate-50 border-b border-slate-200">
                                    <th className="text-left px-4 py-3 text-xs font-semibold text-slate-500 uppercase tracking-wider">Live date</th>
                                    <th className="text-center px-4 py-3 text-xs font-semibold text-slate-500 uppercase tracking-wider">DA</th>
                                    <th className="text-left px-4 py-3 text-xs font-semibold text-slate-500 uppercase tracking-wider">Anchor</th>
                                    <th className="text-left px-4 py-3 text-xs font-semibold text-slate-500 uppercase tracking-wider">Blog URL</th>
                                    <th className="text-left px-4 py-3 text-xs font-semibold text-slate-500 uppercase tracking-wider">Client URL</th>
                                </tr>
                            </thead>
                            <tbody className="divide-y divide-slate-100">
                                {proposals.map((proposal, index) => (
                                    <tr key={index} className="hover:bg-slate-50 transition-colors">
                                        <td className="px-4 py-3 text-sm">
                                            <Link to={`/proposals/${proposal.id}`} className="text-indigo-600 hover:text-indigo-800 font-medium">
                                                <CompactDate isostring={proposal.dateBlogLive}/>
                                            </Link>
                                        </td>
                                        <td className="px-4 py-3 text-sm text-center">
                                            <span className="inline-flex items-center bg-indigo-50 text-indigo-700 text-xs font-medium px-2 py-0.5 rounded-full">
                                                {proposal.paidLinks[0].supplier.da}
                                            </span>
                                        </td>
                                        <td className="px-4 py-3 text-sm text-slate-700 truncate max-w-xs">{proposal.paidLinks[0].demand.anchorText}</td>
                                        <td className="px-4 py-3 text-sm text-slate-500 truncate max-w-xs">{proposal.liveLinkUrl}</td>
                                        <td className="px-4 py-3 text-sm text-slate-500 truncate max-w-xs">{removeProtocolAndDomain(proposal.paidLinks[0].demand.url)}</td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                </div>
            :
                <Loading />
            }
        </Layout>
    );
};

export default History;