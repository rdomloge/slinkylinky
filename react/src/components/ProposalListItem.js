import React, {useState, useEffect} from 'react'

import NiceDate from "./Date";
import TrafficLights from "./ProposalTrafficLights";
import SupplierSummary from './supplierSummary';


export default function ProposalListItem({proposal}) {

    const [supplier, setSupplier] = useState()

    useEffect(() => {
        const paidLinksUrl = proposal._links.paidLinks.href;
        fetch(paidLinksUrl)
            .then( (resp) => resp.json())
            .then((pl) => {
                fetch(pl._embedded.paidlinks[0]._links.blogger.href)
                    .then( (res) => res.json())
                        .then( (s) => setSupplier(s));
            });
    }, [proposal])

    return (
        <>
            <div className="card">
                <NiceDate isostring={proposal.dateCreated}/>
                {supplier && <SupplierSummary supplier={supplier}/>}
                <p>Live Link {proposal.liveLinkUrl}</p>
                <div>
                    <TrafficLights proposal={proposal}/>
                </div>
            </div>
        </>
    );
}