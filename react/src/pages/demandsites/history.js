import React, { useEffect, useState } from 'react';
import { useRouter } from 'next/router';
import PageTitle from '@/components/pagetitle';
import Paging from '@/components/Paging';
import Layout from '@/components/layout/Layout';
import { CompactDate } from '@/components/atoms/DateTime';
import Loading from '@/components/Loading';
import Link from 'next/link';


const History = () => {

    const router = useRouter();
    const [proposals, setProposals] = useState([]);
    const [totalPages, setTotalPages] = useState(1);
    const [total, setTotal] = useState(0);
    const [currentPage, setCurrentPage] = useState(0);

    useEffect(() => {
        if(router.isReady) {
            const domain = router.query.domain;
            const page = router.query.page ? parseInt(router.query.page) : 0;
            setCurrentPage(page);
            fetchPaidLinks(domain, page);
        }
    }, [router.isReady, router.query.page]);

    const fetchPaidLinks = async (domain, page) => {
        try {
            // /proposals/search/findByPaidLinksDemandDomain?demandDomain=acticareuk.com&projection=liteProposal&size=2&page=0
            const url = `/.rest/proposals/search/findAllByPaidLinks_Demand_DomainOrderByDateCreatedDesc?domain=${domain}&projection=liteProposal&size=30&page=${page-1}`;
            fetch(url).then((res) => {
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
        let domain = router.query.domain;
        let domainEndIndex = url.indexOf(domain) + domain.length;
        return url.substring(domainEndIndex);
    }

    return (
        <Layout pagetitle='Demand site history'>
            <PageTitle title='Demand site history' id="demandsite-history-list-id"  />
            <h1>Customer: {router.query.domain}, {total} links</h1>
            <div>
                <Paging baseUrl={`/demandsites/history`} baseQuery={{"domain": router.query.domain}} pageCount={totalPages} total={total} page={currentPage}/>
            </div>

            {proposals ?
                <table className='table-auto w-full'>
                    <thead>
                    <tr>
                        <th>Live</th>
                        <th>DA</th>
                        <th>Anchor</th>
                        <th>Blog</th>
                        <th>Client URL</th>
                    </tr>
                    </thead>
                    <tbody>
                        {proposals
                            .map((proposal, index) => (
                                <tr key={index}>
                                    <td className='truncate max-w-xs'> 
                                        <Link href={`/proposals/${proposal.id}`}>
                                            <CompactDate isostring={proposal.dateBlogLive}/> 
                                        </Link>
                                    </td>
                                    <td className='text-center truncate max-w-xs'>{proposal.paidLinks[0].supplier.da}</td>
                                    <td className='truncate max-w-xxs'>{proposal.paidLinks[0].demand.anchorText}</td>
                                    <td className='truncate max-w-xs'>{proposal.liveLinkUrl}</td>
                                    <td className='truncate max-w-xs'>{removeProtocolAndDomain(proposal.paidLinks[0].demand.url)}</td>
                                </tr>
                            ))
                        }
                    </tbody>
                </table>
            :
                <Loading />
            }
        </Layout>
    );
};

export default History;