import TrafficLight from "./TrafficLight";
import TrafficLightClickHandler from "./TrafficLightClickHandler";

export default function TrafficLights({proposal, updateHandler, interactive}) {
    
    if( ! interactive) {
        return (
            <div className="p-2 m-2 h-13">
                <TrafficLight text="Content" value={proposal.contentReady} />
                <TrafficLight text="Sent" value={proposal.proposalSent} />
                <TrafficLight text="Accepted" value={proposal.proposalAccepted} />
                <TrafficLight text="Invoice recv" value={proposal.invoiceReceived} />
                <TrafficLight text="Invoice paid" value={proposal.invoicePaid} />
                <TrafficLight text="Live" value={proposal.blogLive} />
            </div>
        );
***REMOVED***
    else {
        return (
            <div className="p-2 m-2 h-13">
                <TrafficLightClickHandler proposal={proposal} updateHandler={updateHandler} propertyName="contentReady">
                    <TrafficLight text="Content" value={proposal.contentReady} />
                </TrafficLightClickHandler>
                <TrafficLightClickHandler proposal={proposal} updateHandler={updateHandler} propertyName="proposalSent" propertyDate="dateSentToSupplier">
                    <TrafficLight text="Sent" value={proposal.proposalSent} />
                </TrafficLightClickHandler>
                <TrafficLightClickHandler proposal={proposal} updateHandler={updateHandler} propertyName="proposalAccepted" propertyDate="dateAcceptedBySupplier">
                    <TrafficLight text="Accepted" value={proposal.proposalAccepted} />
                </TrafficLightClickHandler>
                <TrafficLightClickHandler proposal={proposal} updateHandler={updateHandler} propertyName="invoiceReceived" propertyDate="dateInvoiceReceived">
                    <TrafficLight text="Invoice recv" value={proposal.invoiceReceived} />
                </TrafficLightClickHandler>
                <TrafficLightClickHandler proposal={proposal} updateHandler={updateHandler} propertyName="invoicePaid" propertyDate="dateInvoicePaid">
                    <TrafficLight text="Invoice paid" value={proposal.invoicePaid} />
                </TrafficLightClickHandler>
                <TrafficLightClickHandler proposal={proposal} updateHandler={updateHandler} propertyName="blogLive" propertyDate="dateBlogLive">
                    <TrafficLight text="Live" value={proposal.blogLive} />
                </TrafficLightClickHandler>
            </div>
        );
***REMOVED***
}
