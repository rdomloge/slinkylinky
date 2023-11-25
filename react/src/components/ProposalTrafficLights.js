import TrafficLight from "./TrafficLight";

export default function TrafficLights({proposal}) {
    return (
        <div className="p-2 m-2 h-12">
            <TrafficLight text="Content" value={proposal.contentReady} />
            <TrafficLight text="Sent" value={proposal.proposalSent} />
            <TrafficLight text="Accepted" value={proposal.proposalAccepted} />
            <TrafficLight text="Invoice" value={proposal.invoiceReceived} />
            <TrafficLight text="Live" value={proposal.blogLive} />
        </div>
    );
}
