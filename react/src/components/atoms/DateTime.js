export default function NiceDate(props) {
    if(null != props.isostring) {
        return (
            <>
                <span className="align-middle">{new Date(props.isostring).toDateString()}</span>
            </>
        );
    }
    else {
        return (
            <>
                <span>-</span>
            </>
        );
    }
}

export function NiceDateTime({isostring}) {
    if(null == isostring) {
        throw new Error("isostring is required");
    }
    return (
        <>
        <span className="align-middle">{new Date(isostring).toLocaleString()}</span>
        </>
    );
}