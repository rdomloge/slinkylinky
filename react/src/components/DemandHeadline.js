export default function DemandHeadline({linkDemand}) {
    return (
        <>
            <p className="text-right">{linkDemand.name}(DA {linkDemand.daNeeded})</p>
        </>
    );
}