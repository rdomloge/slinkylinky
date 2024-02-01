import TrafficLight from "./TrafficLight";
import TrafficLightClickHandler from "./TrafficLightClickHandler";

export default function TrafficLights({proposal, updateHandler, interactive}) {
    
    if( ! interactive) {
        return (
            <div className="p-2 m-2 h-13">
                { ! proposal.paidLinks[0].supplier.thirdParty ?
                    <TrafficLight text="Content" value={proposal.contentReady} />
                :
                    null
            ***REMOVED***
                <TrafficLight text="Sent" value={proposal.proposalSent} />
                { ! proposal.paidLinks[0].supplier.thirdParty ?
                    <>
                    <TrafficLight text="Accepted" value={proposal.proposalAccepted} />
                    <TrafficLight text="Invoice recv" value={proposal.invoiceReceived} />
                    <TrafficLight text="Invoice paid" value={proposal.invoicePaid} />
                    </>
                :
                null
            ***REMOVED***
                <TrafficLight text="Live" value={proposal.blogLive} />
            </div>
        );
***REMOVED***
    else {
        return (
            <div className="p-2 m-2 h-13">
                { ! proposal.paidLinks[0].supplier.thirdParty ?
                    <TrafficLightClickHandler proposal={proposal} updateHandler={updateHandler} propertyName="contentReady">
                        <TrafficLight text="Content" value={proposal.contentReady} />
                    </TrafficLightClickHandler>
                : 
                    null
            ***REMOVED***
                <TrafficLightClickHandler proposal={proposal} updateHandler={updateHandler} propertyName="proposalSent" propertyDate="dateSentToSupplier">
                    <TrafficLight text="Sent" value={proposal.proposalSent} />
                </TrafficLightClickHandler>
                { ! proposal.paidLinks[0].supplier.thirdParty ?
                    <>
                    <TrafficLightClickHandler proposal={proposal} updateHandler={updateHandler} propertyName="proposalAccepted" propertyDate="dateAcceptedBySupplier">
                        <TrafficLight text="Accepted" value={proposal.proposalAccepted} />
                    </TrafficLightClickHandler>
                
                    <TrafficLightClickHandler proposal={proposal} updateHandler={updateHandler} propertyName="invoiceReceived" propertyDate="dateInvoiceReceived">
                        <TrafficLight text="Invoice recv" value={proposal.invoiceReceived} />
                    </TrafficLightClickHandler>
                    <TrafficLightClickHandler proposal={proposal} updateHandler={updateHandler} propertyName="invoicePaid" propertyDate="dateInvoicePaid">
                        <TrafficLight text="Invoice paid" value={proposal.invoicePaid} />
                    </TrafficLightClickHandler>
                    </>
                :
                    null
            ***REMOVED***
                <TrafficLightClickHandler proposal={proposal} updateHandler={updateHandler} propertyName="blogLive" propertyDate="dateBlogLive">
                    <TrafficLight text="Live" value={proposal.blogLive} />
                </TrafficLightClickHandler>
            </div>
        );
***REMOVED***
}
