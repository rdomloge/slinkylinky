import React, {useState, useEffect} from 'react'

import NiceDate from "./atoms/DateTime";
import TrafficLights from "./ProposalTrafficLights";
import SupplierSummary from './supplierSummary';
import Link from 'next/link';
import DemandHeadline from './DemandHeadline';


export default function ProposalListItem({proposal, originalSupplier = null}) {

    return (
        <>
            <div className="card grid grid-cols-11">
                <div className='col-span-8'>
                    <NiceDate isostring={proposal.dateCreated}/>
                    {originalSupplier ?
                        <SupplierSummary supplier={originalSupplier}/>
                    :
                        <SupplierSummary supplier={proposal.paidLinks[0].supplier}/>
                ***REMOVED***
                    {proposal.blogLive ?
                        <div>
                            <Link href={proposal.liveLinkUrl}>
                                <p className='font-extrabold truncate'>
                                    {proposal.liveLinkTitle}
                                </p>
                            </Link>
                            <p>Blog live at <NiceDate isostring={proposal.dateBlogLive}/></p>
                        </div>
                    : null}
                    <div>
                        <TrafficLights proposal={proposal} interactive={false}/>
                    </div>
                </div>
                <div className='col-span-3 m-3'>
                    <Link href={"/proposals/"+proposal.id} className='font-semibold text-right text-2xl'>
                        <p className='font-semibold text-right text-2xl mb-4'>View</p>
                    </Link>
                    <p className='font-semibold text-right'>Demand</p>
                       {proposal.paidLinks.map( 
                            (pl,index) => <DemandHeadline demand={pl.demand} key={index}/> )} 
                </div>
            </div>
        </>
    );
}