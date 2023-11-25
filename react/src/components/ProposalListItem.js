import NiceDate from "./Date";
import TrafficLights from "./ProposalTrafficLights";
TrafficLights

export default function ProposalListItem({proposal}) {
    return (
        <>
            <div className="card">
                <NiceDate isostring={proposal.dateCreated}/>
                <div>
                    <TrafficLights proposal={proposal}/>
                </div>
            </div>
        </>
    );
}