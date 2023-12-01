export default function DemandHeadline({linkDemand}) {
    return (
        <>
            <p className="text-right">{linkDemand.name}({linkDemand.daNeeded})</p>
        </>
    );
}