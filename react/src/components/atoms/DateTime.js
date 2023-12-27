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
    return (
        <span className="align-middle">{new Date(isostring).toLocaleString()}</span>
    );
}