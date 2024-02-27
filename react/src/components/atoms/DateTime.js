export default function NiceDate(props) {
    if(null != props.isostring) {
        return (
            <>
                <span className="align-middle">{new Date(props.isostring).toDateString()}</span>
            </>
        );
***REMOVED***
    else {
        return (
            <>
                <span>-</span>
            </>
        );
***REMOVED***
}

export function NiceDateTime({isostring}) {
    if(null == isostring) {
        throw new Error("isostring is required");
***REMOVED***
    return (
        <>
        <span className="align-middle">{new Date(isostring).toLocaleString()}</span>
        </>
    );
}