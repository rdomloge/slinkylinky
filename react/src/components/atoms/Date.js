export default function NiceDate(props) {
    if(null != props.isostring) {
        return (
            <>
                <span>{new Date(props.isostring).toDateString()}</span>
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