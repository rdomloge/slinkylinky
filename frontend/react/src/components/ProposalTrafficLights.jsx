import TrafficLight from "./TrafficLight";
import TrafficLightClickHandler from "./TrafficLightClickHandler";

function Connector({ active }) {
    return (
        <div className={`flex-1 h-0.5 mt-3.5 mx-1 rounded-full transition-colors ${active ? 'bg-green-400' : 'bg-gray-200'}`}/>
    );
}

export default function TrafficLights({ proposal, updateHandler, interactive }) {
    const isThirdParty = proposal.paidLinks[0].supplier.thirdParty;

    if (!interactive) {
        return (
            <div className="flex items-start py-2 w-full px-2">
                {!isThirdParty && <>
                    <TrafficLight text="Content" value={proposal.contentReady}/>
                    <Connector active={proposal.contentReady}/>
                </>}
                <TrafficLight text="Sent" value={proposal.proposalSent}/>
                {!isThirdParty && <>
                    <Connector active={proposal.proposalSent}/>
                    <TrafficLight text="Accepted" value={proposal.proposalAccepted}/>
                    <Connector active={proposal.proposalAccepted}/>
                    <TrafficLight text="Invoice recv" value={proposal.invoiceReceived}/>
                    <Connector active={proposal.invoiceReceived}/>
                    <TrafficLight text="Invoice paid" value={proposal.invoicePaid}/>
                </>}
                <Connector active={isThirdParty ? proposal.proposalSent : proposal.invoicePaid}/>
                <TrafficLight text="Live" value={proposal.blogLive}/>
                <Connector active={proposal.blogLive}/>
                <TrafficLight text="Validated" value={proposal.validated}/>
            </div>
        );
    }

    return (
        <div className="flex items-start py-2">
            {!isThirdParty && <>
                <TrafficLightClickHandler proposal={proposal} updateHandler={updateHandler} propertyName="contentReady">
                    <TrafficLight text="Content" value={proposal.contentReady}/>
                </TrafficLightClickHandler>
                <Connector active={proposal.contentReady}/>
            </>}
            <TrafficLightClickHandler proposal={proposal} updateHandler={updateHandler} propertyName="proposalSent" propertyDate="dateSentToSupplier">
                <TrafficLight text="Sent" value={proposal.proposalSent}/>
            </TrafficLightClickHandler>
            {!isThirdParty && <>
                <Connector active={proposal.proposalSent}/>
                <TrafficLightClickHandler proposal={proposal} updateHandler={updateHandler} propertyName="proposalAccepted" propertyDate="dateAcceptedBySupplier">
                    <TrafficLight text="Accepted" value={proposal.proposalAccepted}/>
                </TrafficLightClickHandler>
                <Connector active={proposal.proposalAccepted}/>
                <TrafficLightClickHandler proposal={proposal} updateHandler={updateHandler} propertyName="invoiceReceived" propertyDate="dateInvoiceReceived">
                    <TrafficLight text="Invoice recv" value={proposal.invoiceReceived}/>
                </TrafficLightClickHandler>
                <Connector active={proposal.invoiceReceived}/>
                <TrafficLightClickHandler proposal={proposal} updateHandler={updateHandler} propertyName="invoicePaid" propertyDate="dateInvoicePaid">
                    <TrafficLight text="Invoice paid" value={proposal.invoicePaid}/>
                </TrafficLightClickHandler>
            </>}
            <Connector active={isThirdParty ? proposal.proposalSent : proposal.invoicePaid}/>
            <TrafficLightClickHandler proposal={proposal} updateHandler={updateHandler} propertyName="blogLive" propertyDate="dateBlogLive">
                <TrafficLight text="Live" value={proposal.blogLive}/>
            </TrafficLightClickHandler>
            <Connector active={proposal.blogLive}/>
            <TrafficLightClickHandler proposal={proposal} updateHandler={updateHandler} propertyName="validated" propertyDate="dateValidated">
                <TrafficLight text="Validated" value={proposal.validated}/>
            </TrafficLightClickHandler>
        </div>
    );
}
