import React, {useState, useEffect} from 'react'

import NiceDate from "./Date";
import TrafficLights from "./ProposalTrafficLights";
import SupplierSummary from './supplierSummary';
import Link from 'next/link';
import DemandHeadline from './DemandHeadline';


export default function ProposalListItem({proposal}) {

    const [supplier, setSupplier] = useState()

    return (
        <>
            <div className="card grid grid-cols-9">
                <div className='col-span-7'>
                    <NiceDate isostring={proposal.dateCreated}/>
                    {<SupplierSummary supplier={proposal.paidLinks[0].blogger}/>}
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
                        <TrafficLights proposal={proposal}/>
                    </div>
                </div>
                <div className='col-span-2 m-3'>
                    <p className='font-semibold text-right'>Demand</p>
                       {proposal.paidLinks.map( 
                            pl => <DemandHeadline linkDemand={pl.linkDemand}/> )} 
                </div>
            </div>
        </>
    );
}